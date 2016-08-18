# Load simulation
vsim work.lease_recently_used_4_elmt_tb

#                       Group Name        Radix               Signal(s)
add wave    -noupdate   -group {tb}       -radix hexadecimal  /lease_recently_used_4_elmt_tb/*
add wave    -noupdate   -group {lru}      -radix hexadecimal  /lease_recently_used_4_elmt_tb/dut/lru_list



# Use short names
configure wave -signalnamewidth 1
