vsim work.tb_rx_fsm

add wave -position end sim:/tb_rx_fsm/dut/*

run 5 us

wave zoom full