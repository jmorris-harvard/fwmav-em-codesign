import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import sys

from matplotlib.colors import LogNorm

def main ():
  plt.rcParams['font.size'] = 20
  
  data = pd.read_csv ('output_manual.csv')
  x = data['width'].to_numpy ()
  y = data['length'].to_numpy ()

  z = data['bulk'].to_numpy ()
  fig, ax = plt.subplots (figsize = (6,5))
  sc = ax.scatter (x, y, c = z, cmap = 'viridis', s = 200, norm = LogNorm (), clip_on = False, edgecolors = 'black', zorder = 5)
  fig.colorbar (sc, ax = ax)
  ax.set_title ('bulk')
  ax.set_xscale ('log')
  ax.set_yscale ('log')
  ax.grid ()

  z = data['resistance'].to_numpy ()
  fig, ax = plt.subplots (figsize = (6,5))
  sc = ax.scatter (x, y, c = z, cmap = 'viridis', s = 200, norm = LogNorm (), clip_on = False, edgecolors = 'black', zorder = 5)
  fig.colorbar (sc, ax = ax)
  ax.set_title ('resistance')
  ax.set_xscale ('log')
  # ax.set_yscale ('log')
  ax.grid ()

  z = data['inductance'].to_numpy ()
  fig, ax = plt.subplots (figsize = (6,5))
  sc = ax.scatter (x, y, c = z, cmap = 'viridis', s = 200, norm = LogNorm (), clip_on = False, edgecolors = 'black', zorder = 5)
  fig.colorbar (sc, ax = ax)
  ax.set_title ('inductance')
  ax.set_xscale ('log')
  # ax.set_yscale ('log')
  ax.grid ()

  z = data['capacitance'].to_numpy ()
  fig, ax = plt.subplots (figsize = (6,5))
  sc = ax.scatter (x, y, c = z, cmap = 'viridis', s = 200, norm = LogNorm (), clip_on = False, edgecolors = 'black', zorder = 5)
  fig.colorbar (sc, ax = ax)
  ax.set_title ('capacitance')
  ax.set_xscale ('log')
  # ax.set_yscale ('log')
  ax.grid ()

  plt.tight_layout ()
  plt.show ()

if __name__ == '__main__':
  main ()
