import numpy as np
import itertools
import sys
import os
import argparse
import pandas as pd
import scipy.optimize as opt
import matplotlib.pyplot as plt

from process_specs import XT018, XT011
from battery import Battery

import warnings
warnings.filterwarnings ("ignore", category = RuntimeWarning)

class ChargePump:
  def __init__ (this):
    pass

  def ivoltage (
    cvoltage,
    ccount,
    cresistance,
    N,
    pcapacitance,
    frequency,
    kparasitic,
    rout,
    ovoltage
  ):
    ivoltn = ccount * cvoltage - ((N + 1.0) * ovoltage * cresistance) / rout
    ivoltd = 1.0 + 2.0 * N * pcapacitance * kparasitic * frequency * cresistance
    return ivoltn / ivoltd

  def cinput (
    cvoltage,
    ccount,
    cresistance,
    N,
    pcapacitance,
    frequency,
    kparasitic,
    rout,
    ovoltage
  ):
    ivoltage = ChargePump.ivoltage (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      N = N,
      pcapacitance = pcapacitance,
      frequency = frequency,
      kparasitic = kparasitic,
      rout = rout,
      ovoltage = ovoltage
    )
    return (N + 1.0) * ovoltage / rout + 2.0 * N * pcapacitance * kparasitic * frequency * ivoltage 

  def vout (
    cvoltage,
    ccount,
    cresistance,
    N,
    M,
    pcapacitance,
    frequency,
    vdiode,
    kparasitic,
    rout,
    ovoltage 
  ):
    ivoltage = ChargePump.ivoltage (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      N = N,
      pcapacitance = pcapacitance,
      frequency = frequency,
      kparasitic = kparasitic,
      rout = rout,
      ovoltage = ovoltage
    )
    
    vacc = 0.0
    multi = 1.0 / (1.0 + kparasitic)
    for i in range (1, int (N/M) + 1):
      vadd = ivoltage
      for j in range (1, i + 1):
        vadd = vadd * multi
      vacc = vacc + vadd
    return ivoltage + M * vacc - (N + 1.0) * vdiode

  def oresistance (
    N,
    M,
    pcapacitance,
    kparasitic,
    frequency
  ):
    racc = 0.0
    multi = 1.0 / (1.0 + kparasitic)
    for i in range (1, int (N/M) + 1):
      for j in range (1, i + 1):
        racc = racc + ((N / M) - j + 1.0) * multi
    return (M * racc) / (frequency * pcapacitance)

  def run (
    cvoltage = 3.3,
    ccount = 1,
    cresistance = 5.0,
    rsource = 10.0,
    N = 1,
    M = 1,
    pcapacitance = 25.0e-12,
    vdiode = 0.5,
    frequency = 10.0e6,
    kparasitic = 0.01,
    rout = 100.0e3,
    ovoltage = 200.0,
    verbose = False
  ):
    vout = ChargePump.vout (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      N = N,
      M = M,
      pcapacitance = pcapacitance,
      frequency = frequency,
      vdiode = vdiode,
      kparasitic = kparasitic,
      rout = rout,
      ovoltage = ovoltage
    )

    ivoltage = ChargePump.ivoltage (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      N = N,
      pcapacitance = pcapacitance,
      frequency = frequency,
      kparasitic = kparasitic,
      rout = rout,
      ovoltage = ovoltage
    )

    oresistance = ChargePump.oresistance (
      N = N,
      M = M,
      pcapacitance = pcapacitance,
      kparasitic = kparasitic,
      frequency = frequency
    )

    cinput = ChargePump.cinput (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      N = N,
      pcapacitance = pcapacitance,
      frequency = frequency,
      kparasitic = kparasitic,
      rout = rout,
      ovoltage = ovoltage
    )

    if verbose:
      print ('N', N)
      print ('M', M)
      print ('capacitance', pcapacitance)
      print ('frequency', frequency)
      print ('input voltage', ivoltage)
      print ('max input voltage', ccount * cvoltage)
      print ('unloaded vout', vout)
      print ('output resistance', oresistance)
      print ('output current', ovoltage / rout)
      print ('input current', cinput)

    return vout - (ovoltage * oresistance) / rout - ovoltage

  UnitCapacitanceTable = (
    (5, 7.0E-15 / (1.0E-6 ** 2.0)),
	(10, 3.0E-15 / (1.0E-6 ** 2.0)),
	(30, 43.3E-15 / (11.04E-6 * 4.48E-6)),
	(60, 41.8E-15 / (10.8E-6 * 4.48E-6)),
  )

  def weight (
    cvoltage,
    ccount,
    N,
    M,
    pcapacitance,
    process
  ):
    unitCap = ChargePump.UnitCapacitanceTable[-1][1]
    for v, unit in ChargePump.UnitCapacitanceTable:
      if cvoltage * ccount * M < v:
        unitCap = unit
        break
    totalArea = (pcapacitance * N * 2.0) / unitCap
    sideLength = np.sqrt (totalArea)
    mass = None
    if process.lower() == 'xt018':
      mass = XT018.mass (sideLength, sideLength)
    elif process.lower() == 'xt011':
      mass = XT011.mass (sideLength, sideLength)

    # board
    pidensity = 1.37e6
    cdensity = 8.85e6
    pit = 50e-6
    ct = 18e-6

    # polyimide layer
    mass = mass + (pidensity * pit * totalArea)
    # copper layer
    mass = mass + (cdensity * ct * totalArea)

    return mass, totalArea


