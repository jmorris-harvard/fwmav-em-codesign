set projectName "fpu"
set src "fpu.h"
set testbench "testbench.cpp"
set topModule "fpu"


# New Project
project new -name $projectName
# solution new -state initial

# Options
solution options defaults
options set /Input/CppStandard c++11
options set General/BranchOnChange {Never branch}
solution options set /Input/CppStandard c++11
solution options set Output/OutputVerilog true

# Set Up Tools and Flows
flow package require /ModelSim
flow package option set /ModelSim/VOPT_ARGS {}
flow package option set /ModelSim/SCCOM_OPTS {-g -x c++ -Wall -Wno-unused-label -Wno-unknown-pragmas -O3}

flow package require /VCS
flow package option set /VCS/VCS_HOME {$VCS_HOME}
flow package option set /VCS/VG_GNU_PACKAGE {$VCS_HOME/linux}
flow package option set /VCS/VLOGAN_OPTS {}

flow package require /OSCI
flow package option set /OSCI/COMP_FLAGS {-Wall -Wno-unknown-pragmas -Wno-unused-label -O3}

flow package require /SCVerify
flow package option set /SCVerify/TB_STACKSIZE 64000000
flow package option set /SCVerify/INVOKE_ARGS {}
flow package option set /SCVerify/MAX_SIM_TIME 0
flow package option set /SCVerify/USE_VCS true
flow package option set /SCVerify/USE_QUESTASIM true

# Preprocessing
solution file add $src -type CHEADER
solution file add $testbench -type C++ -exclude true

go new

# Analyze:
go analyze

# Compile:
solution design set $topModule -top
go compile

# Libraries:
solution library add mgc_Xilinx-ARTIX-7-1_beh -- -rtlsyntool Vivado -manufacturer Xilinx -family ARTIX-7 -speed -1 -part xc7a100tcsg324-1
go libraries

# Assembly:
directive set -CLOCKS {clk {-CLOCK_PERIOD 200.0 -CLOCK_EDGE rising -CLOCK_UNCERTAINTY 0.0 -CLOCK_HIGH_TIME 100.0 -RESET_SYNC_NAME rstn -RESET_ASYNC_NAME arstn -RESET_KIND sync -RESET_SYNC_ACTIVE low -RESET_ASYNC_ACTIVE low -ENABLE_NAME en -ENABLE_ACTIVE high}}
directive set /fpu -DONE_FLAG done
directive set /fpu -READY_FLAG ready
directive set /fpu -START_FLAG start
go assembly

go architect

go allocate

go schedule

go dpfsm

go extract

# Run Simulations
# flow run /SCVerify/launch_make Verify_orig_cxx_osci.mk {} SIMTOOL=osci valgrind
# flow run /SCVerify/launch_make Verify_rtl_v_vcs.mk SIMTOOL=vcs sim
# flow run /SCVerify/launch_make Verify_rtl_v_msim.mk SIMTOOL=msim sim

project save

