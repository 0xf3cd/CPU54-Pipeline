module CLZCounter(
	input [31:0]rs_value,
	input start,
	output busy,
	output reg [31:0]result
);

	/*
	 * 先使用组合逻辑
	 * 之后补上状态机
	 */

	 assign busy = 1'b0;
	 always @(*) begin
	 	if(rs_value[31:0] == 32'b0) begin
	 		result = 32'd32;
	 	end else if(rs_value[31:0] == 32'b1) begin
	 		result = 32'd31;
	 	end else if(rs_value[31:1] == 31'b1) begin
	 		result = 32'd30;
	 	end else if(rs_value[31:2] == 30'b1) begin
	 		result = 32'd29;
	 	end else if(rs_value[31:3] == 29'b1) begin
	 		result = 32'd28;
	 	end else if(rs_value[31:4] == 28'b1) begin
	 		result = 32'd27;
	 	end else if(rs_value[31:5] == 27'b1) begin
	 		result = 32'd26;
	 	end else if(rs_value[31:6] == 26'b1) begin
	 		result = 32'd25;
	 	end else if(rs_value[31:7] == 25'b1) begin
	 		result = 32'd24;
	 	end else if(rs_value[31:8] == 24'b1) begin
	 		result = 32'd23;
	 	end else if(rs_value[31:9] == 23'b1) begin
	 		result = 32'd22;
	 	end else if(rs_value[31:10] == 22'b1) begin
	 		result = 32'd21;
	 	end else if(rs_value[31:11] == 21'b1) begin
	 		result = 32'd20;
	 	end else if(rs_value[31:12] == 20'b1) begin
	 		result = 32'd19;
	 	end else if(rs_value[31:13] == 19'b1) begin
	 		result = 32'd18;
	 	end else if(rs_value[31:14] == 18'b1) begin
	 		result = 32'd17;
	 	end else if(rs_value[31:15] == 17'b1) begin
	 		result = 32'd16;
	 	end else if(rs_value[31:16] == 16'b1) begin
	 		result = 32'd15;
	 	end else if(rs_value[31:17] == 15'b1) begin
	 		result = 32'd14;
	 	end else if(rs_value[31:18] == 14'b1) begin
	 		result = 32'd13;
	 	end else if(rs_value[31:19] == 13'b1) begin
	 		result = 32'd12;
	 	end else if(rs_value[31:20] == 12'b1) begin
	 		result = 32'd11;
	 	end else if(rs_value[31:21] == 11'b1) begin
	 		result = 32'd10;
	 	end else if(rs_value[31:22] == 10'b1) begin
	 		result = 32'd9;
	 	end else if(rs_value[31:23] == 9'b1) begin
	 		result = 32'd8;
	 	end else if(rs_value[31:24] == 8'b1) begin
	 		result = 32'd7;
	 	end else if(rs_value[31:25] == 7'b1) begin
	 		result = 32'd6;
	 	end else if(rs_value[31:26] == 6'b1) begin
	 		result = 32'd5;
	 	end else if(rs_value[31:27] == 5'b1) begin
	 		result = 32'd4;
	 	end else if(rs_value[31:28] == 4'b1) begin
	 		result = 32'd3;
	 	end else if(rs_value[31:29] == 3'b1) begin
	 		result = 32'd2;
	 	end else if(rs_value[31:30] == 2'b1) begin
	 		result = 32'd1;
	 	end else begin
	 		result = 32'd0;
	 	end
	 end
endmodule