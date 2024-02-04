set_false_path \
    -from [get_pins zybo_top_i/hdmi_rx/dvi2rgb/U0/TMDS_ClockingX/aLocked_reg/C] \
    -to [get_pins {zybo_top_i/hdmi_tx/tx_dc_fifo/U0/inst_fifo_gen/gconvfifo.rf/gbi.bi/v7_bi_fifo.fblk/gextw[1].gnll_fifo.inst_extd/gonep.inst_prim/gf18e1_inst.sngfifo18e1/RDEN}]
set_false_path \
    -from [get_pins zybo_top_i/hdmi_rx/dvi2rgb/U0/TMDS_ClockingX/aLocked_reg/C] \
    -to [get_pins {zybo_top_i/hdmi_rx/rx_dc_fifo/U0/inst_fifo_gen/gconvfifo.rf/gbi.bi/v7_bi_fifo.fblk/gextw[1].gnll_fifo.inst_extd/gonep.inst_prim/gf18e1_inst.sngfifo18e1/WREN}]
