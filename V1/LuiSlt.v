module lui_32bits(b, r);
	input [15:0]b;
	output [31:0]r;

	assign r = {b[15:0], 16'b0};
endmodule

module slt_32bits(a, b, aluc, r, is_equal, is_smaller);
	input [31:0]a;
	input [31:0]b;
	input aluc;//1 slt; 0 sltu
	output [31:0]r;
	output is_equal;
	output is_smaller;
	
	wire [32:0]ar = {1'b0, a};
	wire [32:0]br = {1'b0, b};

	reg [2:0]compared_result;//分别代表a-b>0 a-b=0 a-b<0
	always @(ar or br) begin
		if(ar > br) begin
			compared_result = 3'b100;
		end else if(ar == br) begin
			compared_result = 3'b010;
		end else begin
			compared_result = 3'b001;
		end
	end //先当无符号数比较

	reg r_low = 1'b0;//表示r的最低位
	always @(*) begin
		if(aluc == 1'b1) begin//slt
			case({a[31], b[31]})
				2'b00: begin
					//a+ b+
					r_low = compared_result[0];
				end
				2'b01: begin
					//a+ b-
					r_low = 1'b0;
				end
				2'b10: begin
					//a- b+
					r_low = 1'b1;
				end
				2'b11: begin
					//a- b-
					r_low = compared_result[0];
				end
			endcase
		end else begin//sltu
			r_low = compared_result[0];
		end
	end
	/*assign r[0] = ((~aluc) & compared_result[0]) 
			    | (aluc & a[31] & (~b[31])) 
			    | (aluc & (~a[31]) & (~b[31]) & compared_result[0]) 
			    | (aluc & a[31] & b[31] & compared_result[2]);*/
	assign r[31:1] = 0;
	assign r[0] = r_low;

	assign is_equal = compared_result[1];
	assign is_smaller = compared_result[0];
endmodule

module LuiSlt(a, b, aluc, r, is_equal, is_smaller);
	input [31:0]a;
	input [31:0]b;
	input [1:0]aluc;
	output reg [31:0]r;
	output is_equal;//若a、b相等，则值为1；否则为0
	output is_smaller;//a<b则值为1；否则为0

	wire [31:0]r_lui;
	wire [31:0]r_slt;
	lui_32bits lui_(b[15:0], r_lui);
	slt_32bits slt_(a, b, aluc[0], r_slt, is_equal, is_smaller);

	always @(aluc or r_lui or r_slt) begin
		if(aluc[1]) begin//slt
			r = r_slt;
		end else begin//lui
			r = r_lui;
		end
	end
endmodule