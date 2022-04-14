set_property -dict { PACKAGE_PIN D5    IOSTANDARD LVCMOS33 } [get_ports { s00_axi_aclk }];
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} -add [get_ports s00_axi_aclk];