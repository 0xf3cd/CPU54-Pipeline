module PcInstSaver(
    input clk,
    input [31:0]pc,
    input [31:0]inst,
    input stop,
    output reg [31:0]previous_pc,
    output reg [31:0]previous_inst
);
    always @(negedge clk) begin
        if(stop) begin
            previous_inst <= previous_inst;
            previous_pc <= previous_pc;
        end else begin
            previous_inst <= inst;
            previous_pc <= pc;
        end
    end
endmodule