vlib work
vlog -f ALSU.list  +cover -covercells
vsim -voptargs=+acc work.ALSU_top -cover -sv_seed random -l sim.ALSU_log
add wave /ALSU_top/ALSU_if/*
add wave /ALSU_top/shift_regif/*
coverage save ALSU.ucdb -onexit
run -all
#quit -sim
#vcover report ALSU.ucdb -details -annotate -all -output coverage_ALSU_rpt.txt