def solvec (
  cvoltage,
  ccount,
  cresistance,
  rsource,
  N,
  M,
  vdiode,
  frequency,
  kparasitic,
  rout,
  ovoltage
):
  def func (x):
    return ChargePump.run (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      N = N,
      M = M,
      vdiode = vdiode,
      pcapacitance = x, # solve optimal capacitance
      frequency = frequency,
      kparasitic = kparasitic,
      rout = rout,
      ovoltage = ovoltage
    )
  result, info, ier, mesg = opt.fsolve (func = func, x0 = [1.0e-9], full_output = True)
  pcapacitance = result[0]
  if ier != 1:
    return False, None, None, None, info
  cinput = ChargePump.cinput (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    N = N,
    pcapacitance = pcapacitance,
    frequency = frequency,
    kparasitic = kparasitic,
    rout = rout,
    ovoltage = ovoltage
  )
  ivoltage = ChargePump.ivoltage (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    N = N,
    pcapacitance = pcapacitance,
    frequency = frequency,
    kparasitic = kparasitic,
    rout = rout,
    ovoltage = ovoltage
  )
  oresistance = ChargePump.oresistance (
    N = N,
    M = M,
    pcapacitance = pcapacitance,
    kparasitic = kparasitic,
    frequency = frequency
  )
  return True, pcapacitance, cinput, ivoltage, info

def main_judge ():
  cvoltage = 3.7
  ccount = 5
  cresistance = 16.4
  rsource = 8.5
  M = 2
  vdiode = 0.25
  frequency = 100.0e3
  kparasitic = 0.01
  rout = 600.0e3
  ovoltage = 200.0
  N = int (ovoltage / (ccount * cvoltage))
  N = N - int (N % M) + M
  current = None
  pcap = None
  calls = []
  iterations = 0
  while True:
    success, pcapacitance, cinput, ivoltage, info = solvec (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      N = N,
      M = M,
      vdiode = vdiode,
      frequency = frequency,
      kparasitic = kparasitic,
      rout = rout,
      ovoltage = ovoltage
    )
    calls.append (info['nfev'])
    iterations = iterations + 1
    if success:
      ChargePump.run (
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        N = N,
        M = M,
        vdiode = vdiode,
        pcapacitance = pcapacitance,
        frequency = frequency,
        kparasitic = kparasitic,
        rout = rout,
        ovoltage = ovoltage,
        verbose = True
      )
      print ()
    if success and (current is None or current > pcapacitance * N):
      current = pcapacitance * N
      pcap = pcapacitance
    elif current is not None:
      break
    elif ivoltage < 0.0:
      break
    N = N + M
  print ('calls', calls)
  print ('sum (calls)', sum (calls))
  print ('iterations', iterations)

def main_test ():
  cvoltage = 3.7
  ccount = 5
  cresistance = 7.9
  rsource = 8.5
  N = 16
  M = 2
  vdiode = 0.0
  frequency = 10000.0e3
  kparasitic = 0.01
  rout = 600.0e3
  ovoltage = 200.0


  success, pcapacitance, cinput = solvec (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    N = N,
    M = M,
    vdiode = vdiode,
    frequency = frequency,
    kparasitic = kparasitic,
    rout = rout,
    ovoltage = ovoltage
  )
  if success:
    print ('capacitance', pcapacitance)
    print ('cinput', cinput)
    ChargePump.run (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      N = N,
      M = M,
      vdiode = vdiode,
      pcapacitance = pcapacitance,
      frequency = frequency,
      kparasitic = kparasitic,
      rout = rout,
      ovoltage = ovoltage,
      verbose = True
    )

