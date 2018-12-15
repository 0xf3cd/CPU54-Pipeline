module ConfJudger(
    input [31:0]if_inst,
    input id_isLW,
    input id_rf_we,
    input [4:0]id_rf_waddr,
    input exe_isLW,
    input exe_rf_we,
    input [4:0]exe_rf_waddr,
    input mem_isLW,
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
        if(id_isLW && id_rf_we && id_rf_waddr != 5'b0) begin
            if(if_rs == id_rf_waddr) begin
                if_stop = 1'b1;
            end else if(if_rt == id_rf_waddr) begin
                if_stop = 1'b1;
            end else begin
                if_stop = 1'b0;
            end
        end else if(exe_isLW && exe_rf_we && exe_rf_waddr != 5'b0) begin 
            if(if_rs == exe_rf_waddr) begin
                if_stop = 1'b1;
            end else if(if_rt == exe_rf_waddr) begin
                if_stop = 1'b1;
            end else begin
                if_stop = 1'b0;
            end
        end else if(mem_isLW && mem_rf_we && mem_rf_waddr != 5'b0) begin
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


// module ID_RS_MUX(
//     input [4:0]rs,
//     input [31:0]rs_value,
//     input [31:0]exe_NPC,
//     input [31:0]exe_MDU_out,
//     input [31:0]exe_Z,
//     input [31:0]mem_NPC,
//     input [31:0]mem_MDU_out,
//     input [31:0]mem_Z,
//     input [4:0]exe_rf_waddr,
//     input exe_rf_we,
//     input exe_isJAL,
//     input exe_isLW,
//     input exe_isMUL,
//     input [4:0]mem_rf_waddr,
//     input mem_rf_we,
//     input mem_isJAL,
//     input mem_isLW,
//     input mem_isMUL,
//     output reg [31:0]out = 32'b0
// );
//     always @(*) begin 
//         if(exe_rf_we && exe_rf_waddr == rs && rs != 5'b0) begin
//             if(exe_isJAL) begin
//                 out = exe_NPC;
//             end else if(exe_isMUL) begin
//                 out = exe_MDU_out;
//             end else if(exe_isLW) begin
//                 // 如果发现有 LW 冲突，则在 IF 层面已经进行处理，此时输出 32'b0
//                 out = 32'b0;
//             end else begin
//                 out = exe_Z;
//             end
//         end else begin
//             if(mem_rf_we && mem_rf_waddr == rs && rs != 5'b0) begin
//                 if(mem_isJAL) begin
//                     out = mem_NPC;
//                 end else if(mem_isMUL) begin
//                     out = mem_MDU_out;
//                 end else if(mem_isLW) begin
//                     // 如果发现有 LW 冲突，则在 IF 层面已经进行处理，此时输出 32'b0
//                     out = 32'b0;
//                 end else begin
//                     out = mem_Z;
//                 end
//             end else begin
//                 out = rs_value;
//             end
//         end
//     end
// endmodule

module ID_RSRT_MUX(
    input [4:0]rs,
    input [31:0]rs_value,
    input [4:0]rt,
    input [31:0]rt_value,
    input [31:0]exe_NPC,
    input [31:0]exe_MDU_out,
    input [31:0]exe_Z,
    input [31:0]mem_NPC,
    input [31:0]mem_MDU_out,
    input [31:0]mem_Z,
    input [4:0]exe_rf_waddr,
    input exe_rf_we,
    input exe_isJAL,
    input exe_isLW,
    input exe_isMUL,
    input [4:0]mem_rf_waddr,
    input mem_rf_we,
    input mem_isJAL,
    input mem_isLW,
    input mem_isMUL,
    output reg [31:0]rs_out = 32'b0,
    output reg [31:0]rt_out = 32'b0,
    output reg LW_conf = 1'b0
);
    reg rs_LW_conf = 1'b0;
    reg rt_LW_conf = 1'b0;

    always @(*) begin 
        if(exe_rf_we && exe_rf_waddr == rs && rs != 5'b0) begin
            if(exe_isJAL) begin
                rs_LW_conf = 1'b0;
                rs_out = exe_NPC;
            end else if(exe_isMUL) begin
                rs_LW_conf = 1'b0;
                rs_out = exe_MDU_out;
            end else if(exe_isLW) begin
                // 如果发现有 LW 冲突，则在 IF 层面已经进行处理，此时输出 32'b0
                rs_LW_conf = 1'b1;
                rs_out = 32'b0;
            end else begin
                rs_LW_conf = 1'b0;
                rs_out = exe_Z;
            end
        end else begin
            if(mem_rf_we && mem_rf_waddr == rs && rs != 5'b0) begin
                if(mem_isJAL) begin
                    rs_LW_conf = 1'b0;
                    rs_out = mem_NPC;
                end else if(mem_isMUL) begin
                    rs_LW_conf = 1'b0;
                    rs_out = mem_MDU_out;
                end else if(mem_isLW) begin
                    // 如果发现有 LW 冲突，则在 IF 层面已经进行处理，此时输出 32'b0
                    rs_LW_conf = 1'b1;
                    rs_out = 32'b0;
                end else begin
                    rs_LW_conf = 1'b0;
                    rs_out = mem_Z;
                end
            end else begin
                rs_LW_conf = 1'b0;
                rs_out = rs_value;
            end
        end
    end

    always @(*) begin 
        if(exe_rf_we && exe_rf_waddr == rt && rt != 5'b0) begin
            if(exe_isJAL) begin
                rt_LW_conf = 1'b0;
                rt_out = exe_NPC;
            end else if(exe_isMUL) begin
                rt_LW_conf = 1'b0;
                rt_out = exe_MDU_out;
            end else if(exe_isLW) begin
                // 如果发现有 LW 冲突，则在 IF 层面已经进行处理，此时输出 32'b0
                rt_LW_conf = 1'b1;
                rt_out = 32'b0;
            end else begin
                rt_LW_conf = 1'b0;
                rt_out = exe_Z;
            end
        end else begin
            if(mem_rf_we && mem_rf_waddr == rt && rt != 5'b0) begin
                if(mem_isJAL) begin
                    rt_LW_conf = 1'b0;
                    rt_out = mem_NPC;
                end else if(mem_isMUL) begin
                    rt_LW_conf = 1'b0;
                    rt_out = mem_MDU_out;
                end else if(mem_isLW) begin
                    // 如果发现有 LW 冲突，则在 IF 层面已经进行处理，此时输出 32'b0
                    rt_LW_conf = 1'b1;
                    rt_out = 32'b0;
                end else begin
                    rt_LW_conf = 1'b0;
                    rt_out = mem_Z;
                end
            end else begin
                rt_LW_conf = 1'b0;
                rt_out = rt_value;
            end
        end
    end

    always @(*) begin 
        if(rs_LW_conf || rt_LW_conf) begin
            LW_conf = 1'b1;
        end else begin
            LW_conf = 1'b0;
        end
    end
endmodule