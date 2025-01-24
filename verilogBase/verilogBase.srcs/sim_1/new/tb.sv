`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2025 11:17:18 PM
// Design Name: 
// Module Name: tb
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


module tb;
    import utils::*; // Import the realNo class and functions

    // Task to print the realNo object
    task displayRealNo(input string op, input realNo num);
        $display("%s: Magnitude = %0d, Exponent = %0d", op, num.magnitude, num.exponent);
    endtask

    initial begin
        realNo num1, num2, result;

        // Initialize test cases
        num1 = new(123456, 2);  // 123456 * 10^2
        num2 = new(789, 1);     // 789 * 10^1

        $display("=== TESTING MULTIPLICATION ===");
        result = mult(num1, num2);
        displayRealNo("Multiplication", result);

        $display("\n=== TESTING DIVISION ===");
        result = divide(num1, num2);
        displayRealNo("Division", result);

        $display("\n=== TESTING ADDITION ===");
        result = add(num1, num2);
        displayRealNo("Addition", result);

        $display("\n=== TESTING SUBTRACTION ===");
        result = sub(num1, num2);
        displayRealNo("Subtraction", result);

        // Additional edge cases
        $display("\n=== TESTING EDGE CASES ===");
        // Case 1: Large exponent difference
        num1 = new(1, 20); // 1 * 10^20
        num2 = new(1, -10); // 1 * 10^-10
        result = add(num1, num2);
        displayRealNo("Addition (large exponent diff)", result);

        // Case 2: Subtraction resulting in zero
        num1 = new(1000, 3); // 1000 * 10^3
        num2 = new(1000, 3); // 1000 * 10^3
        result = sub(num1, num2);
        displayRealNo("Subtraction (result = 0)", result);

        // Case 3: Multiplication with a zero magnitude
        num1 = new(0, 5);  // 0 * 10^5
        num2 = new(789, 1); // 789 * 10^1
        result = mult(num1, num2);
        displayRealNo("Multiplication (zero magnitude)", result);

        // Case 4: Division by a large number
        num1 = new(123456, 5);  // 123456 * 10^5
        num2 = new(789000000, 0); // 789000000 * 10^0
        result = divide(num1, num2);
        displayRealNo("Division (large divisor)", result);

        // Case 5: Negative exponent handling
        num1 = new(123, -5); // 123 * 10^-5
        num2 = new(456, -3); // 456 * 10^-3
        result = add(num1, num2);
        displayRealNo("Addition (negative exponents)", result);

        $display("\n=== TESTING COMPLETED ===");
    end

endmodule

