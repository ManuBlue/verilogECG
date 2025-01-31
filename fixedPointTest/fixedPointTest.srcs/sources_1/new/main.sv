`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2025 06:44:59 PM
// Design Name: 
// Module Name: main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main(
        input clk,
        output reg o
        );
        reg signed [32:0] a, b, c;
        reg signed [15:0] ab; 
        always @(*) begin
            a = 16'd0003_6250;  // 3.6250  8'b0011_1010
            b = 8'b0100_0001;  // 4.0625
            c = a + b + clk;         // 0111.1011 = 7.6875
            $display(a);
            if(c>8'b1000_1000) begin
                o = 1;
            end
            else begin
                o = 0;
            end
        end
endmodule
