import numpy as np
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

def get_time_m (target, div):
  return int ((50.0e6 * div - 3.0 * 153.0 * target - 8000 * target) / target)

def get_sampling_m (delay):
  return 50.0e6 / (8000.0 + 3.0 * 153.0 + float (delay))

def current (dev, verbose = False):
  n = 32
  r = 4.8
  sv = 5.0
  read = 256
  vlsb = 0.003125
  clsb = 0.005 / (2.0 ** 15.0)
  timers = 153 # minimum 153
  rtimers = 153 * 50
  delaym = 8000
  freq = 1.0 / ((timers / 50.0e6) * 32.0)
  rfreq = 1.0 / ((rtimers / 50.0e6) * 32.0)
  cc = 1
  gain = 0x03 # 0110 or 0011

  # configure stimulation
  dev.setWire (0x01, cc | (gain << 1), mask = 0x1F) # config
  dev.setWire (0x02, rtimers) # timer
  X = np.linspace (0.0, 1.0, n)
  Y = []
  bit8 = int (2 ** 8)
  bit10 = int (2 ** 10)
  bit12 = int (2 ** 12)
  for x in X:
    line = x * bit12
    Y.append (int (line))
  Ys = np.array (Y) / bit12
  if cc == 1:
    Ys = Ys * (120e-6 / float (bit12))
  else:
    Ys = Ys * sv
  plotter.digitized (Ys)
  # write data
  for y in Y:
    dev.setWire (0x03, y)
    dev.setTrigger (0x40, 0x0)

  # configure recording
  shunt = int (819.2e6 * clsb * r)
  dev.setWire (0x04, (shunt << 1), mask = 0xFFFF)
  dev.setWire (0x05, 0x1, mask = 0xFFFF) # timer

  delays = [get_time_m (freq, m) for m in [2.0]] 
  measurements = [
    bytearray (0), # vlow
    bytearray (0), # vhigh
    bytearray (0), # clow
    bytearray (0), # chigh
  ]

  input ('press <enter> to begin ...')
  while True:
    for d in delays:
      print ('running sample rate (%d)...' % (get_sampling_m (d)))
      dev.setWire (0x06, 8000 + d)
      dev.setTrigger (0x40, 0x1)
      dev.setTrigger (0x40, 0x2)
      time.sleep (5)
      data = dev.readBuffer (0xA0, 1024)
      vlow = data[0::4]
      vhigh = data[1::4]
      clow = data[2::4]
      chigh = data[3::4]
      v = combine ([vhigh[0]], [vlow[0]])[0] * vlsb
      c = combine ([chigh[0]], [clow[0]])[0] * clsb
      voltages = combine (vhigh, vlow)
      vvalues = np.array (voltages) * vlsb
      currents = combine (chigh, clow)
      cvalues = np.array (currents[::-1]) * clsb
      tlsb = (8000.0 + float (d)) / 50.0e6
      t = [float (i) * tlsb for i in range (len (vvalues))]
      with open ('output_%s_%s.csv' % (str (rfreq), d), 'w') as csv:
        csv.write ('time,voltage,current\n')
        for row in zip (t, vvalues, cvalues):
          csv.write (','.join ([str (r) for r in row]) + '\n')
      dev.setTrigger (0x40, 0x1)
      dev.setTrigger (0x40, 0x2)
    break
