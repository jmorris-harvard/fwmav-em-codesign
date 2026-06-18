#!/usr/bin/python3.8

from Component import Component

import control
from copy import deepcopy
import math
import matplotlib.pyplot as plt
import numpy as np
import time
import sys

def quad (params, x, y):
    a, b, c, d, e, f = params
    return a + b * x + c * y + d * x * x + e * y * y + f * x * y

class PiezoBimorph (Component):
    # Create 3d cad tool to build bimorph based on dimensions listed here
    def __init__ (this):
        super ().__init__ ()
        nuA = 0.31
        planeA = 1.0 / (1.0 - nuA * nuA)
        eA = 62.0E9
        gA = eA / (2.0 * (1.0 + nuA))

        nuP = 0.33
        eP1 = 260.0E9
        eP2 = 7.0E9
        planeP = 1.0 / (1.0 - nuP * nuP * (eP2 / eP1))
        gP = 5E9

        this.vars['qActive'] = np.zeros (shape = (3,3))
        this.vars['qActive'][0,0] = planeA * eA
        this.vars['qActive'][1,1] = planeA * eA
        this.vars['qActive'][0,1] = planeA * nuA * eA
        this.vars['qActive'][1,0] = planeA * nuA * eA
        this.vars['qActive'][2,2] = gA

        this.vars['qPassive'] = np.zeros (shape = (3,3))
        this.vars['qPassive'][0,0] = planeP * eP1
        this.vars['qPassive'][1,1] = planeP * eP2
        this.vars['qPassive'][0,1] = planeP * nuP * eP2
        this.vars['qPassive'][1,0] = planeP * nuP * eP2
        this.vars['qPassive'][2,2] = gP

        this.vars['appliedElectricField'] = 1.5E6
        this.vars['activeMaterialThickness'] = 127.0E-6 # old 60.0
        this.vars['passiveMaterialThickness'] = 60.0E-6
        this.vars['d31'] = -320E-12 * (1 + nuA) 

        this.vars['widthRatio'] = 1.75
        this.vars['lengthRatio'] = 0.4
        this.vars['length'] = 0.01 # old: 0.010
        this.vars['width'] = 0.001 # old: 0.001
        this.vars['multiLayers'] = 1
        this.vars['relativePermitivity'] = 3800 
        this.vars['permitivityConstant'] = 8.85E-12
        this.vars['activeDensity'] = 7.8E6
        this.vars['passiveDensity'] = 1.5E6  

        this.vars['staticStrokeAmplitude'] = 120.0
        this.vars['actuatorMassRatio'] = 0.6 # Unused
        this.vars['actuatorEnergyDensity'] = 1.1 # Unused
        this.vars['operatingFrequency'] = 70.0 # old: 120

        this.vars['wingLength'] = 11.2E-3 # old: 15.0
        this.vars['aspectRatio'] = 3.5
        this.vars['wingShapeParameter'] = 0.56
        this.vars['inertialParameter'] = 0.8948
        this.vars['transmissionRatio'] = 3.28E3
        this.vars['airDensity'] = 1.293E3 
        this.vars['dragCoefficient'] = 1.9
        this.vars['maxDragCoefficient'] = 1.9
        this.vars['angularVelocityParameter'] = 500 # Unused
        this.vars['radiusToCenterParameter'] = 0.6733
        this.vars['stiffnessParameter'] = 5.4872E-6 * 1.0E3 # Convert kg -> in stiffness
        this.vars['liftCoefficient'] = 1.8
        this.vars['lossTangent'] = 0.1
        this.vars['accelerationGravity'] = 9.8

        this.vars['bulkParameters'] = (
            8.92103253e-9,
            -1.76371979e-10,
            -1.68331257e-9,
            1.91578242e-11,
            6.53430611e-11,
            3.57189032e-10
        )
        this.vars['capacitanceParameters'] = (
            5.77158764e-9,
            -2.33033461e-10,
            -1.05713387e-9,
            2.05368099e-12,
            3.72576718e-11,
            9.08588177e-11
        )
        this.vars['inductanceParameters'] = (
            1.97419801,
            -1.72693583,
            0.23848568,
            0.13117417,
            0.09727597,
            -0.16419654
        )
        this.vars['resistanceParameters'] = (
            204.99455588,
            -338.95108104,
            348.95308684,
            15.53343814,
            -8.95344226,
            -6.47332884
        )

    def update (this, verbose = False, plot = False):
        # Get parameters
        qActive = this.vars['qActive']
        qPassive = this.vars['qPassive'] 
        appliedElectricField = this.vars['appliedElectricField']
        activeMaterialThickness = this.vars['activeMaterialThickness']
        passiveMaterialThickness = this.vars['passiveMaterialThickness']
        d31 = this.vars['d31']
        widthRatio = this.vars['widthRatio']
        lengthRatio = this.vars['lengthRatio']
        length = this.vars['length']
        width = this.vars['width']
        multiLayers = this.vars['multiLayers']
        relativePermitivity = this.vars['relativePermitivity']
        permitivityConstant = this.vars['permitivityConstant']
        activeDensity = this.vars['activeDensity'] 
        passiveDensity = this.vars['passiveDensity']
        wingLength = this.vars['wingLength']
        aspectRatio = this.vars['aspectRatio']
        wingShapeParameter = this.vars['wingShapeParameter']
        inertialParameter = this.vars['inertialParameter'] 
        transmissionRatio = this.vars['transmissionRatio']
        airDensity = this.vars['airDensity']
        dragCoefficient = this.vars['maxDragCoefficient']
        angularVelocityParameter = this.vars['angularVelocityParameter']
        radiusToCenterParameter = this.vars['radiusToCenterParameter']
        stiffnessParameter = this.vars['stiffnessParameter']
        liftCoefficient = this.vars['liftCoefficient']
        lossTangent = this.vars['lossTangent']
        accelerationGravity = this.vars['accelerationGravity']
        operatingFrequency = this.vars['operatingFrequency']

        # Determine true thickness based on multiLayers parameter
        activeMaterialThickness = activeMaterialThickness * multiLayers

        # Build layup
        layUp = [0]
        # Build bimorph
        plyT = np.array ([activeMaterialThickness, passiveMaterialThickness, activeMaterialThickness])
        if verbose: 
            print ('plyT', plyT)
            print ()

        # Find midPlane value
        midPlaneZ = np.sum (plyT) / 2.0

        # Find height at each plyLayer
        plyHeights = []
        for i in range (len (plyT)):
            plyHeights.append (np.sum (plyT[:i + 1]))
        plyHeights = np.array (plyHeights)
        if verbose:
            print ('plyHeights', plyHeights)
            print ('midPlaneZ', midPlaneZ)
            print ()

        # Determine which layer the midPlane cuts through
        midLayer = np.min (np.where (plyHeights > midPlaneZ)[0])
        if verbose:
            print ('midLayer', midLayer)
            print ()

        # Now create new layUp split by the midPlane
        newPlyT = []
        if midLayer == 0:
            # midPlane cuts through 1st layer
            # Split 1st layer into 2 and append the rest
            newPlyT = [midPlaneZ, plyT[0] - midPlaneZ]
            newPlyT.extend (plyT[1:])
        else:
            # midPlane cuts trough another layer
            # Append up to midPlane, split midLayer and append the rest
            newPlyT.extend (plyT[0:midLayer])
            newPlyT.append (midPlaneZ - plyHeights[midLayer - 1])
            newPlyT.append (plyHeights[midLayer] - midPlaneZ)
            newPlyT.extend (plyT[midLayer + 1:])
        newPlyT = np.array (newPlyT)
        if verbose:
            print ('newPlyT', newPlyT)
            print ()

        # Create new height map using separated thickness layers
        newPlyHeights = []
        for i in range (len (newPlyT)):
            if i < midLayer + 1:
                newPlyHeights.append (-np.sum (newPlyT[i:midLayer + 1]))
            else:
                newPlyHeights.append (np.sum (newPlyT[midLayer + 1:i + 1]))
        newPlyHeights = np.array (newPlyHeights).T  
        if verbose: 
            print ('newPlyHeights', newPlyHeights)
            print ()

        # Get inidividual ply thicknesses
        zTemp = []
        zTemp.extend (newPlyHeights[np.where (newPlyHeights < 0.0)])
        zTemp.append (0.0)
        zTemp.extend (newPlyHeights[np.where (newPlyHeights > 0.0)])
        zTemp = np.array (zTemp)
        if verbose:
            print ('zTemp', zTemp)
            print ()

        zNew = np.zeros (shape = (newPlyHeights.shape[0], 3))
        for i in range (newPlyHeights.shape[0]):
            zNew[i, 0] = zTemp[i + 1] - zTemp[i]
            zNew[i, 1] = (zTemp[i + 1] ** 2.0) - (zTemp[i] ** 2.0)
            zNew[i, 2] = (zTemp[i + 1] ** 3.0) - (zTemp[i] ** 3.0)
        if verbose:
            print ('zNew', zNew)
            print ()

        # Get laminate matrices
        A = np.zeros (shape = (3,3))
        B = np.zeros (shape = (3,3))
        D = np.zeros (shape = (3,3))

        # For bimorphs add piezo layer components 
        # TODO: Add qActive
        A = qActive * (zNew[0, 0] + zNew[zNew.shape[0] - 1, 0])
        B = qActive * (zNew[0, 1] + zNew[zNew.shape[0] - 1, 1])
        D = qActive * (zNew[0, 2] + zNew[zNew.shape[0] - 1, 2])

        # Add contributions in elastic layers
        # TODO: Add qPassive
        for i in range (1, zNew.shape[0] - 1):
            A = A + qPassive * zNew[i, 0]
            B = B + qPassive * zNew[i, 1]
            D = D + qPassive * zNew[i, 2]
        if verbose:
            print ('qPassive', qPassive)
            print ()

        B = B / 2.0
        D = D / 3.0
        if verbose:
            print ('A', A)
            print ('B', B)
            print ('D', D)
            print ()

        nPiezoLayers = 1 # TODO: Change this
        # TODO: Add appliedElectricField
        # TODO: Add activeMaterialThickness
        #   TODO: Add d31
        appliedVoltage = appliedElectricField * activeMaterialThickness
        d31Matrix = np.array ([
            [d31],
            [d31],
            [0.0]
        ])
        N = np.zeros (shape = (3, 1))
        M = np.zeros (shape = (3, 1))
        N = qActive @ d31Matrix * appliedVoltage
        # TODO: Adjust here multiple piezo layers
        M = qActive @ d31Matrix * appliedVoltage * np.abs (zNew[zNew.shape[0] - 1, 1] / zNew[zNew.shape[0] - 1, 0]) / 2.0

        stiffnessMatrix = np.zeros (shape = (6, 6))
        stiffnessMatrix[0:3,0:3] = A
        stiffnessMatrix[0:3,3:6] = B
        stiffnessMatrix[3:6,0:3] = B
        stiffnessMatrix[3:6,3:6] = D
        if verbose:
            print ('N', N)
            print ('M', M)
            print ('stiffnessMatrix', stiffnessMatrix)
            print ()

        C = np.linalg.inv (stiffnessMatrix)
        P = C[3,0] * N[0] + C[3,1] * N[1] + C[3,3] * M[0] + C[3,4] * M[1]
        P = P[0]
        if verbose:
            print ('C', C)
            print ('P', P)
            print ()

        # TODO: Add widthRatio
        # TODO: Add lengthRatio
        gA = 6.0 * (widthRatio - 1.0) * (-3.0 - 2.0 * lengthRatio + 2.0 * widthRatio + 2.0 * lengthRatio * widthRatio)
        gB = 3.0 * (widthRatio - 2.0) * (-2.0 - 2.0 * lengthRatio + widthRatio + 2.0 * lengthRatio * widthRatio) * math.log ((2.0 - widthRatio) / widthRatio)
        gC = 8.0 * (1.0 - widthRatio) ** 3.0
        gD = 6.0 * (widthRatio - 1.0) * (3.0 + 4.0 * lengthRatio - 2.0 * widthRatio - 4.0 * lengthRatio * widthRatio)
        gE = 3.0 * ((-2.0 - 2.0 * lengthRatio + widthRatio + 2.0 * lengthRatio * widthRatio) ** 2.0) * math.log ((2.0 - widthRatio) / widthRatio)

        gLExt = (gD + gE) / gC
        gF = (1.0 + 2.0 * lengthRatio) / gLExt
        gG = (1.0 + 2.0 * lengthRatio)
        if verbose:
            print ('gA', gA)
            print ('gB', gB)
            print ('gC', gC)
            print ('gD', gD)
            print ('gE', gE)
            print ('gF', gF)
            print ('gLExt', gLExt)
            print ()

        # TODO: Add length
        # TODO: Add width
        # TODO: Add relativePermitivity
        # TODO: Add permitivityConstant
        # TODO: Add output - singleSidedCapacitance
        singleSidedCapacitance = (length * width * relativePermitivity * permitivityConstant) / (activeMaterialThickness / multiLayers)

        # TODO: Add output - unloadedDisplacement
        # TODO: Add output - blockedForce
        unloadedDisplacement =  -((P * length * length) / 2.0) * gG * 2.0 ## peak-to-peak
        # unloadedDisplacement =  -((P * length * length) / 2.0) * gG ## amplitude
        blockedForce = -(3.0 * P * width) / (2 * length * C[3,3])
        blockedForce = blockedForce * gF * 2.0
        blockedForce = blockedForce * 1.0e3 # convert kg in force to g

        # TODO: Add activeDensity
        # TODO: Add passiveDensity
        # TODO: Add output - volume
        # TODO: Add output - mass
        area = width * length
        activeVolume = area * activeMaterialThickness * 2.0
        passiveVolume = area * passiveMaterialThickness
        totalVolume = activeVolume + passiveVolume
        mass = (activeVolume * activeDensity) + (passiveVolume * passiveDensity)

        # TODO: Add output - deviceStiffness
        deviceStiffness = np.abs (blockedForce / unloadedDisplacement)
        if verbose:
            print ('unloadedDisplacement(p-p)', unloadedDisplacement)
            print ('blockedForce(mN p-p)', blockedForce)
            print ('deviceStiffness(mN/m)', deviceStiffness)
            print ('activeMass(g)',activeVolume * activeDensity)
            print ('passiveMass(g)',passiveVolume * passiveDensity)
            print ()
        # Recompute transmission ratio to meet specs
        # targetStrokeAmplitude = 120.0 * (math.pi / 180.0)
        # transmissionRatio = targetStrokeAmplitude / unloadedDisplacement

        # Thurst calculations
        # TODO: Add wingLength 
        # TODO: Add scaleC
        # TODO: Add wingParameter
        # TODO: Add inertialParameter
        # TODO: Add transmissionRatio
        # TODO: Add airDensity
        # TODO: Add dragCoefficient
        # TODO: Add angularVelocityParameter
        # TODO: Add radiusToCenterParameter
        # TODO: Add stiffnessParameter
        c = wingLength / aspectRatio
        beta = c * wingLength * wingLength * wingLength * wingShapeParameter * wingShapeParameter
        J = inertialParameter * (wingLength ** 4.0)
        equivalentMass = mass + (transmissionRatio ** 2.0) * J
        equivalentStiffness = deviceStiffness + (transmissionRatio ** 2.0) * stiffnessParameter
        approximatedResonantFrequency = math.sqrt (equivalentStiffness / equivalentMass) / (2 * math.pi)
        if verbose:
            print ('beta', beta)
            print ('equivalentMass(g)', equivalentMass)
            print ('equivalentStiffness(mN/m)', equivalentStiffness)
            print ('approximatedResonantFrequency(Hz)', approximatedResonantFrequency)
            print ()

        # Linearize around guess natural frequency
        c = (transmissionRatio ** 3.0) * airDensity * dragCoefficient * (wingLength ** 5.0) * (wingShapeParameter ** 2.0) * radiusToCenterParameter
        c = c / aspectRatio
        try:
            # qualityFactor = math.sqrt ((mass * deviceStiffness) / (c * blockedForce))
            qualityFactor = math.sqrt ((equivalentMass * equivalentStiffness) / (c * blockedForce))
        except:
            print (mass)
            print (deviceStiffness)
            print (c)
            print (blockedForce)
            print (transmissionRatio)
            sys.exit ()
        # approximateLoadedDisplacement = qualityFactor * unloadedDisplacement
        approximateLoadedDisplacement = unloadedDisplacement
        if verbose:
            print ('c', c)
            print ('qualityFactor', qualityFactor)
            print ('unloadedDisplacement(p-p)', unloadedDisplacement)
            print ('approximatedLoadedDisplacment(p-p)', approximateLoadedDisplacement)
        approximateLoadedDisplacement = approximateLoadedDisplacement / 2.0 # amplitude
        # angularVelocityParameter = (2.0 * math.pi * approximateLoadedDisplacement * approximatedResonantFrequency * transmissionRatio)
        angularVelocityParameter = (2.0 * math.pi * approximateLoadedDisplacement * operatingFrequency * transmissionRatio)
        aerodynamicDamping = 0.5 * airDensity * beta * dragCoefficient * angularVelocityParameter
        if verbose:
            print ('aerodynamicDamping', aerodynamicDamping)
            print ('J', J)
        radiusToCenter = wingLength * radiusToCenterParameter
        equivalentDamping = (transmissionRatio ** 2.0) * radiusToCenter * aerodynamicDamping
        # print ('equivalentDamping', equivalentDamping)

        if verbose:
            print ('approximatedResonantFrequency', approximatedResonantFrequency)
            print ('radiusToCenter', radiusToCenter)
            print ('equivalentDamping', equivalentDamping)
 
        # make appliedVoltage an external variable
        A = blockedForce / appliedVoltage
        GFunc = control.TransferFunction (
                [0.0, 0.0, 1.0],
                [equivalentMass, equivalentDamping, equivalentStiffness]
        )

        # Get natural response
        frequencies = np.logspace (0.0, 4.0, 100)
        averageVoltage = appliedVoltage / 2.0
        omegas = 2.0 * math.pi * frequencies
        GResponses = GFunc.frequency_response (omegas)
        magnitudes, phases, omegas = GResponses
        if plot:
            if plot:
                fig, ax = plt.subplots ()
                ax.plot (frequencies, magnitudes * A * appliedVoltage)
                ax.set_xscale ('log')
                naturalResponse = max (magnitudes)
                naturalFrequency = frequencies[np.where (magnitudes == naturalResponse)]
                ax.axvline (naturalFrequency, color = 'red')
                ax.axhline (naturalResponse * A * appliedVoltage, color = 'red')
                ax.axvline (operatingFrequency)
                fig.savefig ('wn.png')
                plt.close (fig)

                fig, ax = plt.subplots ()
                # Plot around operating point to see what happens
                for eqMass in [(equivalentMass / 10.0), equivalentMass, (equivalentMass * 10.0)]:
                    tempFunc = control.TransferFunction (
                        [0.0, 0.0, 1.0],
                        [eqMass, equivalentDamping, equivalentStiffness],
                    )
                    y = []
                    m, _, f = tempFunc.frequency_response (omegas)
                    for mo, fo in zip (m, f):
                        y.append (mo * fo * A * averageVoltage)
                    ax.plot (frequencies, y, label = 'eqMass: %s' % (eqMass))
                for eqDamping in [equivalentDamping / 10.0, equivalentDamping, equivalentDamping * 10.0]:
                    tempFunc = control.TransferFunction (
                        [0.0, 0.0, 1.0],
                        [equivalentMass, eqDamping, equivalentStiffness],
                    )
                    y = []
                    m, _, f = tempFunc.frequency_response (omegas)
                    for mo, fo in zip (m, f):
                        y.append (mo * fo * A * averageVoltage)
                    ax.plot (frequencies, y, label = 'eqDamping: %s' % (eqDamping))
                for eqStiffness in [equivalentStiffness / 10.0, equivalentStiffness, equivalentStiffness * 10.0]:
                    tempFunc = control.TransferFunction (
                        [0.0, 0.0, 1.0],
                        [equivalentMass, equivalentDamping, eqStiffness],
                    )
                    y = []
                    m, _, f = tempFunc.frequency_response (omegas)
                    for mo, fo in zip (m, f):
                        y.append (mo * fo * A * averageVoltage)
                    ax.plot (frequencies, y, label = 'eqStiffness: %s' % (eqStiffness))
                ax.set_xscale ('log')
                # ax.set_yscale ('log')
                ax.legend ()
                fig.savefig ('eq.png')
                plt.close (fig)
                
            print ('DC Response: ', GFunc.frequency_response (0)[0][0])
        # TODO: Add output - naturalFrequency
        # Select frequency that maximizes wingAngularVelocity
        # angularVelocities = []
        # for omega, magnitude in zip (omegas, magnitudes):
            # angularVelocity = magnitude * A * averageVoltage * transmissionRatio * omega
            # angularVelocity = magnitude * omega
        #     angularVelocity = magnitude
        #     angularVelocities.append (angularVelocity)
        # maxAngularVelocity = np.max (angularVelocities)
        naturalResponse = max (magnitudes)
        gen = (i for i, v in enumerate (magnitudes) if v == naturalResponse)
        naturalFrequency = frequencies [next (gen)]
        # naturalFrequency = frequencies[np.where (magnitudes == naturalResponse)]
        # naturalFrequency = frequencies[np.where (magnitudes == np.max(magnitudes))][0]
        naturalAngularFrequency = 2 * math.pi * naturalFrequency

        # still choose operating frequency
        magnitude, phase, omega = GFunc.frequency_response (naturalAngularFrequency)
        # magnitude, phase, omega = GFunc.frequency_response (operatingFrequency)
        loadedDisplacement = magnitude[0] * A * appliedVoltage
        wingAngularVelocity = (loadedDisplacement / 2.0) * transmissionRatio * naturalAngularFrequency # Use amplitude and average voltage not peak to peak
        # wingAngularVelocity = (loadedDisplacement / 2.0) * transmissionRatio * operatingFrequency # Use amplitude and average voltage not peak to peak

        if verbose:
            print ('naturalFrequency(Hz)', naturalFrequency)
            print ('loadedDisplacement(p-p)', loadedDisplacement)
            print ('A', A)
            print ('wingAngularVelocity', wingAngularVelocity)
            print ()

        if verbose:
            print ('averageVoltage', averageVoltage)
            print ()
        # TODO: Add output - strokeAmplitude
        # TODO: Check that strokeAmplitude does not exceed maximum
        strokeAmplitude = (loadedDisplacement * transmissionRatio) * (180 / math.pi)
        if verbose:
            print ('loadedDisplacement', loadedDisplacement)
            print ('strokeAmplitude', strokeAmplitude)
            print ()
        # TODO: Add output - thrust
        # TODO: Add output - liftableMass
        # Add # wings
        thrust = 0.5 * airDensity * liftCoefficient * ((wingAngularVelocity) ** 2.0) * beta
        trueSingleWingThrust = thrust * 0.25 # 02/13 Jalil 0.5 --> 0.25
        thrust = trueSingleWingThrust * 2.0 # add wing # here (default 2)
        # thrust = thrust
        liftableMass = thrust / accelerationGravity
        if verbose:
          print ('thrust(mN)', thrust)
          print ('liftableMass', liftableMass)

        # TODO: Add output - parallelLossResistance
        parallelLossResistance = 1.0 / (2.0 * multiLayers * math.pi * naturalFrequency * singleSidedCapacitance * lossTangent)

        # log outputs:
        this.res['A'] = A
        this.res['approximatedResonantFrequency'] = math.sqrt (equivalentStiffness / equivalentMass) / (2 * math.pi)
        this.res['appliedVoltage'] = appliedVoltage / multiLayers
        this.res['equivalentStiffness'] = equivalentStiffness
        this.res['equivalentDamping'] = equivalentDamping
        this.res['equivalentMass'] = equivalentMass
        this.res['singleSidedCapacitance'] = singleSidedCapacitance
        this.res['qualityFactor'] = qualityFactor
        this.res['unloadedDisplacement'] = unloadedDisplacement
        this.res['loadedDisplacement'] = loadedDisplacement
        this.res['blockedForce'] = blockedForce
        this.res['deviceStiffness'] = deviceStiffness
        this.res['naturalFrequency'] = naturalFrequency
        this.res['strokeAmplitude'] = strokeAmplitude
        this.res['wingAngularVelocity'] = wingAngularVelocity
        this.res['thrust'] = thrust
        this.res['liftableMass'] = liftableMass
        this.res['parallelLossResistance'] = parallelLossResistance
        this.res['deviceMass'] = mass
        this.res['totalMechanicalMass'] = (mass * 3.0)
        this.res['netThrust'] = liftableMass - (mass * 3.0)
        this.res['layeredThickness'] = activeMaterialThickness
        this.res['wingAngularVelocity'] = wingAngularVelocity
        # impedance calculation
        # iav = vac / (pi * |z(w)|) + vdc / |z(0)| # ac current is divided by 2 since return current is ignored
        # vac = vdc = appliedVoltage / 2
        bulk = quad (this.vars['bulkParameters'], this.vars['width'], this.vars['length'])
        if bulk < 0.0:
            bulk = 1e-12
        resistance = quad (this.vars['resistanceParameters'], this.vars['width'], this.vars['length'])
        if resistance < 0.0:
            resistance = 1.0
        inductance = quad (this.vars['inductanceParameters'], this.vars['width'], this.vars['length'])
        if inductance < 0.0:
            inductance = 1e-6
        capacitance = quad (this.vars['capacitanceParameters'], this.vars['width'], this.vars['length'])
        if capacitance < 0.0:
            capacitance = 1e-12
        zr = 4e6
        zc = 1.0 / (1.0j * 2.0 * np.pi * this.res['naturalFrequency'] * bulk)
        zc1 = 1.0 / (1.0j * 2.0 * np.pi * this.res['naturalFrequency'] * capacitance)
        zl1 = 1.0j * 2.0 * np.pi * this.res['naturalFrequency'] * inductance
        zr1 = resistance
        z1 = zc1 + zl1  + zr1
        z = (zr * zc) / (zr + zc)
        z = (z * z1) / (z + z1)
        mag_z = np.abs (z)
        iac = this.res['appliedVoltage'] / (2.0 * np.pi * mag_z)
        idc = this.res['appliedVoltage'] / (2.0 * zr)
        this.res['averageCurrent'] = iac + idc

    def build (this, desiredThrust):
        # static values
        staticStrokeAmplitude = this['staticStrokeAmplitude'] # solved
        operatingFrequency = this['operatingFrequency'] # solved
        length = this['length'] # static

        # transmissionRatio = this['transmissionRatio'] # solved
        # desiredDisplacement = (staticStrokeAmplitude * math.pi / 180.0) / transmissionRatio # displacement to reach stroke amplitude # not applicable
        
        # current updated values
        this.update (verbose = False)
        prevDisplacement = this['unloadedDisplacement'] # scales length ** 2
        desiredDisplacement = prevDisplacement
        desiredTransmission = (staticStrokeAmplitude * math.pi) / (180.0 * prevDisplacement)

        # displacementScale = desiredDisplacement / prevDisplacement
        # lengthScale = math.sqrt (displacementScale)

        # update length
        # if not math.isclose (lengthScale, 1.0, rel_tol = 1e-6):
        #   this['length'] = prevLength * lengthScale
        #   this.update ()

        # update values
        this['transmissionRatio'] = desiredTransmission
        transmissionRatio = this['transmissionRatio']

        # other parameters
        accelerationGravity = this['accelerationGravity']
        dragCoefficient = this['maxDragCoefficient']
        liftCoefficient = this['liftCoefficient']
        radiusToCenterParameter = this['radiusToCenterParameter']
        aspectRatio = this['aspectRatio']
        airDensity = this['airDensity']
        wingShapeParameter = this['wingShapeParameter']
        stiffnessParameter = this['stiffnessParameter']
        inertialParameter = this['inertialParameter']

        # values to be updated
        prevBlockedForce = this['blockedForce'] # scales width
        prevStiffness = this['deviceStiffness'] # scales width
        prevMass = this['deviceMass'] # scales width
        # print ('prevMass', prevMass)
        # print ('prevStiffness', prevStiffness)

        prevWidth = this['width']

        # preprocess argument
        # put desired thrust in mN (* 1.0e3)
        # assume average thrust is peak thrust over 2
        desiredThrust = desiredThrust * 1.0e3 * 2.0  # desired peak on single wing

        # desired wing length (based on desired thrust on single wing)
        desiredAngularFrequency = 2.0 * math.pi * operatingFrequency
        desiredAngularVelocity = desiredAngularFrequency * 0.5 * desiredDisplacement * transmissionRatio
        # using blade element equation
        desiredWingLength = 2.0 * (desiredThrust * aspectRatio) / ((desiredAngularVelocity ** 2.0) * liftCoefficient * airDensity * (wingShapeParameter ** 2.0))
        desiredWingLength = desiredWingLength ** 0.25
        # scale wing size not shape
        wingInertia = inertialParameter * (desiredWingLength ** 4.0)
        # print ('wingInertia', wingInertia)
        radiusToCenter = radiusToCenterParameter * desiredWingLength
        # print (desiredWingLength)
        # required to counteract the damping force on wing
        # computed using damped resonant equation

        # solve quadratric equation to determine required blocked
        A = 2.0 * (prevMass ** 2.0) * (desiredAngularFrequency ** 2.0) * desiredDisplacement # 
        # print ('A1', A)
        A = A - 2.0 * prevMass * prevBlockedForce #
        # print ('A', A)
        B = 2.0 * prevMass * wingInertia * (transmissionRatio ** 2.0) * (desiredAngularFrequency ** 2.0) * desiredDisplacement #
        # print ('B1', B)
        B = B - 2.0 * prevBlockedForce * wingInertia * (transmissionRatio ** 2.0) #
        # print ('B2', B)
        B = B - 2.0 * prevMass * stiffnessParameter * (transmissionRatio ** 2.0) * desiredDisplacement #
        # print ('B', B)
        C = 2.0 * (wingInertia ** 2.0) * (transmissionRatio ** 4.0) * (desiredAngularFrequency ** 2.0) * desiredDisplacement #
        # print ('C1', C)
        C = C - 2.0 * wingInertia * stiffnessParameter * (transmissionRatio ** 4.0) * desiredDisplacement #
        # print ('C2', C)
        Cdamping = 0.5 * airDensity * (desiredWingLength ** 4.0) * (1.0 / aspectRatio) * (wingShapeParameter ** 2.0) * dragCoefficient * desiredAngularVelocity * radiusToCenter * (transmissionRatio ** 2.0)
        # print ('Cdamping', Cdamping)
        # fail on no solution
        C = C + (Cdamping ** 2.0) * desiredDisplacement
        if (B ** 2.0) - 4.0 * A * C < 0:
          return
        # print ('C', C)
        blockedForceScaleA = -1.0 * B + np.sqrt ((B ** 2.0) - 4.0 * A * C)
        blockedForceScaleA = blockedForceScaleA / (2.0 * A)
        # print ('bFSA', blockedForceScaleA)
        blockedForceScaleB = -1.0 * B - np.sqrt ((B ** 2.0) - 4.0 * A * C)
        blockedForceScaleB = blockedForceScaleB / (2.0 * A)
        # print ('bFSB', blockedForceScaleB)
        # take positive solution
        blockedForceScale = max (blockedForceScaleA, blockedForceScaleB)
        if blockedForceScale < 0:
          return 
        
        # desiredBlockedForce = 0.5 * 2.0 * transmissionRatio * (desiredThrust * dragCoefficient * radiusToCenter / liftCoefficient) # drag
        # L = 0.5 * airDensity * ((2.0 * math.pi * operatingFrequency * 0.5 * desiredDisplacement * transmissionRatio) ** 2.0) * liftCoefficient * (desiredWingLength ** 4.0) * (wingShapeParameter ** 2.0) / aspectRatio
        # desiredAngularAcceleration = (0.5 * desiredDisplacement) * transmissionRatio * (2.0 * math.pi * operatingFrequency) ** 2.0
        # desiredBlockedForce = desiredBlockedForce + transmissionRatio * (wingInertia * desiredAngularAcceleration) # inertia
        # blockedForceScale = desiredBlockedForce / prevBlockedForce

        widthScale = blockedForceScale

        # print ('desiredWingLength', desiredWingLength)
        # print ('desiredDisplacement', desiredDisplacement)
        # print ('desiredStrokeAmplitude', (desiredDisplacement / 2.0) * transmissionRatio * (180.0 / math.pi))
        # print ('prevForce', prevBlockedForce)
        # print ('desiredForce', prevBlockedForce * blockedForceScale)
        # print ()

        # Check
        eMass = prevMass * blockedForceScale + wingInertia * (transmissionRatio ** 2.0)
        # print ('eMass', eMass)
        eStiffness = prevStiffness * blockedForceScale + stiffnessParameter * (transmissionRatio ** 2.0) 
        # print ('eStiffness', eStiffness)
        undampedOmega = np.sqrt (eStiffness / eMass)
        # print ('undampedOmega', undampedOmega)
        # print ('undampedFrequency', undampedOmega / (2.0 * np.pi))
        dampingAlpha = Cdamping / (2.0 * np.sqrt (eMass * eStiffness))
        # print ('dampingAlpha', dampingAlpha)
        wd = undampedOmega * np.sqrt (1.0 - (dampingAlpha ** 2.0))
        wp = undampedOmega * np.sqrt (1.0 - 2.0 * (dampingAlpha ** 2.0))
        # print ('wd', wd)
        # print ('fd', wd / (2.0 * np.pi))
        # print ('wp', wp)
        # print ('fp', wp / (2.0 * np.pi))

        this['width'] = prevWidth * widthScale
        this['wingLength'] = desiredWingLength
        this.update ()