def main_sweep ():
  parser = argparse.ArgumentParser (description = 'Sweep across mechanical options and determine ideal cp circuit')
  parser.add_argument ('--file', '-f', type = str, required = True)
  parser.add_argument ('--process', '-p', type = str, required = True)
  parser.add_argument ('--split', '-s', default = False, action = 'store_true')
  args = parser.parse_args ()
  params = {
    'ccount': [1],
    'frequency': [10.0e3, 100.0e3, 1.0e6, 10.0e6, 100.0e6],
    'M': [1, 2, 3]
  }

  # enumerate each option
  keys = params.keys ()
  ops = [params[key] for key in keys]
  product = list (itertools.product (*ops))
  print (len (product))
  print (product[0])

  # constants
  cvoltage = 3.7
  cresistance = 7.9
  rsource = 8.5
  vdiode = 0.25
  kparasitic = 0.01

  df = pd.read_csv (args.file)
  print (df.shape[0])
  cols = [col for col in df.columns]
  cols.append ('cp-frequency')
  cols.append ('cp-capacitance')
  cols.append ('N')
  cols.append ('M')
  cols.append ('cp-area')
  cols.append ('cp-mass')
  cols.append ('cp-vin')
  cols.append ('cp-load')
  cols.append ('battery-mass')
  cols.append ('battery-alpha')
  cols.append ('runtime')
  dfout = pd.DataFrame (columns = cols)
  outfile = os.path.splitext (args.file)[0] + '_cp.csv'
  for i in range (df.shape[0]):
    # grab option
    row = df.iloc[i]
    iav = float (row['averageCurrent'])
    voltage = float (row['appliedVoltage'])
    precurrent = float (row['total-additional-current'])
    load = voltage / iav
    print (i)
    for j, op in enumerate (product):
      best = None
      pcapacitance = None
      cinvoltage = None
      cinput = None
      Nsave = None
      ccount = op[0]
      cpfrequency = op[1]
      M = int (op[2])
      # start at best case scenario
      incvoltage = None
      if args.split:
        incvoltage = cvoltage
      else:
        incvoltage = cvoltage - (precurrent * cresistance)
      N = int (voltage / (incvoltage * ccount))
      N = N - int (N % M) + M 
      Nstart = N
      calls = []
      iterations = 0
      halfperiod = 1.0 / (3.0 * cpfrequency)
      while True:
        success, pcap, cin, vin, info = solvec (
          cvoltage = incvoltage,
          ccount = ccount,
          cresistance = cresistance,
          rsource = rsource,
          N = N,
          M = M,
          vdiode = vdiode,
          frequency = cpfrequency,
          kparasitic = kparasitic,
          rout = load,
          ovoltage = voltage
        )
        if success: # enforce correctness
          tau = pcap * rsource
          limit = tau * 3.0
          current = N * pcap
          if vin < 0.0 or pcap < 0.0: # no negative components
            break

          if limit > halfperiod: # assume quasistatic
            break

          if best is None or current < best: # check getting better
            best = current
            pcapacitance = pcap
            cinput = cin
            Nsave = N
            cinvoltage = vin
          else:
            break
        elif best is not None: # enforce done 
          break
        elif N > Nstart * 2:
          break
        N = N + M
        iterations = iterations + 1
        calls.append (info['nfev'])
      # print (iterations)
      # print (sum (calls))
      if best is None:
        continue
      else:
        print ('good')
      # get weight
      mass, area = ChargePump.weight (
        cvoltage = cvoltage,
        ccount = ccount,
        N = N,
        M = M,
        pcapacitance = pcapacitance,
        process = args.process
      )
      netThrust = float (row['netThrust'])
      if mass >= netThrust:
        continue
      # get battery
      runtime, alpha = None, 0.0
      if args.split:
        runtime, alpha = Battery.bMass2 (ccount, cinput, 1, precurrent, netThrust - mass)
      else:
        runtime = Battery.bMass (ccount, cinput + precurrent, netThrust - mass)
      row['ccount'] = ccount
      row['cp-frequency'] = cpfrequency
      row['cp-capacitance'] = pcapacitance
      row['N'] = N
      row['M'] = M
      row['cp-mass'] = mass
      row['cp-vin'] = cinvoltage
      row['cp-load'] = cinput
      row['battery-mass'] = netThrust - mass
      row['battery-alpha'] = alpha
      row['runtime'] = runtime
      row['netThrust'] = 0.0
      dfout = pd.concat ([dfout, row.to_frame ().T], ignore_index = True)
  dfout.to_csv (outfile, index = False)

if __name__ == '__main__':
  main_sweep ()
