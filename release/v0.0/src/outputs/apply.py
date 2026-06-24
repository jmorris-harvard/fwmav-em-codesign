import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import re
import os
import sys

def piecewise_impl (x, points):
  points = sorted (points, key = lambda p:p[0])
  xs, ys = list (zip (*points))
  return float (np.interp (x, xs, ys))

def poly_impl (x, L, k, x0, c):
  return L * (1.0 - 1.0 / (1.0 + np.exp (-k * (x - x0)))) + c

def coeff (x):
  points = (
    (0.750, 0.767),
    (1.000, 0.622),
    (5.000, 0.068),
    (10.00, 0.028)
  )
  return float (np.interp (x, xs, ys))

def coeff (x):
  params = (
    0.78661956,
    0.95331228,
    2.57173435,
    0.01624584
  )
  return poly_impl (x, *params)


def main ():
  filename = './data.cp.fw'
  check = True
  files = os.listdir (filename)
  pattern = r'mechanical-options-pruned-external-(?P<tech>\w+)-(?P<power>(boost)|(cp))-\d.csv'
 
  for item in files:
    m = re.match (pattern, item)
    if m is None:
      continue
    df = pd.read_csv (os.path.join (filename, item))
    df['runtime-new'] = 0.0
    updated = {}
    for column in df.columns:
      if column == 'Unnamed: 0':
        continue
      updated[column] = list ()
    for i in range (df.shape[0]):
      if df.loc[i, 'runtime'] is not None:
        # apply capacity scaling
        df.loc[i, 'runtime-new'] = df.loc[i, 'runtime'] * coeff (3600.0 / df.loc[i, 'runtime'])

      if df.loc[i, 'runtime-new'] < 1.0:
        # skip small runtimes
        continue

      for column in df.columns:
        if column == 'Unnamed: 0':
          continue
        updated[column].append (df.loc[i, column])
    
    df = pd.DataFrame.from_dict (updated)
    df.to_csv (os.path.join (filename, 'mechanical-options-pruned-external-%s-%s-complete-0.csv' % (m.group ('tech'), m.group ('power'))))

if __name__ == '__main__':
  main ()
