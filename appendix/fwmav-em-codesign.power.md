# Implementation of Power Electronics Section

This document explains how the Python modules `charge_pump.py` and `tapped_boost.py` implement the **Power Electronics** section from the electromechanical co-design framework paper. The paper describes two complementary converter topologies for generating high-voltage outputs from a low-voltage battery.

---

## Overview: Power Converter Architecture

The paper's co-design framework evaluates two distinct power conversion strategies:

```
[Li-Ion Battery: 3.7 V]
         ↓
    [Choice of Converter Type]
         ├─→ [Tapped-Inductor Boost] ← High efficiency, high mass
         │        ↓
         │   [Output: V_PZT ≈ 60-70 V]
         │
         └─→ [Capacitive Charge Pump] ← Lower efficiency, lower mass
                  ↓
              [Output: V_PZT ≈ 60-70 V]
```

The framework addresses **trade-offs between mass and efficiency** in power electronics, a critical constraint for insect-scale FWMAVs with stringent SWaP (Size, Weight, and Power) budgets.

---

## Part (a): Tapped-Inductor Boost Converter (`tapped_boost.py`)

The paper describes the boost converter topology from Vazquez et al. (2007), which provides **high gain** and **compact size** for generating peak voltages $V_{PZT}$ from the $\approx 3.7$ V nominal battery voltage.

### Circuit Components and Parameters

The paper specifies discrete component parasitics:

```python
def run(
    cvoltage = 3.3,        # Battery voltage
    ccount = 1,            # Number of cells in series
    cresistance = 5.0,     # Cell internal resistance (mΩ)
    rsource = 10.0,        # Source parasitic resistance (mΩ)
    irsource = 1.0,        # Inductor equivalent series resistance (Ω)
    inductance = 3.3e-3,   # Primary inductance (H)
    tratio = 6.0,          # Transformer turns ratio
    kcoupling = 1.0,       # Coupling coefficient (ideally 1.0)
    cparasiticl = 500e-12, # Primary-side parasitic capacitance
    cparasitich = 500e-12, # Secondary-side parasitic capacitance
    ontime = 10.0e-6,      # Switch on-time (μs)
    switchtime = 5.0e-9,   # Switch transition time (ns)
    ovoltage = 10.0,       # Output voltage (V)
    duty = None,           # Duty cycle (computed)
    rout = 15.0e3,         # Load resistance (Ω)
):
```

These parameters correspond to Table 1 in the paper:
- $V_B$ — `cvoltage` × `ccount`: Battery voltage
- $E_{PZT}$ induces `ovoltage` requirement for the piezoelectric load
- $L_P$ — `inductance`: Primary inductance  
- $D$ — `duty`: Drive clock duty cycle

### Inductor Dynamics

The converter operates in **discontinuous conduction mode** (DCM), where inductor current returns to zero before each switching cycle. The paper notes this reduces resistive losses in low-power applications.

The inductor current during the "on" phase evolves as:

$$i(t) = \frac{V_B - i_{avg} R_{source}}{L} (1 - e^{-t/\tau})$$

where $\tau = \frac{L}{R_{source} + R_L}$ is the inductor time constant. The implementation models this with exponential functions:

```python
def iavg(...):
    # Compute average inductor current during steady-state operation
    tau = Boost.tau(rsource, irsource, inductance)
    offtime, period = Boost.offtime(ontime, duty)
    # ... complex formula accounting for energy balance
    return i, tau, offtime, period, minductance
```

**Peak current** during the on-phase:

```python
def ipeak(...):
    tau = Boost.tau(rsource, irsource, inductance)
    fx = 1.0 - np.exp(-1.0 * ontime / tau)
    return ((cvoltage * ccount - iavg * cresistance) * fx) / (rsource + irsource)
```

This implements the exponential rise: $I_{peak} = \frac{V_B - I_{avg}R_{cell}}{R_{source}} (1 - e^{-t_{on}/\tau})$

