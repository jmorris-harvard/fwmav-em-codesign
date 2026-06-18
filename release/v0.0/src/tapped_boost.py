import itertools
import matplotlib.pyplot as plt
import numpy as np
import scipy.optimize as opt
import sys
import argparse
import os
import pandas as pd

from battery import Battery

class Boost:
  def tau (
    rsource,
    irsource,
    inductance
  ):
    return inductance / (rsource + irsource)

  def period (
    ontime,
    duty
  ):
    return ontime / duty

  def offtime (
    ontime,
    duty
  ):
    period = Boost.period (
        ontime = ontime,
        duty = duty
    )
    return period * (1.0 - duty), period

  def minductance (
    inductance,
    tratio
  ):
    return inductance * ((tratio ** 2.0) + 1.0)

  def rsecondary (
    irsource,
    tratio
  ):
    return irsource + (irsource * tratio)

  def iavg (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    tau = Boost.tau (
        rsource = rsource,
        irsource = irsource,
        inductance = inductance
    )
    offtime, period = Boost.offtime (
        ontime = ontime,
        duty = duty
    )
    minductance = Boost.minductance (
        inductance = inductance,
        tratio = tratio
    )
    fx = ontime + tau * (np.exp (-1.0 * ontime / tau) - 1.0)
    gx = 1.0 - np.exp (-1.0 * ontime / tau)
    a = cresistance * cresistance * gx * gx * minductance
    b = 2.0 * period * (rsource + irsource) * (rsource + irsource) * (ovoltage - cvoltage * ccount)
    b = b + 2.0 * cresistance * fx * (ovoltage - cvoltage * ccount) * (rsource + irsource)
    b = b + 2.0 * (cvoltage * ccount) * cresistance * gx * minductance
    b = b * -1.0
    c = 2.0 * (cvoltage * ccount) * fx * (ovoltage - cvoltage * ccount) * (rsource + irsource)
    root = b * b - 4.0 * a * c
    i = -1.0 * b - np.sqrt (b * b - 4.0 * a * c)
    i = i / (2.0 * a)
    return i, tau, offtime, period, minductance

  def ipeak (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    tau = Boost.tau (
        rsource = rsource,
        irsource = irsource,
        inductance = inductance
    )
    iavg = Boost.iavg ( 
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )[0]
    fx = 1.0 - np.exp (-1.0 * ontime / tau)
    return ((cvoltage * ccount - iavg * cresistance) * fx) / (rsource + irsource), tau, iavg

  def einductor (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    ipeak = Boost.ipeak ( 
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )[0]
    return (kcoupling * inductance * ipeak * ipeak) / 2.0, ipeak

  def ecapacitor (
    cparasiticl,
    cparasitich,
    tratio,
    ovoltage
  ):
    ech = (cparasitich * ovoltage * ovoltage) / 2.0
    lovoltage = ovoltage / (tratio + 1.0)
    ecl = (cparasiticl * lovoltage * lovoltage) / 2.0
    return ech + ecl

  def ivoltage (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    iavg = Boost.iavg ( 
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )[0]
    return ccount * cvoltage - iavg * cresistance, iavg

  def isecondary (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    ipeak = Boost.ipeak ( 
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )[0]
    minductance = Boost.minductance (
        inductance = inductance,
        tratio = tratio
    )
    return ipeak * np.sqrt ((kcoupling * inductance) / minductance), ipeak, minductance

  def idischarge (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    isecondary, _, minductance = Boost.isecondary (
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )
    ivoltage = Boost.ivoltage (
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )[0]
    return (minductance * isecondary) / (ovoltage - ivoltage), isecondary, ivoltage, minductance

  def einputoutput (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    idischarge, isecondary, ivoltage, minductance = Boost.idischarge (
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )
    return (isecondary * idischarge * ivoltage) / 2.0, isecondary, ivoltage, idischarge, minductance


  def eresistor (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    idischarge, isecondary, _, _ = Boost.idischarge (
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )
    rsecondary = Boost.rsecondary (
        irsource = irsource,
        tratio = tratio,
    )
    return (idischarge * isecondary * isecondary * (rsource + rsecondary)) / 3.0, isecondary, idischarge, rsecondary

  def eoutput (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    kcoupling,
    ontime,
    duty,
    ovoltage,
    rout
  ):
    idischarge = Boost.idischarge (
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )[0]
    offtime, period = Boost.offtime (
        ontime = ontime,
        duty = duty
    )
    return (ovoltage * ovoltage * period) / rout, idischarge, offtime

  def ecore (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    tratio,
    imass,
    imax,
    kcoupling,
    ontime,
    ovoltage,
    duty
  ):
    k = 4.855e-8
    m = 2.74 # beta
    n = 1.64 # alpha
    ipeak = Boost.ipeak ( 
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )[0]
    # predict B using inductor core constraints
    Bmax = 0.3
    B = Bmax * (ipeak / imax)
    f = 2.0 / (ontime / duty)
    return k * (B ** m) * (f ** n) * imass * (ontime / duty)

  def eswitch (
    cvoltage,
    ccount,
    cresistance,
    rsource,
    irsource,
    inductance,
    kcoupling,
    tratio,
    ontime,
    switchtime,
    ovoltage,
    duty
  ):
    ipeak = Boost.ipeak (
        cvoltage = cvoltage,
        ccount = ccount,
        cresistance = cresistance,
        rsource = rsource,
        irsource = irsource,
        inductance = inductance,
        tratio = tratio,
        kcoupling = kcoupling,
        ontime = ontime,
        ovoltage = ovoltage,
        duty = duty
    )[0]
    voltage = ovoltage / (tratio + 1.0)
    return (ipeak * voltage * switchtime) / 6.0, ipeak, voltage

  def run (
    cvoltage = 3.3, # cell voltage
    ccount = 1, # cell count
    cresistance = 5.0, # cell rc resistance
    rsource = 10.0, # cell ohmic resistance
    irsource = 1.0, # inductor equivalent series resistance
    inductance = 3.3e-3,
    imass = 20.0e-3,
    imax = 700.0e-3,
    tratio = 6.0,
    kcoupling = 1.0,
    cparasiticl = 500.0e-12,
    cparasitich = 500.0e-12,
    ontime = 10.0e-6,
    switchtime = 5.0e-9,
    duty = None,
    ovoltage = 10.0,
    rout = 15.0e3,
    verbose = False 
  ):
    einductor, ipeak = Boost.einductor (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      tratio = tratio,
      kcoupling = kcoupling,
      ontime = ontime,
      ovoltage = ovoltage,
      duty = duty
    )
    ecapacitor = Boost.ecapacitor (
      cparasiticl = cparasiticl,
      cparasitich = cparasitich,
      tratio = tratio,
      ovoltage = ovoltage
    )
    einputoutput, isecondary, ivoltage, idischarge, minductance = Boost.einputoutput (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      tratio = tratio,
      kcoupling = kcoupling,
      ontime = ontime,
      ovoltage = ovoltage,
      duty = duty
    )
    eresistor, _, _, rsecondary = Boost.eresistor (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      tratio = tratio,
      kcoupling = kcoupling,
      ontime = ontime,
      ovoltage = ovoltage,
      duty = duty
    )
    eoutput, _, downtime = Boost.eoutput (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      tratio = tratio,
      kcoupling = kcoupling,
      ontime = ontime,
      duty = duty,
      ovoltage = ovoltage,
      rout = rout
    )
    eswitch, _, svoltage = Boost.eswitch (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      kcoupling = kcoupling,
      tratio = tratio,
      ontime = ontime,
      switchtime = switchtime,
      ovoltage = ovoltage,
      duty = duty
    )
    iavg = Boost.iavg ( 
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      tratio = tratio,
      kcoupling = kcoupling,
      ontime = ontime,
      ovoltage = ovoltage,
      duty = duty
    )[0]
    
    '''
    ecore = Boost.ecore (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      tratio = tratio,
      imass = imass,
      imax = imax,
      kcoupling = kcoupling,
      ontime = ontime,
      ovoltage = ovoltage,
      duty = duty
    )
    '''
    ecore = 0.0
    
    if verbose:
      print ('input voltage:', ivoltage)
      print ('source resistance:', rsource)
      print ('primary resistance:', irsource)
      print ('secondary resistance:', rsecondary)
      print ('input inductance:', inductance)
      print ('mutual inductance:', minductance)
      print ('on time:', ontime)
      print ('off time:', downtime)
      print ('discharge:', idischarge)
      print ('frequency:', 1.0 / (ontime + downtime))
      print ('peak current:', ipeak)
      print ('secondary peak current:', isecondary)
      print ('average current:', iavg)
      print ('voltage stress:', svoltage)
      print ('output voltage:', ovoltage)
      print ('load resistance:', rout)

      print ('inductor energy:', einductor)
      print ('capacitor energy:', ecapacitor)
      print ('input energy on discharge:', einputoutput)
      print ('resistor energy on discharge:', eresistor)
      print ('output energy per cycle:', eoutput)
      print ('switch energy:', eswitch)
    return einductor - ecapacitor + einputoutput - eresistor - eoutput - eswitch - ecore, einductor, ecapacitor, einputoutput, eresistor, eoutput, eswitch, ecore, ipeak, ivoltage, downtime, idischarge

  def weight (
    inductance,
    ipeak,
    imass = None
  ):
    # core mass (assumes single turn inductor)
    perm = 2000.0
    k = 1.25e-6
    fluxdensity = 0.3
    fdensity = 4.9e6

    length = (perm * k * ipeak) / fluxdensity
    A = (inductance * length) / (perm * k)
    volume = A * length 
    mass = None
    if imass is not None:
      mass = imass
    else:
      mass = volume * fdensity

    # input capacitor (0201)
    mass = mass + 3.0e-3
    # switch (SOT-23) https://www.diodes.com/assets/Datasheets/DMN6140L.pdf
    mass = mass + 7.2e-3
    # diodes https://www.diodes.com/assets/Datasheets/DMN6140L.pdf
    mass = mass + 10e-3
    # output capacitor (0402)
    mass = mass + 6.0e-3
    # feedback resistors (0201) x 2
    mass = mass + 2.0 * 1.0e-3

    # board
    pidensity = 1.37e6
    cdensity = 8.85e6
    pit = 50e-6
    ct = 18e-6

    # polyimide layer
    mass = mass + (pidensity * pit * 20.0e-3 * 10e-3)
    # copper layer
    mass = mass + (cdensity * ct * 20.0e-3 * 10e-3)

    return mass

def main_judge ():
  ccount = 1.0
  cvoltage = 3.7
  cresistance = 2.0
  rsource = 5.6 * ccount
  irsource = 1.0
  tratio = 6.9
  kcoupling = 0.95
  cparasiticl = 1e-12
  cparasitich = 1e-12
  ontime = 1.0
  frequency = 21.7e3
  inductance = 1.9e-6
  switchtime = 15.0e-9
  ovoltage = 17.5
  rout = 330.0e3
  duty = 0.5
  ivoltage, iavg = Boost.ivoltage (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    inductance = inductance,
    tratio = tratio,
    kcoupling = kcoupling,
    ontime = ontime,
    ovoltage = ovoltage,
    duty = duty
  )
  print ('iavg', iavg)
  print ('ivoltage', ivoltage)
  print ('imax', ivoltage / (rsource + irsource))
  ipeak = ivoltage / (rsource + irsource)
  ipeak = ipeak * (1.0 -np.exp (-1.0 * ontime / (inductance / (rsource + irsource))))
  print ('ipeak', ipeak)
  tau = inductance / (rsource + irsource)
  q = ivoltage * (ontime + tau * np.exp (-1.0 * ontime / tau) - tau)
  q = q / (rsource + irsource)
  print ('iavg charge', q / (ontime / duty))
  '''
  ipeak = Boost.ipeak (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    tratio = tratio,
    kcoupling = kcoupling,
    inductance = inductance,
    ontime = 1.0 / (2.0 * frequency),
    ovoltage = ovoltage,
    duty = duty 
  )
  print (ipeak[0])
  print (Boost.run (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    tratio = tratio,
    kcoupling = kcoupling,
    cparasiticl = cparasiticl,
    cparasitich = cparasitich,
    inductance = inductance,
    ontime = 1.0 / (2.0 * frequency),
    switchtime = switchtime,
    ovoltage = ovoltage,
    rout = rout,
    duty = duty 
  )[0])
  '''

def main_plotf ():
  ccount = 3.0
  cvoltage = 3.7
  cresistance = 16.1
  rsource = 8.4
  irsource = 1.0
  tratio = 6.9 # 8.0
  imass = 32.0e-3
  imax = 700.0e-3
  kcoupling = 0.95 # 0.95
  cparasiticl = 40e-12
  cparasitich = 20e-12
  frequency = np.logspace (3, 9, 50)
  inductance = 6.2e-6 # 1.9e-6
  switchtime = 10.0e-9
  ovoltage = 200.0
  rout = 600.0e3
  duty = 0.5
  out = Boost.run (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    tratio = tratio,
    imass = imass,
    imax = imax,
    kcoupling = kcoupling,
    cparasiticl = cparasiticl,
    cparasitich = cparasitich,
    inductance = inductance,
    ontime = 1.0 / (2.0 * frequency),
    switchtime = switchtime,
    ovoltage = ovoltage,
    rout = rout,
    duty = duty 
  )
  # print (out[0])
  fig,ax = plt.subplots ()
  ax.plot (frequency, out[0])
  ax.set_xscale ('log')
  ax.axhline (y = 0.0, color = 'r')
  plt.show ()
  '''
  Boost.run (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    tratio = tratio,
    kcoupling = kcoupling,
    cparasiticl = cparasiticl,
    cparasitich = cparasitich,
    inductance = inductance,
    ontime = 1.0 / (2.0 * 14.7e3),
    switchtime = switchtime,
    ovoltage = ovoltage,
    rout = rout,
    duty = duty,
    verbose = True
  )
  '''

def solvef (
  cvoltage,
  ccount,
  cresistance,
  rsource,
  irsource,
  inductance,
  tratio,
  imass,
  imax,
  kcoupling,
  cparasiticl,
  cparasitich,
  switchtime,
  ovoltage,
  rout,
  duty,
  x0 = None
):
  def func (x):
    return Boost.run (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      tratio = tratio,
      imass = imass,
      imax = imax,
      kcoupling = kcoupling,
      cparasiticl = cparasiticl,
      cparasitich = cparasitich,
      ontime = x, # solve optimal frequency
      switchtime = switchtime,
      duty = duty,
      ovoltage = ovoltage,
      rout = rout,
      verbose = False
    )[0]
  if x0 is None:
    x0 = inductance / (rsource + irsource)
  result, info, ier, mesg = opt.fsolve (func = func, x0 = [x0], full_output = True)
  result = result[0]
  if ier != 1:
    # print ('failed')
    return False, None, None, None, None
  ivoltage, iavg = Boost.ivoltage (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    inductance = inductance,
    tratio = tratio,
    kcoupling = kcoupling,
    ontime = result,
    ovoltage = ovoltage,
    duty = duty
  )
  if ivoltage < 0.0:
    return False, None, None, None, None
  ipeak = Boost.ipeak (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    inductance = inductance,
    tratio = tratio,
    kcoupling = kcoupling,
    ontime = result,
    ovoltage = ovoltage,
    duty = duty
  )[0]
  return True, result, iavg, ivoltage, ipeak

def solvefmax (
  cvoltage,
  ccount,
  cresistance,
  rsource,
  irsource,
  inductance,
  tratio,
  imass,
  imax,
  kcoupling,
  cparasiticl,
  cparasitich,
  switchtime,
  ovoltage,
  rout,
  duty
):
  def func (x):
    return -1.0 * Boost.run (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      tratio = tratio,
      imass = imass,
      imax = imax,
      kcoupling = kcoupling,
      cparasiticl = cparasiticl,
      cparasitich = cparasitich,
      ontime = x, # solve optimal frequency
      switchtime = switchtime,
      duty = duty,
      ovoltage = ovoltage,
      rout = rout,
      verbose = False
    )[0]
  result = opt.minimize (fun = func, x0 = [inductance / (rsource + irsource)])
  success = result.success
  result = result.x[0]
  if not success:
    # print ('failed')
    return False, None, None, None, None
  ivoltage, iavg = Boost.ivoltage (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    inductance = inductance,
    tratio = tratio,
    kcoupling = kcoupling,
    ontime = result,
    ovoltage = ovoltage,
    duty = duty
  )
  ipeak = Boost.ipeak (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    inductance = inductance,
    tratio = tratio,
    kcoupling = kcoupling,
    ontime = result,
    ovoltage = ovoltage,
    duty = duty
  )[0]
  return True, result, iavg, ivoltage, ipeak

def solvei (
  cvoltage,
  ccount,
  cresistance,
  rsource,
  irsource,
  tratio,
  kcoupling,
  cparasitic,
  ontime,
  switchtime,
  ovoltage,
  rout,
  duty
):
  def func (x):
    return Boost.run (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = x, # solve optimal inductance
      tratio = tratio,
      kcoupling = kcoupling,
      cparasitic = cparasitic,
      ontime = ontime,
      switchtime = switchtime,
      duty = duty,
      ovoltage = ovoltage,
      rout = rout,
      verbose = False
    )[0]
  result, info, ier, mesg = opt.fsolve (func = func, x0 = [ontime / rsource], full_output = True)
  result = result[0]
  if ier != 1:
    return False, None, None, None, None
  ivoltage, iavg, ipeak = Boost.ivoltage (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    inductance = result,
    tratio = tratio,
    kcoupling = kcoupling,
    ontime = ontime,
    ovoltage = ovoltage
  )
  return True, result, iavg, ivoltage, ipeak

def main_test ():
  # constants
  ccount = 1.0
  cvoltage = 3.7
  cresistance = 0.001
  rsource = 6.0
  irsource = 1.0
  tratio = 8.0
  imass = 32.0e-3
  imax = 700.0e-3
  kcoupling = 0.95 # 0.95
  cparasiticl = 40e-12
  cparasitich = 40e-12
  # frequency = 150e3
  inductance = 1.9e-6 # 1.9e-6
  switchtime = 10.0e-9
  ovoltage = 90.0
  rout = 1000.0e3
  duty = 0.5
  success, result, iavg, ivoltage, ipeak = solvef (
    cvoltage = cvoltage,
    ccount = ccount,
    cresistance = cresistance,
    rsource = rsource,
    irsource = irsource,
    tratio = tratio,
    imass = imass,
    imax = imax,
    kcoupling = kcoupling,
    cparasiticl = cparasiticl,
    cparasitich = cparasitich,
    inductance = inductance,
    # ontime = 1.0 / (2.0 * frequency),
    switchtime = switchtime,
    ovoltage = ovoltage,
    rout = rout,
    duty = duty,
    x0 = 1.0
  )
  if success:
    print (Boost.run (
      cvoltage = cvoltage,
      ccount = ccount,
      cresistance = cresistance,
      rsource = rsource,
      irsource = irsource,
      inductance = inductance,
      # inductance = result,
      tratio = tratio,
      imass = imass,
      imax = imax,
      kcoupling = kcoupling,
      cparasiticl = cparasiticl,
      cparasitich = cparasitich,
      # ontime = 1.0 / (2.0 * frequency),
      ontime = result,
      switchtime = switchtime,
      duty = duty,
      ovoltage = ovoltage,
      rout = rout,
      verbose = True
    )[0])
    print ()
    tau = inductance / (rsource + irsource)
    q = cvoltage * (result + tau * np.exp (-1.0 * result / tau) - tau)
    q = q / (rsource + irsource)
    print ('iavg charge', q / (result / duty))
  else:
    # print ('failed')
    pass


def main_sweep ():
  parser = argparse.ArgumentParser (description = 'Sweep across mechanical options and determine ideal magnetic circuit')

  parser.add_argument ('--file', '-f', type = str, required = True)
  parser.add_argument ('--split', '-s', action = 'store_true', default = False)

  args = parser.parse_args ()
  params = {
    'ccount': [1],
    'tratio': [1.5, 2.0, 3.0, 10.0],
    'duty': list (np.linspace (0.1, 0.5, 50)),
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
  inductance = 1.9e-6
  imass = 54e-3 
  imax = 700.0e-3 
  irsource = 1.0
  kcoupling = 0.95
  cparasiticl = 40e-12
  cparasitich = 20e-12
  switchtime = 5.0e-9

  # grab option data
  df = pd.read_csv (args.file)

  cols = [col for col in df.columns]
  cols.append ('ccount')
  cols.append ('boost-frequency')
  cols.append ('inductance')
  cols.append ('boost-mass')
  cols.append ('boost-vin')
  cols.append ('boost-load')
  cols.append ('battery-mass')
  cols.append ('battery-alpha')
  cols.append ('runtime')
  dfout = pd.DataFrame (columns = cols)
  outfile = os.path.splitext (args.file)[0] + '-boost.csv'
  for i in range (df.shape[0]):
    if i % 100 == 0:
      print (i)
    # grab option
    row = df.iloc[i]
    iav = float (row['averageCurrent'])
    voltage = float (row['appliedVoltage'])
    precurrent = float (row['total-additional-current'])
    load = voltage / iav
    # iterate through all circuit options
    for j, op in enumerate (product):
      incvoltage = None
      if args.split:
        incvoltage = cvoltage
      else:
        incvoltage = cvoltage - (precurrent * cresistance)
      success, ontime, iavg, vin, ipk = solvef (
        cvoltage = incvoltage,
        ccount = op[0],
        cresistance = cresistance,
        inductance = inductance,
        rsource = rsource,
        irsource = irsource,
        tratio = op[1],
        kcoupling = kcoupling,
        imass = imass,
        imax = imax,
        cparasiticl = cparasiticl,
        cparasitich = cparasitich,
        switchtime = switchtime,
        ovoltage = voltage,
        rout = load,
        duty = 0.5 # start at 0.5 more likely to succeed
      )
      if not success:
        continue
      if ontime < 0.0:
        continue
      success, ontime, iavg, vin, ipk = solvef (
        cvoltage = incvoltage,
        ccount = op[0],
        cresistance = cresistance,
        inductance = inductance,
        rsource = rsource,
        irsource = irsource,
        tratio = op[1],
        kcoupling = kcoupling,
        imass = imass,
        imax = imax,
        cparasiticl = cparasiticl,
        cparasitich = cparasitich,
        switchtime = switchtime,
        ovoltage = voltage,
        rout = load,
        duty = op[2], # real
        x0 = ontime # use previous as initial guess
      )
      if not success:
        continue
      if ontime < 0.0:
        continue
      # get weight
      mass = Boost.weight (
        inductance = inductance,
        ipeak = ipk,
        imass = imass
      )
      netThrust = float (row['netThrust'])
      if mass >= netThrust:
        continue
      # get battery
      runtime, alpha = None, 0.0
      if args.split:
        runtime, alpha = Battery.bMass2 (op[0], iavg, 1, precurrent, netThrust - mass)
      else:
        runtime = Battery.bMass (op[0], iavg + precurrent, netThrust - mass)
      row['ccount'] = op[0]
      row['boost-frequency'] = op[2] / ontime
      row['inductance'] = inductance
      row['boost-mass'] = mass
      row['boost-vin'] = vin
      row['boost-load'] = iavg
      row['battery-mass'] = netThrust - mass
      row['battery-alpha'] = alpha
      row['runtime'] = runtime
      row['netThrust'] = 0.0
      dfout = pd.concat ([dfout, row.to_frame ().T], ignore_index = True)
  dfout.to_csv (outfile, index = False)

if __name__ == '__main__':
  # main_plotf ()
  # main_test ()
  main_sweep ()
