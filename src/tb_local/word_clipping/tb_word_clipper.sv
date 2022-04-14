module tb_word_clipper();

  logic iclk, irstn, ivalid, ilast, ovalid;
  logic [31:0] iidx, start_idx, oend_idx;
  logic [15:0] idata;

  word_clipper dut(.*);

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
    ilast = 1'b0;
    iidx = 32'h0;

    repeat(3) @(posedge iclk);

    //test for staying under the lower threshold
    
    for (int i = 0; i < 100; i++) begin
      @(posedge iclk);
      iidx <= iidx + 32'h1;
      idata <= 16'h0;
      ivalid <= 1'b1;
    end
    
    for (int i = 15'h0; i < 15'h0100; i++) begin
      @(posedge iclk);
        iidx <= iidx + 32'h1;
      idata <= i;
      ivalid <= 1'b1;
    end
    for (int i = 15'h0100; i > 15'h0; i--) begin
      @(posedge iclk);
        iidx <= iidx + 32'h1;
      idata <= i;
      ivalid <= 1'b1;
    end

    for (int i = 0; i < 100; i++) begin
      @(posedge iclk);
        iidx <= iidx + 32'h1;
      idata <= 16'h0;
      ivalid <= 1'b1;
    end

    //There should be no ovalid at this point
    
    //test for hitting the upper threshold
    for (int i = 0; i < 100; i++) begin
      @(posedge iclk);
        iidx <= iidx + 32'h1;
      idata <= 16'h0;
      ivalid <= 1'b1;
    end
    
    for (int i = 15'h0; i < 15'hFFFF; i++) begin
      @(posedge iclk);
        iidx <= iidx + 32'h1;
      idata <= i;
      ivalid <= 1'b1;
    end

    for (int i = 0; i < 100; i++) begin
      @(posedge iclk);
      iidx <= iidx + 32'h1;
      idata <= 16'h0;
      ivalid <= 1'b1;
    end

    //ovalid should have been raised here
    
    $display("check waveform for one ovalid");
    $finish;
    
  end

endmodule
