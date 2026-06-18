import argparse
import cma
import itertools
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy as sp
import sys

class CircuitModel ():
  def __init__ (this):
    this.initial = None
    this.bounds = None
    this.expected = None

  def modelZ (this, params, freq):
    H = this.impedance (params, freq)
    M = np.abs (H)
    P = np.angle (H, deg = True)
    return M, P

  def modelY (this, params, freq):
    M, P = this.modelZ (params, freq)
    return 1.0 / M, -1.0 * P

  def initialize (this, params):
    this.initial = params

  def randomInitialize (this):
    params = list ()
    for low, high in zip (this.bounds[0], this.bounds[1]):
      params.append (np.random.uniform (low, high))
    this.initial = tuple (params)

  def initializeCMA (this, frequencies, magnitudes, phases):
    this.frequencies = frequencies
    this.magnitudes = magnitudes
    this.phases = phases

  def residualsZ (this, params, freq, mag, phase, magweight = 1.0e3, phaseweight = 1.0e-3):
    M, P = this.modelZ (params, freq)
    Merror = (M - mag) / mag
    Perror = (P - phase) / phase
    return np.concatenate ([Merror * magweight, Perror * phaseweight])

  def residualsY (this, params, freq, mag, phase, magweight = 1.0e3, phaseweight = 1.0e-3):
    M, P = this.modelY (params, freq)
    Merror = (M - mag) / mag
    Perror = (P - phase) / phase
    return np.concatenate ([Merror * magweight, Perror * phaseweight])

  def objectiveZ (this, params, magweight = 1.0, phaseweight = 1.0e-6):
    M, P = this.modelZ (params, this.frequencies)
    Mr = (M - this.magnitudes) / this.magnitudes
    Pr = (P - this.phases) / this.phases
    return float (np.vdot (Mr, Mr)) * magweight + float (np.vdot (Pr, Pr)) * phaseweight

  def objectiveY (this, params, magweight = 1.0, phaseweight = 1.0e-6):
    M, P = this.modelY (params, this.frequencies)
    Mr = (M - this.magnitudes) / this.magnitudes
    Pr = (P - this.phases) / this.phases
    return float (np.vdot (Mr, Mr)) * magweight + float (np.vdot (Pr, Pr)) * phaseweight

  def impedance (this):
    raise NotImplementedError ('please implement impedance method in subclass')

  def Zc (c, freq):
    omega = 2.0 * np.pi * freq
    return 1.0 / (1.0j * omega * c)

  def Zl (l, freq):
    omega = 2.0 * np.pi * freq
    return 1.0j * omega * l

  def Zr (r, freq):
    return r

class RCModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [10, 1e-9]
    this.bounds = ([0.01, 1e-15], [1e9, 1])

  def impedance (this, params, freq):
    R, C = params
    omega = 2.0 * np.pi * freq
    return R + 1.0 / (1.0j * omega * C)

  def print (this, params):
    R, C = params
    print (f'Fitted Values:\nR = {R:.2e} Ohms\nC = {C:.2e} Farads')

class PRCModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [10, 1e-9]
    this.bounds = ([0.01, 1e-15], [1e9, 1])
    this.expected = [1.2e3, 220e-9]

  def impedance (this, params, freq):
    R, C = params
    omega = 2.0 * np.pi * freq
    ZR = R
    ZC = 1.0 / (1.0j * omega * C)
    return (ZR * ZC) / (ZR + ZC)

  def print (this, params):
    R, C = params
    print (f'Fitted Values:\nR = {R:.2e} Ohms\nC = {C:.2e} Farads')

class RCEModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [10, 10, 1e-9]
    this.bounds = ([0.01, 0.01, 1e-15], [1e9, 1e9, 1])

  def impedance (this, params, freq):
    R1, R2, C = params
    omega = 2.0 * np.pi * freq
    ZR1 = R1
    ZR2 = R2
    ZC = 1.0 / (1.0j * omega * C)
    P = (ZR2 * ZC) / (ZR2 + ZC)
    return P + ZR1

  def print (this, params):
    R1, R2, C = params
    print (f'Fitted Values:\nR1 = {R1:.2e} Ohms\nR2 = {R2:.2e} Ohms\nC = {C:.2e} Farads')

class RCBATModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [10, 10, 1e-9, 10, 1e-9]
    this.bounds = ([0.01, 0.01, 1e-15, 0.01, 1e-15], [1e9, 1e9, 1, 1e9, 1])

  def impedance (this, params, freq):
    R0, R1, C1, R2, C2 = params
    omega = 2.0 * np.pi * freq
    ZR0 = R0
    ZR1 = R1
    ZR2 = R2
    ZC1 = 1.0 / (1.0j * omega * C1)
    ZC2 = 1.0 / (1.0j * omega * C2)
    P1 = (ZR1 * ZC1) / (ZR1 + ZC1)
    P2 = (ZR2 * ZC2) / (ZR2 + ZC2)
    return P1 + P2 + ZR0

  def print (this, params):
    R0, R1, C1, R2, C2 = params
    print (f'Fitted Values:')
    print (f'R0 = {R0:.2e} Ohms')
    print (f'R1 = {R1:.2e} Ohms')
    print (f'C1 = {C1:.2e} Farads')
    print (f'R2 = {R2:.2e} Ohms')
    print (f'C2 = {C2:.2e} Farads')

class PiezoModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [4.5e6, 7e-9, 20e3, 1e-9, 20]
    this.bounds = ([1e3, 1e-9, 100, 1e-12, 1e-6], [1e9, 1e-6, 1e9, 1e-6, 1e6])

  def impedance (this, params, freq):
    R0, C0, R1, C1, L1 = params
    ZR0 = CircuitModel.Zr (R0, freq)
    ZC0 = CircuitModel.Zc (C0, freq)
    ZR1 = CircuitModel.Zr (R1, freq)
    ZC1 = CircuitModel.Zc (C1, freq)
    ZL1 = CircuitModel.Zl (L1, freq)
    S1 = ZR1 + ZC1 + ZL1
    Z = (ZC0 * S1) / (ZC0 + S1)
    Z = (ZR0 * Z) / (ZR0 + Z)
    return Z

  def print (this, params):
    R0, C0, R1, C1, L1 = params
    print (f'Fitted Values:')
    print (f'R0 = {R0:.2e} Ohms')
    print (f'C0 = {C0:.2e} Farads')
    print (f'R1 = {R1:.2e} Ohms')
    print (f'C1 = {C1:.2e} Farads')
    print (f'L1 = {L1:.2e} Henries')
    W0 = 1.0 / np.sqrt (L1 * C1)
    F0 = W0 / (2.0 * np.pi)
    D0 = R1 / (2.0 * L1)
    print (f'Primary Resonance = {F0:.2e} Hz')

class IdealPiezoModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [6.6e-9, 8e3, 1800e-12, 8]
    this.bounds = ([1e-12, 1e3, 1e-12, 1e-3], [1e-6, 1e6, 1e-6, 1e6])

  def impedance (this, params, freq):
    C0, R1, C1, L1 = params
    ZC0 = CircuitModel.Zc (C0, freq)
    ZR1 = CircuitModel.Zr (R1, freq)
    ZC1 = CircuitModel.Zc (C1, freq)
    ZL1 = CircuitModel.Zl (L1, freq)
    S1 = ZR1 + ZC1 + ZL1
    Z = (ZC0 * S1) / (ZC0 + S1)
    return Z

  def print (this, params):
    C0, R1, C1, L1 = params
    print (f'Fitted Values:')
    print (f'C0 = {C0:.2e} Farads')
    print (f'R1 = {R1:.2e} Ohms')
    print (f'C1 = {C1:.2e} Farads')
    print (f'L1 = {L1:.2e} Henries')
    W0 = 1.0 / np.sqrt (L1 * C1)
    F0 = W0 / (2.0 * np.pi)
    D0 = R1 / (2.0 * L1)
    print (f'Primary Resonance = {F0:.2e} Hz')

