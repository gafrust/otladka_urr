set_property PACKAGE_PIN AA3 [get_ports clk_60_i]




set_property PACKAGE_PIN AD21 [get_ports rs_rx_i]
set_property PACKAGE_PIN AE21 [get_ports rs_tx_o]

set_property PACKAGE_PIN AB21 [get_ports rs_dir_o]

set_property IOSTANDARD LVCMOS18 [get_ports clk_60_i]



#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

set_property IOSTANDARD LVCMOS33 [get_ports rs_rx_i]
set_property IOSTANDARD LVCMOS33 [get_ports rs_tx_o]

set_property IOSTANDARD LVCMOS33 [get_ports rs_dir_o]



connect_debug_port u_ila_0/probe0 [get_nets [list {crc_out_o_OBUF[0]} {crc_out_o_OBUF[1]} {crc_out_o_OBUF[2]} {crc_out_o_OBUF[3]} {crc_out_o_OBUF[4]} {crc_out_o_OBUF[5]} {crc_out_o_OBUF[6]} {crc_out_o_OBUF[7]} {crc_out_o_OBUF[8]} {crc_out_o_OBUF[9]} {crc_out_o_OBUF[10]} {crc_out_o_OBUF[11]} {crc_out_o_OBUF[12]} {crc_out_o_OBUF[13]} {crc_out_o_OBUF[14]} {crc_out_o_OBUF[15]} {crc_out_o_OBUF[16]} {crc_out_o_OBUF[17]} {crc_out_o_OBUF[18]} {crc_out_o_OBUF[19]} {crc_out_o_OBUF[20]} {crc_out_o_OBUF[21]} {crc_out_o_OBUF[22]} {crc_out_o_OBUF[23]} {crc_out_o_OBUF[24]} {crc_out_o_OBUF[25]} {crc_out_o_OBUF[26]} {crc_out_o_OBUF[27]} {crc_out_o_OBUF[28]} {crc_out_o_OBUF[29]} {crc_out_o_OBUF[30]} {crc_out_o_OBUF[31]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list vd_crc_o_OBUF]]
connect_debug_port u_ila_0/probe6 [get_nets [list vd_o_OBUF]]
connect_debug_port u_ila_0/probe9 [get_nets [list crc_result_o_OBUF]]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 32768 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_60_i_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_urr_osn/state[0]} {u_urr_osn/state[1]} {u_urr_osn/state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {addr_i[0]} {addr_i[1]} {addr_i[2]} {addr_i[3]} {addr_i[4]} {addr_i[5]} {addr_i[6]} {addr_i[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {crc_out_o[0]} {crc_out_o[1]} {crc_out_o[2]} {crc_out_o[3]} {crc_out_o[4]} {crc_out_o[5]} {crc_out_o[6]} {crc_out_o[7]} {crc_out_o[8]} {crc_out_o[9]} {crc_out_o[10]} {crc_out_o[11]} {crc_out_o[12]} {crc_out_o[13]} {crc_out_o[14]} {crc_out_o[15]} {crc_out_o[16]} {crc_out_o[17]} {crc_out_o[18]} {crc_out_o[19]} {crc_out_o[20]} {crc_out_o[21]} {crc_out_o[22]} {crc_out_o[23]} {crc_out_o[24]} {crc_out_o[25]} {crc_out_o[26]} {crc_out_o[27]} {crc_out_o[28]} {crc_out_o[29]} {crc_out_o[30]} {crc_out_o[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 24 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {freq[0]} {freq[1]} {freq[2]} {freq[3]} {freq[4]} {freq[5]} {freq[6]} {freq[7]} {freq[8]} {freq[9]} {freq[10]} {freq[11]} {freq[12]} {freq[13]} {freq[14]} {freq[15]} {freq[16]} {freq[17]} {freq[18]} {freq[19]} {freq[20]} {freq[21]} {freq[22]} {freq[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list err_freq_from_urr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list u_rx/fft_rx]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list u_tx/tx_reg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list vd_crc_o_force_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list vd_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list vd_o_force_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list vd_o_urr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list vd_urr_crc]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_60_i_IBUF_BUFG]
