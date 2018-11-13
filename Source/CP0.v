module CP0(
	input clk,
	input rst,
	input mfc0,
	input [4:0]addr,
	input mtc0,
	input [31:0]data,
	input exception,
	input eret,
	input [31:0]pc,
	input [3:0]cause,
	output reg [31:0]CP0_out,
	output [31:0]status,
	output [31:0]epc_out
);
	
	reg [31:0]memory[31:0];
	integer i;
	initial begin
		for(i = 0; i <= 31; i = i + 1) begin
			memory[i] = 32'b0;
		end
	end

	// reg [31:0]status_reg = 32'b0;//12号寄存器  [3:1]分别屏蔽teq, break, systcall
	// reg [31:0]cause_reg = 32'b0;//13号寄存器  [6:2]记录异常原因
	// reg [31:0]epc_reg = 32'b0;//14号寄存器  存放PC+4
	//wire [31:0]status_reg = memory[12];
	//wire [31:0]cause_reg = memory[13];
	//wire [31:0]epc_reg = memory[14];

	reg exception_valid = 1'b0;
	always @(*) begin
		if(exception & memory[12][0]) begin
			case(cause[3:0])
				4'b1000: begin //systcall
					if(memory[12][1]) begin
						exception_valid = 1'b1;
					end else begin
						exception_valid = 1'b0;
					end
				end
				4'b1001: begin //break
					if(memory[12][2]) begin
						exception_valid = 1'b1;
					end else begin
						exception_valid = 1'b0;
					end
				end
				4'b1101: begin //teq
					if(memory[12][3]) begin
						exception_valid = 1'b1;
					end else begin
						exception_valid = 1'b0;
					end
				end
				default: begin
					exception_valid = 1'bx;
				end
			endcase
		end else begin
			exception_valid = 1'b0;
		end
	end 

	reg in_exception = 1'b0;
	always @(negedge clk or posedge rst) begin
		if(rst) begin
			memory[12] <= 32'h0000000f;
			memory[13] <= 32'b0;
			memory[14] <= 32'b0;
			in_exception <= 1'b0;
		end else begin
			if(mtc0) begin
				//mtc0有效
				// case(addr[4:0])
				// 	5'd12: begin //systcall
				// 		status_reg <= data;
				// 	end
				// 	5'd13: begin //break
				// 		cause_reg <= data;
				// 	end
				// 	5'd14: begin //teq
				// 		epc_reg <= data;
				// 	end
				// 	default: begin
				// 		status_reg <= status_reg;
				// 		cause_reg <= cause_reg;
				// 		epc_reg <= epc_reg;
				// 	end
				// endcase
				memory[addr] <= data;
			end else begin
				if(exception_valid & (~in_exception)) begin
					memory[12] <= {memory[12][26:0], 5'b0};
					memory[13] <= {26'b0 ,cause, 2'b0};
					memory[14] <= pc - 32'h4;
					in_exception <= 1'b1;
				end else if(eret & in_exception) begin
					memory[12] <= {5'b0, memory[12][31:5]};
					in_exception <= 1'b0;
				end
			end
		end
	end

	always @(*) begin
		if(mfc0) begin
			// case(addr)
			// 	5'd12: begin
			// 		CP0_out = status_reg;
			// 	end
			// 	5'd13: begin
			// 		CP0_out = cause_reg;
			// 	end
			// 	5'd14: begin
			// 		CP0_out = epc_reg;
			// 	end
			// 	default: begin
			// 		CP0_out = 32'bx;
			// 	end
			// endcase
			CP0_out = memory[addr];
		end else begin
			CP0_out = 32'bx;
		end
	end

	wire [31:0]cause_ = memory[13];
	assign status = memory[12];//status_reg;
	assign epc_out = memory[14];//epc_reg;
endmodule