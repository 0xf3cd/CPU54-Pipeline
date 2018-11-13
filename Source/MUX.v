module PCMUX(
	input [31:0]ALU,
	input [31:0]Z,
	input [31:0]out_J,
	input [31:0]rs_value,
	input [31:0]EPC,
	input [2:0]sel,
	output reg[31:0]out
);
	/*
	 * 000 ALU
	 * 001 Z
	 * 010 out_J
	 * 011 rs_value
	 * 100 EPC
	 * else 0x4
	 */
	always @(*) begin
		case(sel)
			3'b000: out = ALU;
			3'b001: out = Z;
			3'b010: out = out_J;
			3'b011: out = rs_value;
			3'b100: out = EPC;
			default: out = 32'h00400004;
		endcase
	end
endmodule

module SaverMUX(
	input [31:0]DMEM,
	input [31:0]CP0_out,
	input sel,
	output [31:0]out
);
	/*
	 * 0 CP0_out
	 * 1 DMEM
	 */
	assign out = sel? DMEM: CP0_out;
endmodule

module RegFileAddrMUX(
	input [4:0]rs,
	input [4:0]rt,
	input [4:0]rd,
	input [1:0]sel,
	output reg [4:0]out
);
	/*
	 * 00 rs
	 * 01 rt
	 * 10 rd
	 * 11 $31
	 */
	always @(*) begin
		case(sel)
			2'b00: out = rs;
			2'b01: out = rt;
			2'b10: out = rd;
			2'b11: out = 5'd31;
		endcase
	end
endmodule

module RegFileDataMUX(
	input [31:0]Z,
	input [31:0]SignExt8,
	input [31:0]ZeroExt8,
	input [31:0]SignExt16,
	input [31:0]ZeroExt16,
	input [31:0]Saver,
	input [31:0]PC,
	input [31:0]CLZ_result,
	input [31:0]HI,
	input [31:0]LO,
	input [31:0]MDU_r2,
	input [3:0]sel,
	output reg [31:0]out
);
	/*
	 * 0000 Z
	 * 0001 SignExt8
	 * 0010 ZeroExt8
	 * 0011 SignExt16
	 * 0100 ZeroExt16
	 * 0101 Saver
	 * 0110 PC
	 * 0111 CLZ_result
	 * 1000 HI
	 * 1001 LO
	 * 1010 MDU_r2
	 */
	always @(*) begin
	 	case(sel)
	 		4'b0000: out = Z;
	 		4'b0001: out = SignExt8;
	 		4'b0010: out = ZeroExt8;
	 		4'b0011: out = SignExt16;
	 		4'b0100: out = ZeroExt16;
	 		4'b0101: out = Saver;
	 		4'b0110: out = PC;
	 		4'b0111: out = CLZ_result;
	 		4'b1000: out = HI;
	 		4'b1001: out = LO;
	 		4'b1010: out = MDU_r2;
	 		default: out = 32'bx;
	 	endcase
	end
endmodule

module SignExt16MUX(
	input [15:0]imm16,
	input [15:0]Saver,
	input sel,
	output [15:0]out
);
	/*
	 * 0 Saver
	 * 1 imm16
	 */
	assign out = sel? imm16: Saver;
endmodule

module ZeroExt16MUX(
	input [15:0]imm16,
	input [15:0]Saver,
	input sel,
	output [15:0]out
);
	/*
	 * 0 Saver
	 * 1 imm16
	 */
	assign out = sel? imm16: Saver;
endmodule

module HIMUX(
	input [31:0]rs_value,
	input [31:0]MDU_r1,
	input sel,
	output [31:0]out
);
	/*
	 * 0 MDU_r1
	 * 1 rs_value
	 */
	assign out = sel? rs_value: MDU_r1;
endmodule

module LOMUX(
	input [31:0]rs_value,
	input [31:0]MDU_r2,
	input sel,
	output [31:0]out
);
	/*
	 * 0 MDU_r2
	 * 1 rs_value
	 */
	assign out = sel? rs_value: MDU_r2;
endmodule

module ALUAMUX(
	input [31:0]PC,
	input [31:0]rs_value,
	input [31:0]ZeroExt5,
	input [1:0]sel,
	output reg [31:0]out
);
	/*
	 * 00 PC
	 * 01 rs_value
	 * 10 ZeroExt5
	 */
	always @(*) begin
		case(sel)
			2'b00: out = PC;
			2'b01: out = rs_value;
			2'b10: out = ZeroExt5;
			2'b11: out = 32'bx;
		endcase
	end
endmodule

module ALUBMUX(
	input [31:0]SignExt16,
	input [31:0]ZeroExt16,
	input [31:0]rt_value,
	input [31:0]SignExt18,
	input [2:0]sel,
	output reg [31:0]out
);
	/*
	 * 000 SignExt16
	 * 001 ZeroExt16
	 * 010 rt_value
	 * 011 SignExt18
	 * 100 4
	 */
	always @(*) begin
		case(sel)
			3'b000: out = SignExt16;
			3'b001: out = ZeroExt16;
			3'b010: out = rt_value;
			3'b011: out = SignExt18;
			3'b100: out = 32'd4;
			default: out = 32'bx;
		endcase
	end
endmodule

module DMEMMUX(
	input [31:0]out_8,
	input [31:0]out_16,
	input [31:0]rt_value,
	input [1:0]sel,
	output reg [31:0]out
);
	/*
	 * 00 out_8
	 * 01 out_16
	 * 10 rt_value
	 */
	always @(*) begin
		case(sel)
			2'b00: out = out_8;
			2'b01: out = out_16;
			2'b10: out = rt_value;
			default: out = 32'bx;
		endcase
	end
endmodule