`timescale 1ns / 1ps

module frame_tb();

	wire [31:0] frame_start, frame_end;
	wire valid, done;
	
	reg [31:0] start_addr, end_addr; 
	reg clock, reset;
	reg start;
	
	frame # (
	   .FRAME_SIZE(64),
	   .FRAME_OVERLAP(32)
	) dut (
		.clk(clock), 
		.rst(reset),
		.i_start(start),
		.i_start_addr(start_addr),
		.i_end_addr(end_addr),
		.o_frame_start(frame_start),
		.o_frame_end(frame_end),
		.o_done(done),
		.o_valid(valid)
	);
	
	initial begin
	    clock = 0;
		forever begin
			#2 clock = ~clock;
		end
	end
	
	initial begin
		reset = 0;
		#3
		
		start_addr = 'h80000000;
		end_addr = 'h80000100;
		reset = 1;
		
		#2
		start = 1;
		#4
		start = 0;
		
		#200
		start_addr = 'h10000000;
		end_addr = 'h10000c00;
		start = 1;
		#4
		start = 0;
		
	end
	
endmodule