def main2 (PB):
    x = np.linspace (1.0E-3, 20E-3, 20)
    stiffnesses = np.zeros(shape = (20, 20))
    displacements = np.zeros(shape = (20, 20))
    ldisplacements = np.zeros(shape = (20, 20))
    blockedforce = np.zeros(shape = (20, 20))
    naturalfrequency = np.zeros(shape = (20, 20))
    for i, l in enumerate (x):
        for j, w in enumerate (x):
            PB['length'] = l
            PB['width'] = w
            PB.update ()
            stiffnesses[i, j] = PB['deviceStiffness']
            displacements[i, j] = PB['unloadedDisplacement']
            ldisplacements[i, j] = PB['loadedDisplacement']
            blockedforce[i, j] = PB['blockedForce']
            naturalfrequency[i, j] = PB['naturalFrequency']
    l, w = np.meshgrid (x, x)

    fig, ax = plt.subplots ()
    ax.plot (x, ldisplacements[19,:])
    fig.savefig ('linear-width.png')

    fig, ax = plt.subplots ()
    ax.plot (x, ldisplacements[:,19])
    fig.savefig ('linear-length.png')

    fig, ax = plt.subplots ()
    contour = ax.contourf (l, w, naturalfrequency)
    fig.colorbar (contour)
    ax.set_title ('Natural Frequency')
    ax.set_ylabel ('length')
    ax.set_xlabel ('width')
    fig.savefig ('natty-freq.png')

    fig, ax = plt.subplots ()
    contour = ax.contourf (l, w, stiffnesses)
    fig.colorbar (contour)
    ax.set_title ('Stiffness')
    ax.set_ylabel ('length')
    ax.set_xlabel ('width')
    fig.savefig ('stiffness.png')

    fig, ax = plt.subplots ()
    contour = ax.contourf (l, w, displacements)
    fig.colorbar (contour)
    ax.set_title ('Displacements')
    ax.set_ylabel ('length')
    ax.set_xlabel ('width')
    fig.savefig ('unloaded.png')

    fig, ax = plt.subplots ()
    contour = ax.contourf (l, w, ldisplacements)
    fig.colorbar (contour)
    ax.set_title ('LoadedDisplacements')
    ax.set_ylabel ('length')
    ax.set_xlabel ('width')
    fig.savefig ('loaded.png')

    fig, ax = plt.subplots ()
    contour = ax.contourf (l, w, blockedforce)
    fig.colorbar (contour)
    ax.set_title ('BlockedForce')
    ax.set_ylabel ('length')
    ax.set_xlabel ('width')
    fig.savefig ('force.png')
        
