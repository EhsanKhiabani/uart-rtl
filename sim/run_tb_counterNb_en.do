
vsim work.tb_counterNb_en

add wave -position end sim:/tb_counterNb_en/dut/*

run 80 us

wave zoom full