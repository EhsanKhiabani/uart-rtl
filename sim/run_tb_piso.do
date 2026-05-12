
vsim work.tb_piso

add wave -position end sim:/tb_piso/uut/*

run 80 us

wave zoom full