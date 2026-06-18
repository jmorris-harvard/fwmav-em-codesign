import numpy as np
import pandas as pd
import time
import sys
import math 
import matplotlib.pyplot as plt

def combine (vhigh, vlow, chigh, clow):
  vdata = []
  cdata = []
  for vh, vl, ch, cl in zip (vhigh, vlow, chigh, clow):
    v = (int (vh) << 8) | int (vl)
    c = (int (ch) << 8) | int (cl)
    if not v & 0x8000:
      continue # invalid sample
    v &= 0x7FFF # remove valid bit
    if c & 0x8000: # twos complement
      c = c - 0x10000
    vdata.append (v)
    cdata.append (c)
  return vdata, cdata

def lcm (a, b, limit = 1000):
  A, B = a, b
  cnt = 1
  while cnt < limit:
    if A == B:
      break
    elif A < B: 
      A = A + a
    else:
      B = B + b
      cnt = cnt + 1
  return A == B, cnt

class SignalGenerator ():
  SampleLimit = 1024
  VoltageMax = 5.0
  VoltageMin = 0.0

  CoreFrequency = int (50.0e6)

  class Configuration ():
    def __init__ (this, nsamples, timer, data):
      this.nsamples = nsamples
      this.timer = timer
      this.data = data

  def __init__ (this, dev):
    this.dev = dev
    this.config = SignalGenerator.Configuration (0, 0, [])
    this.data = []
    this.time = []
    this.running = False

  def configure (this, nsamples, freq, ampl, offset):
    if nsamples > SignalGenerator.SampleLimit:
      print ('too many samples to program (%d)' % (nsamples))
      sys.exit (1)

    if ampl <= 0.0:
      print ('non positive amplitude not allowed (%d)' % (ampl))
      sys.exit (1)

    if offset + ampl > SignalGenerator.VoltageMax:
      print ('requested voltage too high (%.2f)' % (offset + ampl))
      sys.exit (1)

    if offset - ampl < SignalGenerator.VoltageMin:
      print ('requested voltage too low (%.2f)' % (offset - ampl))
      sys.exit (1)

    timer = float (SignalGenerator.CoreFrequency) / (float (nsamples) * float (freq))
    if not timer.is_integer ():
      print ('output rate (%.2f) must divide into core frequency (%.2f)' % \
          (float (nsamples * freq), SignalGenerator.CoreFrequency))
      sys.exit (1)
    timestep = timer / float (SignalGenerator.CoreFrequency)
    timer = int (timer)
    t = [timestep * float (n) for n in range (nsamples)]

    pktopk = SignalGenerator.VoltageMax - SignalGenerator.VoltageMin
    nampl = ampl / pktopk
    noffset = offset / pktopk
    bit12 = int (2.0 ** 12.0)

    X = np.linspace (0.0, 2.0 * np.pi, nsamples)
    Y = []
    Yb = []
    for x in X:
      sine = np.sin (x) * nampl
      sine = sine + noffset
      Y.append (sine * pktopk)
      Yb.append (int (sine * bit12))

    this.config.nsamples = nsamples
    this.config.timer = timer
    this.config.data = Yb
    this.time = t 
    this.data = Y

  def display (this, binary = False): 
    fig, ax = plt.subplots ()
    x = []
    y = []
    Y = this.config.data if binary else this.data
    for i in range (1, len (this.time)):
      x.append (this.time[i-1])
      x.append (this.time[i])
      y.append (Y[i-1])
      y.append (Y[i-1])
    x.append (this.time[-1])
    x.append (this.time[-1])
    y.append (Y[-1])
    y.append (Y[-1])
    ax.plot (x, y)
    ax.grid ()
    if binary:
      ax.set_ylim ([0, (2.0 ** 12)])
    ax.set_ylabel ('Voltage')
    ax.set_xlabel ('Time')
    plt.show ()

  def start (this):
    if this.running:
      this.stop ()
      time.sleep (0.1)
    this.dev.setWire (0x01, 0x00)
    this.dev.setWire (0x02, this.config.timer)
    this.dev.setWire (0x04, this.config.nsamples - 1)
    for data in this.config.data:
      this.dev.setWire (0x03, data)
      this.dev.setTrigger (0x40, 0x0)
    this.dev.setTrigger (0x40, 0x1)
    this.running = True

  def stop (this):
    if this.running:
      this.dev.setTrigger (0x40, 0x1)
    this.running = False

  def __del__ (this):
    this.stop ()

  def __str__ (this):
    out = 'generator configuration:\n' + \
          '\tnsamples: ' + str (this.config.nsamples) + '\n' + \
          '\ttimer: ' + str (this.config.timer) + '\n' + \
          '\tdata: ' + str (this.config.data)
    return out
    
