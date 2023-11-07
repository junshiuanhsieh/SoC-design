create_clock -period 10 -name wb_clk_i [get_ports wb_clk_i]
set_input_delay -clock wb_clk_i 2 [all_inputs]
set_output_delay -clock wb_clk_i 0 [all_outputs]