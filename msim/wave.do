onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /spi_master_tb/sim_clk
add wave -noupdate -label clk_cnt -radix unsigned /spi_master_tb/DUT/clk_cnt
add wave -noupdate -label data_reg /spi_master_tb/DUT/data_reg
add wave -noupdate -label data_shift /spi_master_tb/DUT/data_shift
add wave -noupdate -label dbit_cnt_reg -radix unsigned /spi_master_tb/DUT/dbit_cnt_reg
add wave -noupdate -label dbit_cnt_dec /spi_master_tb/DUT/dbit_cnt_dec
add wave -noupdate -label dbit_cnt_ovf /spi_master_tb/DUT/dbit_cnt_ovf
add wave -noupdate -label sim_rst_n /spi_master_tb/sim_rst_n
add wave -noupdate -label sim_req /spi_master_tb/sim_req
add wave -noupdate -label spi_cs_n /spi_master_tb/spi_cs_n
add wave -noupdate -label spi_mosi /spi_master_tb/spi_mosi
add wave -noupdate -label spi_clk /spi_master_tb/spi_clk
add wave -noupdate -label clk_ovf /spi_master_tb/DUT/clk_ovf
add wave -noupdate -label state_reg /spi_master_tb/DUT/state_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {607976 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 131
configure wave -valuecolwidth 104
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {4200 ns}
