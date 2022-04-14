//this module still needs to access memory

module word_clipping_wrapper #
(
  parameter MOVING_AVG_SAMPLE_NUM = 20,
  parameter WORD_CLIP_LOW_THRESHOLD = 15'h0042,
  parameter WORD_CLIP_UP_THRESHOLD = 15'h0294
)(
  input i_clk,
  input i_rstn,
  
  input i_valid,
  input [15:0] i_data, //audio data
  input [31:0] i_addr, //memory address of audio data

  input i_last,
  input i_ack,
  
  output [31:0] o_word_start,
  output [31:0] o_word_end,
  output o_done,
  output o_valid
);

  wire abs_val_ovalid, moving_average_ovalid, word_clipper_ovalid, word_clipper_odone;
  wire [15:0] moving_average_odata, abs_val_odata;
  wire [31:0] word_clipper_end_idx, word_clipper_start_idx, moving_average_idx, absolute_value_idx;

  absolute_value uabsolute_value(
    .iclk(i_clk),
    .irstn(i_rstn),
    .ivalid(i_valid),
    .iidx(i_addr),
    .idata(i_data),
    .ovalid(abs_val_ovalid),
    .odata(abs_val_odata),
    .oidx(absolute_value_idx)
  );
  
  moving_average # (
	.BURST_SIZE(MOVING_AVG_SAMPLE_NUM)
  ) umoving_average(
    .iclk(i_clk),
    .irstn(i_rstn),
    .ivalid(abs_val_ovalid),
    .idata(abs_val_odata),
    .iidx(absolute_value_idx),
    .ovalid(moving_average_ovalid),
    .odata(moving_average_odata),
    .oidx(moving_average_idx)
  );
  
  word_clipper #(
	.LOWER_THRESHOLD(WORD_CLIP_LOW_THRESHOLD),
	.UPPER_THRESHOLD(WORD_CLIP_UP_THRESHOLD)
  ) uword_clipper (
    .iclk(i_clk),
    .irstn(i_rstn),
    .ivalid(moving_average_ovalid),
    .ilast(i_last), 					// not really needed i dont think, maybe we find out later
    .iack(i_ack),
    .iidx(moving_average_idx),
    .idata(moving_average_odata),
    .ovalid(word_clipper_ovalid),
    .ostart_idx(word_clipper_start_idx),
    .oend_idx(word_clipper_end_idx),
    .odone(word_clipper_odone)
  );
  
  assign o_word_start = word_clipper_start_idx;
  assign o_word_end = word_clipper_end_idx;
  assign o_valid = word_clipper_ovalid;
  assign o_done = word_clipper_odone;
  
//  frame uframe(
//    .clk(iclk),
//   .rst(irstn), // i sure hope this is resetn 
//    .i_start(word_clipper_ovalid),
//    .i_start_addr(word_clipper_start_idx),
//    .i_end_addr(word_clipper_end_idx),
    //TODO these connections
//    .o_frame_start(o_frame_start),
//   .o_frame_end(o_frame_end),
//    .o_done(o_done),
//    .o_valid(o_valid)
//  );

endmodule