class CurrentGenerator ():
  SampleLimit = 1024
  CurrentMax = 250.0e-6
  CurrentMin = -250.0e-6

  CoreFrequency = int (50.0e6)
  BinaryOffset = (2.0 ** 11.0)

  class Configuration ():
    def __init__ (this, nsamples, timer, data):
      this.nsamples = nsamples
      this.timer = timer
      this.data = data

  def __init__ (this, dev):
    this.dev = dev
    this.config = SignalGenerator.Configuration (0, 0, [])
    this.data = []
    this.time = []
    this.running = False

  def configure (this, nsamples, freq, ampl, offset):
    if nsamples > CurrentGenerator.SampleLimit:
      print ('too many samples to program (%d)' % (nsamples))
      sys.exit (1)

    if ampl <= 0.0:
      print ('non positive amplitude not allowed (%d)' % (ampl))
      sys.exit (1)

    if offset + ampl > CurrentGenerator.CurrentMax:
      print ('requested current too high (%.2f)' % (offset + ampl))
      sys.exit (1)

    if offset - ampl < CurrentGenerator.CurrentMin:
      print ('requested current too low (%.2f)' % (offset - ampl))
      sys.exit (1)

    timer = float (CurrentGenerator.CoreFrequency) / (float (nsamples) * float (freq))
    if not timer.is_integer ():
      print ('output rate (%.2f) must divide into core frequency (%.2f)' % \
          (float (nsamples * freq), CurrentGenerator.CoreFrequency))
      sys.exit (1)
    timestep = timer / float (CurrentGenerator.CoreFrequency)
    timer = int (timer)
    t = [timestep * float (n) for n in range (nsamples)]

    pktopk = CurrentGenerator.CurrentMax - CurrentGenerator.CurrentMin
    nampl = ampl / pktopk
    noffset = offset / pktopk
    bit12 = int (2.0 ** 12.0)

    X = np.linspace (0.0, 2.0 * np.pi, nsamples)
    Y = []
    Yb = []
    for x in X:
      sine = np.sin (x) * nampl
      sine = sine + noffset
      Y.append (sine * pktopk)
      Yb.append (int (sine * bit12 + CurrentGenerator.BinaryOffset))

    this.config.nsamples = nsamples
    this.config.timer = timer
    this.config.data = Yb
    this.time = t 
    this.data = Y

  def display (this, binary = False): 
    fig, ax = plt.subplots ()
    x = []
    y = []
    Y = this.config.data if binary else this.data
    for i in range (1, len (this.time)):
      x.append (this.time[i-1])
      x.append (this.time[i])
      y.append (Y[i-1])
      y.append (Y[i-1])
    x.append (this.time[-1])
    x.append (this.time[-1])
    y.append (Y[-1])
    y.append (Y[-1])
    ax.plot (x, y)
    ax.grid ()
    if binary:
      ax.set_ylim ([0, (2.0 ** 12)])
    ax.set_ylabel ('Current')
    ax.set_xlabel ('Time')
    plt.show ()

  def start (this):
    if this.running:
      this.stop ()
      time.sleep (0.1)
    this.dev.setWire (0x01, 0x17)
    this.dev.setWire (0x02, this.config.timer)
    this.dev.setWire (0x04, this.config.nsamples - 1)
    for data in this.config.data:
      this.dev.setWire (0x03, data)
      this.dev.setTrigger (0x40, 0x0)
    this.dev.setTrigger (0x40, 0x1)
    this.running = True

  def stop (this):
    if this.running:
      this.dev.setTrigger (0x40, 0x1)
    this.running = False

  def __del__ (this):
    this.stop ()

  def __str__ (this):
    out = 'current generator configuration:\n' + \
          '\tnsamples: ' + str (this.config.nsamples) + '\n' + \
          '\ttimer: ' + str (this.config.timer) + '\n' + \
          '\tdata: ' + str (this.config.data)
    return out

