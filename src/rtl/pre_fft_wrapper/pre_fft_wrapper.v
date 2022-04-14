//this module still needs to access memory

module pre_fft_wrapper(
  input iclk,
  input irstn,
  
  input ivalid
  input [15:0] idata, //audio data
  input [31:0] iaddr, //memory address of audio data

  output ovalid,
  output [31:0] o_frame_start,
  output [31:0] o_frame_end,
  output o_done,
  output o_valid
);

  wire abs_val_ovalid, moving_average_ovalid, word_clipper_ovalid;
  wire [15:0] moving_average_odata, abs_val_odata;
  wire [31:0] word_clipper_end_idx, word_clipper_start_idx, moving_average_idx, absolute_value_idx;

  absolute_value uabsolute_value(
    .iclk(iclk),
    .irstn(irstn),
    .ivalid(ivalid),
    .iidx(iaddr),
    .idata(idata),
    .ovalid(abs_val_ovalid),
    .odata(abs_val_odata),
    .oidx(absolute_value_idx)
  );
  
  moving_average umoving_average(
    .iclk(iclk),
    .irstn(irstn),
    .ivalid(abs_val_ovalid),
    .idata(abs_val_odata),
    .iidx(absolute_value_idx)
    .ovalid(moving_average_ovalid),
    .odata(moving_average_odata)
    .oidx(moving_average_idx)
  );
  
  word_clipper uword_clipper(
    .iclk(iclk),
    .irstn(irstn),
    .ivalid(moving_average_ovalid),
    .ilast(), // not really needed i dont think, maybe we find out later
    .iidx(moving_average_idx), //TODO feedthrough
    .idata(moving_average_odata),
    .ovalid(word_clipper_ovalid),
    .ostart_idx(word_clipper_start_idx),
    .oend_idx(word_clipper_end_idx)
  );
  
  frame uframe(
    .clk(iclk),
    .rst(irstn), // i sure hope this is resetn 
    .i_start(word_clipper_ovalid),
    .i_start_addr(word_clipper_start_idx),
    .i_end_addr(word_clipper_end_idx),
    //TODO these connections
    .o_frame_start(o_frame_start),
    .o_frame_end(o_frame_end),
    .o_done(o_done),
    .o_valid(o_valid)
  );

endmodule
