`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2022 06:02:04 PM
// Design Name: 
// Module Name: tb_euclidean_distance
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


module tb_euclidean_distance(
    );
    reg [15:0] idata_0;
    reg [15:0] idata_1;
    reg [3:0] iword;
    reg ivalid;
    reg irstn;
    reg iclk;
    wire ovalid;
    wire [63:0] odata;
    wire [3:0] oword_0, oword_1;
    euclidean_distance dut0(
        .idata_0(idata_0),
        .idata_1(idata_1),
        .ivalid(ivalid),
        .irstn(irstn),
        .iclk(iclk),
        .iword(iword),
        .ovalid(ovalid),
        .oword(oword_0),
        .odata(odata)
        );
    euclidean_comparator dut1(
        .iword(oword_0),
        .idata(odata),
        .ivalid(ovalid),
        .iclk(iclk),
        .irstn(irstn),
        .oword(oword_1)
    );
    
    initial 
        begin
        iclk = 0;
        end
        always #10 iclk = ~iclk; 
        integer i, temp;
	initial begin
	   irstn = 0;
	   #35 irstn = 1;
	   ivalid = 1'b1;
	   idata_0 = 16'd16;
	   idata_1 = 16'd14;
	   iword = 4'd1;
	   #20;
	   for (i = 1; i < 10; i = i+1) begin
	       idata_0 = 16 - 2*i;
	       idata_1 = 14 - 2 * i;
	       temp = 4*(i);
	       iword = i+1;
	       #5;
	       if (ovalid == 1'b0) begin
	           $display("WRONG: ovalid = 1'b0");
	       end
	       if (odata == temp) begin
                $display("RIGHT! i = %d, odata = %d, temp = %d", (i-1), odata, temp);
            end
            else if (i != 1) begin
                $display("WRONG! i = %d, odata = %d, temp = %d", (i-1), odata, temp);
            end
        #15;
	   end
	   ivalid = 1'b0;
	   #20;
	   irstn = 1'b0;
	   #5; 
	   if (ovalid != 1'b0) begin
	       $display("WRONG: ovalid = 1'b1");
	   end
	   #15;
	   irstn = 1'b1;
	   ivalid = 1'b1;
	   idata_0 = 16'd63;
	   idata_1 = 16'd60;
	   iword = 4'd2;
	   #5 
	   if (ovalid != 1'b0) begin
	       $display("WRONG: ovalid = 1'b1");
	   end
	   #15;
	   for (i = 1; i < 10; i = i+1) begin
	       idata_0 = 63 - 3 * i;
	       idata_1 = 60 - 3 * i;
	       temp = 9*(i);
	       iword = i+2;
	       #5;
	       if (ovalid == 1'b0) begin
	           $display("WRONG: ovalid = 1'b0");
	       end
	       if (odata == temp) begin
                $display("RIGHT! i = %d, odata = %d, temp = %d", (i-1), odata, temp);
            end
            else if (i != 1) begin
                $display("WRONG! i = %d, odata = %d, temp = %d", (i-1), odata, temp);
            end
        #15;
	   end
	   
	   
	end
        
endmodule
