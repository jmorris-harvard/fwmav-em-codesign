import argparse
import numpy as np
import pandas as pd
import scipy.integrate as spin
import time
import matplotlib
import matplotlib.pyplot as plt
import os
import sys

i = 0

class Wing:
  # constant variables
  airdens = 1.293e3

  def __init__ (
    this,
    # required inputs
    R,
    frequency,
    transmission,
    amplitude,
    # typically constant arguments
    ixx = 1.7e-3 * 1.0e-6, # 1.7 mg mm2
    ixy = 3.5e-3 * 1.0e-6, # 3.5 mg mm2
    ar = 3.5,
    xr = 0.0e-3,
    yr = 0.0e-3,
    yle = 0.0,
    r1 = 0.5,
    xcmr = 5.74e-3 / 12.0e-3,
    ycm = 0.0,
    Lhinge = 70.0e-6,
    whinge = 1.8e-3,
    thinge = 7.6e-6,
    Eh = 2.5e9 * 1.0e3,
    clmax = 1.8,
    cd0 = 0.4,
    cdmax = 3.4,
    crd = 5.0
  ):
    this.R = R
    this.frequency = frequency
    this.transmission = transmission
    this.amplitude = amplitude

    this.ixx = ixx
    this.ixy = ixy
    this.ar = ar
    this.cbar = R / ar
    this.xr = xr
    this.xrhat = xr / R
    this.yr = yr
    this.yrhat = yr / this.cbar
    this.yle = yle
    # this.ylehat = yle / this.cbar
    this.r1 = r1
    this.xcmr = xcmr
    this.xcm = xcmr * R
    this.ycm = ycm

    this.Lhinge = Lhinge
    this.whinge = whinge
    this.thinge = thinge
    this.Eh = Eh

    this.clmax = clmax
    this.cd0 = cd0
    this.cdmax = cdmax
    this.crd = crd

    this.r2 = this.r2func ()
    # print ('r2', this.r2)
    this.p = this.pfunc ()
    this.q = this.qfunc ()
    this.Fhat = this.Fhatfunc ()
    # print ('Fhat', this.Fhat)
    this.beta = spin.quad (this.betafunc, 0.0, 1.0)[0]
    # print ('beta', this.beta)
    this.yrdhat = spin.quad (this.yrdfunc, 0.0, 1.0)[0]
    # print ('yrdhat', this.yrdhat)
    this.stiffness = this.stiffnessfunc ()
    # print ('stiffness', this.stiffness)

    this.Fl = []
    this.phi = []
    this.psi = []
    this.t = []

  # constant methods
  def r2func (this):
    return 0.929 * (this.r1 ** 0.732)

  def pfunc (this):
    return this.r1 * ((this.r1 * (1.0 - this.r1)) / (this.r2 * this.r2 - this.r1 * this.r1) - 1.0)

  def qfunc (this):
    return (1.0 - this.r1) * ((this.r1 * (1.0 - this.r1)) / (this.r2 * this.r2 - this.r1 * this.r1) - 1.0)

  def Fhatfunc (this):
    return this.r2 * this.r2 + 2.0 * this.xr * this.r1 + this.xr * this.xr

  def betafunc (this, rhat):
    return (rhat ** (this.p - 1.0)) * ((1.0 - rhat) ** (this.q - 1.0))

  def crhat (this, rhat):
    return this.betafunc (rhat) / this.beta

  def ylehat (this, rhat):
    if rhat < 0.75:
      return 0
    else:
      return -(30.0e-3 / this.cbar) * (rhat - 0.75) ** 2.0

  def yrdfunc (this, rhat):
    return 0.25 * (abs (this.yrhat + this.ylehat (rhat)) * (this.yrhat + this.ylehat (rhat)) ** 3.0 - abs (this.yrhat + this.ylehat (rhat) - this.crhat (rhat)) * (this.yrhat + this.ylehat (rhat) - this.crhat (rhat)) ** 3.0)

  def stiffnessfunc (this): 
    return (this.Eh * (this.thinge ** 3.0) * this.whinge) / (12.0 * this.Lhinge)

  # dynamic methods
  def cl (this, alpha):
    return this.clmax * np.sin (2.0 * alpha)

  def cd (this, alpha):
    return ((this.cdmax + this.cd0) / 2.0) - ((this.cdmax - this.cd0) / 2.0) * np.cos (2.0 * alpha)

  def cn (this, alpha):
    return this.cl (alpha) * np.cos (alpha) + this.cd (alpha) * np.sin (alpha)

  def dcp (this, alpha):
    return ((0.82 * abs (alpha)) / np.pi) + 50.0e-3

  def wfunc (this, phi, phidot, psi, psidot, theta = 0.0, thetadot = 0.0):
    wx = psidot - phidot * np.sin (theta)
    wy = -1.0 * phidot * np.cos (theta) * np.cos (psi) + thetadot * np.sin (psi)
    wz = phidot * np.cos (theta) * np.sin (psi) + thetadot * np.cos (psi)
    return wx, wy, wz

  def alphafunc (this, wy, wz):
    return np.arctan2 (-wy, wz)

  def ycpfunc (this, rhat, alpha):
    return (this.yrhat + this.ylehat (rhat) - this.crhat (rhat) * this.dcp (alpha)) * (rhat + this.xrhat) * (rhat + this.xrhat) * this.crhat (rhat)

  def ycp (this, alpha):
    def ycpfuncinst (rhat):
      return this.ycpfunc (rhat, alpha)
    return spin.quad (ycpfuncinst, 0.0, 1.0)[0] / this.Fhat

  def mxaero (this, wh, alpha):
    ycpcomp = this.ycp (alpha)
    cncomp = this.cn (alpha)
    m = -0.5 * Wing.airdens * wh * wh * cncomp * this.cbar * this.cbar * this.R * this.R * this.R * this.Fhat * ycpcomp
    return m
  
  def mxrd (this, wx):
    m = -0.5 * Wing.airdens * wx * abs (wx) * this.crd * (this.cbar ** 4.0) * this.R * this.yrdhat
    return m

  def mxelastic (this, psi):
    m = -1.0 * this.stiffness * psi
    return m

  def Flift (this, wh, alpha):
    f = 0.5 * Wing.airdens * wh * wh * this.cl (alpha) * this.cbar * this.R * this.R * this.R * this.Fhat
    return f

  def forward (this, t, state):
    psi, psidot = state

    phi = this.transmission * this.amplitude * np.cos (2.0 * np.pi * this.frequency * t)
    # print ('phi', phi)

    phidot = -2.0 * np.pi * this.frequency * this.transmission * this.amplitude * np.sin (2.0 * np.pi * this.frequency * t)
    # print ('phidot', phidot)

    phidotdot = -4.0 * np.pi * np.pi * this.frequency * this.frequency * this.transmission * this.amplitude * np.cos (2.0 * np.pi * this.frequency * t)
    # print ('phidotdot', phidotdot)

    wx, wy, wz = this.wfunc (phi = phi, phidot = phidot, psi = psi, psidot = psidot)
    wh = np.sqrt (wy * wy + wz * wz)
    alpha = this.alphafunc (wy = wy, wz = wz)
    # print ('wx', wx)
    # print ('wy', wy)
    # print ('wz', wz)
    # print ('wh', wh)
    # print ('alpha', alpha)

    inertialxy = this.ixy * phidotdot * np.cos (psi) - this.ixy * phidot * np.sin (psi) * (1.0 - psidot)
    inertialxx = 0.5 * this.ixx * (phidot ** 2.0) * np.sin (2.0 * psi)
    # print ('inertialxy', inertialxy)
    # print ('inertialxx', inertialxx)
    ma = this.mxaero (wh = wh, alpha = alpha)
    mr = this.mxrd (wx = wx)
    me = this.mxelastic (psi = psi)
    # print ('ma', ma)
    # print ('mr', mr)
    # print ('me', me)

    psidotdot = ma + mr + me + inertialxy + inertialxx
    psidotdot = psidotdot / this.ixx

    Fl = abs (this.Flift (wh, alpha))
    # print ('Fl', Fl)
    # print ('psi', psi)
    # print ('psidot', psidot)
    # print ('psidotdot', psidotdot)
    this.t.append (t)
    this.Fl.append (Fl)
    this.phi.append (phi)
    this.psi.append (psi)
    # print ()

    return [psidot, psidotdot]

  def solve (this, periods):
    y0 = [0.0, 0.0]
    t_span = [0.0, float (periods) / this.frequency]
    result = spin.solve_ivp (this.forward, t_span, y0, method = 'LSODA')
    return this.t, this.phi, this.psi, this.Fl

  def clear (this):
    this.t = []
    this.phi = []
    this.psi = []
    this.Fl = []

