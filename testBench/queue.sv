
 module DFF(
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk) begin
            q <= d;
    end
endmodule
 
module shiftRegister#(
    parameter length = 300
)(
    input si,
    input clk,
    input rst,
    output [length-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < length; i = i + 1) begin : shift
            if (i == 0) begin
                DFF dff_inst (
                    .clk(clk),
                    .reset(rst),
                    .d(si),
                    .q(out[i])
                );
            end
            else begin
                DFF dff_inst (
                    .clk(clk),
                    .reset(rst),
                    .d(out[i-1]),
                    .q(out[i])
                );
            end
        end
    endgenerate
endmodule
 
module queue #(
    parameter QUEUE_SIZE = 300,   // Number of stages in the shift register
    parameter DATA_WIDTH = 13     // Width of the serial data word
)(
    input  logic clk,
    input  logic rst,
    input  logic [DATA_WIDTH-1:0] serialData,
    // Declared as logic so that we can drive it with continuous assignments
    output [DATA_WIDTH-1:0] data [0:QUEUE_SIZE-1]
);
 
    // Each bit of the serial data is shifted in its own chain.
    // temp[j] is a QUEUE_SIZE-bit vector corresponding to bit j's chain.
    wire [QUEUE_SIZE-1:0] temp [DATA_WIDTH-1:0];
 
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : shift_registers
            shiftRegister #(
                .length(QUEUE_SIZE)
            ) shift_reg_inst (
                .si(serialData[i]),
                .clk(clk),
                .rst(rst),
                .out(temp[i])
            );
        end
    endgenerate
 
    // Instead of a procedural always_comb, use a generate loop to "transpose" the bit
    // matrix. For each stage (queue element) and for each bit position, directly assign:
    genvar ii, jj;
    generate
        for (ii = 0; ii < QUEUE_SIZE; ii = ii + 1) begin : data_words
            for (jj = 0; jj < DATA_WIDTH; jj = jj + 1) begin : bit_assign
                assign data[ii][jj] = temp[jj][ii];
            end
        end
    endgenerate
 
endmodule