### Secondary Current and Voltage Relationship

The coupled inductor has a tapped secondary winding to achieve the voltage multiplication. The paper models the turns ratio $T$ (transformer turns ratio):

```python
def isecondary(...):
    ipeak = Boost.ipeak(...)
    minductance = Boost.minductance(inductance, tratio)
    return ipeak * np.sqrt((kcoupling * inductance) / minductance)
```

where $m_{inductance} = L_P \cdot (T^2 + 1)$ is the effective inductance reflected to primary, and the secondary current relates to primary current through the turns ratio and coupling coefficient.

### Energy Balance and Loss Mechanisms

The paper describes energy dissipation in five mechanisms, all implemented in the `run()` method:

**1. Inductor core losses:**
```python
def ecore(...):
    Bmax = 0.3  # Maximum flux density
    B = Bmax * (ipeak / imax)
    f = 2.0 / (ontime / duty)  # Switching frequency
    k = 4.855e-8  # Material-dependent constant
    m, n = 2.74, 1.64  # Exponents (beta, alpha)
    return k * (B ** m) * (f ** n) * imass * (ontime / duty)
```

This implements Steinmetz equation for core loss in magnetic materials.

**2. Energy stored in inductor:**
```python
def einductor(...):
    ipeak = Boost.ipeak(...)
    return (kcoupling * inductance * ipeak * ipeak) / 2.0
```

Energy stored when inductor current is maximum: $E_L = \frac{1}{2}L I_{peak}^2$

**3. Parasitic capacitor charging:**
```python
def ecapacitor(...):
    ech = (cparasitich * ovoltage * ovoltage) / 2.0
    lovoltage = ovoltage / (tratio + 1.0)
    ecl = (cparasiticl * lovoltage * lovoltage) / 2.0
    return ech + ecl
```

Energy stored in parasitic capacitances during switching transients.

**4. Resistive losses:**
```python
def eresistor(...):
    # Power dissipated in source, primary, and secondary resistances
    return (idischarge * isecondary * isecondary * (rsource + rsecondary)) / 3.0
```

**5. Switch losses:**
```python
def eswitch(...):
    ipeak = Boost.ipeak(...)
    voltage = ovoltage / (tratio + 1.0)
    return (ipeak * voltage * switchtime) / 6.0
```

The paper specifies using the DMN6140L nFET with 2.7 ns transition time, which this accounts for.

### Converter Efficiency

The net energy balance per cycle determines if the converter can produce the desired output voltage:

```python
return (einductor - ecapacitor + einputoutput - eresistor - eoutput - eswitch - ecore, ...)
```

A zero return value indicates the design meets the steady-state requirement. The solver adjusts `ontime` or `duty` to achieve this.

### Component Mass

The paper includes realistic mass estimates from discrete components:

```python
def weight(inductance, ipeak, imass=None):
    # Inductor core
    perm = 2000.0  # Permeability
    k = 1.25e-6
    fluxdensity = 0.3
    fdensity = 4.9e6  # Ferrite density
    
    length = (perm * k * ipeak) / fluxdensity
    A = (inductance * length) / (perm * k)
    volume = A * length
    mass = volume * fdensity
    
    # Discrete components (from datasheets)
    mass += 3.0e-3   # Input capacitor (0201)
    mass += 7.2e-3   # Switch (SOT-23)
    mass += 10e-3    # Diodes
    mass += 6.0e-3   # Output capacitor (0402)
    mass += 2.0 * 1.0e-3  # Feedback resistors (0201)
    
    # PCB (polyimide + copper)
    pidensity = 1.37e6  # kg/m³
    cdensity = 8.85e6   # kg/m³
    pit = 50e-6         # Polyimide thickness
    ct = 18e-6          # Copper thickness
    pcb_area = 20.0e-3 * 10e-3
    
    mass += pidensity * pit * pcb_area
    mass += cdensity * ct * pcb_area
    
    return mass
```

