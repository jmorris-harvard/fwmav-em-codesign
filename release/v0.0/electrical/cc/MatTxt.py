#!/usr/bin/python3

import numpy as np
import scipy as sp
import struct
import sys
import time

class MatTxt:
  def __init__ (Self, InFilename = 'config.mat', OutFilename = 'Config.txt'):
    Self.Config = sp.io.loadmat (InFilename)
    Self.Out = OutFilename
    Self.Keys = [Key for Key in Self.Config.keys () if Key[0] != '_']

  def PrintConfig (Self):
    for Key in Self.Keys:
      print ('%s (%s) : %s' % (key, type (Self.Config[Key][0][0]), Self.Config[Key].flatten ()))

  def WriteTxt (Self):
    Lines = []
    for Key in Self.Keys:
      print ('%s' % (Key))
      Item = Self.Config[Key].flatten ()
      if Key == 'delay':
        Item = np.zeros (11)
      for I, X in enumerate (Item):
        print ('\t%d: %s' % (I, X))
        Lines.append ('%s\n' % (X))
    with open (Self.Out, 'w') as Out:
      Out.writelines (Lines)
      Out.writelines ([''])

if __name__ == '__main__':
  MT = MatTxt ()
  MT.WriteTxt ()
