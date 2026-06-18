import argparse
import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd
import re
import sys

def parse_arguments ():
  parser = argparse.ArgumentParser ('')
  parser.add_argument (
      'dirname',
      help = 'pzt data dir name'
  )
  parser.add_argument (
      '--v_scale',
      default = 100.0,
      required = False,
      help = 'data voltage scaling'
  )
  parser.add_argument (
      '--c_scale',
      default = 20.0e-3,
      required = False,
      help = 'data current scaling'
  )
  parser.add_argument (
      '--output',
      default = 'summary.csv',
      required = False,
      help = 'output summary'
  )
  return parser.parse_args ()

def magnitude_phase (voltage, current, sampling_f, signal_f):
  fft_voltage = np.fft.fft (voltage)
  fft_current = np.fft.fft (current)
  frequencies = np.fft.fftfreq (
      len (voltage),
      1.0 / sampling_f
  )
  plus_frequencies = frequencies > 0.0
  frequencies = frequencies[plus_frequencies]
  fft_voltage = fft_voltage[plus_frequencies]
  fft_current = fft_current[plus_frequencies]

  idx = np.argmax (np.abs (fft_voltage))
  # idx = min (enumerate (frequencies), key = lambda x: abs (signal_f - x[1]))[0]
  peak_phase_voltage = np.angle (fft_voltage[idx])
  peak_phase_current = np.angle (fft_current[idx])
  print ('peak voltage: %.2f Hz, expected: %.2f Hz' % (frequencies[idx], signal_f))
  print ('%.2f phase: v (%.2f) c (%.2f)' % (frequencies[idx], peak_phase_voltage, peak_phase_current))

  peak_phase_diff = peak_phase_voltage - peak_phase_current
  peak_phase_diff = np.arctan2 (np.sin (peak_phase_diff), np.cos (peak_phase_diff))

  peak_magnitude_voltage = np.abs (fft_voltage[idx])
  peak_magnitude_current = np.abs (fft_current[idx])
  impedance_magnitude = peak_magnitude_voltage / peak_magnitude_current
  admittance_magnitude = peak_magnitude_current / peak_magnitude_voltage

  magnitude_voltage = np.abs (fft_voltage)
  magnitude_current = np.abs (fft_current)
  phase_voltage = np.angle (fft_voltage)
  phase_current = np.angle (fft_current)

  fig, ax = plt.subplots (figsize = (12, 8))
  ax.plot (frequencies, magnitude_voltage, label = 'Voltage Signal')
  ax.plot (frequencies, magnitude_current, label = 'Current Signal')
  ax.set_title (f'{signal_f} Hz fft')
  ax.set_xlabel ('frequency (Hz)')
  ax.set_ylabel ('magnitude (Ohms)')
  ax.legend ()
  ax.set_yscale ('log')
  ax.grid (True)

  '''
  fig, ax = plt.subplots (figsize = (12, 8))
  ax.plot (frequencies, phase_voltage, label = 'Voltage Signal')
  ax.plot (frequencies, phase_current, label = 'Current Signal')
  ax.set_title (f'{signal_f} Hz fft')
  ax.set_xlabel ('frequency (Hz)')
  ax.set_ylabel ('phase (degrees)')
  ax.legend ()
  ax.grid (True)
  '''

  return admittance_magnitude, impedance_magnitude, peak_phase_diff

def pstring_to_decimal (string):
  high, low = string.split ('p')
  return int (high) + (int (low) / (10.0 ** int (len (low))))

