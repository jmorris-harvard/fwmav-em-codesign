import cadquery as cq
import numpy as np
import matplotlib.pyplot as plt
import sys

from Display import show 

def drawPolygon (wp, p, pts, s, d, t):
	return (
			wp.copyWorkplane (
				cq.Workplane (p)
			)
			.workplane (offset = s * d)
			.polyline (pts)
			.close ()
			.extrude (s * t)
		)
					

class Drawer ():
	def __init__ (this):
		this.mechParams = {}
		this.mechParams['mWidth'] = 4.0
		this.mechParams['mLength'] = 10.0
		this.mechParams['mPiezoThickness'] = 127E-3
		this.mechParams['mElasticThickness'] = 60E-3
		this.mechParams['mWidthRatio'] = 1.75
		this.mechParams['mLengthRatio'] = 0.4
		this.mechParams['mNMulti'] = 2
		this.mechParams['mWingLength'] = 15.0
		this.mechParams['mAspectRatio'] = 3.5

	def draw (this, filename = 'step/default.step'):
		this.getReqParameters ()

		wp = cq.Workplane ('YZ')
		wp = this.drawActuators (wp)
		wp = this.drawAirframe (wp)
		wp = this.drawWings (wp)

		cq.exporters.export (wp, filename)
		show (filename)

	def getReqParameters (this):
		# Input Parameters
		width = this.mechParams['mWidth']
		length = this.mechParams['mLength']
		piezoThickness = this.mechParams['mPiezoThickness']
		elasticThickness = this.mechParams['mElasticThickness']
		widthRatio = this.mechParams['mWidthRatio']
		lengthRatio = this.mechParams['mLengthRatio']
		nMulti = this.mechParams['mNMulti']
		wingLength = this.mechParams['mWingLength']
		aspectRatio = this.mechParams['mAspectRatio']

		# All dimensions are in mm
		distanceBetweenPlates = 1.0E-3
		this.mechParams['mDistanceBetweenPlates'] = distanceBetweenPlates

		# Actuator Parameters
		extensionLength = length * lengthRatio
		this.mechParams['mExtensionLength'] = extensionLength
		connectorLength = 1.5
		this.mechParams['mConnectorLength'] = connectorLength
		baseWidth = width * widthRatio
		this.mechParams['mBaseWidth'] = baseWidth
		topWidth = 2.0 * width - baseWidth
		this.mechParams['mTopWidth'] = topWidth 
		deviceGap = width
		this.mechParams['mDeviceGap'] = deviceGap
		basePlateWidth = deviceGap + 2.0 * (2.0 * nMulti * piezoThickness + 3.0 * elasticThickness)
		basePlateWidth = basePlateWidth + 2.0 * (4.0 * distanceBetweenPlates + nMulti * distanceBetweenPlates)
		this.mechParams['mBasePlateWidth'] = basePlateWidth
		deviceThickness = 2.0 * nMulti * piezoThickness + elasticThickness
		deviceThickness = deviceThickness + 4.0 * distanceBetweenPlates + nMulti * distanceBetweenPlates
		this.mechParams['mDeviceThickness'] = deviceThickness
		pegWidth = (2.0 * baseWidth / 3.0) / (1 + nMulti)
		this.mechParams['mPegWidth'] = pegWidth
		pegSpacing = (baseWidth - (1 + nMulti) * pegWidth) / (2 + nMulti)
		this.mechParams['mPegSpacing'] = pegSpacing

		# Airframe Parameters
		this.mechParams['mBasePlateLength'] = baseWidth * 1.1
		this.mechParams['mHingeLength'] = deviceThickness * 2.0

		# Wing Parameters
		this.mechParams['mMeanChordLength'] = wingLength / aspectRatio

	def drawWings (this, wp):
		elasticThickness = this.mechParams['mElasticThickness']
		hingeLength = this.mechParams['mHingeLength']
		length = this.mechParams['mLength']
		connectorLength = this.mechParams['mConnectorLength']
		extensionLength = this.mechParams['mExtensionLength']
		deviceGap = this.mechParams['mDeviceGap']
		wingLength = this.mechParams['mWingLength']
		meanChordLength = this.mechParams['mMeanChordLength'] * 1.75
		topWidth = this.mechParams['mTopWidth']

		# Draw curve
		ptsPerCurve = 20
		topOffsetx1 = 2.0 / 3.0
		botOffsetx3 = 1.0 / 2.0
		topOffsety = 1.0 / 3.0

		topOffsetx2 = 1.0 - topOffsetx1
		botOffsetx4 = 1.0 - botOffsetx3
		botOffsety = 1.0 - topOffsety

		x1 = np.linspace (0.0, 1.0, ptsPerCurve)
		# x1 = np.insert (x1, 0, 0.0)
		# x1 = np.insert (x1, -1, 1.0)
		y1 = -1.0 * (x1 - 1.0) ** 2.0 + 1.0
		x1 = x1 * topOffsetx1 * wingLength
		y1 = y1 * topOffsety * meanChordLength

		x2 = np.linspace (0.0, 1.0, ptsPerCurve)
		# x2 = np.insert (x2, 0, 0.0)
		# x2 = np.insert (x2, -1, 1.0)
		y2 = -1.0 * (x2 - 1.0) ** 2.0 + 1.0
		x2 = x2 * topOffsetx2 * wingLength + topOffsetx1 * wingLength
		y2 = y2 * topOffsety * meanChordLength
		y2 = y2[::-1]
		x2 = x2[1:]
		y2 = y2[1:]

		x3 = np.linspace (0.0, 1.0, ptsPerCurve)
		# x3 = np.insert (x3, 0, 0.0)
		# x3 = np.insert (x3, -1, 1.0)
		y3 = 1.0 * (x3 - 1.0) ** 2.0 - 1.0
		x3 = x3 * botOffsetx3 * wingLength + botOffsetx4 * wingLength
		y3 = y3 * botOffsety * meanChordLength
		x3 = x3[::-1]
		y3 = y3 - connectorLength / 2.0

		x4 = np.linspace (0.0, 1.0, ptsPerCurve)
		# x4 = np.insert (x4, 0, 0.0)
		# x4 = np.insert (x4, -1, 1.0)
		y4 = 1.0 * (x4 - 1.0) ** 2.0 - 1.0
		x4 = x4 * botOffsetx4 * wingLength
		y4 = y4 * botOffsety * meanChordLength
		x4 = x4[::-1]
		y4 = y4[::-1]
		x4 = x4[1:]
		y4 = y4[1:]
		y4 = y4 - connectorLength / 2.0

		
		devicePts = []
		offsetX = deviceGap / 2.0 + 2.0 * hingeLength
		offsetY = connectorLength + length + extensionLength - connectorLength + connectorLength / 2.0
		# offsetX = 0.0
		# offsetY = 0.0
		for x, y in zip (x1, y1):
			devicePts.append ((x + offsetX, y + offsetY))
		for x, y in zip (x2, y2):
			devicePts.append ((x + offsetX, y + offsetY))
		for x, y in zip (x3, y3):
			devicePts.append ((x + offsetX, y + offsetY))
		for x, y in zip (x4, y4):
			devicePts.append ((x + offsetX, y + offsetY))
		# for x in devicePts:
		# 	print (x)
		firstPoint = devicePts[0]
		trueDevicePts = [
			(firstPoint[0], firstPoint[1] - connectorLength / 2.0),
			(firstPoint[0] - hingeLength, firstPoint[1]),
		]
		for pt in devicePts:
			trueDevicePts.append (pt)
		wp = drawPolygon (wp, 'XZ', trueDevicePts, -1.0, (0.75 * topWidth / 2.0), elasticThickness)
		trueDevicePts = [(-1.0 * pt[0], pt[1]) for pt in trueDevicePts]
		wp = drawPolygon (wp, 'XZ', trueDevicePts, -1.0, (0.75 * topWidth / 2.0), elasticThickness)
		return wp

	def drawAirframe (this, wp):
		basePlateWidth = this.mechParams['mBasePlateWidth']
		basePlateLength = this.mechParams['mBasePlateLength']
		elasticThickness = this.mechParams['mElasticThickness']
		deviceGap = this.mechParams['mDeviceGap']
		lengthRatio = this.mechParams['mLengthRatio']
		length = this.mechParams['mLength']
		connectorLength = this.mechParams['mConnectorLength']
		extensionLength = this.mechParams['mExtensionLength']
		hingeLength = this.mechParams['mHingeLength']
		topWidth = this.mechParams['mTopWidth']
		distanceBetweenPlates = this.mechParams['mDistanceBetweenPlates']
	
		# Base plate
		trueBasePlateWidth = basePlateWidth + 1.0
		devicePts = [
			(-1.0 * trueBasePlateWidth / 2.0, -1.0 * basePlateLength / 2.0),
			(-1.0 * trueBasePlateWidth / 2.0, 1.0 * basePlateLength / 2.0),
			(1.0 * trueBasePlateWidth / 2.0, 1.0 * basePlateLength / 2.0),
			(1.0 * trueBasePlateWidth / 2.0, -1.0 * basePlateLength / 2.0),
			(-1.0 * trueBasePlateWidth / 2.0, -1.0 * basePlateLength / 2.0),
		]
		wp = drawPolygon (wp, 'XY', devicePts, -1.0, 0.0, elasticThickness)

		# Airframe width
		frameGapS = basePlateLength * 0.3
		frameGapL = deviceGap - (elasticThickness * 15.0)
		frameLength = length * (1.0 + lengthRatio) + connectorLength
		devicePts = [
			(-1.0 * frameGapL / 2.0, 0.0),
			(-1.0 * frameGapL / 2.0, frameLength),
			(1.0 * frameGapL / 2.0, frameLength),
			(1.0 * frameGapL / 2.0, 0.0),
			(-1.0 * frameGapL / 2.0, 0.0),
		]
		wp = drawPolygon (wp, 'XZ', devicePts, -1.0, frameGapS / 2.0, elasticThickness)
		wp = drawPolygon (wp, 'XZ', devicePts, 1.0, frameGapS / 2.0, elasticThickness)
		
		# Airframe length
		devicePts = [
			(-1.0 * frameGapS / 2.0, 0.0),
			(-1.0 * frameGapS / 2.0, frameLength),
			(1.0 * frameGapS / 2.0, frameLength),
			(1.0 * frameGapS / 2.0, 0.0),
			(-1.0 * frameGapS / 2.0, 0.0),
		]
		wp = drawPolygon (wp, 'YZ', devicePts, -1.0, frameGapL / 2.0, elasticThickness)
		wp = drawPolygon (wp, 'YZ', devicePts, 1.0, frameGapL / 2.0, elasticThickness)

		# Hinges
		hingeHeight = connectorLength + length + extensionLength - connectorLength
		devicePts = [
			(1.0 * deviceGap / 2.0, hingeHeight),
			(1.0 * deviceGap / 2.0, hingeHeight + connectorLength),
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight + connectorLength),
			(1.0 * deviceGap / 2.0 + 2.0 * hingeLength, hingeHeight + connectorLength / 2.0),
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight + connectorLength / 2.0),
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight),
			(1.0 * deviceGap / 2.0, hingeHeight)
		]
		wp = drawPolygon (wp, 'XZ', devicePts, 1.0, 0.0, elasticThickness)
		wp = drawPolygon (wp, 'XZ', devicePts, -1.0, 0.0, elasticThickness)
		devicePts = [
			(-1.0 * deviceGap / 2.0, hingeHeight),
			(-1.0 * deviceGap / 2.0, hingeHeight + connectorLength),
			(-1.0 * deviceGap / 2.0 - hingeLength, hingeHeight + connectorLength),
			(-1.0 * deviceGap / 2.0 - 2.0 * hingeLength, hingeHeight + connectorLength / 2.0),
			(-1.0 * deviceGap / 2.0 - hingeLength, hingeHeight + connectorLength / 2.0),
			(-1.0 * deviceGap / 2.0 - hingeLength, hingeHeight),
			(-1.0 * deviceGap / 2.0, hingeHeight)
		]
		wp = drawPolygon (wp, 'XZ', devicePts, 1.0, 0.0, elasticThickness)
		wp = drawPolygon (wp, 'XZ', devicePts, -1.0, 0.0, elasticThickness)
		devicePts = [
			(-1.0 * deviceGap / 2.0 - 2.0 * hingeLength, hingeHeight + connectorLength / 2.0),
			(-1.0 * deviceGap / 2.0 - hingeLength, hingeHeight + connectorLength),
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight + connectorLength),
			(1.0 * deviceGap / 2.0 + 2.0 * hingeLength, hingeHeight + connectorLength / 2.0),
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight + connectorLength / 2.0),
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight),
			(-1.0 * deviceGap / 2.0 - hingeLength, hingeHeight),
			(-1.0 * deviceGap / 2.0 - hingeLength, hingeHeight + connectorLength / 2.0),
			(-1.0 * deviceGap / 2.0 - 2.0 * hingeLength, hingeHeight + connectorLength / 2.0)
		]
		wp = drawPolygon (wp, 'XZ', devicePts, -1.0, 0.75 * topWidth, 2.0 * elasticThickness)
		devicePts = [	
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight + connectorLength),
			(1.0 * deviceGap / 2.0 + 2.0 * hingeLength, hingeHeight + connectorLength / 2.0),
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight + connectorLength / 2.0),
			(1.0 * deviceGap / 2.0 + hingeLength, hingeHeight + connectorLength),
		]
		wp = drawPolygon (wp, 'XZ', devicePts, -1.0, elasticThickness + distanceBetweenPlates, 0.75 * topWidth - elasticThickness - 2.0 * distanceBetweenPlates)
		devicePts = [(-pt[0],pt[1]) for pt in devicePts]
		wp = drawPolygon (wp, 'XZ', devicePts, -1.0, elasticThickness + distanceBetweenPlates, 0.75 * topWidth - elasticThickness - 2.0 * distanceBetweenPlates)
		return wp

	def drawActuators (this, wp):
		width = this.mechParams['mWidth']
		length = this.mechParams['mLength']
		piezoThickness = this.mechParams['mPiezoThickness']
		nMulti = this.mechParams['mNMulti']
		elasticThickness = this.mechParams['mElasticThickness']
		widthRatio = this.mechParams['mWidthRatio']
		lengthRatio = this.mechParams['mLengthRatio']

		distanceBetweenPlates = this.mechParams['mDistanceBetweenPlates']

		basePlateWidth = this.mechParams['mBasePlateWidth']
		baseWidth = this.mechParams['mBaseWidth']
		topWidth = this.mechParams['mTopWidth']
		connectorLength = this.mechParams['mConnectorLength']
		extensionLength = this.mechParams['mExtensionLength']
		deviceThickness = this.mechParams['mDeviceThickness']
		pegWidth = this.mechParams['mPegWidth']
		pegSpacing = this.mechParams['mPegSpacing']

		# Actuator
		devicePts = [
			(-1.0 * baseWidth / 2.0, 0.0),
			(-1.0 * baseWidth / 2.0, connectorLength),
			(-1.0 * topWidth / 2.0, connectorLength + length),
			(-1.0 * topWidth / 2.0, extensionLength + connectorLength + length),
			(topWidth / 2.0, extensionLength + connectorLength + length),
			(topWidth / 2.0, connectorLength + length),
			(baseWidth / 2.0, connectorLength),
			(baseWidth / 2.0, 0.0),
			(-1.0 * baseWidth / 2.0, 0.0)
		]

		# Connector attachement
		devicePts0 = [
			(-1.0 * baseWidth / 2.0, 0.0),
			(-1.0 * baseWidth / 2.0, connectorLength),
			(1.0 * baseWidth / 2.0, connectorLength),
			(1.0 * baseWidth / 2.0, 0.0),
			(-1.0 * baseWidth / 2.0, 0.0),
		]

		# Connector pegs
		startingPoint = (-1.0 * baseWidth / 2.0, 0.0)
		devicePts1 = []
		for _ in range (nMulti + 1):
			devicePts1.append ([(startingPoint[0] + pegSpacing, startingPoint[1])])
			devicePts1[-1].append ((startingPoint[0] + pegSpacing + pegWidth, startingPoint[1]))
			devicePts1[-1].append ((startingPoint[0] + pegSpacing + pegWidth, startingPoint[1] - connectorLength / 2.0))
			devicePts1[-1].append ((startingPoint[0] + pegSpacing, startingPoint[1] - connectorLength / 2.0))
			devicePts1[-1].append ((startingPoint[0] + pegSpacing, startingPoint[1]))
			startingPoint = (startingPoint[0] + pegSpacing + pegWidth, startingPoint[1])

		# Hinge attachment
		devicePts2 = [
			(-1.0 * topWidth / 2.0, connectorLength + length),
			(-1.0 * topWidth / 2.0, extensionLength + connectorLength + length),
			(1.0 * topWidth / 2.0, extensionLength + connectorLength + length),
			(1.0 * topWidth / 2.0, connectorLength + length),
			(-1.0 * topWidth / 2.0, connectorLength + length)
		]

		distanceBase = (basePlateWidth / 2.0) - (2.0 * nMulti * piezoThickness) - (3.0 * elasticThickness)
		distanceBase = distanceBase - (4.0 * distanceBetweenPlates) - (nMulti * distanceBetweenPlates)

		distanceOver = distanceBase
		wp = drawPolygon (wp, 'YZ', devicePts0, 1.0, distanceOver, elasticThickness)
		wp = drawPolygon (wp, 'YZ', devicePts2, 1.0, distanceOver, elasticThickness)
		distanceOver = distanceOver +  elasticThickness + distanceBetweenPlates
		for pts in devicePts1:
			wp = drawPolygon (wp, 'YZ', pts, 1.0, distanceOver, deviceThickness)
		for _ in range (nMulti):
			wp = drawPolygon (wp, 'YZ', devicePts, 1.0, distanceOver, piezoThickness)
			distanceOver = distanceOver + piezoThickness + distanceBetweenPlates
		wp = drawPolygon (wp, 'YZ', devicePts, 1.0, distanceOver, elasticThickness)
		distanceOver = distanceOver + elasticThickness + distanceBetweenPlates
		for _ in range (nMulti):
			wp = drawPolygon (wp, 'YZ', devicePts, 1.0, distanceOver, piezoThickness)
			distanceOver = distanceOver + piezoThickness + distanceBetweenPlates
		wp = drawPolygon (wp, 'YZ', devicePts0, 1.0, distanceOver, elasticThickness)
		wp = drawPolygon (wp, 'YZ', devicePts2, 1.0, distanceOver, elasticThickness)

		distanceOver = distanceBase
		wp = drawPolygon (wp, 'YZ', devicePts0, -1.0, distanceOver, elasticThickness)
		wp = drawPolygon (wp, 'YZ', devicePts2, -1.0, distanceOver, elasticThickness)
		distanceOver = distanceOver +  elasticThickness + distanceBetweenPlates
		for pts in devicePts1:
			wp = drawPolygon (wp, 'YZ', pts, -1.0, distanceOver, deviceThickness)
		for _ in range (nMulti):
			wp = drawPolygon (wp, 'YZ', devicePts, -1.0, distanceOver, piezoThickness)
			distanceOver = distanceOver + piezoThickness + distanceBetweenPlates
		wp = drawPolygon (wp, 'YZ', devicePts, -1.0, distanceOver, elasticThickness)
		distanceOver = distanceOver + elasticThickness + distanceBetweenPlates
		for _ in range (nMulti):
			wp = drawPolygon (wp, 'YZ', devicePts, -1.0, distanceOver, piezoThickness)
			distanceOver = distanceOver + piezoThickness + distanceBetweenPlates
		wp = drawPolygon (wp, 'YZ', devicePts0, -1.0, distanceOver, elasticThickness)
		wp = drawPolygon (wp, 'YZ', devicePts2, -1.0, distanceOver, elasticThickness)
		return wp

if __name__ == '__main__':
	d = Drawer ()
	d.draw ()
