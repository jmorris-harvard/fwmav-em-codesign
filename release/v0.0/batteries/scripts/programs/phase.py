import numpy as np
import pandas as pd
import time
import sys

from . import sine as plotter

def combine (high, low):
  data = []
  for h, l in zip (high, low):
    value = (int (h) << 8) | int (l)
    if value & 0x8000: # 2s complement conversion
      value = value - 0x10000 
    if value != 0:
      data.append (value)
  return data

def phase (dev, verbose = False):
  n = 25
  r = 4.8
  sv = 5.0
  phase_samples = 10
  phase_step = 500
  phase_sweep = 25
  vlsb = 0.003125
  clsb = 0.005 / (2.0 ** 15.0)
  
  timers = 200 # 10kHz sig
  delaym = 9539 # 5kHz sampling rate

  freq = 1.0 / ((timers / 50.0e6) * float (n))

  # configure stimulation
  dev.setWire (0x01, 0x00, mask = 0x1F) # config
  dev.setWire (0x02, timers) # timer
  dev.setWire (0x04, n - 1) # top
  X = np.linspace (0.0, 2.0 * np.pi, n)
  Y = []
  bit10 = int (2 ** 10)
  bit12 = int (2 ** 12)
  for x in X:
    sine = np.sin (x)
    Y.append (int (sine * int (bit10 / 2) + int (bit12 / 2)))
  Ys = np.array (Y) / bit12
  Ys = Ys * sv
  # plotter.digitized (Ys)
  # write data
  for y in Y:
    dev.setWire (0x03, y)
    dev.setTrigger (0x40, 0x0)

  # configure recording
  shunt = int (819.2e6 * clsb * r)
  dev.setWire (0x05, (shunt << 1) | 0x1 << 16, mask = 0xFFFFF) # shunt config
  dev.setWire (0x06, 0x1, mask = 0xFFFF) # timer
  dev.setWire (0x07, delaym, mask = 0xFFFF) # delay
  dev.setWire (0x08, phase_sweep, mask = 0xFFFF) # sweep
  dev.setWire (0x09, phase_step, mask = 0xFFFF) # step
  dev.setWire (0x0a, phase_samples, mask = 0xFFFF) # samples

  input ('press <enter> to begin s...')
  dev.setTrigger (0x40, 0x1)
  dev.setTrigger (0x40, 0x2)
  cnt = 0
  total_samples = phase_samples * phase_sweep
  vvalues = []
  cvalues = []
  while cnt < total_samples:
    time.sleep (5)
    data = dev.readBuffer (0xA0, 5 * total_samples)
    print (data)

    vlow = data[0::4]
    vhigh = data[1::4]
    clow = data[2::4]
    chigh = data[3::4]

    voltages = combine (vhigh, vlow)
    vvalues.extend (list (np.array (voltages) * vlsb))
    currents = combine (chigh, clow)
    cvalues.extend (list (np.array (currents) * clsb))

    cnt = cnt + len (vvalues)
    print ('got (%d,%d) out of %d samples' % (cnt, len(cvalues), total_samples))
  dev.setTrigger (0x40, 0x1)
  dev.setTrigger (0x40, 0x2)
  samples_v = dict ()
  samples_c = dict ()
  for i in range (phase_sweep):
    samples_v['%d' % (i)] = vvalues[i * phase_samples:(i + 1) * phase_samples]
    samples_c['%d' % (i)] = cvalues[i * phase_samples:(i + 1) * phase_samples]
  df_v = pd.DataFrame.from_dict (samples_v)
  df_v.to_csv ('samples_v.csv')
  df_c = pd.DataFrame.from_dict (samples_c)
  df_c.to_csv ('samples_c.csv')
  dev.setTrigger (0x40, 0x1)
  dev.setTrigger (0x40, 0x2)
