# Load simulation
vsim work.DirectMapped_tb

#                   Group Name      Radix                Signals
add wave -noupdate  -group {tb}    -radix unsigned      /DirectMapped_tb/clk
add wave -noupdate  -group {tb}    -radix unsigned      /DirectMapped_tb/rst

add wave -noupdate  -group {tb}    -radix unsigned      /DirectMapped_tb/wen_i
add wave -noupdate  -group {tb}    -radix hexadecimal   /DirectMapped_tb/address_i

add wave -noupdate  -group {tb}    -radix unsigned      /DirectMapped_tb/hit_o
add wave -noupdate  -group {tb}    -radix unsigned      /DirectMapped_tb/data_i
add wave -noupdate  -group {tb}    -radix unsigned      /DirectMapped_tb/data_o

# cache
add wave -noupdate -group {cache}  -radix unsigned      /DirectMapped_tb/dut/clk
add wave -noupdate -group {cache}  -radix unsigned      /DirectMapped_tb/dut/rst

add wave -noupdate -group {cache}  -radix unsigned      /DirectMapped_tb/dut/cache

# Use short names
configure wave -signalnamewidth 1