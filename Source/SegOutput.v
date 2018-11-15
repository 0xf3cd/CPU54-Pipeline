module SegOutput(
	input clk,
	input [31:0]value,
	output reg [7:0]atog,
	output reg [7:0]seg_cs
);
	wire clk_seg;
	reg [10:0]clk_div = 11'b0;
	always @(posedge clk) begin
		clk_div <= clk_div + 1'b1;
	end
	assign clk_seg = clk_div[10];

	always @(posedge clk_seg) begin
		case(seg_cs)
			8'b11111110: seg_cs <= 8'b11111101;
			8'b11111101: seg_cs <= 8'b11111011;
			8'b11111011: seg_cs <= 8'b11110111;
			8'b11110111: seg_cs <= 8'b11101111;
			8'b11101111: seg_cs <= 8'b11011111;
			8'b11011111: seg_cs <= 8'b10111111;
			8'b10111111: seg_cs <= 8'b01111111;
			8'b01111111: seg_cs <= 8'b11111110;
			default: seg_cs <= 8'b11111110;
		endcase
	end

	reg [3:0]now_to_show;
	always @(*) begin
		case(seg_cs)
			8'b11111110: now_to_show = value[3:0];
			8'b11111101: now_to_show = value[7:4];
			8'b11111011: now_to_show = value[11:8];
			8'b11110111: now_to_show = value[15:12];
			8'b11101111: now_to_show = value[19:16];
			8'b11011111: now_to_show = value[23:20];
			8'b10111111: now_to_show = value[27:24];
			8'b01111111: now_to_show = value[31:28];
			default: now_to_show = value[3:0];
		endcase
	end

	always @(*) begin
		case(now_to_show)
			4'b0000: atog = 8'b00000011;
			4'b0001: atog = 8'b10011111;
			4'b0010: atog = 8'b00100101;
			4'b0011: atog = 8'b00001101;
			4'b0100: atog = 8'b10011001;
			4'b0101: atog = 8'b01001001;
			4'b0110: atog = 8'b01000001;
			4'b0111: atog = 8'b00011111;
			4'b1000: atog = 8'b00000001;
			4'b1001: atog = 8'b00001001;
			4'b1010: atog = 8'b01100001;//E
			4'b1011: atog = 8'b11010101;//n
			4'b1100: atog = 8'b10000101;//d
			4'b1101: atog = 8'b11111101;//dash
			default: atog = 8'b11111111;//empty
		endcase
	end
endmodule