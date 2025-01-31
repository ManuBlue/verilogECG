`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2025 01:42:04 PM
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
package utils;

    class realNo;
        longint magnitude;
        int exponent;

        // Constructor
        function new(input longint magnitude, input int exponent);
            this.magnitude = magnitude;
            this.exponent = exponent;

            // Normalize for exponent >= 32
            if (this.exponent >= 32) begin
                int difference = this.exponent - 32;
                this.magnitude = this.magnitude * ($pow(10, difference));
                this.exponent = 32;
            end
            
            // Normalize for exponent <= -32
            else if (this.exponent <= -32) begin
                int difference = -32 - this.exponent;
                this.magnitude = this.magnitude / ($pow(10, difference));
                this.exponent = -32;
            end
        endfunction
    endclass

    // Multiplication
    function realNo mult(realNo a, realNo b);
        int newExp;
        longint newMag;
        realNo rv;
        newExp = a.exponent + b.exponent;
        newMag = a.magnitude * b.magnitude;
        rv = new(newMag, newExp);
        return rv;
    endfunction

    // Division
    function realNo divide(realNo a, realNo b);
        int newExp;
        longint newMag;
        realNo rv;
        newExp = a.exponent - b.exponent;
        newMag = a.magnitude / b.magnitude;
        rv = new(newMag, newExp);
        return rv;
    endfunction

    // Addition
    function realNo add(realNo a, realNo b);
        int diff;
        longint newMag;
        int newExp;
        realNo rv;

        // Align exponents
        if (a.exponent > b.exponent) begin
            diff = a.exponent - b.exponent;
            newMag = a.magnitude + (b.magnitude / $pow(10, diff));
            newExp = a.exponent;
        end else begin
            diff = b.exponent - a.exponent;
            newMag = (a.magnitude / $pow(10, diff)) + b.magnitude;
            newExp = b.exponent;
        end

        rv = new(newMag, newExp);
        return rv;
    endfunction

    // Subtraction
    function realNo sub(realNo a, realNo b);
        int diff;
        longint newMag;
        int newExp;
        realNo rv;

        // Align exponents
        if (a.exponent > b.exponent) begin
            diff = a.exponent - b.exponent;
            newMag = a.magnitude - (b.magnitude / $pow(10, diff));
            newExp = a.exponent;
        end else begin
            diff = b.exponent - a.exponent;
            newMag = (a.magnitude / $pow(10, diff)) - b.magnitude;
            newExp = b.exponent;
        end

        rv = new(newMag, newExp);
        return rv;
    endfunction

endpackage


module main(
        input reset,
        output reg [2:0] led
        );
        import utils::*;
        import myArrays::*;
        int temp;
        initial begin
            temp = wts1[0];
        end
endmodule