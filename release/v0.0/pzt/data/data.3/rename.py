import argparse
import os
import pathlib
import re
import shutil
import sys

def parse_arguments ():
  parser = argparse.ArgumentParser ('')
  parser.add_argument (
      'dirname',
      help = 'data location'
  )
  parser.add_argument (
    '--backup',
    required = False,
    default = None,
    help = 'backup files to this directory'
  )
  return parser.parse_args ()

def main ():
  args = parse_arguments ()
  if args.backup is None:
    args.backup = os.path.join (args.dirname, 'backup')
  pathlib.Path (args.backup).mkdir (parents = True, exist_ok = True)
  
  filenames = os.listdir (args.dirname)
  pattern = r'standardPZT_(?P<signal>\d+)Vpp_(?P<bias>\d+)Bias_(?P<frequency>\d+)Hz\.csv'
  for filename in filenames:
    m = re.match (pattern, filename)
    if m is None:
      continue
    print ('renaming', filename)
    # copy back up
    source = os.path.join (args.dirname, filename)
    destination = os.path.join (args.backup, filename)
    shutil.copy (source, destination)
    # move original
    signal = int (m.group ('signal'))
    bias = int (m.group ('bias'))
    frequency = int (m.group ('frequency'))
    destination = os.path.join (
        args.dirname, 
        f'1p75Width_10p0Length_{signal}p0Vpp_{bias}p0Bias_{frequency}p0Hz.csv'
    )
    shutil.move (source, destination) 
  print ('done.')

if __name__ == '__main__':
  main ()
