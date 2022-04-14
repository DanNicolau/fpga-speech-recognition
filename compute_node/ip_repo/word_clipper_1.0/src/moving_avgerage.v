// moving average: assume a stream of input that is 16-bit wide. 
// calculate the average of the last BURST_SIZE-1:0 elements passed in
// Assumptions:
    // BURST_SIZE is a power of 2
    // average is calculated only if ivalid high
    // output is valid if ovalid high. ovalid will remain high as long as number of input has exceed BURST_SIZE and i_valid is high. 
// Inputs:
    // idata = data to be taken average of 
    // iclk = clock
    // irstn = active low resetn
    // ivalid = valid signal to start computing 
// Output:
    // ovalid= = valid signal for output
    // odata = average of last BURST_SIZE number of idata
module moving_average #(
		parameter BURST_SIZE = 16
)(
        input [15:0] idata,
        input [31:0] iidx,
        input iclk,
        input irstn,
        input ivalid,
        output ovalid,
        output [31:0] oidx,
        output [15:0] odata

    );
    // declare regs and integers
    integer i;
    reg [20:0] odata_reg;
    reg [15:0] tmp [BURST_SIZE-1:0];
    reg [7:0] burst_counter;
    reg [31:0] oidx_reg [BURST_SIZE-1:0];
    reg ovalid_reg;

    // outputs are visible in the next clock cycle
    always @ (posedge iclk)
    begin
        if (!irstn) begin
            odata_reg <= 21'b0;
            burst_counter <= 8'b0;
            // initiliaze tmp with 0s, which will hold the last BUST_SIZE number of inputs
            for (i = 0; i < BURST_SIZE; i=i+1)begin
                tmp[i] <= 16'b0;
                oidx_reg[i] <= 32'b0;
            end
            ovalid_reg <= 1'b0;
        end
        else if (ivalid) begin
            if (burst_counter < BURST_SIZE-1) begin
                // output is valid if we received at least BURST_SIZE number of inputs
                // and ivalid is high
                ovalid_reg <= 1'b0;
            end
            else begin
                ovalid_reg <= 1'b1;
            end
            burst_counter <= burst_counter + 1;
            for (i = 0; i < BURST_SIZE-1; i=i+1) begin
                tmp[i] <= tmp[i+1]; // shift tmp to the left
                oidx_reg[i] <= oidx_reg[i+1];
            end
            tmp[BURST_SIZE-1] <= idata; // add newest data to the end
            oidx_reg[BURST_SIZE-1] <= iidx;
            odata_reg <= odata_reg - {5'b0, tmp[0]} + {5'b0, idata}; // compute newest sum
        end
        else begin
            // output not valid after 1 cycle of ivalid negedge
            ovalid_reg <= 1'b0;
        end
    end

    assign ovalid = ovalid_reg;
    assign odata = odata_reg >> $clog2(BURST_SIZE); // take average by shifting 
    assign oidx = oidx_reg[0];
endmodule