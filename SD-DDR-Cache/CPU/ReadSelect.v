module ReadSelect(
	input [31:0]addr,
	input [31:0]DMEM,
	input [31:0]SD_Status,
	input [31:0]DDR2_Status,
	input [31:0]Switch,
	input [31:0]Button,
	input [31:0]SD_RD,
	input [31:0]DDR2_RD,
	output reg [31:0]rdata
);

	always @(*) begin
		if(addr[14]) begin
			//Õ‚…Ë
			case(addr[14:0])
				15'h4014: rdata = SD_Status;
				15'h4030: rdata = DDR2_Status;
				15'h4048: rdata = Switch;
				15'h404C: rdata = Button;
				15'h4058: rdata = SD_RD;
				15'h405C: rdata = DDR2_RD;
				default: rdata = DMEM;
			endcase
		end else begin
			//DMEM
			rdata = DMEM;
		end
	end
endmodule