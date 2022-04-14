`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2022 05:39:20 PM
// Design Name: 
// Module Name: euclidean_distance
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


module euclidean_distance(
    input [15:0] idata_0,
    input [15:0] idata_1,
    input ivalid,
    input irstn,
    input iclk,
    input [3:0] iword,
    output [3:0] oword,
    output ovalid,
    output [63:0] odata
    );
    
    reg [63:0] sum;
    reg [63:0] temp;
    reg ovalid_reg;
    reg [3:0] oword_reg;
    
    always @ (posedge iclk) begin
        if (!irstn) begin
            sum <= 64'b0;
            ovalid_reg <= 1'b0;
            oword_reg <= 4'b0;
        end
        else begin
        if (ivalid == 1'b1) begin
            ovalid_reg <= 1'b1;
            temp = ({48'b0, idata_1} - {48'b0, idata_0})**2;
            sum <= sum + temp;
            oword_reg <= iword;
        end
        else begin
            ovalid_reg <= 1'b0;
        end
        end
        
    end
    
    assign odata = sum;
    assign ovalid = ovalid_reg;
    assign oword = oword_reg;
endmodule
