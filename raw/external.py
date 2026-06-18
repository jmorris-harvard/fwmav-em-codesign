import argparse
import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd
import sys

def main ():
  parser = argparse.ArgumentParser (description = 'add external masses and power sinks to build description')
  parser.add_argument ('--file', '-f', type = str, help = 'csv containing physical descriptions')
  parser.add_argument ('--additional', '-a', type = str, help = 'csv containing addtional elements with headers [name,mass,power,voltage]')

  args = parser.parse_args ()
  outfile = os.path.splitext (args.file)[0] + '-' + os.path.splitext (args.additional)[0] + '.csv'
  df = pd.read_csv (args.file)

  # get all new columns
  dfadd = pd.read_csv (args.additional)
  addcols = {}
  totalmass = 0.0
  totalcurrent = 0.0
  for i in range (dfadd.shape[0]):
    base = dfadd.loc[i, 'name']
    if float (dfadd.loc[i, 'mass']) > 0.0:
      addcols[base + '-mass'] = float (dfadd.loc[i, 'mass'])
      addcols[base + '-area'] = float (dfadd.loc[i, 'area'])
      totalmass = totalmass + addcols[base + '-mass']
    if float (dfadd.loc[i, 'power']) > 0.0:
      addcols[base + '-current'] = float (dfadd.loc[i, 'power']) / float (dfadd.loc[i, 'voltage'])
      totalcurrent = totalcurrent + addcols[base + '-current']
  if totalmass > 0.0:
    addcols['total-additional-mass'] = totalmass
  if totalcurrent > 0.0:
    addcols['total-additional-current'] = totalcurrent
  cols = [c for c in df.columns]
  for c in addcols.keys ():
    cols.append (c)
  dfloaded = pd.DataFrame (columns = cols)

  # prune items 
  for i in range (df.shape[0]):
    newnet = df.loc[i, 'netThrust'] - totalmass 
    if newnet < 0.0:
      continue
    newrow = df.iloc[i]
    newrow['netThrust'] = newnet
    for c in addcols.keys ():
      newrow[c] = addcols[c]
    dfloaded = pd.concat ([dfloaded, newrow.to_frame().T], ignore_index = True)

  dfloaded.to_csv (outfile, index = False) 

if __name__ == '__main__':
  main ()
