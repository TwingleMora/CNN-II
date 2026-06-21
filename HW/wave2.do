onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /systolic_array_tb2/WIDTH
add wave -noupdate /systolic_array_tb2/ROWS
add wave -noupdate /systolic_array_tb2/COLS
add wave -noupdate /systolic_array_tb2/clk
add wave -noupdate /systolic_array_tb2/rst
add wave -noupdate /systolic_array_tb2/a1_in
add wave -noupdate /systolic_array_tb2/a2_in
add wave -noupdate /systolic_array_tb2/b1_in
add wave -noupdate /systolic_array_tb2/b2_in
add wave -noupdate /systolic_array_tb2/en
add wave -noupdate /systolic_array_tb2/max_rows
add wave -noupdate /systolic_array_tb2/max_cols
add wave -noupdate /systolic_array_tb2/max_common
add wave -noupdate /systolic_array_tb2/d1_in
add wave -noupdate /systolic_array_tb2/d2_in
add wave -noupdate /systolic_array_tb2/d3_in
add wave -noupdate /systolic_array_tb2/d4_in
add wave -noupdate /systolic_array_tb2/p1_ready_out
add wave -noupdate /systolic_array_tb2/p2_ready_out
add wave -noupdate /systolic_array_tb2/p3_ready_out
add wave -noupdate /systolic_array_tb2/sync_rst
add wave -noupdate /systolic_array_tb2/a1_valid_in
add wave -noupdate /systolic_array_tb2/a2_valid_in
add wave -noupdate /systolic_array_tb2/b1_valid_in
add wave -noupdate /systolic_array_tb2/b2_valid_in
add wave -noupdate /systolic_array_tb2/done
add wave -noupdate /systolic_array_tb2/a_in
add wave -noupdate /systolic_array_tb2/b_in
add wave -noupdate /systolic_array_tb2/a_valid_in
add wave -noupdate /systolic_array_tb2/b_valid_in
add wave -noupdate -expand /systolic_array_tb2/a_ready_out
add wave -noupdate -expand /systolic_array_tb2/b_ready_out
add wave -noupdate /systolic_array_tb2/parallel_sum
add wave -noupdate /systolic_array_tb2/shift_en
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/PARAM_WIDTH
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/WIDTH
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/ROWS
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/COLS
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/NO_INPUTS
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/clk
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/rst
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/sync_rst
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/max_rows
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/max_cols
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/max_common
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/shift_en
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/parallel_sum
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/a_in
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/a_valid_in
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/a_ready_out
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/b_in
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/b_valid_in
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/b_ready_out
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/en
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/done
add wave -noupdate -height 40 -expand -group DUT -radix unsigned -childformat {{{/systolic_array_tb2/DUT/d_out[0]} -radix unsigned} {{/systolic_array_tb2/DUT/d_out[1]} -radix unsigned} {{/systolic_array_tb2/DUT/d_out[2]} -radix unsigned} {{/systolic_array_tb2/DUT/d_out[3]} -radix unsigned}} -expand -subitemconfig {{/systolic_array_tb2/DUT/d_out[0]} {-height 15 -radix unsigned} {/systolic_array_tb2/DUT/d_out[1]} {-height 15 -radix unsigned} {/systolic_array_tb2/DUT/d_out[2]} {-height 15 -radix unsigned} {/systolic_array_tb2/DUT/d_out[3]} {-height 15 -radix unsigned}} /systolic_array_tb2/DUT/d_out
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/a_out_most_right
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/b_out_most_down
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/a_out_right
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/b_out_down
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/a_valid_most_right
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/b_valid_most_down
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/pe_valid_out
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/all_mult_count
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/pe0_mult_count
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/pe0_done
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/min_mult_count
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/real_mult_count
add wave -noupdate -height 40 -expand -group DUT -color Salmon -format Literal /systolic_array_tb2/DUT/pe0_valid_in
add wave -noupdate -height 40 -expand -group DUT /systolic_array_tb2/DUT/main_counter_en
add wave -noupdate -height 40 -expand -group NEW /systolic_array_tb2/DUT/clk
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/parallel_sum}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/shift_en}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/a_in}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/b_in}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/en}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/valid_a}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/valid_b}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/a_out}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/b_out}
add wave -noupdate -height 40 -expand -group NEW -radix unsigned {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/d_out}
add wave -noupdate -height 40 -expand -group NEW {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/w_valid}
add wave -noupdate -expand -group MAC {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/comb_a_in}
add wave -noupdate -expand -group MAC {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/comb_b_in}
add wave -noupdate -expand -group MAC {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/comb_mult}
add wave -noupdate -expand -group MAC {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/comb_parallel_add}
add wave -noupdate -expand -group MAC {/systolic_array_tb2/DUT/ROW_GENERATE[1]/COL_GENERATE[0]/genblk1/genblk1/pe_x/comb_accum_reg}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 234
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
WaveRestoreZoom {0 ns} {55 ns}