def main (PB):
    liftableMasses = []
    frequencies = []
    strokeAmplitudes = []
    x = np.linspace (5.0E-3, 30.0E-3, 50)
    for wL in x:
        PB['wingLength'] = wL
        PB.update ()
        liftableMasses.append (PB['liftableMass'])
        frequencies.append (PB['naturalFrequency'])
        strokeAmplitudes.append (PB['strokeAmplitude'])
    plt.plot (x, liftableMasses)
    plt.yscale ('log')
    plt.title ('liftableMass')
    plt.show ()
    plt.plot (x, frequencies)
    plt.title ('naturalFrequency')
    plt.show ()
    plt.plot (x, strokeAmplitudes)
    plt.title ('strokeAmplitude')
    plt.show ()

def console (PB):
    while 1:
        w = float (input ('> Input Width: ')) * 1E-3
        l = float (input ('> Input Length: ')) * 1E-3
        r = float (input ('> Input Wing: ')) * 1E-3
        PB['width'] = w
        PB['length'] = l
        PB['wingLength'] = r
        PB.update ()
        print ('Resulting frequency:', PB['naturalFrequency'])
        print ('Resulting thrust:', PB['thrust'])
        print ('Blocked force:', PB['blockedForce'])
        print ('Stroke amplitude:', PB['strokeAmplitude'])
        print ('Wing velocity:', PB['wingAngularVelocity'])


