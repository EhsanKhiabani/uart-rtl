
vsim work.tb_baud_tick

add wave -position end sim:/tb_baud_tick/uut/*

run 625 us

wave zoom full