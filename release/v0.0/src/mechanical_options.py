from piezo_bimorph import PiezoBimorph
import numpy as np
import pandas as pd
import itertools

def main ():
  # create PB object
  pb = PiezoBimorph ()
  params = {
    'length': [5.0e-3, 10.0e-3, 15.0e-3, 20.0e-3, 25.0e-3],
    'appliedElectricField': [0.25e6, 0.5e6, 0.75e6, 1.0e6, 1.25e6, 1.5e6, 1.75e6, 2.0e6],
    'activeMaterialThickness': [127e-6],
    'multiLayers': [1],
    'staticStrokeAmplitude': [30.0, 60.0, 90.0, 120.0, 150.0],
    'operatingFrequency': [
        25.0, 50.0, 75.0, 100.0,
        125.0, 150.0, 175.0, 200.0,
        225.0, 250.0, 275.0, 300.0, 
        325.0, 350.0, 375.0, 400.0,
        425.0, 450.0, 475.0, 500.0]
  }

  # add params
  results = {}
  for key in params.keys ():
    results[key] = []

  # add other vars
  results['width'] = []
  results['transmissionRatio'] = []
  results['wingLength'] = []

  # add values to report
  results['naturalFrequency'] = []
  results['netThrust'] = []
  results['loadedDisplacement'] = []
  results['liftableMass'] = []
  results['totalMechanicalMass'] = []
  results['appliedVoltage'] = []
  results['averageCurrent'] = []

  # build best design on each option
  keys = params.keys ()
  ops = [params[key] for key in keys]
  product = list (itertools.product (*ops))
  print (len (product))
  print (product[0])

  for i, op in enumerate (product):
    if i % 100 == 0:
      print (i, len(product), op)
    # set pb to this 
    for key, var in zip (keys, op):
      pb[key] = var

    # determine best lift
    thrust = 0.001
    step = 0.0005

    intermediate = {}
    for key in results.keys ():
      intermediate[key] = None

    while True:
      pb.build (thrust)
      # ensure stroke amplitude does not explode
      if pb['strokeAmplitude'] > 180.0:
        break
      if intermediate['netThrust'] is None or pb['netThrust'] > intermediate['netThrust']:
        for key in intermediate.keys ():
          intermediate[key] = pb[key]
      else:
        break
      thrust = thrust + step
    if intermediate['netThrust'] is not None and intermediate['netThrust'] > 0:
      # save configuration
      for key in results.keys ():
        results[key].append (intermediate[key])
  # save all results to csv
  df = pd.DataFrame.from_dict (results)
  df.to_csv ('mechanical_options.csv')

if __name__ == '__main__':
  main ()
