#!/usr/bin/python3.8

import time

def _led (dev):
  _led_addr = 0x00
  cmd = input ('>write value: ')
  dev.setWire (_led_addr, int (cmd), mask = 0xFF)

def _invalid (dev):
  print ('invalid command')

def _reset (dev):
  _reset_addr = 0x00
  cmd = input ('>reset time: ')
  dev.setWire (_reset_addr, 0x100, mask = 0x100)
  time.sleep (int (cmd))
  dev.setWire (_reset_addr, 0x000, mask = 0x100)

def interactive (dev):
  print ('enter commands...')
  cmap = {
    'led': _led,
    'reset': _reset,
  }
  while True:
    cmd = input ('@> ')
    if cmd == 'quit':
      break
    cmap.get (cmd, _invalid) (dev)
