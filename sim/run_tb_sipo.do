
vsim work.tb_sipo

add wave -position end sim:/tb_sipo/dut/*

run 80 us

wave zoom full