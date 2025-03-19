`timescale 1ns / 1ps

module tb();
    wire [2:0] dout;
    reg [2:0] select;
    reg clk;
    reg rst;

    // Instantiate the top module
    top myTop (
        .clk(clk),
        .rst(rst),
        .select(select),
        .dout(dout)
    );

    // Generate a fast clock (period = 2ns, frequency = 500 MHz)
    initial begin
        clk = 0;
        forever #1 clk = ~clk; // Toggle clock every 1ns
    end

    // Debug: Print peaks detected in the preprocess module
    always @(posedge clk) begin
        if (myTop.pp.state == 1) begin // Assuming FIND_PEAKS state is 1
            $display("Time: %0t | Peak Count: %0d | Current Index: %0d | Peak Value: %0d",
                     $time, myTop.pp.peak_count, myTop.pp.current_index, myTop.pp.ecg_signal[myTop.pp.current_index]);
        end
    end

    initial begin
        integer file; // File handle for output
        rst = 1; // Assert reset
        select = 1; // Initialize select
        #10 rst = 0; // Deassert reset after 10ns

        // Debug: Monitor state transitions in the preprocess module
        $monitor("Time: %0t | State: %0d | Done: %b", $time, myTop.pp.state, myTop.pp.done);

        // Wait for the preprocess module to finish
        wait (myTop.pp.done);

        // Debug: Print peak values and indices
        $display("Detected Peaks:");
        for (int i = 0; i < myTop.pp.peak_count; i++) begin
            $display("Peak[%0d]: Index = %0d, Value = %0d", i, myTop.pp.peaks[i], myTop.pp.ecg_signal[myTop.pp.peaks[i]]);
        end

        // Debug: Print processed signal values
        $display("Processed Signal:");
        for (int i = 0; i < 187; i++) begin
            $display("processed_signal[%0d] = %0d", i, myTop.pp.processed_signal[i]);
        end

        // Open the file for writing
        file = $fopen("D:/temp.txt", "w");
        if (file) begin
            $display("Writing processed_signal to output.txt...");
            for (int i = 0; i < 187; i++) begin
                $fdisplay(file, "processed_signal[%0d] = %0d", i, myTop.pp.processed_signal[i]);
            end
            $fclose(file);
            $display("Finished writing to output.txt.");
        end else begin
            $display("Error: Could not open file for writing.");
        end
        
        // Finish simulation
        $finish;
    end
endmodule
