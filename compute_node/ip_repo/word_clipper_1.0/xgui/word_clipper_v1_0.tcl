# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set C_S00_WORD_CLIP_AXI_DATA_WIDTH [ipgui::add_param $IPINST -name "C_S00_WORD_CLIP_AXI_DATA_WIDTH" -parent ${Page_0} -widget comboBox]
  set_property tooltip {Width of S_AXI data bus} ${C_S00_WORD_CLIP_AXI_DATA_WIDTH}
  set C_S00_WORD_CLIP_AXI_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_S00_WORD_CLIP_AXI_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of S_AXI address bus} ${C_S00_WORD_CLIP_AXI_ADDR_WIDTH}
  ipgui::add_param $IPINST -name "C_S00_WORD_CLIP_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_WORD_CLIP_AXI_HIGHADDR" -parent ${Page_0}

  set C_S00_WORD_CLIP_AXI_SAMPLE_NUM [ipgui::add_param $IPINST -name "C_S00_WORD_CLIP_AXI_SAMPLE_NUM"]
  set_property tooltip {Number of samples to consider in one moving average} ${C_S00_WORD_CLIP_AXI_SAMPLE_NUM}
  set C_S00_WORD_CLIP_AXI_LOW_THRESHOLD [ipgui::add_param $IPINST -name "C_S00_WORD_CLIP_AXI_LOW_THRESHOLD"]
  set_property tooltip {Lower threshold for Identifying word} ${C_S00_WORD_CLIP_AXI_LOW_THRESHOLD}
  set C_S00_WORD_CLIP_AXI_UP_THRESHOLD [ipgui::add_param $IPINST -name "C_S00_WORD_CLIP_AXI_UP_THRESHOLD"]
  set_property tooltip {Upper threshold to identify word} ${C_S00_WORD_CLIP_AXI_UP_THRESHOLD}
  set C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH [ipgui::add_param $IPINST -name "C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH" -widget comboBox]
  set_property tooltip {Bit width of 1 sample in WAV file} ${C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH}

}

proc update_PARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD { PARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD } {
	# Procedure called to update C_S00_WORD_CLIP_AXI_LOW_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD { PARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD } {
	# Procedure called to validate C_S00_WORD_CLIP_AXI_LOW_THRESHOLD
	return true
}

proc update_PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM { PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM } {
	# Procedure called to update C_S00_WORD_CLIP_AXI_SAMPLE_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM { PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM } {
	# Procedure called to validate C_S00_WORD_CLIP_AXI_SAMPLE_NUM
	return true
}

proc update_PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH { PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH } {
	# Procedure called to update C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH { PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH } {
	# Procedure called to validate C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD { PARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD } {
	# Procedure called to update C_S00_WORD_CLIP_AXI_UP_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD { PARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD } {
	# Procedure called to validate C_S00_WORD_CLIP_AXI_UP_THRESHOLD
	return true
}

proc update_PARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_WORD_CLIP_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_WORD_CLIP_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_WORD_CLIP_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_WORD_CLIP_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_WORD_CLIP_AXI_BASEADDR { PARAM_VALUE.C_S00_WORD_CLIP_AXI_BASEADDR } {
	# Procedure called to update C_S00_WORD_CLIP_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_WORD_CLIP_AXI_BASEADDR { PARAM_VALUE.C_S00_WORD_CLIP_AXI_BASEADDR } {
	# Procedure called to validate C_S00_WORD_CLIP_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_WORD_CLIP_AXI_HIGHADDR { PARAM_VALUE.C_S00_WORD_CLIP_AXI_HIGHADDR } {
	# Procedure called to update C_S00_WORD_CLIP_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_WORD_CLIP_AXI_HIGHADDR { PARAM_VALUE.C_S00_WORD_CLIP_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_WORD_CLIP_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH PARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM { MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM}] ${MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_NUM}
}

proc update_MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD { MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD PARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD}] ${MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_LOW_THRESHOLD}
}

proc update_MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD { MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD PARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD}] ${MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_UP_THRESHOLD}
}

proc update_MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH { MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH}] ${MODELPARAM_VALUE.C_S00_WORD_CLIP_AXI_SAMPLE_WIDTH}
}

