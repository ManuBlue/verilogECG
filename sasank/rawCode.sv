`timescale 1 ns / 1 ns
module top (
    input logic clk,                          // Clock signal for sequential processing
    input logic rst,                          // Reset signal
    input logic [12:0] serialData,            // 13-bit serial input data
    output logic [2:0] output_rsvd            // 3-bit output
);

    reg [12:0] data [0:186];                  // Queue (data storage)
    logic [2:0] decision_out;                 // Decision Tree Output
    decisionTree_fixpt dtree (
        .features(data),
        .output_rsvd(decision_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 187; i = i + 1) begin
                data[i] <= 13'd0;
            end
        end 
        else begin
            integer i;
            for (i = 0; i < 186; i = i + 1) begin
                data[i] <= data[i + 1];       
            end
            data[186] <= serialData;         

            output_rsvd <= decision_out;     
        end
    end

endmodule


module findHeartRate(
    input logic [12:0] serialData,
    input logic start,
    input logic samplingClk,  // Recommended: 500-1000Hz
    output logic [2:0] heartRate
    );

    // Data storage for 5000 samples
    reg [12:0] testData[0:4999];  // Array to store 5000 samples
    reg [12:0] sampleIndex;       // Counter to track stored samples
    reg samplingActive;            // Flag to track sampling status

    always @(posedge samplingClk or posedge start) begin
        if (start) begin
            sampleIndex <= 0;
            samplingActive <= 1;
        end 
        else if (samplingActive && sampleIndex < 5000) begin
            testData[sampleIndex] <= serialData;  
            sampleIndex <= sampleIndex + 1;
            if (sampleIndex == 4999) begin
                samplingActive <= 0;  
                //Implement find heartRate logic here
                //(Imagine I found the heart rate for now)
            end
        end
    end

endmodule



module decisionTree_fixpt
          (  input vector_of_unsigned_logic_13 features[0:186]  ,
             output logic [2:0] output_rsvd);


  logic [2:0] output_rsvd_1;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_0;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_1;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_2;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_3;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_4;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_5;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_6;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_7;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_8;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_9;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_10;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_11;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_12;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_13;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_14;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_15;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_16;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_17;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_18;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_19;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_20;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_21;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_22;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_23;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_24;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_25;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_26;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_27;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_28;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_29;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_30;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_31;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_32;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_33;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_34;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_35;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_36;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_37;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_38;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_39;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_40;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_41;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_42;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_43;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_44;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_45;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_46;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_47;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_48;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_49;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_50;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_51;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_52;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_53;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_54;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_55;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_56;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_57;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_58;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_59;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_60;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_61;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_62;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_63;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_64;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_65;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_66;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_67;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_68;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_69;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_70;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_71;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_72;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_73;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_74;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_75;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_76;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_77;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_78;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_79;  /* ufix3 */
  logic [2:0] decisionTree_fixpt_tmp_80;  /* ufix3 */


  always_comb begin
    if (features[27] <= 13'b0110010000010) begin
      decisionTree_fixpt_tmp = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp = 3'b000;
    end
    if (features[3] <= 13'b0010000101000) begin
      decisionTree_fixpt_tmp = 3'b010;
    end
    if (features[11] <= 13'b0010101000110) begin
      decisionTree_fixpt_tmp = 3'b010;
    end
    if (features[7] <= 13'b0001100111000) begin
      decisionTree_fixpt_tmp_0 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_0 = 3'b010;
    end
    if (features[112] > 13'b0010110101110) begin
      decisionTree_fixpt_tmp_0 = 3'b000;
    end
    if (features[98] <= 13'b0100100001000) begin
      decisionTree_fixpt_tmp_0 = decisionTree_fixpt_tmp;
    end
    if (features[61] <= 13'b0000111100001) begin
      decisionTree_fixpt_tmp_1 = 3'b001;
    end
    else begin
      decisionTree_fixpt_tmp_1 = 3'b000;
    end
    if (features[44] > 13'b0010011110100) begin
      decisionTree_fixpt_tmp_1 = 3'b100;
    end
    if (features[13] <= 13'b0001011010010) begin
      decisionTree_fixpt_tmp_2 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_2 = 3'b010;
    end
    if (features[67] <= 13'b0001100010000) begin
      decisionTree_fixpt_tmp_3 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_3 = 3'b000;
    end
    if (features[33] > 13'b0010111110010) begin
      decisionTree_fixpt_tmp_3 = 3'b010;
    end
    if (features[5] > 13'b0001110110000) begin
      decisionTree_fixpt_tmp_3 = 3'b100;
    end
    if (features[2] <= 13'b0001110100000) begin
      decisionTree_fixpt_tmp_3 = 3'b000;
    end
    if (features[100] <= 13'b0010100011100) begin
      decisionTree_fixpt_tmp_4 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_4 = 3'b000;
    end
    if (features[1] > 13'b0000111111011) begin
      decisionTree_fixpt_tmp_4 = 3'b000;
    end
    if (features[7] <= 13'b0001000100101) begin
      decisionTree_fixpt_tmp_4 = 3'b010;
    end
    if (features[10] <= 13'b0001010100100) begin
      decisionTree_fixpt_tmp_4 = decisionTree_fixpt_tmp_3;
    end
    if (features[22] > 13'b0100100001101) begin
      decisionTree_fixpt_tmp_4 = 3'b010;
    end
    if (features[5] <= 13'b0000000001001) begin
      decisionTree_fixpt_tmp_4 = decisionTree_fixpt_tmp_2;
    end
    if (features[12] <= 13'b0000001101000) begin
      decisionTree_fixpt_tmp_4 = decisionTree_fixpt_tmp_1;
    end
    if (features[1] <= 13'b0000110011010) begin
      decisionTree_fixpt_tmp_4 = decisionTree_fixpt_tmp_0;
    end
    if (features[32] <= 13'b0010111100111) begin
      decisionTree_fixpt_tmp_5 = 3'b001;
    end
    else begin
      decisionTree_fixpt_tmp_5 = 3'b000;
    end
    if (features[4] <= 13'b0000101101111) begin
      decisionTree_fixpt_tmp_5 = 3'b000;
    end
    if (features[1] <= 13'b0101001001000) begin
      decisionTree_fixpt_tmp_5 = 3'b000;
    end
    if (features[44] <= 13'b0001001000110) begin
      decisionTree_fixpt_tmp_5 = 3'b000;
    end
    if (features[5] <= 13'b0001100101000) begin
      decisionTree_fixpt_tmp_6 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_6 = 3'b001;
    end
    if (features[2] > 13'b0011010100000) begin
      decisionTree_fixpt_tmp_6 = 3'b000;
    end
    if (features[2] <= 13'b0010101011010) begin
      decisionTree_fixpt_tmp_6 = decisionTree_fixpt_tmp_5;
    end
    if (features[3] <= 13'b0001000101000) begin
      decisionTree_fixpt_tmp_7 = 3'b001;
    end
    else begin
      decisionTree_fixpt_tmp_7 = 3'b000;
    end
    if (features[84] > 13'b0000101110100) begin
      decisionTree_fixpt_tmp_7 = 3'b000;
    end
    if (features[79] <= 13'b0001010000100) begin
      decisionTree_fixpt_tmp_8 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_8 = 3'b000;
    end
    if (features[99] <= 13'b0001011110101) begin
      decisionTree_fixpt_tmp_8 = decisionTree_fixpt_tmp_7;
    end
    if (features[1] <= 13'b0101010010010) begin
      decisionTree_fixpt_tmp_9 = 3'b001;
    end
    else begin
      decisionTree_fixpt_tmp_9 = 3'b000;
    end
    if (features[73] <= 13'b0001001101110) begin
      decisionTree_fixpt_tmp_9 = 3'b100;
    end
    if (features[94] <= 13'b0001101000101) begin
      decisionTree_fixpt_tmp_9 = 3'b000;
    end
    if (features[40] <= 13'b0000111100110) begin
      decisionTree_fixpt_tmp_9 = decisionTree_fixpt_tmp_8;
    end
    if (features[59] <= 13'b0010011010100) begin
      decisionTree_fixpt_tmp_10 = 3'b001;
    end
    else begin
      decisionTree_fixpt_tmp_10 = 3'b000;
    end
    if (features[36] <= 13'b0011111011111) begin
      decisionTree_fixpt_tmp_10 = 3'b000;
    end
    if (features[32] <= 13'b0010101101111) begin
      decisionTree_fixpt_tmp_11 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_11 = 3'b010;
    end
    if (features[133] <= 13'b0000101011101) begin
      decisionTree_fixpt_tmp_11 = decisionTree_fixpt_tmp_10;
    end
    if (features[30] <= 13'b0010101111010) begin
      decisionTree_fixpt_tmp_12 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_12 = 3'b001;
    end
    if (features[164] <= 13'b0001110001010) begin
      decisionTree_fixpt_tmp_12 = decisionTree_fixpt_tmp_11;
    end
    if (features[31] <= 13'b0011010000110) begin
      decisionTree_fixpt_tmp_13 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_13 = 3'b001;
    end
    if (features[59] > 13'b0010010010100) begin
      decisionTree_fixpt_tmp_13 = 3'b000;
    end
    if (features[3] > 13'b0000010001101) begin
      decisionTree_fixpt_tmp_13 = 3'b000;
    end
    if (features[36] <= 13'b0100000010000) begin
      decisionTree_fixpt_tmp_13 = 3'b000;
    end
    if (features[186] > 13'b0011100011110) begin
      decisionTree_fixpt_tmp_13 = 3'b001;
    end
    if (features[90] <= 13'b0100011010110) begin
      decisionTree_fixpt_tmp_14 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_14 = 3'b001;
    end
    if (features[139] > 13'b0011011110000) begin
      decisionTree_fixpt_tmp_14 = 3'b001;
    end
    if (features[124] <= 13'b0011001011010) begin
      decisionTree_fixpt_tmp_14 = decisionTree_fixpt_tmp_13;
    end
    if (features[179] > 13'b0111000111010) begin
      decisionTree_fixpt_tmp_14 = 3'b001;
    end
    if (features[45] <= 13'b0001100111010) begin
      decisionTree_fixpt_tmp_15 = 3'b011;
    end
    else begin
      decisionTree_fixpt_tmp_15 = 3'b000;
    end
    if (features[61] <= 13'b0100001100110) begin
      decisionTree_fixpt_tmp_15 = 3'b000;
    end
    if (features[35] > 13'b0011100101001) begin
      decisionTree_fixpt_tmp_15 = 3'b001;
    end
    if (features[54] <= 13'b0100110101000) begin
      decisionTree_fixpt_tmp_15 = decisionTree_fixpt_tmp_14;
    end
    if (features[69] <= 13'b0010001110010) begin
      decisionTree_fixpt_tmp_16 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_16 = 3'b001;
    end
    if (features[2] > 13'b0001001101010) begin
      decisionTree_fixpt_tmp_16 = 3'b000;
    end
    if (features[4] <= 13'b0010001100000) begin
      decisionTree_fixpt_tmp_16 = decisionTree_fixpt_tmp_15;
    end
    if (features[7] <= 13'b0001111100011) begin
      decisionTree_fixpt_tmp_17 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_17 = 3'b000;
    end
    if (features[9] <= 13'b0010010011010) begin
      decisionTree_fixpt_tmp_17 = 3'b000;
    end
    if (features[143] > 13'b0001000110001) begin
      decisionTree_fixpt_tmp_17 = 3'b010;
    end
    if (features[2] <= 13'b0100110010110) begin
      decisionTree_fixpt_tmp_17 = decisionTree_fixpt_tmp_16;
    end
    if (features[3] <= 13'b0000001101110) begin
      decisionTree_fixpt_tmp_18 = 3'b001;
    end
    else begin
      decisionTree_fixpt_tmp_18 = 3'b000;
    end
    if (features[50] <= 13'b0100101111100) begin
      decisionTree_fixpt_tmp_18 = decisionTree_fixpt_tmp_17;
    end
    if (features[0] <= 13'b0110111001000) begin
      decisionTree_fixpt_tmp_18 = decisionTree_fixpt_tmp_12;
    end
    if (features[27] <= 13'b0000001111000) begin
      decisionTree_fixpt_tmp_18 = decisionTree_fixpt_tmp_9;
    end
    if (features[57] <= 13'b0010101011100) begin
      decisionTree_fixpt_tmp_19 = 3'b001;
    end
    else begin
      decisionTree_fixpt_tmp_19 = 3'b000;
    end
    if (features[5] <= 13'b0000101001110) begin
      decisionTree_fixpt_tmp_19 = 3'b000;
    end
    if (features[82] > 13'b0010111100101) begin
      decisionTree_fixpt_tmp_19 = 3'b000;
    end
    if (features[3] > 13'b0000011010010) begin
      decisionTree_fixpt_tmp_19 = 3'b000;
    end
    if (features[36] <= 13'b0100001011000) begin
      decisionTree_fixpt_tmp_19 = decisionTree_fixpt_tmp_18;
    end
    if (features[42] <= 13'b0010111100000) begin
      decisionTree_fixpt_tmp_20 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_20 = 3'b100;
    end
    if (features[26] <= 13'b0000100001000) begin
      decisionTree_fixpt_tmp_21 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_21 = 3'b000;
    end
    if (features[149] > 13'b0000001110010) begin
      decisionTree_fixpt_tmp_21 = 3'b010;
    end
    if (features[1] <= 13'b0011111111100) begin
      decisionTree_fixpt_tmp_21 = decisionTree_fixpt_tmp_20;
    end
    if (features[49] <= 13'b0001110111010) begin
      decisionTree_fixpt_tmp_22 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_22 = 3'b011;
    end
    if (features[8] > 13'b0000110011001) begin
      decisionTree_fixpt_tmp_22 = 3'b010;
    end
    if (features[40] <= 13'b0001010000001) begin
      decisionTree_fixpt_tmp_22 = 3'b000;
    end
    if (features[51] <= 13'b0010010001000) begin
      decisionTree_fixpt_tmp_23 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_23 = 3'b011;
    end
    if (features[11] <= 13'b0000101011100) begin
      decisionTree_fixpt_tmp_23 = 3'b000;
    end
    if (features[55] <= 13'b0100010101110) begin
      decisionTree_fixpt_tmp_23 = 3'b000;
    end
    if (features[60] <= 13'b0001111110110) begin
      decisionTree_fixpt_tmp_24 = 3'b011;
    end
    else begin
      decisionTree_fixpt_tmp_24 = 3'b000;
    end
    if (features[17] > 13'b0001010111010) begin
      decisionTree_fixpt_tmp_24 = 3'b000;
    end
    if (features[32] <= 13'b0010100000100) begin
      decisionTree_fixpt_tmp_24 = decisionTree_fixpt_tmp_23;
    end
    if (features[4] > 13'b0001100110110) begin
      decisionTree_fixpt_tmp_24 = 3'b000;
    end
    if (features[18] <= 13'b0000001110000) begin
      decisionTree_fixpt_tmp_24 = decisionTree_fixpt_tmp_22;
    end
    if (features[58] <= 13'b0010110001010) begin
      decisionTree_fixpt_tmp_25 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_25 = 3'b010;
    end
    if (features[136] <= 13'b0000110001111) begin
      decisionTree_fixpt_tmp_26 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_26 = 3'b010;
    end
    if (features[67] <= 13'b0100110110100) begin
      decisionTree_fixpt_tmp_27 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_27 = 3'b011;
    end
    if (features[152] <= 13'b0000000111000) begin
      decisionTree_fixpt_tmp_28 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_28 = 3'b010;
    end
    if (features[1] <= 13'b0110101110010) begin
      decisionTree_fixpt_tmp_29 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_29 = 3'b010;
    end
    if (features[5] <= 13'b0001000110110) begin
      decisionTree_fixpt_tmp_30 = 3'b011;
    end
    else begin
      decisionTree_fixpt_tmp_30 = 3'b010;
    end
    if (features[52] <= 13'b0001101100000) begin
      decisionTree_fixpt_tmp_30 = 3'b000;
    end
    if (features[18] > 13'b0000000010110) begin
      decisionTree_fixpt_tmp_30 = 3'b000;
    end
    if (features[5] <= 13'b0000010011010) begin
      decisionTree_fixpt_tmp_30 = decisionTree_fixpt_tmp_29;
    end
    if (features[99] <= 13'b0000100000111) begin
      decisionTree_fixpt_tmp_31 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_31 = 3'b000;
    end
    if (features[108] > 13'b0000001011110) begin
      decisionTree_fixpt_tmp_31 = 3'b000;
    end
    if (features[105] <= 13'b0001101000110) begin
      decisionTree_fixpt_tmp_31 = 3'b000;
    end
    if (features[1] <= 13'b0010101010010) begin
      decisionTree_fixpt_tmp_31 = 3'b100;
    end
    if (features[96] <= 13'b0000000000010) begin
      decisionTree_fixpt_tmp_31 = decisionTree_fixpt_tmp_30;
    end
    if (features[185] > 13'b0000000001111) begin
      decisionTree_fixpt_tmp_31 = 3'b001;
    end
    if (features[0] <= 13'b0110001101110) begin
      decisionTree_fixpt_tmp_31 = decisionTree_fixpt_tmp_28;
    end
    if (features[3] > 13'b0101010001010) begin
      decisionTree_fixpt_tmp_31 = 3'b100;
    end
    if (features[72] <= 13'b0000000000101) begin
      decisionTree_fixpt_tmp_31 = decisionTree_fixpt_tmp_27;
    end
    if (features[23] <= 13'b0000000011110) begin
      decisionTree_fixpt_tmp_31 = decisionTree_fixpt_tmp_26;
    end
    if (features[21] <= 13'b0000001110001) begin
      decisionTree_fixpt_tmp_32 = 3'b011;
    end
    else begin
      decisionTree_fixpt_tmp_32 = 3'b000;
    end
    if (features[1] <= 13'b0111111101111) begin
      decisionTree_fixpt_tmp_32 = decisionTree_fixpt_tmp_31;
    end
    if (features[157] > 13'b0100011101111) begin
      decisionTree_fixpt_tmp_32 = 3'b001;
    end
    if (features[4] <= 13'b0000000001100) begin
      decisionTree_fixpt_tmp_32 = decisionTree_fixpt_tmp_25;
    end
    if (features[5] <= 13'b0001100011100) begin
      decisionTree_fixpt_tmp_33 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_33 = 3'b000;
    end
    if (features[8] <= 13'b0000100001010) begin
      decisionTree_fixpt_tmp_33 = 3'b000;
    end
    if (features[14] <= 13'b0000101100010) begin
      decisionTree_fixpt_tmp_34 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_34 = 3'b010;
    end
    if (features[37] <= 13'b0000111100010) begin
      decisionTree_fixpt_tmp_34 = decisionTree_fixpt_tmp_33;
    end
    if (features[123] > 13'b0001010001000) begin
      decisionTree_fixpt_tmp_34 = 3'b010;
    end
    if (features[2] <= 13'b0010011011001) begin
      decisionTree_fixpt_tmp_35 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_35 = 3'b100;
    end
    if (features[37] <= 13'b0000111010110) begin
      decisionTree_fixpt_tmp_36 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_36 = 3'b010;
    end
    if (features[4] > 13'b0001101011010) begin
      decisionTree_fixpt_tmp_36 = 3'b000;
    end
    if (features[59] <= 13'b0001011000000) begin
      decisionTree_fixpt_tmp_37 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_37 = 3'b010;
    end
    if (features[19] > 13'b0000000110110) begin
      decisionTree_fixpt_tmp_37 = 3'b000;
    end
    if (features[2] <= 13'b0011110001011) begin
      decisionTree_fixpt_tmp_38 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_38 = 3'b100;
    end
    if (features[1] > 13'b0110110010110) begin
      decisionTree_fixpt_tmp_38 = 3'b000;
    end
    if (features[2] <= 13'b0101000001010) begin
      decisionTree_fixpt_tmp_39 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_39 = 3'b000;
    end
    if (features[3] <= 13'b0010101110101) begin
      decisionTree_fixpt_tmp_39 = decisionTree_fixpt_tmp_38;
    end
    if (features[6] <= 13'b0001000001100) begin
      decisionTree_fixpt_tmp_39 = decisionTree_fixpt_tmp_37;
    end
    if (features[25] <= 13'b0000001101010) begin
      decisionTree_fixpt_tmp_39 = decisionTree_fixpt_tmp_36;
    end
    if (features[4] > 13'b0010001100111) begin
      decisionTree_fixpt_tmp_39 = 3'b000;
    end
    if (features[37] <= 13'b0011000011101) begin
      decisionTree_fixpt_tmp_40 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_40 = 3'b010;
    end
    if (features[26] <= 13'b0000111010110) begin
      decisionTree_fixpt_tmp_40 = 3'b010;
    end
    if (features[67] <= 13'b0010011111000) begin
      decisionTree_fixpt_tmp_40 = decisionTree_fixpt_tmp_39;
    end
    if (features[7] <= 13'b0000000001100) begin
      decisionTree_fixpt_tmp_41 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_41 = 3'b000;
    end
    if (features[4] <= 13'b0000001110101) begin
      decisionTree_fixpt_tmp_42 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_42 = 3'b000;
    end
    if (features[86] <= 13'b0110010111110) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_41;
    end
    if (features[26] <= 13'b0001110000000) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_40;
    end
    if (features[1] <= 13'b0011110001010) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_35;
    end
    if (features[22] <= 13'b0000001110010) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_34;
    end
    if (features[98] <= 13'b0001011110010) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_32;
    end
    if (features[81] <= 13'b0000000000100) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_24;
    end
    if (features[0] <= 13'b0101111010110) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_21;
    end
    if (features[3] <= 13'b0001101111110) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_19;
    end
    if (features[59] <= 13'b0000000000100) begin
      decisionTree_fixpt_tmp_42 = decisionTree_fixpt_tmp_6;
    end
    if (features[1] <= 13'b0110110100100) begin
      decisionTree_fixpt_tmp_43 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_43 = 3'b000;
    end
    if (features[55] > 13'b0001010100011) begin
      decisionTree_fixpt_tmp_43 = 3'b010;
    end
    if (features[95] <= 13'b0000001000000) begin
      decisionTree_fixpt_tmp_44 = 3'b011;
    end
    else begin
      decisionTree_fixpt_tmp_44 = 3'b000;
    end
    if (features[1] <= 13'b0111001110110) begin
      decisionTree_fixpt_tmp_45 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_45 = 3'b010;
    end
    if (features[9] <= 13'b0000101110111) begin
      decisionTree_fixpt_tmp_45 = decisionTree_fixpt_tmp_44;
    end
    if (features[27] <= 13'b0000110010010) begin
      decisionTree_fixpt_tmp_46 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_46 = 3'b000;
    end
    if (features[56] <= 13'b0001011100111) begin
      decisionTree_fixpt_tmp_46 = 3'b000;
    end
    if (features[6] > 13'b0010111001000) begin
      decisionTree_fixpt_tmp_46 = 3'b100;
    end
    if (features[23] <= 13'b0000001010000) begin
      decisionTree_fixpt_tmp_47 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_47 = 3'b000;
    end
    if (features[33] <= 13'b0000110001100) begin
      decisionTree_fixpt_tmp_47 = decisionTree_fixpt_tmp_46;
    end
    if (features[0] <= 13'b0111011100110) begin
      decisionTree_fixpt_tmp_48 = 3'b011;
    end
    else begin
      decisionTree_fixpt_tmp_48 = 3'b000;
    end
    if (features[56] <= 13'b0100101110010) begin
      decisionTree_fixpt_tmp_48 = decisionTree_fixpt_tmp_47;
    end
    if (features[18] <= 13'b0000001100100) begin
      decisionTree_fixpt_tmp_48 = decisionTree_fixpt_tmp_45;
    end
    if (features[25] <= 13'b0000001110110) begin
      decisionTree_fixpt_tmp_48 = decisionTree_fixpt_tmp_43;
    end
    if (features[2] <= 13'b0101110010110) begin
      decisionTree_fixpt_tmp_48 = decisionTree_fixpt_tmp_42;
    end
    if (features[0] <= 13'b0100101010001) begin
      decisionTree_fixpt_tmp_48 = decisionTree_fixpt_tmp_4;
    end
    if (features[11] <= 13'b0011001111001) begin
      decisionTree_fixpt_tmp_49 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_49 = 3'b000;
    end
    if (features[16] <= 13'b0001110011000) begin
      decisionTree_fixpt_tmp_49 = 3'b000;
    end
    if (features[31] <= 13'b0111010110000) begin
      decisionTree_fixpt_tmp_50 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_50 = 3'b010;
    end
    if (features[1] > 13'b0110001000110) begin
      decisionTree_fixpt_tmp_50 = 3'b010;
    end
    if (features[57] <= 13'b0010100111010) begin
      decisionTree_fixpt_tmp_51 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_51 = 3'b010;
    end
    if (features[138] <= 13'b0000001001000) begin
      decisionTree_fixpt_tmp_51 = decisionTree_fixpt_tmp_50;
    end
    if (features[4] <= 13'b0000111111100) begin
      decisionTree_fixpt_tmp_51 = decisionTree_fixpt_tmp_49;
    end
    if (features[87] <= 13'b0010000110010) begin
      decisionTree_fixpt_tmp_52 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_52 = 3'b001;
    end
    if (features[71] <= 13'b0011011010110) begin
      decisionTree_fixpt_tmp_53 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_53 = 3'b000;
    end
    if (features[33] <= 13'b0100111111110) begin
      decisionTree_fixpt_tmp_53 = decisionTree_fixpt_tmp_52;
    end
    if (features[52] <= 13'b0011011000100) begin
      decisionTree_fixpt_tmp_54 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_54 = 3'b010;
    end
    if (features[30] <= 13'b0100010001111) begin
      decisionTree_fixpt_tmp_55 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_55 = 3'b001;
    end
    if (features[43] <= 13'b0011111011010) begin
      decisionTree_fixpt_tmp_55 = 3'b001;
    end
    if (features[27] <= 13'b0010110100110) begin
      decisionTree_fixpt_tmp_55 = 3'b000;
    end
    if (features[86] <= 13'b0010000011101) begin
      decisionTree_fixpt_tmp_55 = decisionTree_fixpt_tmp_54;
    end
    if (features[1] <= 13'b0101100001100) begin
      decisionTree_fixpt_tmp_55 = decisionTree_fixpt_tmp_53;
    end
    if (features[1] <= 13'b0110111001110) begin
      decisionTree_fixpt_tmp_56 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_56 = 3'b001;
    end
    if (features[4] <= 13'b0000100011111) begin
      decisionTree_fixpt_tmp_56 = 3'b010;
    end
    if (features[10] > 13'b0010101001000) begin
      decisionTree_fixpt_tmp_56 = 3'b000;
    end
    if (features[0] <= 13'b0000000010100) begin
      decisionTree_fixpt_tmp_56 = 3'b010;
    end
    if (features[3] > 13'b0001100011110) begin
      decisionTree_fixpt_tmp_56 = 3'b000;
    end
    if (features[10] <= 13'b0010001111010) begin
      decisionTree_fixpt_tmp_56 = decisionTree_fixpt_tmp_55;
    end
    if (features[0] <= 13'b0110110001100) begin
      decisionTree_fixpt_tmp_57 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_57 = 3'b000;
    end
    if (features[12] <= 13'b0101111100010) begin
      decisionTree_fixpt_tmp_58 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_58 = 3'b010;
    end
    if (features[48] <= 13'b0110110000000) begin
      decisionTree_fixpt_tmp_58 = decisionTree_fixpt_tmp_57;
    end
    if (features[16] <= 13'b0100100011000) begin
      decisionTree_fixpt_tmp_58 = decisionTree_fixpt_tmp_56;
    end
    if (features[34] <= 13'b0100101110110) begin
      decisionTree_fixpt_tmp_59 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_59 = 3'b010;
    end
    if (features[1] <= 13'b0110101000100) begin
      decisionTree_fixpt_tmp_60 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_60 = 3'b000;
    end
    if (features[4] <= 13'b0001100010100) begin
      decisionTree_fixpt_tmp_60 = decisionTree_fixpt_tmp_59;
    end
    if (features[41] <= 13'b0101000000100) begin
      decisionTree_fixpt_tmp_61 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_61 = 3'b010;
    end
    if (features[0] <= 13'b0111111111001) begin
      decisionTree_fixpt_tmp_61 = 3'b000;
    end
    if (features[8] <= 13'b0001100111011) begin
      decisionTree_fixpt_tmp_61 = decisionTree_fixpt_tmp_60;
    end
    if (features[2] <= 13'b0011110010010) begin
      decisionTree_fixpt_tmp_61 = decisionTree_fixpt_tmp_58;
    end
    if (features[8] <= 13'b0000101101110) begin
      decisionTree_fixpt_tmp_61 = decisionTree_fixpt_tmp_51;
    end
    if (features[36] <= 13'b0100011010000) begin
      decisionTree_fixpt_tmp_61 = decisionTree_fixpt_tmp_48;
    end
    if (features[29] <= 13'b0010100100110) begin
      decisionTree_fixpt_tmp_62 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_62 = 3'b010;
    end
    if (features[50] <= 13'b0001000011010) begin
      decisionTree_fixpt_tmp_63 = 3'b001;
    end
    else begin
      decisionTree_fixpt_tmp_63 = 3'b100;
    end
    if (features[2] <= 13'b0011010101000) begin
      decisionTree_fixpt_tmp_63 = decisionTree_fixpt_tmp_62;
    end
    if (features[59] <= 13'b0000010001010) begin
      decisionTree_fixpt_tmp_64 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_64 = 3'b010;
    end
    if (features[26] > 13'b0001010001010) begin
      decisionTree_fixpt_tmp_64 = 3'b000;
    end
    if (features[18] <= 13'b0000010111110) begin
      decisionTree_fixpt_tmp_65 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_65 = 3'b000;
    end
    if (features[83] <= 13'b0000000001100) begin
      decisionTree_fixpt_tmp_65 = decisionTree_fixpt_tmp_64;
    end
    if (features[40] > 13'b0100101101100) begin
      decisionTree_fixpt_tmp_65 = 3'b100;
    end
    if (features[43] <= 13'b0100000100110) begin
      decisionTree_fixpt_tmp_66 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_66 = 3'b100;
    end
    if (features[58] > 13'b0100110011010) begin
      decisionTree_fixpt_tmp_66 = 3'b011;
    end
    if (features[2] <= 13'b0110111000100) begin
      decisionTree_fixpt_tmp_66 = decisionTree_fixpt_tmp_65;
    end
    if (features[130] > 13'b0001010111110) begin
      decisionTree_fixpt_tmp_66 = 3'b010;
    end
    if (features[3] <= 13'b0100000110011) begin
      decisionTree_fixpt_tmp_67 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_67 = 3'b010;
    end
    if (features[44] <= 13'b0011011000010) begin
      decisionTree_fixpt_tmp_68 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_68 = 3'b100;
    end
    if (features[26] <= 13'b0010001011101) begin
      decisionTree_fixpt_tmp_68 = decisionTree_fixpt_tmp_67;
    end
    if (features[7] <= 13'b0010110001000) begin
      decisionTree_fixpt_tmp_68 = decisionTree_fixpt_tmp_66;
    end
    if (features[1] <= 13'b0101101010010) begin
      decisionTree_fixpt_tmp_68 = decisionTree_fixpt_tmp_63;
    end
    if (features[1] <= 13'b0110011111101) begin
      decisionTree_fixpt_tmp_69 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_69 = 3'b000;
    end
    if (features[84] > 13'b0001110011010) begin
      decisionTree_fixpt_tmp_69 = 3'b010;
    end
    if (features[22] <= 13'b0000001100110) begin
      decisionTree_fixpt_tmp_70 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_70 = 3'b100;
    end
    if (features[33] <= 13'b0000001001000) begin
      decisionTree_fixpt_tmp_70 = 3'b000;
    end
    if (features[45] <= 13'b0100001011000) begin
      decisionTree_fixpt_tmp_71 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_71 = 3'b100;
    end
    if (features[130] <= 13'b0000000110001) begin
      decisionTree_fixpt_tmp_71 = decisionTree_fixpt_tmp_70;
    end
    if (features[26] <= 13'b0000010111100) begin
      decisionTree_fixpt_tmp_71 = decisionTree_fixpt_tmp_69;
    end
    if (features[102] <= 13'b0010110000000) begin
      decisionTree_fixpt_tmp_71 = decisionTree_fixpt_tmp_68;
    end
    if (features[57] <= 13'b0010000001010) begin
      decisionTree_fixpt_tmp_72 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_72 = 3'b010;
    end
    if (features[58] <= 13'b0000000010000) begin
      decisionTree_fixpt_tmp_73 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_73 = 3'b000;
    end
    if (features[6] <= 13'b0011010100100) begin
      decisionTree_fixpt_tmp_74 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_74 = 3'b100;
    end
    if (features[55] <= 13'b0010000000010) begin
      decisionTree_fixpt_tmp_74 = decisionTree_fixpt_tmp_73;
    end
    if (features[23] <= 13'b0001010100000) begin
      decisionTree_fixpt_tmp_74 = decisionTree_fixpt_tmp_72;
    end
    if (features[99] <= 13'b0001011101111) begin
      decisionTree_fixpt_tmp_75 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_75 = 3'b100;
    end
    if (features[26] <= 13'b0011110011101) begin
      decisionTree_fixpt_tmp_76 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_76 = 3'b010;
    end
    if (features[99] <= 13'b0100001101000) begin
      decisionTree_fixpt_tmp_77 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_77 = 3'b100;
    end
    if (features[2] <= 13'b0011110110110) begin
      decisionTree_fixpt_tmp_77 = decisionTree_fixpt_tmp_76;
    end
    if (features[107] > 13'b0010101111110) begin
      decisionTree_fixpt_tmp_77 = 3'b000;
    end
    if (features[1] <= 13'b0100010100010) begin
      decisionTree_fixpt_tmp_78 = 3'b100;
    end
    else begin
      decisionTree_fixpt_tmp_78 = 3'b000;
    end
    if (features[0] <= 13'b0111111101100) begin
      decisionTree_fixpt_tmp_78 = decisionTree_fixpt_tmp_77;
    end
    if (features[19] <= 13'b0110011000010) begin
      decisionTree_fixpt_tmp_79 = 3'b000;
    end
    else begin
      decisionTree_fixpt_tmp_79 = 3'b010;
    end
    if (features[3] > 13'b0010011111000) begin
      decisionTree_fixpt_tmp_79 = 3'b000;
    end
    if (features[64] > 13'b0111110000100) begin
      decisionTree_fixpt_tmp_79 = 3'b010;
    end
    if (features[13] <= 13'b0010100011110) begin
      decisionTree_fixpt_tmp_79 = 3'b100;
    end
    if (features[8] <= 13'b0010010111110) begin
      decisionTree_fixpt_tmp_79 = 3'b100;
    end
    if (features[41] <= 13'b0100010010000) begin
      decisionTree_fixpt_tmp_79 = decisionTree_fixpt_tmp_78;
    end
    if (features[0] <= 13'b0000001001111) begin
      decisionTree_fixpt_tmp_80 = 3'b010;
    end
    else begin
      decisionTree_fixpt_tmp_80 = 3'b000;
    end
    if (features[39] > 13'b0101110110110) begin
      decisionTree_fixpt_tmp_80 = 3'b000;
    end
    if (features[24] <= 13'b0111101110110) begin
      decisionTree_fixpt_tmp_80 = decisionTree_fixpt_tmp_79;
    end
    if (features[15] <= 13'b0010011001100) begin
      decisionTree_fixpt_tmp_80 = decisionTree_fixpt_tmp_75;
    end
    if (features[10] <= 13'b0001110100100) begin
      decisionTree_fixpt_tmp_80 = 3'b100;
    end
    if (features[3] <= 13'b0100000011010) begin
      output_rsvd_1 = 3'b001;
    end
    else begin
      output_rsvd_1 = 3'b000;
    end
    if (features[2] <= 13'b0010000001101) begin
      output_rsvd_1 = 3'b010;
    end
    if (features[21] <= 13'b0111101000000) begin
      output_rsvd_1 = decisionTree_fixpt_tmp_80;
    end
    if (features[33] <= 13'b0010000110010) begin
      output_rsvd_1 = decisionTree_fixpt_tmp_74;
    end
    if (features[12] <= 13'b0010010111110) begin
      output_rsvd_1 = decisionTree_fixpt_tmp_71;
    end
    
    if (features[4] <= 13'b0011001001010) begin
      output_rsvd_1 = decisionTree_fixpt_tmp_61;
    end
  end



  assign output_rsvd = output_rsvd_1;

endmodule  // decisionTree_fixpt
