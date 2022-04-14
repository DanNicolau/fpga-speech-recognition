`timescale 1ns / 1ps

module pre_fft_wrapper_tb ();

  reg clock, resetn;
  
  reg in_valid;
  reg [15:0] in_data; //audio data
  reg [31:0] in_addr; //memory address of audio data

  wire [31:0] out_frame_start;
  wire [31:0] out_frame_end;
  wire out_done;
  wire out_valid;
  
  pre_fft_wrapper dut (
        .iclk(clock),
        .irstn(resetn),
          
        .ivalid(in_valid),
        .idata(in_data), //audio data
        .iaddr(in_addr), //memory address of audio data
        
        .o_frame_start(out_frame_start),
        .o_frame_end(out_frame_end),
        .o_done(out_done),
        .o_valid(out_valid)
  );
  
  initial begin
    clock = 1'b0;
    forever begin
        #2 clock = ~clock;
    end
  end
  
  initial begin
    #10000;
    $display("timeout");
    $finish;
  end
  
  initial begin
    resetn = 1'b1;
    #3
    resetn = 1'b0;
    #8
    resetn = 1'b1;  
  end
  
    integer i;
  
    initial begin
        in_valid = 1'b0;
        in_addr = 32'h0;
        repeat(5) @(posedge clock);
           
           
        for (i = 0; i < 32'h100; i = i + 32'h1) begin
            @(posedge clock);
            in_valid <= 1'b1;
            in_data <= $random();
            in_addr <= in_addr + 32'h4;
        end
        
        for (i = 0; i < 32'h100; i = i + 32'h1) begin
            @(posedge clock);
            in_valid <= 1'b1;
            in_data <= 16'd0;
            in_addr <= in_addr + 32'h4;
        end
        
        @(posedge clock);
        in_valid <= 1'b0;
       
        repeat(10) @(posedge clock);
   end
endmodule
