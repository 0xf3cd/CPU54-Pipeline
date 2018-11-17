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
    /* 00 rd
     * 01 rt
     * 1x rt_value
     */
    always @(*) begin
        if(sel[1]) begin
            //1x
            B = rt_value;
        end else begin
            if(sel[0]) begin
                //00
                B = se16;
            end else begin
                //01
                B = ze16;
            end
        end 
    end
endmodule