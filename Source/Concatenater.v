//拼接器
module Concatenater(
	input [31:8]DMEM,
	input [15:0]rt_value,
	input [31:28]PC,
	input [25:0]index,
	output [31:0]out_8,
	output [31:0]out_16,
	output [31:0]out_J
);
	assign out_8 = {DMEM[31:8], rt_value[7:0]};
	assign out_16 = {DMEM[31:16], rt_value[15:0]};
	assign out_J = {PC[31:28], index[25:0], 2'b0};
endmodule