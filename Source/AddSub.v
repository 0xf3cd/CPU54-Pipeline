module cla_4bits(g, p, carry_in, carry_out, g_out, p_out);//根据输入的4位进位产生函数以及4位进位传递函数，得到4位进位结果
	input [3:0]g;
	input [3:0]p;
	input carry_in;
	output [4:1]carry_out;
	output g_out;//4位超前进位加法器的进位产生函数
	output p_out;//4位超前进位加法器的进位传递函数

	assign carry_out[1] = g[0]
					    | (p[0] & carry_in); 
	assign carry_out[2] = g[1]
					    | (p[1] & g[0])
					    | (p[1] & p[0] & carry_in); 
	assign carry_out[3] = g[2]
					    | (p[2] & g[1])
					    | (p[2] & p[1] & g[0])
					    | (p[2] & p[1] & p[0] & carry_in); 
	assign carry_out[4] = g[3]
					    | (p[3] & g[2])
					    | (p[3] & p[2] & g[1])
					    | (p[3] & p[2] & p[1] & g[0])
					    | (p[3] & p[2] & p[1] & p[0] & carry_in); 

	//carry_out[4]=(g[3]+p[3]*carry_out[3])
	//			  =g[3]+p[3]*g[2]+p[3]*p[2]*g[1]+p[3]*p[2]*p[1]*g[0]+p[3]*p[2]*p[1]*p[0]*carry_in
	//			  =g_out                                            +p_out*carry_in
	assign g_out = g[3]
				 | (p[3] & g[2])
				 | (p[3] & p[2] & g[1])
				 | (p[3] & p[2] & p[1] & g[0]);
	assign p_out = p[3] & p[2] & p[1] & p[0];
endmodule


module Adder_1bit(a, b, carry_in, sum, g, p);//1位超前进位加法器
	input a;
	input b;
	input carry_in;
	output sum;
	output g;//1位超前进位加法器产生函数
	output p;//1位超前进位加法器的传递函数

	assign sum = a ^ b ^ carry_in;
	assign g = a & b;
	assign p = a | b;
endmodule

module Adder_4bits(a, b, carry_in, sum, g_out, p_out);//4位超前进位加法器
	input [3:0]a;
	input [3:0]b;
	input carry_in;
	output [3:0]sum;
	output g_out;//4位超前进位加法器的进位产生函数
	output p_out;//4位超前进位加法器的进位传递函数

	wire [3:0]g;
	wire [3:0]p;
	wire [4:1]carry;

	Adder_1bit Adder_1bit_1(a[0], b[0], carry_in, sum[0], g[0], p[0]);
	Adder_1bit Adder_1bit_2(a[1], b[1], carry[1], sum[1], g[1], p[1]);
	Adder_1bit Adder_1bit_3(a[2], b[2], carry[2], sum[2], g[2], p[2]);
	Adder_1bit Adder_1bit_4(a[3], b[3], carry[3], sum[3], g[3], p[3]);

	cla_4bits CLA(g, p, carry_in, carry, g_out, p_out);
endmodule

module Adder_16bits(a, b, carry_in, sum, g_out, p_out);//16位超前进位加法器
	input [15:0]a;
	input [15:0]b;
	input carry_in;
	output [15:0]sum;
	output g_out;//16位超前进位加法器的进位产生函数
	output p_out;//16位超前进位加法器的进位传递函数

	wire [3:0]g;
	wire [3:0]p;
	wire [4:1]carry;

	Adder_4bits Adder_4bits_1(a[3:0], b[3:0], carry_in, sum[3:0], g[0], p[0]);
	Adder_4bits Adder_4bits_2(a[7:4], b[7:4], carry[1], sum[7:4], g[1], p[1]);
	Adder_4bits Adder_4bits_3(a[11:8], b[11:8], carry[2], sum[11:8], g[2], p[2]);
	Adder_4bits Adder_4bits_4(a[15:12], b[15:12], carry[3], sum[15:12], g[3], p[3]);

	//cla_4bits可通用
	cla_4bits CLA(g, p, carry_in, carry, g_out, p_out);
endmodule

