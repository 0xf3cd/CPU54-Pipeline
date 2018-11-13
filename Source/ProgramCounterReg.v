module ProgramCounterReg(clock, reset, enable, data_in, data_out);
	input clock;
	input reset;
	input enable;
	input [31:0]data_in;
	output reg [31:0] data_out;
	
	initial begin
		data_out = 32'h400000;
	end

	always @(negedge clock or posedge reset) begin
		if(reset) begin
			data_out <= 32'h400000;
		end else begin
			if(enable) begin
				data_out <= data_in;
			end else begin
				data_out <= data_out;
			end
		end
	end
endmodule