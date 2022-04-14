`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2022 07:30:04 PM
// Design Name: 
// Module Name: fft_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Spectrum analysis of composite signal
module fft_top(
    input wire sclk,
    input wire rst_n,
    
    input wire [15:0] xin,
    input wire xvalid,
    input wire xlast,
    output wire xready,
    
    output wire [15:0] fft_out,
    input wire fft_ready,
    output wire fft_valid,
    output wire fft_last
    
    );
//Pin declaration of FFT core
wire s_axis_config_tready;              // DONT CARE
wire  [31:0] s_axis_data_tdata;          // for the input
wire  s_axis_data_tvalid  ;              // assert this to 1 when we have a valid input
wire s_axis_data_tready  ;              // only when this is 1 do we sgive it data
wire  s_axis_data_tlast   ;              // we must assert this along with valid just for 1 cycle (when the last sample is given to the fft mdoule
wire [31:0] m_axis_data_tdata;          // this is the actual output data, concerned with only the real part for this
wire m_axis_data_tready;                // this is the input - this shoul dbe high just for 1 cycle (becuase we just want to read one output at a time
wire m_axis_data_tvalid;                // this means data is valid
wire m_axis_data_tlast;                 // when this is asserted we know that all outputs have been registered
wire event_frame_started ;              // DONT CARE
wire event_tlast_unexpected;            // DONT CARE
wire event_tlast_missing;               // DONT CARE
wire event_status_channel_halt;         // DONT CARE
wire event_data_in_channel_halt;        // DONT CARE
wire event_data_out_channel_halt;       // DONT CARE

//FFT input assignment
assign m_axis_data_tready = fft_ready;
assign s_axis_data_tdata = {16'd0, xin};
assign s_axis_data_tvalid = xvalid;
assign s_axis_data_tlast = xlast;

//FFT output assignment
assign fft_out = m_axis_data_tdata[15:0];
assign fft_valid = m_axis_data_tvalid;
assign fft_last = m_axis_data_tlast;
assign xready = s_axis_data_tready;

//FFT kernel instantiation
xfft_0 fft_ip0 (
  .aclk(sclk),                                                // input wire aclk
  .aresetn(rst_n),                                          // input wire aresetn
  //Since the number of bits of fft transform data will continue to increase, overflow may occur. Therefore, the config channel sets zoom multiples at all levels in its scale part; Because there are 256 data (2 ^ 8), scale here accounts for 2 * 8 = 16 bits
  .s_axis_config_tdata(40'b000000000000000000000000000000000000000_1),                  // input wire [39 : 0] s_axis_config_tdata (just the last bit is 1 for the FWD direction
  .s_axis_config_tvalid(1'b1),                // input wire s_axis_config_tvalid
  .s_axis_config_tready(s_axis_config_tready),                // output wire s_axis_config_tready
  .s_axis_data_tdata(s_axis_data_tdata),                      // input wire [31 : 0] s_axis_data_tdata  !!!!!!!!!
  .s_axis_data_tvalid(s_axis_data_tvalid),                    // input wire s_axis_data_tvalid
  .s_axis_data_tready(s_axis_data_tready),                    // output wire s_axis_data_tready
  .s_axis_data_tlast(s_axis_data_tlast),                      // input wire s_axis_data_tlast
  .m_axis_data_tdata(m_axis_data_tdata),                      // output wire [31 : 0] m_axis_data_tdata!!!!!!!!!!!
  .m_axis_data_tvalid(m_axis_data_tvalid),                    // output wire m_axis_data_tvalid
  .m_axis_data_tready(m_axis_data_tready),                    // input wire m_axis_data_tready
  .m_axis_data_tlast(m_axis_data_tlast),                      // output wire m_axis_data_tlast
  .event_frame_started(event_frame_started),                  // output wire event_frame_started
  .event_tlast_unexpected(event_tlast_unexpected),            // output wire event_tlast_unexpected
  .event_tlast_missing(event_tlast_missing),                  // output wire event_tlast_missing
  .event_status_channel_halt(event_status_channel_halt),      // output wire event_status_channel_halt
  .event_data_in_channel_halt(event_data_in_channel_halt),    // output wire event_data_in_channel_halt
  .event_data_out_channel_halt(event_data_out_channel_halt)  // output wire event_data_out_channel_halt
);
endmodule