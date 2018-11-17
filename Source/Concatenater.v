//拼接器
module Concatenater(
	input [31:28]PC,
	input [25:0]index,
	output [31:0]out_J
);
	assign out_J = {PC[31:28], index[25:0], 2'b0};
endmodule