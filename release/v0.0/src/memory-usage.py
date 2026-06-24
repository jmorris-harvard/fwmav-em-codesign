#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np

# xfab memory descriptions
spram1024x32 = {
  'bytes': 4096.0,
  'power': 0.127, # mW/MHz
  'access': 1.95, # ns
  'leakage': 0.0004, # mW/MHz
  'x': 634.18e-6, # m
  'y': 453.88e-6 # m
}

spram256x32 = {
  'power': 0.089, # mW/MHz
  'access': 1.79, # ns
  'leakage': 0.0004, # mW/MHz
  'x': 370.28, # um
  'y': 311.15 # um
}

# process
processes = {
  '180': {
    'width': 220.0e-9, # m
    'length': 180.0e-9, # m
    'voltage': 1.8, # v
    'capacitance': 290e-18, # f
  },
  '110': {
    'width': 150.0e-9, # m
    'length': 110.0e-9, # m
    'voltage': 1.5, # v
    'capacitance': 250.0e-18 # f
  },
  '65': {
    'width': 120.0e-9, # m
    'length': 60.0e-9, # m
    'voltage': 1.2, # v
    'capacitance': 85.0e-18 # f
  },
  'rram': {}
}

# controller memory requirements (assuming fpu)
program = {
  'code.control': 56232.0, # bytes
  'code.trajectory': 3688.0, # bytes
  'data': 12944.0, # bytes
  'vars.global': 10270.0, # bytes
  'vars.params': 600.0, # bytes
}

rram = {
  'size': 1.15e6, # bit / mm2
  # 'access': 1000.0e-15, #  Gior2021
  'access': 256.0e-15, # Spetalnick2024
}

def main ():
  # configuration
  plt.rcParams['font.size'] = 20

  # implementation requirements
  speed = 40.0 # MHz
  reference = '180'

  n = len (processes.keys ())
  x = np.arange (n)
  width = 0.75

  memory = spram1024x32
  
  # power calculations
  fig, ax = plt.subplots ()
  bottom = np.zeros (shape = n)
  y = np.zeros (shape = n)
  tot = 0
  for section in program.keys ():
    memories = None
    for i, process in enumerate (processes.keys ()):
      memories = np.ceil (program[section] / memory['bytes'])
      if process == 'rram' and section in ['code.control', 'vars.parameters']:
        power = memories * memory['bytes'] * 8 * rram['access'] * speed * 1e6
        y[i] = power
      else:
        if process == 'rram':
          process = '65'
        power = memories * memory['power'] * speed
        scale = processes[process]['voltage'] / processes[reference]['voltage']
        scale = scale * scale
        scale = scale * (processes[process]['capacitance'] / processes[reference]['capacitance'])
        power = power * scale
        y[i] = power
        
    ax.bar (x, y, 
            width = width,
            bottom = bottom,
            edgecolor = 'black',
            label = section.upper ())
    tot = tot + memories
    bottom = bottom + y
  print ('total memory:', tot * memory['bytes'] * 8)
  print (bottom)
      
  ax.set_xticks (x)
  ax.set_xticklabels ([process.upper () for process in processes.keys ()])
  ax.legend ()

  # area calculations
  fig, ax = plt.subplots ()
  bottom = np.zeros (shape = n)
  y = np.zeros (shape = n)
  for section in program.keys ():
    for i, process in enumerate (processes.keys ()):
      memories = np.ceil (program[section] / memory['bytes'])
      if process == 'rram' and section in ['code.control', 'vars.parameters']:
        area = (memories * memory['bytes'] * 8) / rram['size']
        area = area * 1e-6
        y[i] = area
      else:
        if process == 'rram':
          process = '65'
        area = memories * memory['x'] * memory['y']
        scale = processes[process]['length'] / processes[reference]['length']
        scale = scale * (processes[process]['width'] / processes[reference]['width'])
        area = area * scale
        y[i] = area
    ax.bar (x, y, 
            width = width,
            bottom = bottom,
            edgecolor = 'black',
            label = section.upper ())
    bottom = bottom + y
  print (bottom)
      
  ax.set_xticks (x)
  ax.set_xticklabels ([process.upper () for process in processes.keys ()])
  ax.legend ()

  plt.tight_layout ()
  plt.show ()

if __name__ == '__main__':
  main ()
