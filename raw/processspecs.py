import numpy as np
import argparse
import os
import sys

class Layer():
  Densities = {
    'Si': 2.33e6,
    'SiO2': 2.65e6,
    'Cu': 8.96e6,
    'SiN': 3.17e6
  }
  def __init__ (this, name, thickness, material):
    this.name = name
    this.thickness = thickness
    this.material = material
    this.density = Layer.Densities[material]
  def massPerUnitArea (this):
    return this.density * this.thickness

class LayerStack ():
  def __init__ (this):
    this.layers = []
    this.updated = False
    this.massPerArea = None
  def addLayer (this, layer):
    this.layers.append (layer)
    this.updated = False
    return this
  def massPerUnitArea (this):
    this.massPerArea = 0.0
    for layer in this.layers:
      this.massPerArea = this.massPerArea + layer.massPerUnitArea ()
    this.updated = True
    return this.massPerArea
  def mass (this, length, width):
    if not this.updated:
      return this.massPerUnitArea () * length * width
    else:
      return this.massPerArea * length * width

XT011 = LayerStack ().addLayer (
            Layer ('MOSLP-Wafer',725e-6,'Si')
        ).addLayer (
            Layer ('MOSLP-BOx',400e-9,'SiO2')
        ).addLayer (
            Layer ('MOSLP-DeviceLayer',3.5e-6,'Si')
        ).addLayer (
            Layer ('MOSLP-GateOx',3.5e-9,'SiO2')
        ).addLayer (
            Layer ('MOSLP-Poly1',164e-9,'Si')
        ).addLayer (
            Layer ('Met1',325e-9,'Cu')
        ).addLayer (
            Layer ('Met1-Dielec',540e-9,'SiO2')
        ).addLayer (
            Layer ('Met2', 430e-9,'Cu')
        ).addLayer (
            Layer ('Met2-Dielec',350e-9,'SiO2')
        ).addLayer (
            Layer ('Met3', 430e-9,'Cu')
        ).addLayer (
            Layer ('Met3-Dielec',350e-9,'SiO2')
        ).addLayer (
            Layer ('Met4', 430e-9,'Cu')
        ).addLayer (
            Layer ('Met4-Dielec',350e-9,'SiO2')
        ).addLayer (
            Layer ('Met5', 430e-9,'Cu')
        ).addLayer (
            Layer ('Met5-Dielec',350e-9,'SiO2')
        ).addLayer (
            Layer ('MetThick', 3110e-9,'Cu')
        ).addLayer (
            Layer ('MetThick-Dielec',1140e-9,'SiO2')
        ).addLayer (
            Layer ('Passivation',1750e-9,'SiN')
        )


ASAP7 = LayerStack ().addLayer (
            Layer ('MOSLP-Wafer',725e-6,'Si')
        )

XT018 = LayerStack ().addLayer (
            Layer ('MOSLP-Wafer',725e-6,'Si')
        ).addLayer (
            Layer ('MOSLP-BOx',1000e-9,'SiO2')
        ).addLayer (
            Layer ('MOSLP-DeviceLayer',3.5e-6,'Si')
        ).addLayer (
            Layer ('MOSLP-GateOx',12.7e-9,'SiO2')
        ).addLayer (
            Layer ('MOSLP-Poly1', 200e-9,'Si')
        ).addLayer (
            Layer ('Met1',565e-9,'Cu')
        ).addLayer (
            Layer ('Met1-Dielec',990e-9,'SiO2')
        ).addLayer (
            Layer ('Met2', 565e-9,'Cu')
        ).addLayer (
            Layer ('Met2-Dielec',850e-9,'SiO2')
        ).addLayer (
            Layer ('Met3', 565e-9,'Cu')
        ).addLayer (
            Layer ('Met3-Dielec',850e-9,'SiO2')
        ).addLayer (
            Layer ('Met4', 565e-9,'Cu')
        ).addLayer (
            Layer ('Met4-Dielec',850e-9,'SiO2')
        ).addLayer (
            Layer ('Met5', 565e-9,'Cu')
        ).addLayer (
            Layer ('Met5-Dielec',850e-9,'SiO2')
        ).addLayer (
            Layer ('MetThick', 3110e-9,'Cu')
        ).addLayer (
            Layer ('MetThick-Dielec',1000e-9,'SiO2')
        ).addLayer (
            Layer ('Passivation',1750e-9,'SiN')
        )

class Memory ():
  def __init__ (this, WpMHz, Lp1kB, Wp1kB):
    this.WpMHz = WpMHz
    this.Lp1kB = Lp1kB
    this.Wp1kB = Wp1kB
  def power (this, kBs, MHz):
    return this.WpMHz * MHz * kBs
  def size (this, kBs):
    return this.Lp1kB * kBs, this.Wp1kB

SPRAM18 = Memory (0.042e-3, 469.7e-6, 231.4e-6)

SPRAM7 = Memory (0.00384e-3,32.1e-6,25.6e-6)

def dieMass (width, length, pad, speed, kbs, process = 'XT018'):
  width = width + pad
  length = length + pad
  if process.lower () == 'XT018'.lower ():
    print ('mass', XT018.mass (width, length))
    memw, meml = SPRAM18.size (kbs)
    print ('mem-mass', XT018.mass (memw, meml))
    print ('mem-power', SPRAM18.power (kbs, speed))
  elif process.lower () == 'XT011'.lower ():
    print ('mass', XT011.mass (width, length))
    memw, meml = SPRAM18.size (kbs)
    print ('mem-mass', XT011.mass (memw, meml))
    print ('mem-power', SPRAM18.power (kbs, speed) * (1.5/1.8))
  elif process.lower () == 'ASAP7'.lower ():
    print ('mass', ASAP7.mass (width, length))
    memw, meml = SPRAM7.size (kbs)
    print ('mem-mass', ASAP7.mass (memw, meml))
    print ('mem-power', SPRAM7.power (kbs, speed))
  else:
    print ('process %s not yet specified' % (process))
    sys.exit ()

def main ():
  parser = argparse.ArgumentParser (description = 'die mass calculator')
  parser.add_argument ('--width', '-w', type = float, help = 'die width', required = True)
  parser.add_argument ('--length', '-l', type = float, help = 'die length', required = True)
  parser.add_argument ('--pad', type = float, help = 'pad width', default = 100e-6)
  parser.add_argument ('--speed', '-s', type = float, help = 'memory speed', default = 50.0)
  parser.add_argument ('--kbytes', '-b', type = float, help = 'memory size', default = 60.0)
  parser.add_argument ('--process', '-p', help = 'cmos process', default = 'XT018')
  args = parser.parse_args ()
  dieMass (args.width, args.length, args.pad, args.speed, args.kbytes, args.process)

if __name__ == '__main__':
  main ()
