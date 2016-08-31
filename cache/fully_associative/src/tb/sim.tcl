# Load simulation
vsim work.FullyAssociative_tb

#                   Group Name      Radix                Signals
add wave -noupdate  -group {tb}    -radix unsigned      /FullyAssociative_tb/clk
add wave -noupdate  -group {tb}    -radix unsigned      /FullyAssociative_tb/rst

add wave -noupdate  -group {tb}    -radix unsigned      /FullyAssociative_tb/address_i
add wave -noupdate  -group {tb}    -radix unsigned      /FullyAssociative_tb/hit_o

add wave -noupdate  -group {tb}    -radix unsigned      /FullyAssociative_tb/wen_i
add wave -noupdate  -group {tb}    -radix unsigned      /FullyAssociative_tb/ren_i

add wave -noupdate  -group {tb}    -radix unsigned      /FullyAssociative_tb/data_i
add wave -noupdate  -group {tb}    -radix unsigned      /FullyAssociative_tb/data_o

# cache
add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/clk
add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/rst

add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/cache

add wave -noupdate -group {cache}  -radix hexadecimal   /FullyAssociative_tb/dut/address_i
add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/data_i

add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/wen_i
add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/ren_i

add wave -noupdate -group {cache}  -radix hexadecimal   /FullyAssociative_tb/dut/tag

add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/hit_o
add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/hit_index

add wave -noupdate -group {cache}  -radix unsigned      /FullyAssociative_tb/dut/data_o


# lru
add wave -noupdate -group {lru}    -radix unsigned      /FullyAssociative_tb/dut/lru_access_i
add wave -noupdate -group {lru}    -radix unsigned      /FullyAssociative_tb/dut/lru_index_i
add wave -noupdate -group {lru}    -radix unsigned      /FullyAssociative_tb/dut/lru_index_o

# Use short names
configure wave -signalnamewidth 1