def main_prune ():
  parser = argparse.ArgumentParser (description = '')
  parser.add_argument ('--file', '-f', type = str, required = True)

  args = parser.parse_args ()

  # load options
  df = pd.read_csv (args.file)
  outfile = os.path.splitext (args.file)[0] + '_pruned.csv'
  dfpruned = pd.DataFrame (columns = df.columns)

  # run full analysis
  for i in range (df.shape[0]):
    wing = Wing (
      R = float (df.loc[i, 'wingLength']),
      frequency = float (df.loc[i, 'naturalFrequency']),
      transmission = float (df.loc[i, 'transmissionRatio']),
      amplitude = float (df.loc[i, 'loadedDisplacement']) / 2.0
    )
    t, phi, psi, Fl = wing.solve (10)
    oldFl = float (df.loc[i, 'liftableMass'])
    trueFl = 2.0 * np.mean (Fl) * 101.0
    trueFl = trueFl / 1.0e3
    diff = oldFl - trueFl
    print (oldFl, '-->', trueFl)

    # update
    oldNet = float (df.loc[i, 'netThrust'])
    if oldNet - diff > 0.0:
      df.loc[i, 'netThrust'] = oldNet - diff
      df.loc[i, 'liftableMass'] = trueFl
      dfpruned = pd.concat([dfpruned, df.iloc[i].to_frame().T], ignore_index=True)

  dfpruned.to_csv (outfile, index = False)