class SignalRecorder ():
  ShuntMultiplier = 819.2e6

  CoreFrequency = int (50.0e6)
  DelayLimit = 150e-6

  VLSB = 0.003125

  ShuntR = 10.0

  DefaultBufferSize = 1024

  SamplesMinimum = 4

  CalibrationMultiplier = 1.0 # 1.565

  class Configuration ():
    def __init__ (this, shunt, timer, sweep, step, samples):
      this.shunt = shunt
      this.timer = timer
      this.phase = 0x1 if sweep else 0x0
      this.sweep = sweep
      this.step = step
      this.samples = samples
      this.running = False

  def __init__ (this, dev):
    this.dev = dev
    this.CLSB = 0.0
    this.running = False
    this.config = SignalRecorder.Configuration (0, 0, 0, 0, 0)

  def configure (this, cmax, fs, ft, r = None, waves = 1, split = 25):
    r = r if r is not None else SignalRecorder.ShuntR
    clsb = cmax / (2.0 ** 15.0)
    shunt = int (819.2e6 * clsb * r)

    timer = float (SignalRecorder.CoreFrequency) / fs
    if not timer.is_integer ():
      print ('sampling rate (%.2f) is not possible with core frequency (%.2f)' % (fs, SignalRecorder.CoreFrequency))
      sys.exit (1)

    timer = int (timer - (3 * (152 + 2) - 1))
    limit = int (SignalRecorder.CoreFrequency * SignalRecorder.DelayLimit)
    if timer < limit:
      print ('delay (%d) cycles is too short (compared to limit (%d))' % (timer, limit))
      sys.exit (1) 

    success, samples = lcm (fs, ft)
    if not success:
      print ('could not align frequencies (%.2f) and (%.2f)' % (fs, ft))
      sys.exit (1)
    if samples == 0:
      samples = 1
    while samples < SignalRecorder.SamplesMinimum:
      samples = samples * 2

    sweep = int (split * waves)
    divisions = int (SignalRecorder.CoreFrequency / ft)
    step = int (divisions / split)

    this.CLSB = clsb
    this.shift = int (SignalRecorder.CoreFrequency / step)
    this.config = SignalRecorder.Configuration (shunt, timer, sweep, step, samples)

  def start (this):
    if this.running:
      this.stop ()
      time.sleep (0.1)
    this.dev.setWire (0x05, (this.config.shunt << 1) | this.config.phase << 16)
    this.dev.setWire (0x06, 0x1)
    this.dev.setWire (0x07, this.config.timer)
    this.dev.setWire (0x08, this.config.sweep)
    this.dev.setWire (0x09, this.config.step)
    this.dev.setWire (0x0a, this.config.samples)
    this.dev.setTrigger (0x40, 0x2)
    this.running = True

  def read (this, bufsize = None):
    # shunt voltage is 50us offset from bus voltage
    if not this.running:
      print ('device not running')
      sys.exit (1)
    c, v = [], []
    if this.config.phase:
      total = this.config.sweep * this.config.samples
      last = 0
      print ('reading %d samples (phase mode)' % (total))
      while len (v) < total:
        data = this.dev.readBuffer (0xA0, 4 * total)
        time.sleep (0.5)
        clow = data[0::4]
        chigh = data[1::4]
        vlow = data[2::4]
        vhigh = data[3::4]
        voltages, currents = combine (vhigh, vlow, chigh, clow)
        v.extend (list (np.array (voltages, dtype = np.float64) * SignalRecorder.VLSB))
        c.extend (list (np.array (currents, dtype = np.float64) * this.CLSB))
        if len (v) != len (c):
          print ('values not the same length, impossible')
          sys.exit (1)
        if len (v) > last:
          last = len (v)
          print ('got %d samples' % (last))
    else:
      buf = SignalRecorder.DefaultBufferSize if bufsize is None else bufsize
      print ('reading %d samples' % (buf))
      data = this.dev.readBuffer (0xA0, buf)
      clow = data[0::4]
      chigh = data[1::4]
      vlow = data[2::4]
      vhigh = data[3::4]
      voltages, currents = combine (vhigh, vlow, chigh, clow)
      v.extend (list (np.array (voltages, dtype = np.float64) * SignalRecorder.VLSB))
      c.extend (list (np.array (currents, dtype = np.float64) * this.CLSB))
      if len (v) != len (c):
        print ('values not the same length, impossible')
        sys.exit (1)
    mc = np.mean (c)
    c = (np.array (c) - mc) * SignalRecorder.CalibrationMultiplier + mc
    mv = np.mean (v)
    v = (np.array (v) - mv) * SignalRecorder.CalibrationMultiplier + mv
    return c, v

  def stop (this):
    if this.running:
      this.dev.setTrigger (0x40, 0x2)
    this.running = False

  def __del__ (this):
    this.stop ()

  def __str__ (this):
    out = 'recorder configuration:\n' + \
          '\tshunt: ' + str (this.config.shunt) + '\n' + \
          '\ttimer: ' + str (this.config.timer) + '\n' + \
          '\tsweep: ' + str (this.config.sweep) + '\n' + \
          '\tstep: ' + str (this.config.step) + '\n' + \
          '\tsample: ' + str (this.config.samples)
    return out

