module tb_absolute_value();

  logic iclk, irstn, ivalid, ovalid;
  logic [15:0] idata, odata;

  absolute_value dut(.iclk(iclk), .irstn(irstn), .ivalid(ivalid), .ovalid(ovalid), .idata(idata), .odata(odata));

  initial begin
    iclk = 1'b1;
    forever
      #50 iclk = ~iclk;
  end

  initial begin
    irstn = 1'b1;
    @(posedge iclk);
    irstn = 1'b0;
    @(posedge iclk);
    irstn = 1'b1;
  end

  initial begin
    ivalid = 1'b0;
    repeat(5) @(posedge iclk);

    ivalid <= 1'b1;
    idata <= 16'h3;

    @(posedge iclk);
    ivalid <= 1'b0;
   
    @(posedge iclk);
   
    if (!ovalid) begin
      $display("tb test failed, missed ovalid timing");
      $finish;
    end

    if (odata !== 16'h3) begin
      $display("test failed");
      $finish;
    end

    @(posedge iclk);
    ivalid <= 1'b1;
    idata = 16'hFFFF;

    @(posedge iclk);
    ivalid <= 1'b0;

    @(posedge iclk);

    if (!ovalid) begin
      $display("test failed, missed ovalid");
      $finish;
    end else if (odata !== 16'h1) begin
      $display("test failed");
    end else begin
      $display("test passed");
      $finish;
    end
    

  end

endmodule
