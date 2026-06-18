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

def record (dev, verbose = False):
  n = 25
  r = 4.8
  sv = 5.0
  read = 1024
  vlsb = 0.003125
  clsb = 0.005 / (2.0 ** 15.0)
  timers = 153
  delaym = 8000
  freq = 1.0 / ((timers / 50.0e6) * 32.0)
  sleep = 1

  # configure stimulation
  dev.setWire (0x01, 0x00, mask = 0x1F) # config
  dev.setWire (0x02, 0x7F) # timer
  dev.setWire (0x04, n - 1) # mem top
  X = np.linspace (0.0, 2.0 * np.pi, n)
  Y = []
  bit10 = int (2 ** 10)
  bit12 = int (2 ** 12)
  for x in X:
    sine = np.sin (x)
    Y.append (int (sine * int (bit10 / 2) + int (bit12 / 2)))
  Ys = np.array (Y) / bit12
  Ys = Ys * sv
  plotter.digitized (Ys)
  # write data
  print (Y)
  for y in Y:
    dev.setWire (0x03, y)
    dev.setTrigger (0x40, 0x0)

  # configure recording
  shunt = int (819.2e6 * clsb * r)
  dev.setWire (0x05, (shunt << 1), mask = 0xFFFF)
  dev.setWire (0x06, 0x1, mask = 0xFFFF) # timer
  dev.setWire (0x07, 8000)
  measurements = [
    bytearray (0), # vlow
    bytearray (0), # vhigh
    bytearray (0), # clow
    bytearray (0), # chigh
  ]

  input ('press <enter> to begin s...')
  dev.setTrigger (0x40, 0x1)
  dev.setTrigger (0x40, 0x2)
  vvalues = []
  cvalues = []
  try:
    print ('running, press CTRL-C to end')
    while True:
      time.sleep (sleep)
      data = dev.readBuffer (0xA0, read)
      vlow = data[0::4]
      vhigh = data[1::4]
      clow = data[2::4]
      chigh = data[3::4]
      voltages = combine (vhigh, vlow)
      vvalues.extend (list (np.array (voltages) * vlsb))
      currents = combine (chigh, clow)
      cvalues.extend (list (np.array (currents) * clsb))
  except:
    dev.setTrigger (0x40, 0x1)
    dev.setTrigger (0x40, 0x2)
    print ('terminated')
  with open ('output.csv', 'w') as csv:
    csv.write ('voltage,current\n')
    for row in zip (vvalues, cvalues):
      csv.write (','.join ([str (r) for r in row]) + '\n')
