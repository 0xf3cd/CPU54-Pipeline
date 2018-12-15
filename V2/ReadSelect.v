module ReadSelect(
	input [31:0]addr,
	input [31:0]DMEM,
	input [31:0]Switch,
	output reg [31:0]rdata
);

	always @(*) begin
		if(addr[12:0] == 13'h1000) begin
			//Õ‚…Ë
			rdata = Switch;
		end else begin
			//DMEM
			rdata = DMEM;
		end
	end
endmodule