def main ():
  args = parse_arguments ()
  headers = [
    'time (s)',
    'bias (v)',
    'signal (v)',
    'bias (i)',
    'signal (i)',
  ]
  output = {
    'width (mm)': [],
    'length (mm)': [],
    'frequency (Hz)': [],
    'admittance (S)': [],
    'impedance (Ohm)': [],
    'phase (rad)': []
  }

  filenames = os.listdir (args.dirname)
  pattern = r'(?P<width>[\dp]+)Width_(?P<length>[\dp]+)Length_(?P<signal>[\dp]+)Vpp_(?P<bias>[\dp]+)Bias_(?P<frequency>[\dp]+)Hz.csv' 
  valid_filenames = list ()
  for filename in filenames:
    m = re.match (pattern, filename)
    if m is None:
      continue
    valid_filenames.append ((
      pstring_to_decimal (m.group ('frequency')),
      m,
      filename
    ))
  valid_filenames = sorted (valid_filenames, key = lambda x: x[0])

  for _, m, filename in valid_filenames: 
    print ('parsing', filename)
    width = pstring_to_decimal (m.group ('width'))
    length = pstring_to_decimal (m.group ('length'))
    signal = pstring_to_decimal (m.group ('signal'))
    bias = pstring_to_decimal (m.group ('bias'))
    frequency = pstring_to_decimal (m.group ('frequency'))
    filename = os.path.join (args.dirname, filename) 
    data = pd.read_csv (filename, header = None, names = headers)

    # scale
    data['signal (v)'] = data['signal (v)'] * float (args.v_scale)
    data['bias (v)'] = data['bias (v)'] * float (args.v_scale)
    data['signal (i)'] = data['signal (i)'] * float (args.c_scale)
    data['bias (i)'] = data['bias (i)'] * float (args.c_scale)

    # partition
    timescale = data['time (s)'].iloc[1]
    ramp_period = 0.05
    ramp_samples = int (ramp_period / timescale)
    time = data['time (s)'].to_numpy (dtype = float)[ramp_samples:]
    signal_v = data['signal (v)'].to_numpy (dtype = float)[ramp_samples:]
    bias_v = data['bias (v)'].to_numpy (dtype = float)[ramp_samples:]
    signal_i = data['signal (i)'].to_numpy (dtype = float)[ramp_samples:]
    bias_i = data['bias (i)'].to_numpy (dtype = float)[ramp_samples:]

    # plot samples
    wave_period = 1.0 / frequency
    samples_per_wave = int (wave_period / timescale)
    samples = samples_per_wave * 2

    # plot
    fig, axes = plt.subplots (ncols = 2, figsize = (12, 8))
    ax = axes[0]
    ax.plot (time[:samples], signal_v[:samples], label = 'signal (v)', color = 'black')
    ax.set_xlabel ('time (s)')
    ax.set_ylabel ('voltage (v)')
    ax = axes[1]
    ax.plot (time[:samples], signal_i[:samples], label = 'signal (i)', color = 'black')
    ax.set_xlabel ('time (s)')
    ax.set_ylabel ('current (i)')
    fig.suptitle (f'{frequency} Hz signal')

    '''
    fig, axes = plt.subplots (ncols = 2, figsize = (12, 8))
    ax = axes[0]
    ax.plot (time[:samples], bias_v[:samples], label = 'bias (v)', color = 'black')
    ax.set_xlabel ('time (s)')
    ax.set_ylabel ('voltage (v)')
    ax = axes[1]
    ax.plot (time[:samples], bias_i[:samples], label = 'bias (i)', color = 'black')
    ax.set_xlabel ('time (s)')
    ax.set_ylabel ('current (i)')
    fig.suptitle (f'{frequency} Hz bias')
    '''

    # magnitude and phase
    admittance, impedance, phase = magnitude_phase (
        signal_v,
        signal_i,
        1.0 / timescale,
        frequency
    )
    phase = phase * 180.0 / np.pi
    print ('frequency (%.2e) Hz, admittance (%.2e) S, impedance (%.2e) Ohm, phase (%.2f) rad' % (frequency, admittance, impedance, phase))

    output['width (mm)'].append (width)
    output['length (mm)'].append (length)
    output['frequency (Hz)'].append (frequency)
    output['admittance (S)'].append (admittance)
    output['impedance (Ohm)'].append (impedance)
    output['phase (rad)'].append (phase)
    
  df = pd.DataFrame.from_dict (output)
  df.to_csv (args.output)
  plt.show ()

if __name__ == '__main__':
  main ()
