`timescale 1ns / 1ps

module frame # (

	parameter ADDRW = 32,          // default: 32-bit address space
	parameter FRAME_SIZE = 4,      // default: 4 byte frame
	parameter FRAME_OVERLAP = 2    // default: 2 byte overlap
)(
	input clk, rst,
	input i_start,			// should be 1 just for one cycle - indicates computation should be started
	
	input [ADDRW-1:0] i_start_addr,		// first address in word window
	input [ADDRW-1:0] i_end_addr,			// last address in word window
	
	output [ADDRW-1:0] o_frame_start,		// strat address of the current frame
	output [ADDRW-1:0] o_frame_end,		// end address of the current frame
	
	output o_done,			// asserted when all the frame address have been produced
	output o_valid			// asserted when the address are valid
);

	reg [ADDRW-1:0] frame_start_addr;
	reg [ADDRW-1:0] frame_end_addr;
	reg valid, done;
	reg computation_start;
	
	assign o_frame_start = frame_start_addr;
	assign o_frame_end = frame_end_addr;
	assign o_done = done;
	assign o_valid = valid;
	
	always @ (posedge clk) begin
		
		if (!rst) begin				// reset is active high here, do we want active low??
			frame_start_addr <= 32'd0;
			frame_end_addr <= 32'd0;
			valid <= 1'd0;
			done <= 1'd0;
		end
		
		else begin
			
			if (frame_start_addr == 32'd0 && frame_end_addr == 32'd0 && computation_start == 1'd0) begin
				frame_start_addr <= 32'd0;
				frame_end_addr <= 32'd0;
				valid <= 1'd0;
				done <= 1'd0;
			end
			
			else if (frame_start_addr == 32'd0 && frame_end_addr == 32'd0 && computation_start == 1'd1) begin
				frame_start_addr <= i_start_addr;
				frame_end_addr <= i_start_addr + FRAME_SIZE;
				valid <= 1'd1;
				done <= 1'd0;
			end
			
			else if (frame_end_addr == i_end_addr && frame_start_addr == (i_end_addr - FRAME_SIZE) && done == 1'd0) begin
				frame_start_addr <= 32'd0;
				frame_end_addr <= 32'd0;
				valid <= 1'd0;
				done <= 1'd1;
			end
			
			else begin
				frame_start_addr <= frame_start_addr + FRAME_OVERLAP;
				frame_end_addr <= frame_end_addr + FRAME_OVERLAP;
				valid <= valid;
				done <= done;
			end
		end
		
	end
	
	// below block tells us when we must start computing
	always @ (posedge clk) begin
		if (!rst) begin
			computation_start <= 1'd0;
		end
		
		else if (i_start == 1'd1) begin
			computation_start <= 1'd1;
		end
		
		else begin
			computation_start <= 1'd0;
		end
	end
	
endmodule
