import argparse
import cma
import itertools
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy as sp
import tkinter as tk
import sys

from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

import circuit

class App (tk.Tk):
  def __init__ (this, models, data, admittance, order, optimizer):
    super ().__init__ ()
    this.data = data
    this.admittance = admittance
    this.order = order
    for i, (l, w) in enumerate (this.order):
      print (i, ' ', l, ',', w)
    # sys.exit ()
    this.optimizer = optimizer

    this.title ('Fit')
    this.geometry ('1000x650')

    this.columnconfigure (0, weight = 5)
    this.columnconfigure (1, weight = 2)
    this.rowconfigure (0, weight = 1)

    title = tk.Frame (this, pady = 6)
    title.grid (row = 0, column = 0, columnspan = 2, sticky = 'ew')
    this.title = tk.Label (title, text = '', font = ('TkDefaultFont', 14, 'bold'))
    this.title.pack ()

    plot = tk.Frame (this)
    plot.grid (row = 0, column = 0, sticky = 'nsew')
    plot.rowconfigure (0, weight = 1)
    plot.columnconfigure (0, weight = 1)

    controls = tk.Frame (this, padx = 12, pady = 12)
    controls.grid (row = 0, column = 1, sticky = 'nsew')

    plt.rcParams['font.size'] = 20
    fig, axes = plt.subplots (nrows = 2, figsize = (6, 5))
    this.fig = fig
    this.ax_magnitude = axes[0]
    this.ax_magnitude.set_xlabel ('frequency (Hz)')
    if this.admittance:
      this.ax_magnitude.set_ylabel ('admittance (S)')
    else:
      this.ax_magnitude.set_ylabel ('impedance (Ohm)')
    this.ax_magnitude.set_title ('magnitude')
    this.ax_phase = axes[1]
    this.ax_phase.set_xlabel ('frequency (Hz)')
    this.ax_phase.set_ylabel ('phase (rad)')
    this.ax_phase.set_title ('phase')

    this.canvas = FigureCanvasTkAgg (this.fig, master = plot)
    this.canvas.get_tk_widget ().grid (row = 0, column = 0, sticky = 'nsew')

    this.scatter_magnitude = this.ax_magnitude.scatter (list (), list (), s = 100, edgecolors = 'black', label = 'measured', color = 'gray')
    this.curves_magnitude = list ()
    this.colors = ['#009e73', '#e69f00', '#cc97a7', '#0072b2']
    for i, model in enumerate (models):
      zorder = 5 if i == 0 else 2
      this.curves_magnitude.append (this.ax_magnitude.plot (list (), list (), linewidth = 3, color = this.colors[i], label = model.id, zorder = zorder)[0])
    # this.ax_magnitude.grid ()
    # this.ax_magnitude.legend ()
    arrowprops = dict (
      arrowstyle = '-|>',
      linewidth = 2.5,
      color = 'black',
      mutation_scale = 30
    )
    for spine in this.ax_magnitude.spines.values ():
      spine.set_visible (False)
    this.ax_magnitude.tick_params (
        which = 'major',
        direction = 'out',
        length = 6,
        width = 1
    )
    this.ax_magnitude.annotate (
      '',
      xy = (1.02, 0.00),
      xytext = (-0.02, 0.00),
      xycoords = 'axes fraction',
      arrowprops = arrowprops
    )
    this.ax_magnitude.annotate (
      '',
      xy = (0.00, 1.02),
      xytext = (0.00, -0.02),
      xycoords = 'axes fraction',
      arrowprops = arrowprops
    )

    this.scatter_phase = this.ax_phase.scatter (list (), list (), s = 100, edgecolors = 'black', label = 'measured', color = 'gray')
    this.curves_phase = list ()
    for i, model in enumerate (models):
      zorder = 5 if i == 0 else 2
      this.curves_phase.append (this.ax_phase.plot (list (), list (), linewidth = 3, color = this.colors[i], label = model.id, zorder = zorder)[0])
    # this.ax_phase.grid ()
    # this.ax_phase.legend ()
    arrowprops = dict (
      arrowstyle = '-|>',
      linewidth = 2.5,
      color = 'black',
      mutation_scale = 30
    )
    for spine in this.ax_phase.spines.values ():
      spine.set_visible (False)
    this.ax_phase.tick_params (
        which = 'major',
        direction = 'out',
        length = 6,
        width = 1
    )
    this.ax_phase.annotate (
      '',
      xy = (1.02, 0.00),
      xytext = (-0.02, 0.00),
      xycoords = 'axes fraction',
      arrowprops = arrowprops
    )
    this.ax_phase.annotate (
      '',
      xy = (0.00, 1.02),
      xytext = (0.00, -0.02),
      xycoords = 'axes fraction',
      arrowprops = arrowprops
    )

    tk.Label (controls, text = 'Parameters', font = ('TkDefaultFont', 12, 'bold')).pack (anchor = 'w')

    this.models = models
    this.names = list ()
    this.initials = list ()
    this.key = dict ()
    this.outputs = dict ()
    this.outputs['length'] = np.zeros (shape = len (order))
    this.outputs['width'] = np.zeros (shape = len (order))
    for model in models:
      names = model.names
      initials = model.initial
      for name, initial in zip (names, initials):
        if name not in this.names:
          this.key[name] = len (this.names)
          this.names.append (name)
          this.initials.append (initial)
          this.outputs[name] = np.zeros (shape = len (order))
    this.vars = list ()
    for i, (name, init) in enumerate (zip (this.names, this.initials)):
      row = tk.Frame (controls)
      row.pack (fill = 'x', pady = 6)
      tk.Label (row, text = name, width = 3).pack (side = 'left')
      v = tk.StringVar (value = str (init))
      this.vars.append (v)

      entry = tk.Entry (row, textvariable = v)
      entry.pack (side = 'left', fill = 'x', expand = True)
      v.trace_add ('write', lambda *_: this.update ())
    tk.Button (controls, text = 'Reset', command = this.reset).pack (fill = 'x', pady = (14, 6))
    tk.Button (controls, text = 'Optimize', command = this.optimize).pack (fill = 'x', pady = 6)
    tk.Button (controls, text = 'Randomize', command = this.randomize).pack (fill = 'x', pady = 6)
    tk.Button (controls, text = 'Quit', command = this.quit).pack (fill = 'x', pady = 6)
    tk.Button (controls, text = 'Next', command = this.next).pack (fill = 'x', pady = 6)
    tk.Button (controls, text = 'Previous', command = this.previous).pack (fill = 'x', pady = 6)
    tk.Button (controls, text = 'Save', command = this.save).pack (fill = 'x', pady = 6)

    row = tk.Frame (controls)
    row.pack (fill = 'x', pady = 6)
    tk.Label (row, text = 'Scale', width = 5).pack (side = 'left')
    this.scale = tk.StringVar (value = str (2.0))
    entry = tk.Entry (row, textvariable = this.scale)
    entry.pack (side = 'left', fill = 'x', expand = True)
    tk.Button (controls, text = 'Increase', command = this.increase).pack (fill = 'x', pady = (14, 6))
    tk.Button (controls, text = 'Decrease', command = this.decrease).pack (fill = 'x', pady = 6)

    this.status = tk.Label (controls, text = '', fg = 'gray')
    this.status.pack (anchor = 'w', pady = (12, 0))

    this.position = 0
    this.set (this.position)
    this.reset ()
    this.update ()

  def increase (this):
    if 'l1' not in this.models[0].names or 'c1' not in this.models[0].names:
      print ('invalid model to use scale buttons')
      sys.exit ()
    cap = float (this.vars[this.key['c1']].get ().strip ())
    ind = float (this.vars[this.key['l1']].get ().strip ())
    scale = float (this.scale.get ().strip ())
    cap = cap * scale
    ind = ind / scale
    this.vars[this.key['c1']].set (f'{cap:.5e}')
    this.vars[this.key['l1']].set (f'{ind:.5e}')

  def decrease (this):
    if 'l1' not in this.models[0].names or 'c1' not in this.models[0].names:
      print ('invalid model to use scale buttons')
      sys.exit ()
    cap = float (this.vars[this.key['c1']].get ().strip ())
    ind = float (this.vars[this.key['l1']].get ().strip ())
    scale = float (this.scale.get ().strip ())
    cap = cap / scale
    ind = ind * scale
    this.vars[this.key['c1']].set (f'{cap:.5e}')
    this.vars[this.key['l1']].set (f'{ind:.5e}')

  def close (this):
    this.save ()
    this.quit ()

  def save (this):
    out = pd.DataFrame.from_dict (this.outputs)
    out.to_csv ('interactive.csv')

  def next (this):
    this.outputs['length'][this.position] = float (this.order[this.position][0])
    this.outputs['width'][this.position] = float (this.order[this.position][1])
    for name in this.names:
      this.outputs[name][this.position] = float (this.vars[this.key[name]].get ().strip ())
    this.position = this.position + 1
    if this.position == len (this.order):
      this.close ()
    this.set (this.position)
    this.update ()

  def previous (this):
    this.position = this.position - 1
    this.set (this.position)
    this.update ()

  def set (this, i):
    length, width = this.order[i]
    subdata = this.data[this.data['length (mm)'] == length]
    subdata = subdata[subdata['width (mm)'] == width]
    print (subdata)
    this.measured_x = subdata['frequency (Hz)'].to_numpy ()
    if this.admittance:
      this.measured_y_magnitude = subdata['admittance (S)'].to_numpy ()
      this.measured_y_phase = subdata['phase (rad)'].to_numpy () * 180.0 / np.pi
    else:
      this.measured_y_magnitude = subdata['impedance (Ohm)'].to_numpy ()
      this.measured_y_phase = subdata['phase (rad)'].to_numpy () * -180.0 / np.pi
    this.scatter_magnitude.set_offsets (np.column_stack ([this.measured_x, this.measured_y_magnitude]))
    this.scatter_phase.set_offsets (np.column_stack ([this.measured_x, this.measured_y_phase]))
    this.title.config (text = f'Position {this.position}: Length ({this.order[0]}) Width ({this.order[1]})')

  def get (this):
    values = list ()
    for v in this.vars:
      s = v.get ().strip ()
      if s in ('', '-', '.', '-.'):
        return None
      try:
        values.append (float (s))
      except ValueError:
        return None
    return tuple (values)

  def update (this):
    params = this.get ()
    if params is None:
      this.status.config (text = 'waiting on valid', fg = 'gray')
      return

    x = np.logspace (0, 4, 1000)
    for i, model in enumerate (this.models):
      p = [params[this.key[name]] for name in model.names]
      if this.admittance:
        magnitude, phase = model.modelY (p, x)
      else:
        magnitude, phase = model.modelZ (p, x)
      this.curves_magnitude[i].set_data (x, magnitude)
      this.curves_phase[i].set_data (x, phase)

    this.ax_magnitude.set_ylim ([min (this.measured_y_magnitude) * 1e-1, 1e1 * max (this.measured_y_magnitude)])
    this.canvas.draw_idle ()
    this.status.config (text = 'OK', fg = 'green')

  def reset (this):
    for i, (name, init) in enumerate (zip (this.names, this.initials)):
      this.vars[this.key[name]].set (str (init))
    this.ax_magnitude.set_xlim ([1e0, 2e4])
    this.ax_magnitude.set_ylim ([min (this.measured_y_magnitude) * 1e-1, 1e1 * max (this.measured_y_magnitude)])
    this.ax_magnitude.set_xscale ('log')
    this.ax_magnitude.set_yscale ('log')
    this.ax_magnitude.minorticks_off ()
    this.ax_phase.set_xlim ([1e0, 2e4])
    this.ax_phase.set_ylim ([-120.0, 120.0])
    this.ax_phase.set_xscale ('log')
    this.ax_phase.set_yticks ([-90,0,90])
    this.ax_phase.set_yticklabels ([-90,0,90])
    this.ax_phase.minorticks_off ()
    this.fig.tight_layout ()
    this.canvas.draw_idle ()

  def quit (this):
    sys.exit (0)

  def optimize (this):
    p = list ()
    for name in this.models[0].names:
      v = float (this.vars[this.key[name]].get ().strip ())
      p.append (v)

    params = None
    if this.optimizer == 'ls':
      func = None
      if this.admittance:
        func = this.models[0].residualsY
      else:
        func = this.models[0].residualsZ
      result = sp.optimize.least_squares (
        func,
        p,
        args = (
          this.measured_x,
          this.measured_y_magnitude,
          this.measured_y_phase
        ),
        bounds = this.models[0].bounds
      )
      params = result.x
    elif this.optimizer == 'cma':
      this.models[0].initializeCMA (this.measured_x, this.measured_y_magnitude, this.measured_y_phase)
      opts = {
        'seed': 0,
        'popsize': 24,
        'maxiter': 3000,
        'bounds': this.models[0].bounds
      }
      func = None
      if this.admittance:
        func = this.models[0].objectiveY
      else:
        func = this.models[0].objectiveZ
      es = cma.CMAEvolutionStrategy (
          this.models[0].initial,
          0.5,
          opts
      )
      result = es.optimize (func)
      params = result.result.xbest
    else:
      print ('invalid optimizer')
      sys.exit ()
    for i, name in enumerate (this.models[0].names):
      this.vars[this.key[name]].set (f'{params[i]:.5e}')

  def randomize (this):
    for i, name in enumerate (this.models[0].names):
      low = this.models[0].bounds[0][i]
      high = this.models[0].bounds[1][i]
      v = np.random.uniform (low, high)
      this.vars[this.key[name]].set (str (v))

