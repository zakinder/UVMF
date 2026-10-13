# Questa/ModelSim mixed-language compilation; run from UVM/ directory.
# Requires a Questa license supporting mixed-language VHDL + SystemVerilog.
if {![file exists work]} {vlib work}
# Compile the VHDL DUT first (VHDL-2008).
vcom -2008 -work work sa.vhd
# Compile the SystemVerilog/UVM testbench second.
vlog -sv -work work +incdir+. sa_tb_top.sv
# C++ DPI predictor requires a separate shared-library build.