The inductor dominates the boost converter mass due to the high flux density required at low switching frequencies (typically 20-100 kHz for this application).

---

## Part (b): Capacitive Charge Pump Integrated On-Chip (`charge_pump.py`)

The paper presents a **Hybrid Dickson-Cockcroft-Walton** charge pump as a lightweight alternative to inductor-based designs. Charge pumps trade efficiency for reduced mass by using capacitors instead of inductors.

### Charge Pump Topology and Parameters

The charge pump architecture is parameterized by:

```python
def run(
    cvoltage = 3.3,        # Cell voltage (V)
    ccount = 1,            # Number of cells
    cresistance = 5.0,     # Cell internal resistance (mΩ)
    rsource = 10.0,        # Source resistance (Ω)
    N = 1,                 # Number of pump stages (multiplication factor)
    M = 1,                 # Parallelism degree (branch count)
    pcapacitance = 25.0e-12,  # Single stage capacitance (pF)
    frequency = 10.0e6,    # Clock frequency (Hz)
    vdiode = 0.5,          # Diode forward voltage (V)
    kparasitic = 0.01,     # Parasitic capacitance ratio
    rout = 100.0e3,        # Load resistance (Ω)
    ovoltage = 200.0,      # Output voltage (V)
):
```

These parameters correspond to Table 1 inputs:
- $N_P$ — `N`: Charge pump stages (number of cascaded stages)
- $M_P$ — `M`: Charge pump parallelism degree (multiple branches for higher current)
- $F_P$ — `frequency`: Electronics input clock speed
- $C_P$ — `pcapacitance`: Single stage capacitance

### Unloaded Output Voltage

The paper describes the output voltage with $N$ stages and $M$ parallel branches:

$$V_o = V_B + M_P \sum_{i=1}^{N_P/M_P} \prod_{j=1}^{i} \frac{V_B(N_P/M_P - j + 1)}{1 + \alpha_P}$$

where $\alpha_P$ is the ratio of true device capacitance to parasitic capacitance. The implementation computes this recursively:

```python
def vout(...):
    ivoltage = ChargePump.ivoltage(...)  # Input voltage
    vacc = 0.0
    multi = 1.0 / (1.0 + kparasitic)
    
    # Sum over stages
    for i in range(1, int(N/M) + 1):
        vadd = ivoltage
        # Product for this stage
        for j in range(1, i + 1):
            vadd = vadd * multi
        vacc = vacc + vadd
    
    return ivoltage + M * vacc - (N + 1.0) * vdiode
```

Each stage multiplies the voltage by a factor that accounts for parasitic loading, then diodes drop voltage by `vdiode` each.

### Output Resistance (Equivalent Impedance)

As a key result, the charge pump exhibits an output resistance:

$$R_o = \frac{M_P}{F_P C_P} \sum_{i=1}^{N_P/M_P} \sum_{j=1}^{i} \frac{N_P/M_P - j + 1}{1 + \alpha_P}$$

This is implemented as:

```python
def oresistance(N, M, pcapacitance, kparasitic, frequency):
    racc = 0.0
    multi = 1.0 / (1.0 + kparasitic)
    
    for i in range(1, int(N/M) + 1):
        for j in range(1, i + 1):
            racc = racc + ((N / M) - j + 1.0) * multi
    
    return (M * racc) / (frequency * pcapacitance)
```

Higher stages and higher frequencies reduce output impedance. The paper notes this is a fundamental trade-off: more stages increase voltage multiplication but increase output impedance, reducing current delivery capability.

### Input Current (Charge/Discharge Current)

The charge pump draws input current to supply the output load:

$$I_{in} = \frac{(N_P+1)V_{out}}{R_{out}} + 2 N_P C_P \alpha_P f V_{in}$$

where the first term is the DC load current and the second term is the AC charge/discharge current.

