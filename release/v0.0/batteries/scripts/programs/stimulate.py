import numpy as np
import time
import sys

from . import sine as plotter

def stimulate (dev, verbose = False):
  n = 25
  sv = 5.0
  dev.setWire (0x01, 0x00, mask = 0x1F) # config
  dev.setWire (0x02, 20000) # timer
  dev.setWire (0x04, n - 1) # Mem Top
  
  X = np.linspace (0.0, 2.0 * np.pi, n)
  Y = []
  bit10 = int (2 ** 10)
  bit12 = int (2 ** 12)
  for x in X:
    sine = np.sin (x)
    Y.append (int (sine * int (bit10 / 1.25) + int (bit10 / 1.25)))
  Z = [y >> 2 for y in Y]
  Ys = np.array (Y) / bit12
  Ys = Ys * sv
  plotter.digitized (Y)
  plotter.digitized (Ys)
  Zs = np.array (Z) / bit10
  Zs = Zs * sv
  # plotter.digitized (Z)
  # plotter.digitized (Zs)

  # write data
  print (Y)
  for y in Y:
    dev.setWire (0x03, y)
    dev.setTrigger (0x40, 0x0) 

  # start wave
  input ('press <enter> to begin...')
  dev.setTrigger (0x40, 0x1)

  try:
    print ('running, press CTRL-C to end')
    while True:
      pass
  except:
    dev.setTrigger (0x40, 0x1)
    print ()
