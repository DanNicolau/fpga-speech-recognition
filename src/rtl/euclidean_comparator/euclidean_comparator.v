`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2022 11:30:53 AM
// Design Name: 
// Module Name: euclidean_comparator
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


module euclidean_comparator(
        input [3:0] iword,
        input [63:0] idata,
        input ivalid,
        input iclk,
        input irstn,
        output [3:0] oword
    );
    
    reg [63:0] smallest_idata;
    reg [3:0] smallest_iword;
    
    always @ (posedge iclk) begin
        if (!irstn) begin
            smallest_idata <= 64'hFFFFFFFFFFFFFFFF;
            smallest_iword <= 4'b0;
        end
        else begin
            if (ivalid) begin
                if (idata <= smallest_idata) begin
                    smallest_idata <= idata;
                    smallest_iword <= iword;
                end
            end
        end
    end
    assign oword = smallest_iword;
    
endmodule
