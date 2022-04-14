`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2022 02:13:55 PM
// Design Name: 
// Module Name: tb_euclidean_comparator
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


module tb_euclidean_comparator(

    );
    reg [3:0] iword;
    reg [63:0] idata;
    reg ivalid, iclk, irstn;
    wire [3:0] oword;
    euclidean_comparator dut1(
        .iword(iword),
        .idata(idata),
        .ivalid(ivalid),
        .iclk(iclk),
        .irstn(irstn),
        .oword(oword)
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
           idata = 16'hFFFFFFFFFFFFFFF0;
           iword = 4'd1;
           #20;
       
       for (i = 1; i < 10; i = i+1) begin
               idata = 16'hFFFFFFFFFFFFFFF0 - 4*i;
               temp = 'hFFFFFFFFFFFFFFF0 - 4*(i-1);
               iword = i+1;
               #5;
               if (oword == i) begin
                    $display("RIGHT! i = %d, oword = %d, temp = %d", (i-1), oword, temp);
                end
                else if (i != 1) begin
                    $display("WRONG! i = %d, oword = %d, temp = %d", (i-1), oword, temp);
                end
            #15;
           end
           ivalid = 1'b0;
           #20;
           irstn = 1'b0;
           #20;
           irstn = 1'b1;
           ivalid = 1'b1;
           idata = 16'd0;
           iword = 4'd2;
           #5 
           if (oword != 4'b0) begin
               $display("WRONG: ovalid = 1'b1");
           end
           #15;
       end
   
endmodule
