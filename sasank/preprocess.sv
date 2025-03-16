module ECGPreprocess #(
    parameter SIGNAL_LENGTH = 300,        // Total number of signal samples
    parameter DATA_WIDTH    = 13,          // Bit width of each sample
    parameter HEIGHT_TH     = 13'd2000,    // Minimum height threshold
    parameter PROM_TH       = 13'd500,     // Minimum prominence threshold
    parameter DISTANCE      = 75,         // Minimum distance between peaks
    parameter OUTPUT_LENGTH = 187          // Length of the processed signal
)(
    input  logic [DATA_WIDTH-1:0] ecg_signal [0:SIGNAL_LENGTH-1],
    output logic [DATA_WIDTH-1:0] processed_signal [0:OUTPUT_LENGTH-1]
);

  // Local integer indices and counters
  integer i, j, k,temp;
  integer peak_count, filtered_count;
  integer first_peak, second_peak;
  integer seg_start, seg_end;

  // Temporary arrays to hold candidate peaks and filtered peaks
  integer candidate_peaks [0:SIGNAL_LENGTH-1];
  integer filtered_peaks  [0:SIGNAL_LENGTH-1];

  // Temporary variables for peak detection
  logic [DATA_WIDTH-1:0] left_min, right_min, baseline, prom;
  logic [DATA_WIDTH-1:0] ahh;  // Amplitude at second peak

  always_comb begin
    // Initialize output to zero
    for (i = 0; i < OUTPUT_LENGTH; i = i + 1) begin
      processed_signal[i] = '0;
    end

    // -------------------------------------------------
    // Step 1: Find candidate peaks.
    // A candidate must be a local maximum (greater than its neighbors),
    // be at least HEIGHT_TH, and have a prominence >= PROM_TH.
    // -------------------------------------------------
    peak_count = 0;
    for (i = 1; i < SIGNAL_LENGTH-1; i = i + 1) begin
      if ((ecg_signal[i] > ecg_signal[i-1]) && 
          (ecg_signal[i] > ecg_signal[i+1]) &&
          (ecg_signal[i] >= HEIGHT_TH)) begin

        // Compute left minimum (scan left until value stops rising)
        left_min = ecg_signal[i];
        j = i;
        while ((j > 0) && (ecg_signal[j-1] < ecg_signal[i])) begin
          if (ecg_signal[j-1] < left_min)
            left_min = ecg_signal[j-1];
          j = j - 1;
        end

        // Compute right minimum (scan right similarly)
        right_min = ecg_signal[i];
        j = i;
        while ((j < SIGNAL_LENGTH-1) && (ecg_signal[j+1] < ecg_signal[i])) begin
          if (ecg_signal[j+1] < right_min)
            right_min = ecg_signal[j+1];
          j = j + 1;
        end

        // Define baseline as the higher of the two minima and compute prominence.
        baseline = (left_min > right_min) ? left_min : right_min;
        prom = ecg_signal[i] - baseline;

        if (prom >= PROM_TH) begin
          candidate_peaks[peak_count] = i;
          peak_count = peak_count + 1;
        end
      end
    end

    // -------------------------------------------------
    // Step 2: Filter candidate peaks by enforcing minimum distance.
    // For peaks closer than DISTANCE, keep the one with the higher amplitude.
    // -------------------------------------------------
    filtered_count = 0;
    for (i = 0; i < peak_count; i = i + 1) begin
      if (filtered_count == 0) begin
        filtered_peaks[0] = candidate_peaks[i];
        filtered_count = 1;
      end else begin
        if ((candidate_peaks[i] - filtered_peaks[filtered_count-1]) < DISTANCE) begin
          // Replace the previous peak if current candidate has higher amplitude.
          if (ecg_signal[candidate_peaks[i]] > ecg_signal[filtered_peaks[filtered_count-1]]) begin
            filtered_peaks[filtered_count-1] = candidate_peaks[i];
          end
        end else begin
          filtered_peaks[filtered_count] = candidate_peaks[i];
          filtered_count = filtered_count + 1;
        end
      end
    end

    // -------------------------------------------------
    // Step 3: Process the segment between the first two peaks.
    // If fewer than two peaks are found, the output remains all zeros.
    // -------------------------------------------------
    if (filtered_count >= 2) begin
      first_peak  = filtered_peaks[0];
      second_peak = filtered_peaks[1];
      ahh = ecg_signal[second_peak];

      // Define segment boundaries.
      seg_start = first_peak;
      seg_end   = second_peak + 40;
      if (seg_end >= SIGNAL_LENGTH)
        seg_end = SIGNAL_LENGTH - 1;

      k = 0;
      for (i = seg_start; i <= seg_end && k < OUTPUT_LENGTH; i = i + 1, k = k + 1) begin
        processed_signal[k] = ecg_signal[i];
      end
      temp = 0;
      // Starting at the end of the segment, set values to 0 if they are below ahh,
      // and stop processing when a value >= ahh is encountered.
      for (i = k - 1; i >= 0; i = i - 1) begin
        if(!temp) begin
        if (processed_signal[i] >= ahh)
          temp = 1;  
        else
          processed_signal[i] = '0;
      end
      end
    end
    // If fewer than two peaks are found, no segment is processed.
end
endmodule