module Adder_32bits(a,b,carry_in,sum,carry_out);//32位超前进位加法器
	input [31:0]a;
	input [31:0]b;
	input carry_in;
	output [31:0]sum;
	output carry_out;

	wire carry_temp;
	wire [1:0]g;
	wire [1:0]p;
	
	assign carry_temp = g[0]
					  | (p[0] & carry_in);
	assign carry_out = g[1]
					 | (p[1] & g[0])
					 | (p[1] & p[0] & carry_in);

	Adder_16bits Adder_16bits_1(a[15:0], b[15:0], carry_in, sum[15:0], g[0], p[0]);
	Adder_16bits Adder_16bits_2(a[31:16], b[31:16], carry_temp, sum[31:16], g[1], p[1]);
endmodule

module Adder_64bits(a, b, carry_in, sum, carry_out);//64位超前进位加法器
	input [63:0]a;
	input [63:0]b;
	input carry_in;
	output [63:0]sum;
	output carry_out;

	wire [3:0]g;
	wire [3:0]p;
	wire [4:1]carry;
	wire g_out;
	wire p_out;

	Adder_16bits adder_16_1(a[15:0], b[15:0], carry_in, sum[15:0], g[0], p[0]);
	Adder_16bits adder_16_2(a[31:16], b[31:16], carry[1], sum[31:16], g[1], p[1]);
	Adder_16bits adder_16_3(a[47:32], b[47:32], carry[2], sum[47:32], g[2], p[2]);
	Adder_16bits adder_16_4(a[63:48], b[63:48], carry[3], sum[63:48], g[3], p[3]);

	cla_4bits CLA(g, p, carry_in, carry, g_out, p_out);

	assign carry_out = carry[4];
endmodule

module negate_32bits(to_operate, operator, result);
	input [31:0]to_operate;
	input operator;//为1做减法
	output [31:0]result;

	assign result[0] = operator ^ to_operate[0];
	assign result[1] = operator ^ to_operate[1];
	assign result[2] = operator ^ to_operate[2];
	assign result[3] = operator ^ to_operate[3];
	assign result[4] = operator ^ to_operate[4];
	assign result[5] = operator ^ to_operate[5];
	assign result[6] = operator ^ to_operate[6];
	assign result[7] = operator ^ to_operate[7];
	assign result[8] = operator ^ to_operate[8];
	assign result[9] = operator ^ to_operate[9];
	assign result[10] = operator ^ to_operate[10];
	assign result[11] = operator ^ to_operate[11];
	assign result[12] = operator ^ to_operate[12];
	assign result[13] = operator ^ to_operate[13];
	assign result[14] = operator ^ to_operate[14];
	assign result[15] = operator ^ to_operate[15];
	assign result[16] = operator ^ to_operate[16];
	assign result[17] = operator ^ to_operate[17];
	assign result[18] = operator ^ to_operate[18];
	assign result[19] = operator ^ to_operate[19];
	assign result[20] = operator ^ to_operate[20];
	assign result[21] = operator ^ to_operate[21];
	assign result[22] = operator ^ to_operate[22];
	assign result[23] = operator ^ to_operate[23];
	assign result[24] = operator ^ to_operate[24];
	assign result[25] = operator ^ to_operate[25];
	assign result[26] = operator ^ to_operate[26];
	assign result[27] = operator ^ to_operate[27];
	assign result[28] = operator ^ to_operate[28];
	assign result[29] = operator ^ to_operate[29];
	assign result[30] = operator ^ to_operate[30];
	assign result[31] = operator ^ to_operate[31];
endmodule

module AddSub(a, b, aluc, r, carry, overflow);//32位加法减法电路
	input [31:0]a;
	input [31:0]b;
	input aluc;//表示
	output [31:0]r;
	output carry;//CF标志
	output overflow;//OF标志

	wire [31:0]b_to_add;
	wire carry_in;
	wire carry_out;
	
	//做减法时，对于有符号和无符号操作，b都需求补再进行运算
	negate_32bits negate_(b, aluc, b_to_add);//做减法时，b_to_add为b取反；做加法时b_to_add为b
	assign carry_in = aluc ? 1: 0;//做减法时，需要在b取反的基础上加1,得到补码，即加法器的carry_in置1

	Adder_32bits Adder_(a, b_to_add, carry_in, r, carry_out);//若做减法，则为a与b的补码相加；否则为a和b相加

	//无符号数影响CF
	//有符号数影响OF
	assign overflow = ((~a[31]) & (~b_to_add[31]) & r[31])
				    | (a[31] & b_to_add[31] & (~r[31]));
	assign carry = (aluc & (~carry_out))
				 | ((~aluc) & carry_out);
endmodule