def parse_arguments ():
  parser = argparse.ArgumentParser ('')
  parser.add_argument ('filename', help = 'measured data')
  parser.add_argument ('--models', nargs = '+', help = 'model type', default = ['piezo:bimorph:r0,c0,r1,c1,l1'])
  parser.add_argument ('--admittance', help = 'plot admittance', default = False, action = 'store_true')
  parser.add_argument ('--optimizer', help = 'optimizer', default = 'cma')
  return parser.parse_args ()

def main ():
  args = parse_arguments ()
  models = list ()
  for model in args.models:
    m, id, names = model.split (':')
    names = names.split (',')
    if m.lower () == 'rc':
      models.append (circuit.RCModel (id, names))
    elif m.lower () == 'rce':
      models.append (circuit.RCEModel (id, names))
    elif m.lower () == 'prc':
      models.append (circuit.PRCModel (id, names))
    elif m.lower () == 'rcbat':
      models.append (circuit.RCBATModel (id, names))
    elif m.lower () == 'piezo':
      models.append (circuit.PiezoModel (id, names))
    elif m.lower () == 'idealpiezo':
      models.append (circuit.IdealPiezoModel (id, names))
    elif m.lower () == 'r':
      models.append (circuit.RModel (id, names))
    elif m.lower () == 'c':
      models.append (circuit.CModel (id, names))
    elif m.lower () == 'srlc':
      models.append (circuit.SRLCModel (id, names))
    else:
      print ('unknown model given')
      sys.exit (1)
  data = pd.read_csv (args.filename)
  lengths = list (data['length (mm)'].to_numpy ())
  widths = list (data['width (mm)'].to_numpy ())
  comb = list (zip (lengths, widths))
  combinations = list ()
  for c in comb:
    if c not in combinations:
      combinations.append (c)
  try:
    app = App (models, data, args.admittance, combinations, args.optimizer)
    app.mainloop ()
  except Exception as ex:
    print ('error: ', ex, file = sys.stderr)
    raise

if __name__ == '__main__':
  main ()
