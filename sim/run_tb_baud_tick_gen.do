
vsim work.tb_baud_tick

add wave -position end sim:/tb_baud_tick/dut_rx/*
add wave -position end sim:/tb_baud_tick/dut_tx/*

run 250 us

wave zoom full