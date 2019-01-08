module Extender(
	input [15:0]SignExt16_in,
	input [15:0]ZeroExt16_in,
	input [15:0]SignExt18_in,
	input [7:0]SignExt8_in,
	input [7:0]ZeroExt8_in,
	input [4:0]ZeroExt5_in,
	output [31:0]SignExt16_out,
	output [31:0]ZeroExt16_out,
	output [31:0]SignExt18_out,
	output [31:0]SignExt8_out,
	output [31:0]ZeroExt8_out,
	output [31:0]ZeroExt5_out
);
	assign SignExt16_out = {{16{SignExt16_in[15]}}, SignExt16_in};
	assign ZeroExt16_out = {16'b0, ZeroExt16_in};
	assign SignExt18_out = {{14{SignExt18_in[15]}}, SignExt18_in, 2'b0};
	assign SignExt8_out = {{24{SignExt8_in[7]}}, SignExt8_in};
	assign ZeroExt8_out = {24'b0, ZeroExt8_in};
	assign ZeroExt5_out = {27'b0, ZeroExt5_in};
endmodule