def write_data (c, v, phase = False, sweep = 0, samples = 0, tag = None):
  sv = dict ()
  sc = dict ()
  if phase:
    for i in range (sweep):
      sv['%d' % (i)] = v[i * samples:(i + 1) * samples]
      sc['%d' % (i)] = c[i * samples:(i + 1) * samples]
  else:
    sv[0] = v
    sc[0] = c
  dfv = pd.DataFrame.from_dict (sv)
  dfc = pd.DataFrame.from_dict (sc)
  nv = 'sv'
  nc = 'sc'
  if tag is not None:
    nv = nv + '_' + tag
    nc = nc + '_' + tag
  nv = nv + '.csv'
  nc = nc + '.csv'
  dfv.to_csv (nv)
  dfc.to_csv (nc)

def eis (dev, verbose = False):
  frequencies = [
    1.0,
    2.0,
    4.0,
    5.0,
    8.0,
    10.0,
    20.0,
    40.0,
    50.0,
    80.0,
    100.0,
    200.0,
    400.0,
    500.0,
    800.0,
    1000.0,
    2000.0,
    4000.0,
    5000.0,
    8000.0,
    10000.0
  ]
  trials = 1
  for t in range (trials):
    for frequency in frequencies:
      dev.setWire (0x0, 0x100)
      time.sleep (0.1)  
      dev.setWire (0x0, 0x000)

      print ('running %d...' % (frequency))
      sg = SignalGenerator (dev)
      # sg = CurrentGenerator (dev)
      stimsamplies = None
      if frequency < 10.0:
        stimsamples = 500
      elif frequency < 100.0:
        stimsamples = 100 
      elif frequency < 1000.0:
        stimsamples = 50
      else:
        stimsamples = 25
      sg.configure (stimsamples, frequency, 0.2, 4.1)
      # sg.configure (stimsamples, frequency, 200.0e-6, 0.0)
      # sg.display (binary = True)
      print (str (sg))

      sr = SignalRecorder (dev)
      sampling = None
      sleept = None
      if frequency < 10.0:
        sleept = 400
        sampling = 1.0
      elif frequency < 100.0:
        sleept = 200
        sampling = 10.0
      elif frequency < 1000.0:
        sleept = 100
        sampling = 100.0
      else:
        sleept = 20
        sampling = 1000.0 
      sr.configure (15e-3, sampling, frequency, split = 32, waves = 3)
      print (str (sr))

      sg.start ()
      time.sleep (0.1)
      sr.start ()
      print ('sleep for %d seconds' % (sleept))
      time.sleep (sleept)
      c, v = sr.read ()
      sg.stop ()
      sr.stop ()
      write_data (c, v, phase = sr.config.phase, sweep = sr.config.sweep, samples = sr.config.samples, tag = 'S%d_T%d_P%d_R%d' % (int (sampling), int (frequency), int (sr.shift), t))
      print ()