def main ():
  parser = argparse.ArgumentParser (description = '')
  parser.add_argument ('data')
  parser.add_argument ('-m', '--model', type = str, default = 'idealpiezo')
  parser.add_argument ('--admittance', default = False, action = 'store_true')
  parser.add_argument ('--optimizer', type = str, default = 'ls')
  parser.add_argument ('--verbose', default = False, action = 'store_true')
  args = parser.parse_args ()

  data = pd.read_csv (args.data)

  lengths = list (data['length (mm)'].unique ())
  widths = list (data['width (mm)'].unique ())
  combinations = itertools.product (lengths, widths)

  output = {
    'length': [],
    'width': [],
    'bulk': [],
    'capacitance': [],
    'inductance': [],
    'resistance': []
  }
  for i, (length, width) in enumerate (combinations):
    print (f'solving length = {length} mm, width = {width} mm...')
    subdata = data[data['length (mm)'] == length]
    subdata = subdata[subdata['width (mm)'] == width]

    frequency = subdata['frequency (Hz)'].to_numpy ()
    if frequency[0] > 2.0:
      continue
    magnitude = None
    phase = None
    if args.admittance:
      magnitude = subdata['admittance (S)'].to_numpy ()
      phase = subdata['phase (rad)'].to_numpy () * 180.0 / np.pi
    else:
      magnitude = subdata['impedance (Ohm)'].to_numpy ()
      magnitude = np.abs (magnitude)
      phase = subdata['phase (rad)'].to_numpy () * 180.0 / np.pi
      if args.admittance:
        phase = -1.0 * phase

    model = None
    if args.model.lower () == 'rc':
      model = RCModel ()
    elif args.model.lower () == 'rce':
      model = RCEModel ()
    elif args.model.lower () == 'prc':
      model = PRCModel ()
    elif args.model.lower () == 'rcbat':
      model = RCBATModel ()
    elif args.model.lower () == 'piezo':
      model = PiezoModel ()
    elif args.model.lower () == 'idealpiezo':
      model = IdealPiezoModel ()
    else:
      print ('unknown model given')
      sys.exit (1)

    inp = None
    if args.optimizer == 'ls':
      result = None
      if args.admittance:
        result = sp.optimize.least_squares (
            model.residualsY,
            model.initial,
            args = (frequency, magnitude, phase),
            bounds = model.bounds
        )
      else:
        result = sp.optimize.least_squares (
            model.residualsZ,
            model.initial,
            args = (frequency, magnitude, phase),
            bounds = model.bounds
        )
      inp = result.x
    elif args.optimizer == 'cma':
      result = None
      # model.randomInitialize ()
      model.initializeCMA (frequency, magnitude, phase)
      opts = {
        'seed': 0,
        'popsize': 24,
        'maxiter': 3000,
        'bounds': model.bounds
      }
      es = cma.CMAEvolutionStrategy (
          model.initial,
          0.5,
          opts
      )
      if args.admittance:
        result = es.optimize (model.objectiveY)
      else:
        result = es.optimize (model.objectiveZ)
      inp = result.result.xbest
    else:
      print (f'invalid optimizer requested ({args.optimizer})')
      sys.exit ()
    model.print (inp)

    output['length'].append (length)
    output['width'].append (width)
    if args.model == 'idealpiezo':
      output['bulk'].append (inp[0])
      output['resistance'].append (inp[1])
      output['capacitance'].append (inp[2])
      output['inductance'].append (inp[3])
    elif args.model == 'piezo':
      output['bulk'].append (inp[1])
      output['resistance'].append (inp[2])
      output['capacitance'].append (inp[3])
      output['inductance'].append (inp[4])

    if args.verbose:
    # if length == 10 and width == 5:
      frequency_smooth = np.logspace (0, 4, 1000)
      Mmodel, Pmodel = None, None
      if args.admittance:
        Mmodel, Pmodel = model.modelY (inp, frequency_smooth)
      else:
        Mmodel, Pmodel = model.modelZ (inp, frequency_smooth)
      fig, ax = plt.subplots (figsize = (6, 5))
      ax.scatter (frequency, magnitude, label='Measured', color = 'gray', alpha=0.6)
      ax.semilogx (frequency_smooth, Mmodel, label='Circuit Model', linewidth=2, color = '#009e73', linestyle = '-')
      ax.set_xlim ([1, 1e4])
      ax.set_title ("Magnitude Response")
      ax.set_xlabel ("Frequency (Hz)")
      ax.set_ylabel ("Magnitude")
      ax.set_yscale ('log')
      ax.legend ()
      ax.grid ()

      fig, ax = plt.subplots (figsize = (6, 5))
      ax.scatter (frequency, phase, label='Measured', color = 'gray', alpha=0.6)
      ax.semilogx (frequency_smooth, Pmodel, label='Model', linewidth=2, color = '#009e73', linestyle = '-')
      ax.set_title ("Phase Response")
      ax.set_xlabel ("Frequency (Hz)")
      ax.set_ylabel ("Phase (degrees)")
      ax.set_xlim ([1, 1e4])
      ax.set_ylim ([-90, 90])
      ax.legend ()
      ax.grid ()

      plt.tight_layout ()
      plt.show ()

  df = pd.DataFrame.from_dict (output)
  df.to_csv ('output.csv')

if __name__ == '__main__':
  main ()
