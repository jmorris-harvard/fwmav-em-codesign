import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
import pandas as pd

def func (params, x, y):
  a, b, c, d, e, f = params
  return a + b * x + c * y + d * x * x + e * y * y + f * x * y

def residuals (params, x, y, z):
  r = func (params, x, y) - z
  return r

def fit ():
  data = pd.read_csv ('output_manual.csv')
  headers = [
    'bulk',
    'capacitance',
    'inductance',
    'resistance'
  ] 
  x = data['width'].to_numpy ()
  y = data['length'].to_numpy ()
  n = 60
  x_min, x_max = np.min (x), np.max (x)
  y_min, y_max = np.min (y), np.max (y)
  Xg = np.linspace (x_min, x_max)
  Yg = np.linspace (y_min, y_max)
  X, Y = np.meshgrid (Xg, Yg)
  A = np.column_stack ([np.ones_like (x), x, y, x ** 2, x * y, y ** 2])
  params = dict ()
  for header in headers:
    z = data[header].to_numpy ()
    p0, *_ = np.linalg.lstsq (A, z, rcond = None)
    res = sp.optimize.least_squares (residuals, p0, args = (x, y, z), loss = 'linear')
    params[header] = res.x
    print (header, res.x)
    Z = func (params[header], X, Y)
    fig = plt.figure (figsize = (9, 6))
    ax = fig.add_subplot (111, projection = '3d')
    ax.plot_surface (X, Y, Z, linewidth = 0, color = '#009e79', antialiased = True, alpha = 0.75)
    ax.scatter (x, y, z, s = 200, color = '#cc79a7', marker = '*', edgecolor = 'black', linewidth = 1)
    plt.show ()

def linear3d ():
  data = pd.read_csv ('output_manual.csv')
  headers = [
    'bulk',
    'capacitance',
    'inductance',
    'resistance'
  ] 
  x = data['width'].to_numpy ()
  y = data['length'].to_numpy ()
  n = 60
  x_min, x_max = np.min (x), np.max (x)
  y_min, y_max = np.min (y), np.max (y)
  Xg = np.linspace (x_min, x_max, n)
  Yg = np.linspace (y_min, y_max, n)
  X, Y = np.meshgrid (Xg, Yg)
  points = np.column_stack ([x, y])
  for header in headers:
    z = data[header].to_numpy ()
    Z = sp.interpolate.griddata (
        points = points,
        values = z,
        xi = (X, Y),
        method = 'linear'
    )
    fig = plt.figure (figsize = (9, 6))
    ax = fig.add_subplot (111, projection = '3d')
    ax.scatter (x, y, z, s = 200, color = '#cc79a7', marker = '*', edgecolor = 'black', linewidth = 1)
    ax.plot_surface (X, Y, Z, linewidth = 0, color = '#009e79', antialiased = True, alpha = 0.75)
    plt.show ()

def main ():
  linear3d ()

if __name__ == '__main__':
  main ()
