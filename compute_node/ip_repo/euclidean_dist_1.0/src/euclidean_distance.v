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
    input [31:0] idata_0,
    input [31:0] idata_1,
    input ivalid,
    input irstn,
    input iclk,
    input iack,
    output ovalid,
    output [63:0] odata
    );

    reg [31:0] temp;
    reg ivalid_inter;
    reg [63:0] mult_out;
    reg ovalid_reg;

    always @ (posedge iclk) begin
        if(!irstn) begin
            ivalid_inter <= 1'b0;
        end 
        else begin
            ivalid_inter <= ivalid;
        end
    end
    
    always @ (posedge iclk) begin
        if (!irstn) begin
            ovalid_reg <= 1'b0;
            temp <= 32'd0;
            mult_out <= 64'd0;
        end
        else begin
            if (ivalid == 1'b1 && ivalid_inter == 1'b0 && iack == 1'b0) begin
                temp <= (idata_1 > idata_0) ? ({32'b0, idata_1} - {32'b0, idata_0}) : ({32'b0, idata_0} - {32'b0, idata_1}); 
                ovalid_reg <= 1'b0;
                mult_out <= mult_out;
            end
            
            else if (ivalid == 1'b0 && ivalid_inter == 1'b1 && iack == 1'b0) begin
                temp <= temp;
                mult_out <= temp * temp;
                ovalid_reg <= 1'b1;
            end
            
            else if (ivalid == 1'b0  && ivalid_inter == 1'b0 && iack == 1'b1) begin
                ovalid_reg <= 1'b0;
                temp <= temp;
                mult_out <= mult_out;
            end
            
            else begin
                ovalid_reg <= ovalid_reg;
                temp <= temp;
                mult_out <= mult_out;
            end
        end

    end

    assign odata = mult_out;
    assign ovalid = ovalid_reg;

endmodule