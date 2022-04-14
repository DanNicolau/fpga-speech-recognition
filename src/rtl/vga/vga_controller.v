module vga_controller(
    input iclk, //this should be 25.125 MHz clk
//    input irstn,

//    input ivalid,
//    input ix,
//    input iy,
//    input [3:0] ipixel_data,

    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B,
    output VGA_HS,
    output VGA_VS
);

    `define VERTICAL_BITS 10
    `define HORIZONTAL_BITS 9

    reg pixels_0q [639:0][479:0];
    reg [`VERTICAL_BITS-1:0] vrt_cnt_0q;
    reg [`HORIZONTAL_BITS-1:0] hrz_cnt_0q;
    reg vrt_cnt_en;
    wire vga_clk;
  
    //we are not going to use rstn here to save resources

    //horizontal sync logic
    always @(posedge iclk) begin
        if (hrz_cnt_0q < `HORIZONTAL_BITS'd799) begin
            hrz_cnt_0q <= hrz_cnt_0q + `HORIZONTAL_BITS'd1;
            vrt_cnt_en <= 1'b0;
        end else begin //reset
            hrz_cnt_0q <= `HORIZONTAL_BITS'd0;
            vrt_cnt_en <= 1'b1;
        end
    end

    assign VGA_HS = hrz_cnt_0q < `HORIZONTAL_BITS'd96;

    //vertical sync logic
    always @(posedge iclk) begin
        if (vrt_cnt_en) begin
            if (vrt_cnt_0q < `VERTICAL_BITS'd524) begin
                vrt_cnt_0q <= vrt_cnt_0q + `VERTICAL_BITS'd1;
            end else begin //reset
                vrt_cnt_0q <= `VERTICAL_BITS'd0;
            end
        end
    end

    assign VGA_VS = vrt_cnt_0q < `VERTICAL_BITS'd2;

    //test colors
    always @* begin
        if (hrz_cnt_0q < `HORIZONTAL_BITS'd784 &&
            hrz_cnt_0q > `HORIZONTAL_BITS'd143 &&
            hrz_cnt_0q < `VERTICAL_BITS'd515 &&
            hrz_cnt_0q > `VERTICAL_BITS'd34) begin

                //should be purplish
                VGA_R = 4'hF;
                VGA_G = 4'h1;
                VGA_B = 4'hF;

            end else begin
                VGA_R = 4'h0;
                VGA_G = 4'h0;
                VGA_B = 4'h0;
            end
    end



endmodule
