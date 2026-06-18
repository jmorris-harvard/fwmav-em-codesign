import cma
import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
import pandas as pd
import argparse

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

  def residualsZ (this, params, freq, mag, phase, phaseweight = 100e9):
    M, P = this.modelZ (params, freq)
    Merror = M - mag
    Perror = P - phase
    return np.concatenate ([Merror, Perror * phaseweight])

  def residualsY (this, params, freq, mag, phase, phaseweight = 100e9):
    M, P = this.modelY (params, freq)
    Merror = M - mag
    Perror = P - phase
    return np.concatenate ([Merror, Perror * phaseweight])

  def initializeCMA (this, frequencies, magnitudes, phases):
    this.frequencies = frequencies
    this.magnitudes = magnitudes
    this.phases = phases

  def objectiveZ (this, params, phaseweight = 20.0e6):
    M, P = this.modelZ (params, this.frequencies)
    Mr = M - this.magnitudes
    Pr = P - this.phases
    return float (np.vdot (Mr, Mr)) + float (np.vdot (Pr, Pr)) * phaseweight

  def objectiveY (this, params, phaseweight = 20.0e6):
    M, P = this.modelY (params, this.frequencies)
    Mr = M - this.magnitudes
    Pr = P - this.phases
    return float (np.vdot (Mr, Mr)) + float (np.vdot (Pr, Pr)) * phaseweight

  def impedance (this, params, freq):
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
    # this.expected = [0.9e3, 220e-9]

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
    # this.expected = [1.0e3, 7.5e3, 220e-9]

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
    # this.expected = [1.0e3, 7.5e3, 220e-9]

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
    # DW0 = np.sqrt (W0 * W0 - D0 * D0)
    # DF0 = DW0 / (2.0 * np.pi)
    print (f'Primary Resonance = {F0:.2e} Hz')
    # print (f'Damped Primary Resonance = {DF0:.2e} Hz')

class RModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [10]
    this.bounds = ([0.01], [1e9])
    # this.expected = [0.9e3, 220e-9]

  def impedance (this, params, freq):
    R = params[0]
    omega = 2.0 * np.pi * freq
    return R

  def print (this, params):
    R = params[0]
    print (f'Fitted Values:\nR = {R:.2e} Ohms')

class CModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [1e-9]
    this.bounds = ([1e-15], [1])
    # this.expected = [0.9e3, 220e-9]

  def impedance (this, params, freq):
    C = params[0]
    omega = 2.0 * np.pi * freq
    return 1.0 / (1.0j * omega * C)

  def print (this, params):
    C = params[0]
    print (f'Fitted Values:\nC = {C:.2e} Farads')

class SRLCModel (CircuitModel):
  def __init__ (this):
    super ().__init__ ()
    this.initial = [10, 1e-6, 1e-9]
    this.bounds = ([0.01, 1e-9, 1e-15], [1e9, 1e-3, 1])

  def impedance (this, params, freq):
    R, L, C = params
    omega = 2.0 * np.pi * freq
    return R + 1.0j * omega * L + 1.0 / (1.0j * omega * C)

  def print (this, params):
    R, L, C = params
    print (f'Fitted Values:\nR = {R:.2e} Ohms\nL = {L:.2e} Henries\nC = {C:.2e} Farads')