def main_cli ():
  parser = argparse.ArgumentParser (description = '')
  parser.add_argument ('--wing-length', '-R', type = float, required = True)
  parser.add_argument ('--transmission', '-T', type = float, required = True)
  parser.add_argument ('--amplitude', '-d', type = float, required = True)
  parser.add_argument ('--frequency', '-f', type = float, required = True)
  parser.add_argument ('--plot', '-p', default = False, action = 'store_true', required = True)
  args = parser.parse_args ()

  wing = Wing (
    R = args.wing_length,
    frequency = args.frequency,
    transmission = args.transmission,
    amplitude = args.amplitude
  )

  t, phi, psi, Fl = wing.solve (10)
  print ('mean (2 wing)', 2.0 * np.mean (Fl) * 101.0)
  print ('peak (1 wing)', max (Fl) * 101.0)

  if args.plot:
    fig, ax = plt.subplots ()
    ax.plot (t, np.array (phi) * (180.0 / np.pi), color = 'black')
    ax.plot (t, np.array (psi) * (180.0 / np.pi), color = 'red')
    fig.savefig ('psi-cli.png')
    plt.close (fig)

    fig, ax = plt.subplots ()
    ax.plot (t, np.array (phi) * (180.0 / np.pi), color = 'black')
    ax = ax.twinx ()
    ax.plot (t, np.array (Fl) * 101.0 * 2.0, color = 'red')
    fig.savefig ('fl-phi-cli.png')
    plt.close (fig)

    fig, ax = plt.subplots ()
    ax.plot (t, np.array (psi) * (180.0 / np.pi), color = 'black')
    ax = ax.twinx ()
    ax.plot (t, np.array (Fl) * 101.0 * 2.0, color = 'red')
    fig.savefig ('fl-psi-cli.png')
    plt.close (fig)

if __name__ == '__main__':
  main_prune ()
