vlib work
vlog DSP48A1.v tb_DSP48A1.v REG_MUX.v
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
#quit -sim