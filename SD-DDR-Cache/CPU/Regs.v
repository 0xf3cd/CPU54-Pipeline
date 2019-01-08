module Reg_Out(
	input clk,
	input reset,
	input we,
	input [31:0]in,
	output reg [31:0]out = 32'b0
);
	always @(negedge clk or posedge reset) begin
		if(reset) begin
			out <= 32'b0;
		end else begin
			if(we) begin
				out <= in;
			end else begin
				out <= out;
			end
		end
	end
endmodule

//module Reg_In(
//	input clk,
//	input reset,
//	input [31:0]in,
//	output reg [31:0]out = 32'b0
//);
//	always @(negedge clk or posedge reset) begin
//		if(reset) begin
//			out <= 32'b0;
//		end else begin
//			out <= in;
//		end
//	end
//endmodule