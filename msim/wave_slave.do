onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label sim_clk /spi_slave_reg_tb/sim_clk
add wave -noupdate -label spi_clk /spi_slave_reg_tb/spi_clk
add wave -noupdate -label spi_mosi /spi_slave_reg_tb/spi_mosi
add wave -noupdate -label spi_cs_n /spi_slave_reg_tb/spi_cs_n
add wave -noupdate -label data_reg /spi_slave_reg_tb/DUT/data_reg
add wave -noupdate -label spi_out_reg /spi_slave_reg_tb/spi_out_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9999139 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {10500 ns}