```python
def cinput(cvoltage, ccount, cresistance, N, pcapacitance, ...):
    ivoltage = ChargePump.ivoltage(...)
    return (N + 1.0) * ovoltage / rout + 2.0 * N * pcapacitance * kparasitic * frequency * ivoltage
```

### Solver: Finding Optimal Capacitance

The paper requires designing the charge pump to meet a target output voltage with minimum capacitance (minimizing mass). The implementation solves for capacitance using `scipy.optimize.fsolve`:

```python
def solvec(cvoltage, ccount, ..., N, M, ..., ovoltage):
    def func(x):
        return ChargePump.run(
            ...,
            pcapacitance = x,  # Solve for optimal capacitance
            ...
        )
    
    result, info, ier, mesg = opt.fsolve(func, x0=[1.0e-9], full_output=True)
    pcapacitance = result[0]
    
    if ier != 1:
        return False, None, None, None, info
    
    # Return success and computed values
    return True, pcapacitance, cinput(...), ivoltage(...), info
```

The solver iteratively adjusts `pcapacitance` until `run()` returns zero (meeting the output voltage specification).

### Unit Capacitance Density

The paper accounts for on-chip capacitor area scaling. Different voltage ratings require different unit capacitance:

```python
UnitCapacitanceTable = (
    (5, 7.0E-15 / (1.0E-6 ** 2.0)),      # 5V rating
    (10, 3.0E-15 / (1.0E-6 ** 2.0)),     # 10V rating
    (30, 43.3E-15 / (11.04E-6 * 4.48E-6)),  # 30V rating
    (60, 41.8E-15 / (10.8E-6 * 4.48E-6)),   # 60V rating
)
```

Higher output voltages require thicker dielectrics, reducing capacitance per unit area. The solver selects the appropriate unit capacitance based on target output voltage.

### Charge Pump Mass Calculation

Unlike the boost converter with discrete components, the charge pump integrates onto silicon. Mass is computed from capacitor area:

```python
def weight(cvoltage, ccount, N, M, pcapacitance, process):
    # Select unit capacitance based on voltage rating
    unitCap = ChargePump.UnitCapacitanceTable[-1][1]
    for v, unit in ChargePump.UnitCapacitanceTable:
        if cvoltage * ccount * M < v:
            unitCap = unit
            break
    
    # Total capacitor area needed
    totalArea = (pcapacitance * N * 2.0) / unitCap
    sideLength = np.sqrt(totalArea)
    
    # Die mass (silicon density ≈ 2.33e3 kg/m³)
    mass = XT018.mass(sideLength, sideLength)  # Process-specific mass calculation
    
    # Add interconnect layers (polyimide + copper)
    pidensity = 1.37e6  # kg/m³
    cdensity = 8.85e6   # kg/m³
    pit = 50e-6         # Polyimide thickness
    ct = 18e-6          # Copper thickness
    
    mass += pidensity * pit * totalArea
    mass += cdensity * ct * totalArea
    
    return mass, totalArea
```

The charge pump mass is dominated by capacitor area, which scales with $N_P \cdot C_P$. Larger capacitances or more stages increase area but reduce output impedance.

### Design Sweep and Optimization

The paper's Step 3 (Converter Design) uses this module to find the optimal charge pump configuration:

```python
def main_judge():
    # Starting design point
    N = int(ovoltage / (ccount * cvoltage))
    N = N - int(N % M) + M
    
    while True:
        # Solve for optimal capacitance for this N, M
        success, pcapacitance, cinput, ivoltage, info = solvec(...)
        
        if success:
            # Design is feasible
            # Check if improved (smaller capacitance)
            if current is None or current > pcapacitance * N:
                current = pcapacitance * N
                pcap = pcapacitance
            else:
                break  # Stopped improving
        elif ivoltage < 0.0:
            break  # Voltage no longer achievable
        
        # Try next stage count
        N = N + M
```

This systematically increases stage count ($N_P$) until the design begins to degrade, finding the optimal balance between capacitance and output impedance.

