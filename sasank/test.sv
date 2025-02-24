module ECGPreprocess #(parameter SIGNAL_LENGTH = 187)(
    input  logic [12:0] inputSignal [0:SIGNAL_LENGTH-1],
    output logic [12:0] processedSignal [0:SIGNAL_LENGTH-1]
);
 
    integer i;
    integer max_index, second_max_index;
    integer start_index, end_index;
    logic [12:0] max_value, second_max_value;
 
    always @(*) begin
        if (SIGNAL_LENGTH < 2) begin
            for (i = 0; i < SIGNAL_LENGTH; i = i + 1)
                processedSignal[i] = inputSignal[i];
        end else begin
            if (inputSignal[0] > inputSignal[1]) begin
                max_value         = inputSignal[0];
                max_index         = 0;
                second_max_value  = inputSignal[1];
                second_max_index  = 1;
            end else begin
                max_value         = inputSignal[1];
                max_index         = 1;
                second_max_value  = inputSignal[0];
                second_max_index  = 0;
            end
 
            for (i = 2; i < SIGNAL_LENGTH; i = i + 1) begin
                if (inputSignal[i] > max_value) begin
                    second_max_value = max_value;
                    second_max_index = max_index;
                    max_value        = inputSignal[i];
                    max_index        = i;
                end else if (inputSignal[i] > second_max_value) begin
                    second_max_value = inputSignal[i];
                    second_max_index = i;
                end
            end
 
            if (max_index < second_max_index) begin
                start_index = max_index;
                end_index   = second_max_index;
            end else begin
                start_index = second_max_index;
                end_index   = max_index;
            end
 
            for (i = 0; i < SIGNAL_LENGTH; i = i + 1)
                processedSignal[i] = 13'd0;
 
            for (i = start_index; i <= end_index; i = i + 1)
                processedSignal[i] = inputSignal[i];
        end
    end
 
endmodule
