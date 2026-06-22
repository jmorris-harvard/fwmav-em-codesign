# Implementation of Controller Section

This document maps the paper's Controller / custom IC section to the actual hardware and support RTL in `fwmav-em-codesign/release/v0.0/hdl`.

---

## 1. Top-level ASIC integration (`release/v0.0/hdl/rtl/Top.sv`)

`Top.sv` is the central SoC integration point for the controller:

- Instantiates the Cortex-M0 debug-enabled core: `CM0DbgAHB` (Core RTL sources are not included due to ARM IP requirements).
- Connects the core to a single AHB master and routes it through `ahb_interconnect` (Also not included).
- Exposes two on-chip memories via AHB: flash and SRAM.
- Instantiates the key peripherals that implement the controller and power-electronics interfaces.

### Memory and peripheral map

The AHB interconnect address map in `Top.sv` shows the memory/peripheral layout used by the controller software:

- `M0` flash: base `0x0000_0000`, size `0x0001_0000` (64 KB)
- `M1` SRAM: base `0x2000_0000`, size `0x0000_8000` (32 KB)
- `M2` LED peripheral: base `0x4000_0000`, size `0x0000_1000`
- `M3` sercomm peripheral: base `0x4000_1000`, size `0x0000_1000`
- `M4` override peripheral: base `0x4000_2000`, size `0x0000_1000`
- `M5` FPU peripheral: base `0x4000_3000`, size `0x0000_1000`
- `M6` boost converter peripheral: base `0x4000_4000`, size `0x0000_1000`
- `M7` charge-pump peripheral: base `0x4000_5000`, size `0x0000_1000`

These addresses directly map the controller software stack onto the ASIC's register and memory space.

### Memory access wrappers

The top-level design uses `mem_ahb_interpreter.sv` to connect the AHB memory ports to external flash and SRAM pins:

- `flash_mem_interpreter_inst`
- `sram_mem_interpreter_inst`

This matches the paper's assertion that the controller includes on-chip memory interfaces for code and data storage.

---

## 2. Controller peripherals and custom ASIC logic

The controller section in the paper is realized as a set of AHB-attached peripherals and custom RTL.

### 2.1. Power-electronics controller peripheral: `boost_ahb.sv`

- `boost_ahb.sv` is the AHB bridge for the boost converter controller.
- It exposes trigger/flag/register I/O for startup, ADC threshold, and divider configuration.
- The actual control logic is implemented in `boostctl.sv`.

`boostctl.sv` implements the core control flow for boost switching:

- A simple two-state FSM: idle and active.
- Uses an SPI-like `spi_core` to send comparator threshold values (`adc_threshold`).
- Drives the boost switch output `boost_drive`.
- Monitors the comparator input `cmp` to pulse the boost drive output.

This is the digital controller that closes the loop on the boost converter and implements the comparator threshold / drive gating described in the paper.

### 2.2. Charge pump peripheral: `chargepump_ahb.sv`

- `chargepump_ahb.sv` provides the AHB register interface for the charge pump block.
- It instantiates the `chargepump` module and exposes `chargepump_drive` output pins.
- In this release snapshot, the `chargepump` module body is present but contains no visible custom RTL logic.

That means the controller interface exists, even if the internal charge-pump state machine is not detailed here.

### 2.3. Actuation override / drive interface: `overrideChip_ahb.sv`

- `overrideChip_ahb.sv` is the peripheral wrapper for the drive override hardware to control the on-chip HV AWG (or off-chip analog peripherals via FPGA during the design and test phases).
- It instantiates `override.sv`, which exposes:
  - SPI / serial control signals: `cs`, `mosi`, `sck`
  - actuator outputs: `pdrive`, `ndrive`, `drive_en`
  - comparator input: `compare`
- This peripheral is the digital interface for actuator drive and comparator-based feedback.

### 2.4. Floating-point compute block: `fpu_ahb.sv`

- `fpu_ahb.sv` exposes a programmable floating-point accelerator synthesized via Catapult HLS on AHB.
- It uses `fpu_register_io` to map registers, triggers, flags, and data ports.
- The functional core is `fpu` which instantiates `fpu_block`.

This block supports the controller's on-chip compute requirements for vector/math operations in the flight-control stack.

### 2.5. Communications and status peripherals (for FPGA based Testing)

- `sercomm_ahb.sv`: UART/serial communication peripheral.
- `led_ahb.sv`: simple LED status peripheral.

These are standard controller support blocks for debug, telemetry, and status indication.

---

## 3. HLS and synthesized compute logic