def main5 ():
    x = np.linspace (0.0005, 0.010, 10)
    y = []
    z = []
    t = []
    u = []
    for X in x:
        PB.build (X)
        y.append (PB['thrust'])
        z.append (PB['naturalFrequency'])
        t.append (PB['loadedDisplacement'])
        u.append (PB['unloadedDisplacement'])
    plt.plot(x, y)
    plt.show ()
    for i,j,k,l,m in zip (x,y,z,t,u):
        print (i, j, k, l,m)
    for key in PB.res:
        print (key, PB.res[key])
    # console (PB)

def main6 (PB, verbose = False):
    x = np.linspace (0.001, 0.05, 20)
    a = []
    b = []
    c = []
    d = []
    e = []
    f = []
    for i, t in enumerate (x):
        PB.build (t)
        a.append (PB['liftableMass'])
        b.append (PB['totalMass'])
        c.append (PB['liftableMass'] / PB['totalMass'])
        d.append (PB['liftableMass'] - PB['totalMass'])
        e.append (PB['thrust'] * 1.0e-3)
        f.append (PB['strokeAmplitude'])
        if verbose:
            if e[-1] > 2.0 * t:
                print ('no good')
            print ('desiredThrust', t * (1.0e3/9.8))
            print ('calculatedThrust', e[-1] * (1.0e3/9.8))
            print ('wingLength', PB['wingLength'])
            print ('width', PB['width'])
            print ('length', PB['length'])
            print ('unloadedDisplacement', PB['unloadedDisplacement'])
            print ('loadedDisplacement', PB['loadedDisplacement'])
            print ('naturalFrequency', PB['naturalFrequency'])
            print ('strokeAmplitude', PB['strokeAmplitude'])
            print ('approximatedResonantFrequency', PB['approximatedResonantFrequency'])
            print ('deviceStiffness', PB['deviceStiffness'])
            print ('equivalentDamping', PB['equivalentDamping'])
            print ('equivalentStiffness', PB['equivalentStiffness'])
            print ('deviceMass', PB['deviceMass'])
            print ('equivalentMass', PB['equivalentMass'])
            print ('qualityFactor', PB['qualityFactor'])
            print ()
            # sys.exit ()
    fig, ax = plt.subplots ()
    ax.plot (x, a)
    ax.set_title ('Liftable Mass')
    ax.set_xlabel ('Desired Thrust (N)')
    fig.savefig ('liftable-mass.png')

    fig, ax = plt.subplots ()
    ax.plot (x, b)
    ax.set_title ('Total Mass')
    ax.set_xlabel ('Desired Thrust (N)')
    fig.savefig ('total-mass.png')
    
    fig, ax = plt.subplots ()
    ax.plot (x, c)
    ax.set_title ('Lift-Weight Ratio')
    ax.set_xlabel ('Desired Thrust (N)')
    fig.savefig ('lift-weight.png')
    
    fig, ax = plt.subplots ()
    ax.plot (x, d)
    ax.set_title ('Leftover Mass')
    ax.set_xlabel ('Desired Thrust (N)')
    fig.savefig ('leftover.png')

    fig, ax = plt.subplots ()
    ax.plot (x, e)
    ax.set_title ('Calculated Thrust')
    ax.set_xlabel ('Desired Thrust (N)')
    fig.savefig ('thrust.png')

if __name__ == '__main__':
    PB = PiezoBimorph ()
    # main6 (PB, verbose = True)
    # sys.exit ()
    # main2 (PB)
    # sys.exit ()
    PB.update ()
    print (PB['width'])
    print (PB['length'])
    print (PB['strokeAmplitude'])
    print (PB['naturalFrequency'])
    print (PB['totalMechanicalMass'])
    print (PB['thrust'])
    print (PB['liftableMass'])
    print (PB['netThrust'])
    sys.exit ()
#   main6 (PB)
#   PB.build (0.001)
#   for key in PB.vars:
#       print (key, PB.vars[key])
#   for key in PB.res:
#       print (key, PB.res[key])
