module Extender(
	input [15:0]imm16, //SignExt16_in, ZeroExt16_in, SignExt18_in,
	input [4:0]shamt, //ZeroExt5_in,
	output [31:0]ZeroExt5_out,
	output [31:0]ZeroExt16_out,
	output [31:0]SignExt16_out,
	output [31:0]SignExt18_out
);
	assign ZeroExt5_out = {27'b0, shamt};
	assign ZeroExt16_out = {16'b0, imm16};
	assign SignExt16_out = {{16{imm16[15]}}, imm16};
	assign SignExt18_out = {{14{imm16[15]}}, imm16, 2'b0};
endmodule