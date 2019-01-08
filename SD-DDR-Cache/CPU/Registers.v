//IR Saver HI LO Z 需要构建
//下降沿写入

module IRReg(
	input clk,
	input write_ena,
	input [31:0]IMEM_in,
	output [31:0]instruction
);
	reg [31:0]instruction_reg = 32'b0;
	always @(negedge clk) begin
		if(write_ena) begin
			instruction_reg <= IMEM_in;
		end else begin
			instruction_reg <= instruction_reg;
		end
	end

	assign instruction = instruction_reg;
endmodule

module SaverReg(
	input clk,
	input write_ena,
	input [31:0]in,
	output [31:0]out
);
	reg [31:0]out_reg = 32'b0;
	always @(negedge clk) begin
		if(write_ena) begin
			out_reg <= in;
		end else begin
			out_reg <= out_reg;
		end
	end

	assign out = out_reg;
endmodule

module HIReg(
	input clk,
	input write_ena,
	input [31:0]in,
	output [31:0]out
);
	reg [31:0]out_reg = 32'b0;
	always @(negedge clk) begin
		if(write_ena) begin
			out_reg <= in;
		end else begin
			out_reg <= out_reg;
		end
	end

	assign out = out_reg;
endmodule

module LOReg(
	input clk,
	input write_ena,
	input [31:0]in,
	output [31:0]out
);
	reg [31:0]out_reg = 32'b0;
	always @(negedge clk) begin
		if(write_ena) begin
			out_reg <= in;
		end else begin
			out_reg <= out_reg;
		end
	end

	assign out = out_reg;
endmodule

module ZReg(
	input clk,
	input write_ena,
	input [31:0]in,
	output [31:0]out
);
	reg [31:0]out_reg = 32'b0;
	always @(negedge clk) begin
		if(write_ena) begin
			out_reg <= in;
		end else begin
			out_reg <= out_reg;
		end
	end

	assign out = out_reg;
endmodule