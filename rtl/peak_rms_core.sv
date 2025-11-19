// peak_rms_core.sv
// computes per-frame peak and RMS values from AXI-Stream input.
// Exposes peak/rms results and flags threshold exceeding events.

module peak_rms_core #(parameter DATA_WIDTH = 16)(
    input logic clk,
    input logic rst_n,
    input logic signed [DATA_WIDTH-1:0] tdata,
    input logic tvalid,
    input logic tlast,
    output logic tready,
    input logic signed [DATA_WIDTH-1:0] threshold_peak,
    input logic signed [DATA_WIDTH-1:0] threshold_rms,
    output logic signed [DATA_WIDTH-1:0] peak_val,
    output logic signed [DATA_WIDTH-1:0] rms_val,
    output logic peak_exceeded,
    output logic rms_exceeded
);

    // accumulators and counters
    logic signed [DATA_WIDTH-1:0] peak_accum;
    logic [2*DATA_WIDTH-1:0] square_accum;
    logic [$clog2(65536):0] sample_count;


    // output driving regs
    logic signed [DATA_WIDTH-1:0] peak_reg;
    logic signed [DATA_WIDTH-1:0] rms_reg;

    assign peak_val = peak_reg;
    assign rms_val = rms_reg;

    assign tready = 1'b1;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            peak_accum <= '0;
            square_accum <= '0;
            sample_count <= '0;
            peak_reg <= '0;
            rms_reg <= '0;
            peak_exceeded <= 1'b0;
            rms_exceeded <= 1'b0;

        end else if(tvalid && tready) begin
            logic [DATA_WIDTH-1:0] abs_samp;
            abs_samp = (tdata < 0) ? -tdata : tdata; // get abs of sample
            if($signed(abs_samp) > $signed(peak_reg)) begin
                peak_reg <= $signed(abs_samp); // update peak if larger
                peak_exceeded <= (peak_reg > threshold_peak);
            end
            square_accum <= square_accum + $signed(tdata * tdata);
            sample_count <= sample_count + 1;
        end
    end


endmodule