import matplotlib.pyplot as plt
import numpy as np
import sys

def digitized (Y):
  fig, ax = plt.subplots ()
  T = list (range (len (Y)))
  x = []
  y = []
  for i in range (1, len (T)):
    x.append (T[i-1] / max (T))
    x.append (T[i] / max (T))
    y.append (Y[i-1])
    y.append (Y[i-1])
  x.append (T[-1]/ max (T))
  x.append (T[-1] / max (T))
  y.append (Y[-1])
  y.append (Y[-1])
  ax.plot (x, y)
  ax.set_xlim ([0, max (x)])
  ax.set_ylim ([0, max (y)])
  ax.grid ()
  ax.set_ylabel ('8-Bit Voltage Code')
  ax.set_xlabel ('Time (normalized)')
  plt.show ()

if __name__ == '__main__':
  plotconfig.initialize.init (plt)
  X = np.linspace (0.0, 2.0 * np.pi, int (sys.argv[1]))
  Y = []
  bit8 = 256
  for x in X:
    sine = np.sin (x)
    Y.append (int (sine * int (bit8 / 2) + int (bit8 / 2)))
  digitized (Y)
