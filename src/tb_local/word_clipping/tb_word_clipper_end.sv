module tb_word_clipper_end();

  logic iclk, irstn, ivalid, orts, irtr;
  logic [31:0] istart_addr, iend_addr, ostart_addr, oend_addr;

  word_clipper_end dut(.*);
  
  initial begin
    iclk = 1'b1;
    forever
      #5 iclk = ~iclk;
  end

  initial begin
    irstn = 1'b1;
    @(posedge iclk);
    irstn = 1'b0;
    @(posedge iclk);
    irstn = 1'b1;
  end

  initial begin
    repeat(3) @(posedge iclk);

    ivalid <= 1'b1;
    istart_addr <= 32'h2;
    iend_addr <= 32'h3;
    @(posedge iclk);
    ivalid <= 1'b0;
    istart_addr <= 32'hx;
    iend_addr <= 32'hx;
    repeat(7) @(posedge iclk);

    irtr <= 1'b1;
    @(posedge iclk);
    irtr <= 1'b0;

    @(posedge iclk);
    $finish;

  end

endmodule
