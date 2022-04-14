module tb_moving_average();
    parameter burst_size = 4;
    reg [15:0] idata;
    reg [31:0] iidx;
    reg iclk, irstn, ivalid;
    wire [15:0] odata;
    wire ovalid;
    wire [31:0] oidx;


    moving_average #(.BURST_SIZE(burst_size))
    dut0(
        .idata(idata),
        .iclk(iclk),
        .irstn(irstn),
        .ivalid(ivalid),
        .iidx(iidx),
        .ovalid(ovalid),
        .oidx(oidx),
        .odata(odata)
        );
    initial 
	begin
	iclk = 0;
	end
	always #10 iclk = ~iclk; 
	
	initial	begin
		irstn = 0;
		#35 irstn = 1; 
		#10 idata = 16'd0; ivalid = 1'b1; iidx = 31'd0;
		#20 idata = 16'd2; iidx = 31'd1;
		#20 idata = 16'd4; iidx = 31'd2;
		#20 idata = 16'd6; iidx = 31'd3;
		#20 idata = 16'd8; iidx = 31'd4;
		#20 idata = 16'd10; iidx = 31'd5;
		#20 idata = 16'd12; iidx = 31'd6;
		#20 ivalid = 1'b0;
		#20 irstn=1'b0; ivalid = 1'b1; 
		#20 irstn = 1'b1; idata = 16'd4; iidx = 31'd0;
		#20 idata = 16'd8; iidx = 31'd1;
		#20 idata = 16'd12; iidx = 31'd2;
		#20 idata = 16'd16; iidx = 31'd3;
		#20 idata = 16'd20; iidx = 31'd4;
		$monitor("idata=%d, ivalid=%d, iidx=%d, odata=%d, ovalid=%d, oidx=%d", idata, ivalid, iidx, odata, ovalid, oidx);
	end
	
endmodule