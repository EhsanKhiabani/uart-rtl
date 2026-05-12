
vsim work.tb_pwm_controller

add wave -position end sim:/tb_pwm_controller/uut/*

run 40 ms

wave zoom full