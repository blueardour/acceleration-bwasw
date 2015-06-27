vlib work
vlog +acc ../src/bsw.v
vlog +acc ../testbench/testbench.v
vlog +acc ../lib/functions.v

vsim -novopt testbench


