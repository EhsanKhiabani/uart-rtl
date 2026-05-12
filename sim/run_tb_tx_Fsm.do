
vsim work.tb_tx_fsm

add wave -position end sim:/tb_tx_fsm/uut/*

run 5 us

wave zoom full