---

## Design Flow: Selecting Between Converter Types

Both converters implement the same input-output relationship:

$$V_{out} = V_B + I_{out} R_{out} + V_{drops}$$

where:
- Boost converter: $R_{out}$ comes from inductor resistance and core losses
- Charge pump: $R_{out}$ comes from capacitive charge-transfer impedance

The paper's framework evaluates both and selects the design with lower mass while meeting efficiency and voltage requirements.

### Efficiency Comparison

**Tapped-Inductor Boost:**
- Efficiency ≈ 80-90% (high)
- Mass dominated by inductor core (~10-30 mg)
- Operates at 20-100 kHz switching frequency

**Charge Pump:**
- Efficiency ≈ 40-60% (lower due to stage inefficiencies)
- Mass dominated by capacitor area (~5-20 mg)
- Operates at MHz frequencies for on-chip clock

The paper notes the framework trades off these properties in different mass regimes, as shown in Figure 1 caption: "converter voltage density ($V \cdot g^{-1}$) and converter efficiency density ($\eta \cdot g^{-1}$) are these design targets."

---

## Implementation Integration with Full Design Flow

Both modules are called during **Step 3 (Converter Design)** in the paper's execution flow:

1. From Step 2: Bimorph impedance and target voltage $V_{PZT}$ are known
2. Converter design computes average DC load: $\bar{I}_{PZT} = 2\left(\frac{2V_{AC}}{\pi Z(\omega)} + \frac{V_{DC}}{Z(0)}\right)$
3. For each candidate design:
   - **Boost converter path:** Solve for `ontime` and `inductance` to meet $V_{PZT}$ and handle $\bar{I}_{PZT}$
   - **Charge pump path:** Solve for `N` and `M` (stages and parallelism) to meet $V_{PZT}$ with minimum capacitance

4. Compare mass: boost inductor mass vs. charge pump capacitor mass
5. Select lowest-mass converter for this design point
6. Proceed to Step 4 (logic power and mass) and Step 5 (battery sizing)

---

## Key Implementation Details: Bridging Paper Theory to Code

| Paper Concept | Implementation | File |
|---|---|---|
| Tapped-inductor boost topology | Circuit equations + duty cycle solver | tapped_boost.py |
| Discontinuous conduction mode | Exponential inductor current model | tapped_boost.py |
| Energy balance (5 loss mechanisms) | `run()` returns net energy per cycle | tapped_boost.py |
| Hybrid charge pump stages | Recursive voltage multiplication | charge_pump.py |
| Output impedance formula | Double-nested summation in `oresistance()` | charge_pump.py |
| Optimal capacitance solver | `scipy.optimize.fsolve()` wrapper | charge_pump.py |
| Unit capacitance density | Process- and voltage-dependent lookup table | charge_pump.py |
| Component mass (discrete parts) | Datasheet-based mass lookup + core formula | tapped_boost.py |
| Die mass (on-chip) | Process-specific area-to-mass function | charge_pump.py |

---

## Summary

The two Python modules implement the complete **Power Electronics** section of the paper:

- **`tapped_boost.py`** provides the discrete inductor-based boost converter model, solving for drive signal parameters (`ontime`, `duty`) to achieve desired output voltage while accounting for all parasitic losses, magnetic core saturation, and component masses.

- **`charge_pump.py`** provides the on-chip capacitive charge pump model, solving for optimal stage count ($N_P$) and capacitance ($C_P$) to minimize mass while meeting output voltage specifications under load.

- **Integration:** Both converters interface with the preceding actuator design (bimorph impedance and required voltage) and downstream battery sizing, allowing the framework to comprehensively evaluate power electronics trade-offs for FWMAV applications.

The implementations faithfully reproduce the mathematical models described in the paper while adding practical engineering details (discrete parasitics, magnetic saturation, on-chip process constraints) necessary for realistic converter design.
