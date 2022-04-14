

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "word_clipper" "NUM_INSTANCES" "DEVICE_ID"  "C_S00_WORD_CLIP_AXI_BASEADDR" "C_S00_WORD_CLIP_AXI_HIGHADDR"
}
