# fwmav-em-codesign Appendix Summary

This repository contains research artifacts for the insect-scale flapping-wing micro aerial vehicle (FWMAV) electromechanical co-design framework.

The `appendix/` folder contains summary documents that map paper sections to the actual repository code and data.

## Appendix Documents

- `appendix/fwmav-em-codesign.actuation.md`
  - Explains the implementation of the **Actuation: Wings and PZT Bimorph** section.
  - Maps the paper's wing aerodynamics and bimorph actuator models to `release/v0.0/src/piezo_bimorph.py`, `release/v0.0/src/passive.py`, and `release/v0.0/src/mechanical_options.py`.

- `appendix/fwmav-em-codesign.power.md`
  - Explains the implementation of the **Power Electronics** section.
  - Maps the paper's tapped-inductor boost and capacitive charge-pump converter models to `release/v0.0/src/tapped_boost.py`, `release/v0.0/src/charge_pump.py`, and the release RTL in `release/v0.0/electrical/rtl`.

- `appendix/fwmav-em-codesign.controller.md`
  - Maps the paper's **Controller / custom IC** section to the SoC RTL and validation infrastructure.
  - Describes the top-level AHB SoC integration in `release/v0.0/hdl/rtl/Top.sv` and related peripherals such as the FPU, boost controller, charge-pump interface, and debug system.

- `appendix/fwmav-em-codesign.batteries.md`
  - Explains the implementation of the **Energy Source: Battery** section.
  - Summarizes battery mass/capacity modeling in `release/v0.0/src/battery.py` and EIS/battery dataset support in `release/v0.0/batteries`.

## How to use this repository

1. Read the appendix documents in `appendix/` to understand how the paper sections are realized in code.
2. Use `release/v0.0/src/` for the physics-based design models.
3. Use `release/v0.0/electrical/` and `release/v0.0/hdl/` for the ASIC and power electronics RTL.
4. Use `release/v0.0/batteries/` for battery measurement and EIS support.

## Notes

- The appendix documents are written as guided summaries and should be used as a navigation aid between the paper and the code.
- `release/v0.0/pzt/` contains measurements and model-fitting tools for piezoelectric actuator impedance, which support the electrical drive model described in the actuation appendix.