The floating-point unit has explicit HLS provenance and supporting sources:

- `release/v0.0/hdl/rtl/fpu.sv`
  - Contains HLS-generated Verilog modules and comments like `HLS HDL: Verilog Netlister`.
  - Includes Catapult HLS metadata and pipeline FSM structures.
- `release/v0.0/hdl/hls/fpu/fpu.h`
  - C++ source describing the floating-point algorithm.
- `release/v0.0/hdl/hls/fpu/fpu.v`
  - Generated RTL from the HLS flow.

This confirms the controller section includes not only hand-written RTL but also HLS-generated compute hardware for the FPU.

---

## 4. Physical implementation and tapeout evidence

The repository includes downstream physical and place-and-route artifacts that support the controller implementation:

- `release/v0.0/hdl/tapeout/gds/Top.gds`
- `release/v0.0/hdl/pnr/gds/Top.gds`

These GDS files indicate that the controller ASIC design proceeds beyond RTL into layout/tapeout stages.

---

## 5. Process, mass, and power modeling for the controller ASIC

The ASIC controller's mass/power modeling is captured in:

- `release/v0.0/src/process_specs.py`
  - Models die mass with technology layer stacks for `XT018`, `XT011`, and `ASAP7`.
  - Computes memory power for `SPRAM18` and `SPRAM7` at operating frequency.
- `release/v0.0/static/external-xt018.csv`
  - Contains process/technology parameter rows used by the modeling flow.
- `release/v0.0/static/external-xt011.csv`
  - Equivalent process data for the older 0.11 µm process.
- `release/v0.0/static/external-n65.csv`
  - External component / process parameters for another technology point.

This matches the paper's Controller section where chip mass, process technology, and memory power are combined into the overall SWaP tradeoff.

---

## 6. Direct file-to-paper mapping

- `Top.sv` → custom ASIC controller integration, Cortex-M0 core, AHB fabric, flash/SRAM, and peripheral address mapping.
- `boost_ahb.sv` + `boostctl.sv` → boost converter digital control and comparator-driven switching.
- `chargepump_ahb.sv` → charge-pump peripheral register interface and drive outputs.
- `overrideChip_ahb.sv` + `override.sv` → actuator drive override and comparator feedback path.
- `fpu_ahb.sv` + `fpu.sv` + `hdl/hls/fpu/*` → HLS-derived floating-point computational block supporting controller math.
- `mem_ahb_interpreter.sv` → AHB memory wrappers for flash and SRAM.
- `process_specs.py` + `static/external-*.csv` → die mass and memory power estimation for the controller ASIC.
- `hdl/tapeout/gds/Top.gds` and `hdl/pnr/gds/Top.gds` → layout/tapeout artifacts supporting the controller design.

These files collectively implement the paper's Controller / custom IC block and show how the digital system, memory subsystem, and peripheral control are realized in the repository.

---

## Part (c): Controller Test Implementation (`release/v0.0/control/cpp`)

The repository includes a C++ controller test harness under `release/v0.0/control/cpp` that implements and validates the high-level controller logic used to test the digital core before—or alongside—ASIC integration.

### Main simulation flow

- `Main.cpp` is the primary driver: it calls `InitModel()` then repeatedly invokes `SAMPLE_MODEL()` to exercise the control loop for benchmarking.
- `MainSim.cpp` and `MainTest.cpp` provide simulation and test entry points that run the same model with different IO backends.

### Core controller model

- `Unified.cpp` holds the controller implementation and configuration loader. `InitModel()` reads parameters from ASCII configuration files (e.g., `Config.txt`, `Config_100.txt`).
- The model stores tuning parameters, adaptive gains, limits, control gains, trajectory references, and actuator setpoint generation in a central `Config` structure.

### Test and communication support

- `Comm.h` defines the `Read<T>()` template used throughout the model to obtain inputs; `CommDummy.cpp` and `CommTest.cpp` provide test I/O implementations.
- The harness includes simple utilities and configuration files used to replay inputs and validate outputs (`Input.txt`, `Config_*.txt`, `Out.txt`).

### How this maps to the ASIC controller

This C++ test implementation is a software reference for the controller behavior that the ASIC implements in RTL (the AHB peripherals and FPU). It documents and validates:

- attitude and adaptive control loops;
- trajectory generation and desired-state computations;
- actuator command synthesis (the `BiasD2A`, `LeftD2A`, `RightD2A` outputs);
- test-driven validation used during RTL/HLS development and before tapeout.

Adding this section links the power-electronics models and ASIC RTL to the higher-level controller testbed used during development and validation.