def main ():
  parser = argparse.ArgumentParser (description = '')
  parser.add_argument ('data')
  parser.add_argument ('-m', '--model', type = str, default = 'piezo')
  parser.add_argument ('--admittance', default = False, action = 'store_true')
  args = parser.parse_args ()
  df = pd.read_csv (args.data)

  frequency = df['frequency (Hz)'].to_numpy ()
  magnitude = None
  if args.admittance:
    magnitude = df['admittance (S)'].to_numpy ()
  else:
    magnitude = df['impedance (Ohm)'].to_numpy ()
  magnitude = np.abs (magnitude)
  phase = df['phase (rad)'].to_numpy ()
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
  else:
    print ('unknown model given')
    sys.exit (1)

  model.initialize ((4.5e6, 6.6e-9, 8e3, 1800e-12, 8))
  model.initializeCMA (frequency, magnitude, phase)
  opts = {
    'seed': 0,
    'popsize': 24,
    'maxiter': 3000,
    'bounds': model.bounds
  }
  result = None
  if args.admittance:
    es = cma.CMAEvolutionStrategy (
        model.initial,
        0.5, # sigma0
        opts
    )
    result = es.optimize (
        model.objectiveY
    )
  else:
    es = cma.CMAEvolutionStrategy (
        model.initial,
        0.5, # sigma0
        opts
    )
    result = es.optimize (
        model.objectiveZ
    )

  frequency_smooth = np.logspace (0, 4, 1000)
  inp = result.result.xbest
  # inp = (4.5e6, 6.6e-9, 12e3, 1800e-12, 8)
  model.print (inp)
  Mmodel, Pmodel = None, None
  if args.admittance:
    Mmodel, Pmodel = model.modelY (inp, frequency_smooth)
  else:
    Mmodel, Pmodel = model.modelZ (inp, frequency_smooth)
  comsol = pd.read_csv ('loaded.csv')
  comsolm = comsol[comsol['width (mm)'] == 2]
  comsolm = comsolm[comsolm['length (mm)'] == 10]
  comsolp = comsol[comsol['width (mm)'] == 2]
  comsolp = comsolp[comsolp['length (mm)'] == 7]
  plt.figure (figsize=(12, 5))
  plt.subplot (1, 2, 1)
  plt.scatter (frequency, magnitude, label='Measured', alpha=0.6)
  plt.semilogx (frequency_smooth, Mmodel, label='Model', linewidth=2)
  plt.plot (comsolm['freq (Hz)'].to_numpy (), comsolm['Impedance Magnitude (Ohms)'], label = 'COMSOL Model', lw = 2, color = 'red', linestyle = '--')
  plt.xlim ([1, 1e4])
  # if model.expected is not None:
  #   Mexp, _ = model.model (model.expected, frequency)
  #   plt.semilogx (frequency, Mexp, label='Expected', linewidth=2)
  plt.title ("Magnitude Response")
  plt.xlabel ("Frequency (Hz)")
  plt.ylabel ("Magnitude")
  plt.yscale ('log')
  plt.legend ()
  plt.grid ()

  plt.subplot (1, 2, 2)
  plt.scatter (frequency, phase, label='Measured', alpha=0.6)
  plt.semilogx (frequency_smooth, Pmodel, label='Model', linewidth=2)
  plt.plot (comsolp['freq (Hz)'].to_numpy (), comsolp['Impedance Phase (rad)'] * 180.0 / np.pi, label = 'COMSOL Model', lw = 2, color = 'red', linestyle = '--')
  plt.xlim ([1, 1e4])
  # if model.expected is not None:
  #   _, Pexp = model.model (model.expected, frequency)
  #   plt.semilogx (frequency, Pexp, label='Expected', linewidth=2)
  plt.title ("Phase Response")
  plt.xlabel ("Frequency (Hz)")
  plt.ylabel ("Phase (degrees)")
  plt.legend ()
  plt.grid ()

  rm = RModel ()
  rmm, rmp = rm.model ((inp[0]), frequency_smooth)
  cm = CModel ()
  cmm, cmp = cm.model ((inp[1]), frequency_smooth)
  srlcm = SRLCModel ()
  srlcmm, srlcmp = srlcm.model ((inp[2], inp[3], inp[4]), frequency_smooth)
  plt.figure (figsize = (12, 5))
  plt.subplot (1, 1, 1)
  plt.semilogx (frequency_smooth, rmm, label = 'R Model')

  plt.tight_layout ()
  plt.show ()

if __name__ == '__main__':
  main ()
