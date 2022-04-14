//author: dnicolau
//Usage: provide samples in sequential order, if the threshold criteria is met
//a correct output index will be spit out

module word_clipper(
  input iclk,
  input irstn,
  input ivalid,
  input ilast,
  input [31:0] iidx,
  input [15:0] idata,
  output reg ovalid,
  output reg [31:0] ostart_idx,
  output reg [31:0] oend_idx
);

parameter LOWER_THRESHOLD = 15'h0042;
parameter UPPER_THRESHOLD = 15'h0294;

// 0 -> idle / looking for lower threshold
// 1 -> found lower thr, looking for upper thr
// 2 -> found upper thr, looking for ending lower thr

reg [31:0] start_idx0q, end_idx0q;
reg [1:0] state0q, next_state;

//control sigs
reg start_idx_en, end_idx_en, output_idx, commit_start_idx;

always @(posedge iclk) begin
  if (!irstn) begin
    state0q <= 2'h0;
  end else begin
    state0q <= next_state;
  end
end

always @* begin
  next_state = state0q;

  //default control signal values
  start_idx_en = 1'b0;
  output_idx = 1'b0;
  end_idx_en = 1'b0;

  //idle state
  if (state0q == 2'h0) begin
    //immediately crosses upper threshold, will rarely happen
    if (idata > UPPER_THRESHOLD) begin
      start_idx_en = 1'b1;
      commit_start_idx = 1'b1;
      next_state = 2'h2;
    //lower threshold is exceeded
    end else if (idata > LOWER_THRESHOLD) begin
      start_idx_en = 1'b1;
      next_state = 2'h1;
    end

  //looking for upper threshold
  end else if (state0q == 2'h1) begin
    if (idata > UPPER_THRESHOLD) begin
        commit_start_idx = 1'b1;
        next_state = 2'h2;
    end else if (idata < LOWER_THRESHOLD) begin //back to idle, threshold not reached
      next_state = 2'h0;
    end

  //looking for end of word
  end else if (state0q == 2'h2) begin
    if (idata < LOWER_THRESHOLD || ilast) begin
      end_idx_en = 1'b1;
      next_state = 2'h3;
    end
  end else begin //output state to avoid a feedthrough
    next_state = 2'h0;
    output_idx = 1'b1;
  end
end

  //response to control signals
  always @(posedge iclk) begin
    if (start_idx_en) begin
      start_idx0q <= iidx;
    end
  end
  
  always @(posedge iclk) begin
    if (end_idx_en) begin
      end_idx0q <= iidx;
    end
  end

  always @* begin
    ostart_idx = start_idx0q;
    oend_idx = end_idx0q;
    ovalid = state0q == 2'h3;
  end


endmodule
