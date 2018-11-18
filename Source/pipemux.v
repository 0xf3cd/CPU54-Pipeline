module WB_DataMUX(
    input [31:0]Z,
    input [31:0]Saver,
    input sel,
    output [31:0]out
);
    /* 0 Z
     * 1 Saver
     */
    assign out = sel? Saver: Z;
endmodule

module WB_AddrMUX(
    input [4:0]rt,
    input [4:0]rd,
    input sel,
    output [4:0]out
);
    /* 0 rd
     * 1 rt
     */
    assign out = sel? rd: rt;
endmodule

module EXE_AMUX(
    input [31:0]rs_value,
    input [31:0]ze5,
    input sel,
    output [31:0]A
);
    /* 0 rs_value
     * 1 ze5
     */
    assign A = sel? ze5, rs_value;
endmodule

module EXE_BMUX(
    input [31:0]se16,
    input [31:0]ze16,
    input [31:0]rt_value,
    input [1:0]sel,
    output reg [31:0]B
);
    /* 00 se16
     * 01 ze16
     * 1x rt_value
     */
    always @(*) begin
        if(sel[1]) begin
            //1x
            B = rt_value;
        end else begin
            if(sel[0]) begin
                //01
                B = ze16;
            end else begin
                //00
                B = se16;
            end
        end 
    end
endmodule

module ID_RF_WAddrMUX(
    input [4:0]jal_rf_addr,
    input [4:0]wb_rf_addr,
    input sel,
    output [4:0]out
);
    /* 0 jal_rf_addr ($31)
     * 1 wb_rf_addr
     */
    assign out = sel? wb_rf_addr: jal_rf_addr;
endmodule

module ID_RF_WDataMUX(
    input [31:0]PC,
    input [31:0]wb_rf_data,
    input sel,
    output [31:0]out
);
    /* 0 PC
     * 1 wb_rf_data
     */
    assign out = sel? wb_rf_data: PC;
endmodule

module ID_PC_MUX(
    input [31:0]Jointer, // ||J
    input [31:0]rs_value,
    input [31:0]Adder, // PC + SignExt18
    input [1:0]sel,
    output reg [31:0]out
);
    /* 00 Jointer
     * 01 rs_value
     * 1x Adder
     */
    always @(*) begin
        if(sel[1]) begin
            //1x
            out = Adder;
        end else begin
            if(sel[0]) begin
                //01
                out = rs_value;
            end else begin
                //00
                out = Jointer;
            end
        end
    end
endmodule

module IF_PC_MUX(
    input [31:0]Adder, //PC + 4
    input [31:0]id_pc,
    input [31:0]now_pc,
    input [1:0]sel,
    output reg [31:0]out
);
    /* 00 Adder
     * 01 id_pc
     * 1x now_pc
     */
    always @(*) begin
        if(sel[1]) begin
            out = now_pc;
        end else begin
            if(sel[0]) begin
                out = id_pc;
            end else begin
                out = Adder;
            end
        end
    end
endmodule