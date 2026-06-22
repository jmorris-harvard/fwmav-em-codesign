# FWMAV EM Codesign Pipeline

This directory contains a small Python pipeline for exploring and evaluating wing-driven flapping-wing MAV electromechanical designs.

## Overview

The pipeline generates candidate mechanical configurations, evaluates passive wing performance, adds system-level penalties, and finally examines power conversion circuit options.

## Execution order

1. `mechanical_options.py`
   - Generates a sweep of piezo-bimorph design options.
   - Writes a CSV of candidate mechanical configurations.

2. `passive.py`
   - Evaluates the passive wing dynamics for each mechanical option.
   - Prunes and updates the CSV with more accurate lift-related values.

3. `external.py`
   - Adds external mass and power-sink entries to the CSV.
   - Produces a version that includes additional system penalties and current loads.

4. `charge_pump.py` or `tapped_boost.py`
   - Evaluates power-conversion circuit options using the resulting CSV.
   - Appends circuit, battery, and runtime metrics.

## Scripts

- `mechanical_options.py`: Searches over piezo-bimorph geometry and operating parameters to identify promising mechanical designs.
- `passive.py`: Simulates wing motion and aerodynamic loading to estimate lift and other passive-wing performance metrics.
- `external.py`: Incorporates external masses and power sinks into the design table.
- `charge_pump.py`: Models a charge-pump power converter and evaluates candidate circuit parameters against the mechanical design data.
- `tapped_boost.py`: Models a tapped-boost converter and evaluates candidate circuit parameters against the same design data.
- `component.py`: Shared base component definition used by the piezo-bimorph model.
- `piezo_bimorph.py`: Implements the piezo-bimorph actuator model used by `mechanical_options.py`.
- `battery.py`: Provides battery mass and runtime estimation helpers used by the power-converter scripts.
- `process_specs.py`: Stores process-specific physical specifications used by the converter models.
