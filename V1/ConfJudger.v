module ConfJudger(
    input [31:0]if_inst,
    input id_rf_we,
    input [4:0]id_rf_waddr,
    input exe_rf_we,
    input [4:0]exe_rf_waddr,
    input mem_rf_we,
    input [4:0]mem_rf_waddr,
    output reg if_stop
);
    wire [5:0]if_op;
	wire [4:0]if_rs;
	wire [4:0]if_rt;
	wire [4:0]if_rd;
	wire [4:0]if_shamt;
	wire [5:0]if_func;
	wire [15:0]if_imm16;
	wire [25:0]if_index;
    InstructionDecoder IF_ID(
        .instruction(if_inst), 
        .op(if_op), 
        .rs(if_rs), 
        .rt(if_rt), 
        .rd(if_rd), 
        .shamt(if_shamt), 
        .func(if_func), 
        .imm16(if_imm16), 
        .index(if_index)
    );

    always @(*) begin 
        if(id_rf_we && id_rf_waddr != 5'b0) begin
            if(if_rs == id_rf_waddr) begin
                if_stop = 1'b1;
            end else if(if_rt == id_rf_waddr) begin
                if_stop = 1'b1;
            end else begin
                if_stop = 1'b0;
            end
        end else if(exe_rf_we && exe_rf_waddr != 5'b0) begin 
            if(if_rs == exe_rf_waddr) begin
                if_stop = 1'b1;
            end else if(if_rt == exe_rf_waddr) begin
                if_stop = 1'b1;
            end else begin
                if_stop = 1'b0;
            end
        end else if(mem_rf_we && mem_rf_waddr != 5'b0) begin
            if(if_rs == mem_rf_waddr) begin
                if_stop = 1'b1;
            end else if(if_rt == mem_rf_waddr) begin
                if_stop = 1'b1;
            end else begin
                if_stop = 1'b0;
            end
        end else begin 
            if_stop = 1'b0;
        end
    end
endmodule