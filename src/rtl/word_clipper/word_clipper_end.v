module word_clipper_end(
  input iclk,
  input irstn,
  input ivalid,
  input [31:0] istart_addr,
  input [31:0] iend_addr,

  output orts,
  input irtr,
  output [31:0] ostart_addr,
  output [31:0] oend_addr
);

  reg valid_recieved0q;

  reg [31:0] start_addr0q, end_addr0q;

  always @(posedge iclk) begin
    if (~irstn) begin
      valid_recieved0q <= 1'b0;
    end else begin
      if (valid_recieved0q & irtr) begin
        if (ivalid) begin // simple trick to save a clk cycle
          valid_recieved0q <= 1'b1;
          start_addr0q <= istart_addr;
          end_addr0q <= iend_addr;
        end else begin // no input ready
          valid_recieved0q <= 1'b0;
        end
      end else if (ivalid & ~valid_recieved0q) begin
        valid_recieved0q <= 1'b1;
        start_addr0q <= istart_addr;
        end_addr0q <= iend_addr;
      end
    end
  end

  assign orts = valid_recieved0q;
  assign ostart_addr = start_addr0q;
  assign oend_addr = end_addr0q;

endmodule
