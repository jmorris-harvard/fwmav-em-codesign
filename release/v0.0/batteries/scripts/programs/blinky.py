#!/usr/bin/python3.8

import time

def blinky (dev):
  ctr = 0
  addr = 0x00
  sleep = 1
  while True:
    dev.setWire (addr, ctr, mask = 0xFF)
    ctr = ctr + 1
    time.sleep  (sleep)
