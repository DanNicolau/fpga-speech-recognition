`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2022 09:54:21 PM
// Design Name: 
// Module Name: absolute_value
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

//takes an int and gives back the absolute value
module absolute_value(
    input iclk,
    input irstn,

    input ivalid,
    input [31:0] iidx,
    input [15:0] idata,
    output ovalid,
    output [15:0] odata,
    output [31:0] oidx
);

    reg valid_0q;
    reg [15:0] data_0q;
    reg [31:0] idx_0q;

    always @(posedge iclk) begin
        if (!irstn) begin
            valid_0q <= 1'b0;
            idx_0q <= 32'd0;
        end else begin
            valid_0q <= ivalid;
            if (ivalid) begin
                idx_0q <= iidx;
                if (idata[15]) begin
                    data_0q <= -idata; //twos complement
                end else begin
                    data_0q <= idata;
                end
            end
        end
    end

    assign ovalid = valid_0q;
    assign odata = data_0q;
    assign oidx = idx_0q;

endmodule
