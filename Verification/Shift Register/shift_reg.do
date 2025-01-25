vlib work
vlog -f shift_reg.list +cover -covercells 
vsim -voptargs=+acc work.shift_reg_top -cover 
add wave -position insertpoint \
sim:/top/shift_regif/clk \
sim:/top/shift_regif/reset \
sim:/top/shift_regif/serial_in \
sim:/top/shift_regif/direction \
sim:/top/shift_regif/mode \
sim:/top/shift_regif/datain \
sim:/top/shift_regif/dataout 
coverage save shift_reg.ucdb -onexit
run -all
quit -sim
vcover report shift_reg.ucdb -details -annotate -all -output coverage_shift_reg_rpt.txt