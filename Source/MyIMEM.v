// module imem (
//   a,
//   spo
// );

// input wire [10 : 0] a;
// output wire [31 : 0] spo;

module imem(a, spo);
	input wire [10 : 0] a;
	output wire [31 : 0] spo;

	reg [31:0]memory[0:2047];

	integer i;
	initial begin
		for(i = 0; i <= 2047; i = i + 1) begin
			memory[i] = 32'b0;
		end
		$readmemh(("./hex/_4_jr.hex.txt"), memory);
	end

	assign spo = memory[a];
endmodule