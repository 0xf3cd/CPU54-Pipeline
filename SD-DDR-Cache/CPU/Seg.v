module Seg(
	input clk,
	input [31:0]wdata,
	input we,
	output [7:0]atog,
	output [7:0]seg_cs
);
 	reg [31:0]value = 32'b0;
 	always @(negedge clk) begin
 		if(we) begin
 			value <= wdata;
 		end else begin
 			value <= value;
 		end
 	end

 	SegOutput SO(clk, value, atog, seg_cs);
endmodule