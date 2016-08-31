# Load simulation
vsim work.LRU_tb

#                   Group Name      Radix                Signals
add wave -noupdate                 -radix unsigned      /LRU_tb/clk
add wave -noupdate                 -radix unsigned      /LRU_tb/rst

add wave -noupdate -group {tb}     -radix unsigned      /LRU_tb/*

# LRU
add wave -noupdate -group {lru}     -radix unsigned      {sim:/LRU_tb/dut/lru}
add wave -noupdate -group {lru}     -radix unsigned      {sim:/LRU_tb/dut/value}
add wave -noupdate -group {lru}     -radix unsigned      {sim:/LRU_tb/dut/index}

# Level 1 compares
add wave -noupdate -group {l1} -group {index}   -radix unsigned      {sim:/LRU_tb/dut/loop1[0]/cmp1/index_out_o}
add wave -noupdate -group {l1} -group {index}   -radix unsigned      {sim:/LRU_tb/dut/loop1[2]/cmp1/index_out_o}
add wave -noupdate -group {l1} -group {index}   -radix unsigned      {sim:/LRU_tb/dut/loop1[4]/cmp1/index_out_o}
add wave -noupdate -group {l1} -group {index}   -radix unsigned      {sim:/LRU_tb/dut/loop1[6]/cmp1/index_out_o}

add wave -noupdate -group {l1} -group {value}   -radix unsigned      {sim:/LRU_tb/dut/loop1[0]/cmp1/value_out_o}
add wave -noupdate -group {l1} -group {value}   -radix unsigned      {sim:/LRU_tb/dut/loop1[2]/cmp1/value_out_o}
add wave -noupdate -group {l1} -group {value}   -radix unsigned      {sim:/LRU_tb/dut/loop1[4]/cmp1/value_out_o}
add wave -noupdate -group {l1} -group {value}   -radix unsigned      {sim:/LRU_tb/dut/loop1[6]/cmp1/value_out_o}

add wave -noupdate -group {l1} -group {ab}      -radix unsigned      {sim:/LRU_tb/dut/loop1[0]/cmp1/*}
add wave -noupdate -group {l1} -group {cd}      -radix unsigned      {sim:/LRU_tb/dut/loop1[2]/cmp1/*}
add wave -noupdate -group {l1} -group {ef}      -radix unsigned      {sim:/LRU_tb/dut/loop1[4]/cmp1/*}
add wave -noupdate -group {l1} -group {gh}      -radix unsigned      {sim:/LRU_tb/dut/loop1[6]/cmp1/*}


# Level 2 compares
add wave -noupdate -group {l2} -group {index}   -radix unsigned      {sim:/LRU_tb/dut/loop2_1[1]/loop2_2[0]/cmp2/index_out_o}
add wave -noupdate -group {l2} -group {index}   -radix unsigned      {sim:/LRU_tb/dut/loop2_1[1]/loop2_2[2]/cmp2/index_out_o}

add wave -noupdate -group {l2} -group {value}   -radix unsigned      {sim:/LRU_tb/dut/loop2_1[1]/loop2_2[0]/cmp2/value_out_o}
add wave -noupdate -group {l2} -group {value}   -radix unsigned      {sim:/LRU_tb/dut/loop2_1[1]/loop2_2[2]/cmp2/value_out_o}

add wave -noupdate -group {l2} -group {ab}      -radix unsigned      {sim:/LRU_tb/dut/loop2_1[1]/loop2_2[0]/cmp2/*}
add wave -noupdate -group {l2} -group {cd}      -radix unsigned      {sim:/LRU_tb/dut/loop2_1[1]/loop2_2[2]/cmp2/*}


# Level 3 compares
add wave -noupdate -group {l3} -group {index}   -radix unsigned      {sim:/LRU_tb/dut/loop2_1[2]/loop2_2[0]/cmp2/index_out_o}

add wave -noupdate -group {l3} -group {value}   -radix unsigned      {sim:/LRU_tb/dut/loop2_1[2]/loop2_2[0]/cmp2/value_out_o}

add wave -noupdate -group {l3} -group {ab}      -radix unsigned      {sim:/LRU_tb/dut/loop2_1[2]/loop2_2[0]/cmp2/*}

# Use short names
configure wave -signalnamewidth 1