import numpy as np
import scipy as sp

class Battery:
  specificCapacities = {
    'CoO2': 140e-3 * 3600, # mAh --> C
    'MnO2': 147e-3 * 3600 # mAh --> C
  }
  densities = {
    'CoO2': 4.00e6,
    'MnO2': 0.00e6,
    'C': 2.26e6,
    'Al': 2.7e6,
    'Cu': 8.85e6,
    'PP': 0.92e6,
    'Li': 1.876e6,
    'Pouch': (1.38e6 + 2.7e6 + 0.9e6) / 3.0
  }
  thicknesses = {
    'CoO2': 74.0e-6,
    'MnO2': 74.0e-6,
    'C': 40.0e-6,
    'Al': 15e-6,
    'Cu': 9e-6,
    'PP': 20e-6,
    'Li': 20e-6,
    'Pouch': 150e-6
  }
  cellUnitMass = None
  cellUnitCapacity = None
  cellPackageMass = None

  def __init__ (this):
    Battery.cellUnitMass = { # 1 M cell
      'CoO2': Battery.bActive ('CoO2')[0],
      'MnO2': Battery.bActive ('MnO2')[0]
    }
    Battery.cellUnitCapacity = {
      'CoO2': Battery.bActive ('CoO2')[1] * Battery.specificCapacities['CoO2'],
      'MnO2': Battery.bActive ('MnO2')[1] * Battery.specificCapacities['MnO2']
    }
    Battery.cellPackagingMass = {
      'Pouch': Battery.bPackaging ('Pouch')
    }

  def bActive (chem = 'CoO2'):
    catVolume = Battery.thicknesses[chem]
    anVolume = Battery.thicknesses['C']
    sepVolume = Battery.thicknesses['PP']
    catCCVolume = Battery.thicknesses['Al']
    anCCVolume = Battery.thicknesses['Cu']
    elecVolume = Battery.thicknesses['Li']

    catMass = catVolume * Battery.densities[chem]
    anMass = Battery.thicknesses['C'] * Battery.densities['C']
    sepMass = Battery.thicknesses['PP'] * Battery.densities['PP']
    catCCMass = Battery.thicknesses['Al'] * Battery.densities['Al']
    anCCMass = Battery.thicknesses['Cu'] * Battery.densities['Cu']
    elecMass = Battery.thicknesses['Li'] * Battery.densities['Li']
    return catMass + anMass + sepMass + catCCMass + anCCMass + elecMass, catMass

  def bPackaging (brand = 'Pouch'):
    packagingVolume = Battery.thicknesses[brand] * (1.2 * 1.2)
    packagingMass = packagingVolume * Battery.densities[brand]
    return packagingMass

  def qPerGram (ccount, chem = 'CoO2', brand = 'Pouch'):
    mass = ccount * Battery.cellUnitMass[chem]
    mass = mass + ((ccount + 1.0) * Battery.cellPackagingMass[brand])
    capacity = Battery.cellUnitCapacity[chem]
    return capacity / mass

  def bMass (ccount, iavg, target, chem = 'CoO2'):
    qPerGram = Battery.qPerGram (ccount, chem)
    q = target * qPerGram
    runtime = q / iavg
    return runtime

  def bMass2 (ccounta, iavga, ccountb, iavgb, target, chem = 'CoO2'):
    qPGa = Battery.qPerGram (ccounta, chem)
    qPGb = Battery.qPerGram (ccountb, chem)
    alpha = (qPGb * iavga) / (qPGa * iavgb + qPGb * iavga)
    runtime = alpha * (qPGa / iavga) + (1.0 - alpha) * (qPGb / iavgb)
    runtime = runtime * target
    return runtime, alpha

  def bRuntime (ccount, iavg, target, chem = 'CoO2'):
    qPerGram = Battery.qPerGram (ccount, chem)
    q = iavg * target
    mass = q / qPerGram
    return mass

b = Battery ()

def main ():
  print ('runtime', Battery.bMass (2.0, 150.0e-3, 100.0e-3))

if __name__ == '__main__':
  main ()
