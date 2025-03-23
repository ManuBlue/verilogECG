module ECGPreprocess #(
    parameter SIGNAL_LENGTH = 300,
    parameter DATA_WIDTH    = 13,
    parameter HEIGHT_TH     = 13'd3000,
    parameter OUTPUT_LENGTH = 187
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [DATA_WIDTH-1:0] ecg_signal [0:SIGNAL_LENGTH-1],
    output logic [DATA_WIDTH-1:0] processed_signal [0:OUTPUT_LENGTH-1],
    output logic done
);

    // State machine declaration
    typedef enum logic [1:0] {
        IDLE,
        FIND_PEAKS,
        PROCESS_SIGNAL,
        FINALIZE
    } state_t;

    state_t state, next_state;

    // Internal variables
    integer i, peak_count;
    integer peaks[0:SIGNAL_LENGTH-1];
    integer current_index, idx;
    logic [DATA_WIDTH-1:0] temp_signal [0:OUTPUT_LENGTH-1];
    logic j;
    logic [25:0] scaled_value;
    logic [DATA_WIDTH-1:0] copy [0:SIGNAL_LENGTH-1];
    logic [DATA_WIDTH-1:0] tempo [0:OUTPUT_LENGTH-1];
    logic [12:0] min_value, max_value, range;
    integer valid_length; // Number of valid samples from peaks[0] to peaks[1]+40 (capped at OUTPUT_LENGTH)
    integer k;

    // State machine sequential block
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: if (start) next_state = FIND_PEAKS;
            FIND_PEAKS: if (current_index >= SIGNAL_LENGTH - 1) next_state = PROCESS_SIGNAL;
            PROCESS_SIGNAL: if (current_index >= OUTPUT_LENGTH) next_state = FINALIZE;
            FINALIZE: if (idx >= OUTPUT_LENGTH) next_state = IDLE;
        endcase
    end

    // Main sequential logic block for processing
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            peak_count = 0;
            current_index = 0;
            j = 0;
            idx = 0;
            min_value = 13'h1FFF;
            max_value = 13'd0;
            // Initialize processed_signal and temp_signal arrays to zero.
            for (i = 0; i < OUTPUT_LENGTH; i = i + 1) begin
                processed_signal[i] = '0;
                temp_signal[i] = '0;
            end
            $display("Reset: All signals initialized.");
        end else begin
            case (state)
                IDLE: begin
                    peak_count = 0;
                    current_index = 0;
                    idx = 0;
                    j = 0;
                    min_value = 13'h1FFF;
                    max_value = 13'd0;
                    $display("State: IDLE");
                    if (start) begin
                        $display("Received ECG Signal:");
                        for (i = 0; i < SIGNAL_LENGTH; i = i + 1) begin
                            copy[i] = ecg_signal[i];
                            $display("%d: %d", i, ecg_signal[i]);
                        end
                    end
                end

                FIND_PEAKS: begin
                    $display("State: FIND_PEAKS, current_index: %0d", current_index);
                    if (current_index < SIGNAL_LENGTH - 1) begin
                        if (current_index > 0) begin
                            $display("Values: %d, %d, %d", copy[current_index - 1], copy[current_index], copy[current_index + 1]);
                        end
                        if (current_index > 0 &&
                            copy[current_index] > copy[current_index - 1] &&
                            copy[current_index] > copy[current_index + 1] &&
                            copy[current_index] >= HEIGHT_TH) begin
                            peaks[peak_count] = current_index;
                            peak_count = peak_count + 1;
                            $display("Peak found at index: %0d, peak_count: %0d", current_index, peak_count);
                        end
                        current_index = current_index + 1;
                    end else begin
                        current_index = 0;
                    end
                end

                PROCESS_SIGNAL: begin
                    $display("State: PROCESS_SIGNAL, current_index: %0d, peak_count: %0d", current_index, peak_count);
                    if (peak_count >= 2 && current_index < OUTPUT_LENGTH) begin
                        // Copy input signal from peaks[0] to (peaks[1] + 40)
                        if ((peaks[0] + current_index) <= (peaks[1] + 40) &&
                            (peaks[0] + current_index) < SIGNAL_LENGTH) begin
                            processed_signal[current_index] = copy[peaks[0] + current_index];
                            $display("Processed signal[%0d] = %d", current_index, copy[peaks[0] + current_index]);
                        end else begin
                            processed_signal[current_index] <= '0;
                            $display("Processed signal[%0d] = 0", current_index);
                        end
                        if (processed_signal[current_index] > max_value) max_value = processed_signal[current_index];
                        if (processed_signal[current_index] < min_value) min_value = processed_signal[current_index];
                        current_index = current_index + 1;
                    end else begin
                        current_index = current_index + 1;
                    end
                end

                FINALIZE: begin
                    if (idx < OUTPUT_LENGTH) begin
                        scaled_value = ((processed_signal[idx] - min_value) * 13'd4095) / (max_value == min_value ? 1 : max_value - min_value);
                        processed_signal[idx] = scaled_value;
                        $display(scaled_value);
                        $display("Processed signal[%0d] = %d", idx, processed_signal[idx]);
                        idx <= idx + 1;
                    end
                end
            endcase
        end
    end

    // The done signal goes high when in FINALIZE state.
    assign done = (state == FINALIZE);

endmodule