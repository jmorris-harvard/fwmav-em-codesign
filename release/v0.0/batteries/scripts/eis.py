#!/usr/bin/python3.8

import argparse
import os
import re
import sys
import time

import programs
import xem.xem as xem

def startUp (filename):
  dev = xem.Device ()
  if not dev.Initialize ():
    print ('could not connect to device')
    sys.exit (1)
  print ('connected')
  if filename is not None:
    if not dev.downloadFile (filename):
      print ('Could not download bitstream')
      sys.exit (1)
  print ('loaded bitstream', filename)
  return dev

def main ():
  # get available programs
  pattern = r'[^_]\w+'
  lib = dir (programs)

  names = [l for l in lib if re.match (pattern, l)]
  commands = {}
  for name in names:
    programlib = getattr (programs, name)
    if not hasattr (programlib, name):
      continue
    command = getattr (programlib, name)
    if callable (command):
      commands[name] = command

  # parse arguments
  parser = argparse.ArgumentParser (
    prog = 'eis',
    description = 'eis ctrl',
    epilog = '')
  parser.add_argument (
    '-b',
    '--bitfile',
    default = 'eis_0',
    help = 'file to load onto fpga')
  parser.add_argument (
    'command',
    help = 'valid commands: ' + ', '.join (commands.keys ()))
  parser.add_argument (
    '-v',
    '--verbose',
    action = 'store_true',
    default = False,
    help = 'allow verbose output')
  args = parser.parse_args ()
  if args.command not in commands.keys ():
    print ('invalid command given')
    sys.exit ()

  bitfile = os.path.join ('./bitfiles', args.bitfile)
  bitfile = os.path.splitext (bitfile)[0] + '.bit'
  dev = startUp (bitfile)

  # reset
  dev.setWire (0x00, 0x100)
  time.sleep (1)
  # input ('press <enter> to release device...')
  dev.setWire (0x00, 0x000)

  # set up led pattern
  dev.setWire (0x00, 0xAA)

  # run command
  commands[args.command] (dev)

if __name__ == '__main__':
  main ()
