onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /im2col_tb/DEPTH
add wave -noupdate /im2col_tb/WIDTH
add wave -noupdate /im2col_tb/clk
add wave -noupdate /im2col_tb/rst
add wave -noupdate /im2col_tb/i_start
add wave -noupdate /im2col_tb/base_address
add wave -noupdate /im2col_tb/max_windows
add wave -noupdate /im2col_tb/w_i
add wave -noupdate /im2col_tb/h_i
add wave -noupdate /im2col_tb/w_f
add wave -noupdate /im2col_tb/h_f
add wave -noupdate -expand /im2col_tb/o_valid
add wave -noupdate /im2col_tb/o_done
add wave -noupdate /im2col_tb/o_addr1
add wave -noupdate /im2col_tb/o_addr2
add wave -noupdate /im2col_tb/o_addr3
add wave -noupdate /im2col_tb/o_addr4
add wave -noupdate /im2col_tb/o_addr5
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/DEPTH
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/WIDTH
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/TRACKER_WIDTH
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/clk
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/rst
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/i_start
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/base_address
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/max_windows
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/w_i
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/h_i
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/w_f
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/h_f
add wave -noupdate -height 60 -expand -group dut -expand /im2col_tb/dut/o_valid
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_done
add wave -noupdate -height 60 -expand -group dut -radix unsigned /im2col_tb/dut/o_addr1
add wave -noupdate -height 60 -expand -group dut -radix unsigned /im2col_tb/dut/o_addr2
add wave -noupdate -height 60 -expand -group dut -radix unsigned /im2col_tb/dut/o_addr3
add wave -noupdate -height 60 -expand -group dut -radix unsigned /im2col_tb/dut/o_addr4
add wave -noupdate -height 60 -expand -group dut -radix unsigned /im2col_tb/dut/o_addr5
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_window_addr
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_window_valid
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_window_done
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/i_window_en
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/fifo_wr_en
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/fifo_rd_en
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/fifo_sync_rst
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/fifo_wr_data
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/fifo_full
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/fifo_empty
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_fifo_counter
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_fifo_data
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/i_elem_start
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/i_elem_en
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_elem_offset
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_elem_valid
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/o_elem_done
add wave -noupdate -height 60 -expand -group dut /im2col_tb/dut/rd_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {304 ns}
