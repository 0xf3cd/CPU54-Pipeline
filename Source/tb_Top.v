`timescale 1ns / 1ps

module tb();
    reg clk;
    reg reset;
    wire [7:0]atog;
    wire [7:0]seg_cs;

    Top top_(clk, reset, atog, seg_cs);

    initial begin
        $dumpfile("./tb1.vcd");
        $dumpvars;
    end 

    initial begin
        reset = 0;
    end

    initial begin
        clk = 0;
        repeat(3000) begin
            #1
            clk = ~clk;
        end
    end
endmodule