
module converter(
    input bigClk,
    output reg smallClk
    );
    reg [10:0] count;
    reg temp = 0;
    always @(posedge bigClk) begin
        if (temp ==0) begin
            smallClk = 0;
            temp = 1;
        end
        if (count < 2) begin
            count = count+1;
        end else begin 
            smallClk = ~smallClk;
            count = 0;
        end
    end
endmodule
