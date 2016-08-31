# ModelSim 10.4b bug: need to delete library if it already exists because vlib
# work will seg fault otherwise.  
if {[file isdirectory work]} {
    vdel -all -lib work
}

# Create Library
vlib work

# Compile .sv files
vlog -work work "../LRU.sv"
vlog -work work "../Compare.sv"
vlog -work work "../FullyAssociative.sv"
vlog -work work "FullyAssociative_tb.sv"