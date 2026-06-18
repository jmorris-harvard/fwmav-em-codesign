#!/usr/bin/python3
import numpy as np
import scipy as sp
import struct
import sys
import time

class MatTxt:
  def __init__ (Self, InFilename = 'input.mat', OutFilename = 'Input.txt'):
    Self.Input = sp.io.loadmat (InFilename)
    Self.InputY = Self.Input['yout']
    Self.Out = OutFilename

  def WriteTxt (Self, Num):
    Lines = []
    for I in range (Num):
      Lines.append ('%s\n' % (Self.InputY[I][5])) # X
      Lines.append ('%s\n' % (Self.InputY[I][6])) # Y
      Lines.append ('%s\n' % (Self.InputY[I][7])) # Z
      Lines.append ('%s\n' % (Self.InputY[I][8])) # Alpha
      Lines.append ('%s\n' % (Self.InputY[I][9])) # Beta
      Lines.append ('%s\n' % (Self.InputY[I][10])) # Gamma 
    with open (Self.Out, 'w') as Out:
      Out.writelines (Lines)
      Out.writelines ([''])

if __name__ == '__main__':
  MT = MatTxt ()
  MT.WriteTxt (800)
