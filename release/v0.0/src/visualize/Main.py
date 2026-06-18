from DrawMechanical import Drawer

import pandas as pd
import sys

def main ():
	filename = sys.argv[1]
	row = int (sys.argv[2])
	df = pd.read_csv (filename)
	data = df.loc[row]
	print (data['massEfficiency'])
	d = Drawer ()
	d.mechParams['mWidth'] = data['width'] * 1E3
	print ('Width', data['width'])
	d.mechParams['mLength'] = data['length'] * 1E3
	print ('Length', data['length'])
	d.mechParams['mPiezoThickness'] = data['activeMaterialThickness'] * 1E3
	d.mechParams['mElasticThickness'] = data['passiveMaterialThickness'] * 1E3
	print ('Piezo', data['activeMaterialThickness'])
	d.mechParams['mWidthRatio'] = data['widthRatio']
	d.mechParams['mLengthRatio'] = data['lengthRatio']
	d.mechParams['mNMulti'] = int (data['multiLayers'])
	d.mechParams['wingLength'] = data['wingLength'] * 1E3

	IC = (110E-3 + 66E-3 + 5.6E-3 + 21E-3) / 1.8
	cap = data['capacityQ'] / (data['inputCurrent'] + IC)
	print (cap)
	sys.exit ()

	d.draw('step/bee_%d.step' % (row))

if __name__ == '__main__':
	main ()
