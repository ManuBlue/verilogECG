module tb();
    reg reset = 0;
    wire [9:0] led;
    main kill(reset, led);

    initial begin 
        reset = 1; #10; 
        reset = 0; #10;
        $finish;
    end
endmodule