# ECE532: Digital Systems Design

## Description of Design Tree

### compute_node

This contains the relevant compute_node files we thought were worth including since it should be possible to recreate the block diagram and includes the constraint files. If you are skimming this project, this probably isn't what you want to look at.

Large parts of the autogenerated Vivado project such as the ip/ have been removed.

The compute_node/demo_group.sdk folder contains some relevant code in echo.c and main.c .

compute_node/ip_repo/ is the ip repository for our custom IPs.

### load_manager

Same as above but for the load manager fpga.

### software_model

This contains the code for the software model, minus any audio files you might use to generate the dictionary.

### src

Contains most of the user-generated code.

#### mem

echo.c contains the load manager echo.c code. letters.h and .c contain some helped functions for writing text to the VGA assuming the video buffer is mapped to the right memory. Contains some scratchpad files for font bitmap as well.

#### rtl

This contains our rtl files:

* absolute_value.v
* euclidean_comparator.v
* frame.v
* load_manage.v
* moving_average.v
* pre_fft_wrapper.v
* vga_controller.v
* word_clipper.v
* word_clipper_end.v

#### scripts

Contains some python scripts:

* ibm_watson_test_to_speech.py.py Some code to access ibm watson api?
* tcp_client(DESLA)

#### tb_local

This contains testbenches for the rtl files. These are not as rigorous as we would have liked them to be but were still very useful in our development.

### text-to-speech

This contains a python script to generate tts word samples.