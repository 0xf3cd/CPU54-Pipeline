module Top(
	input clk_100,
	input reset,
	output [7:0]atog,
	output [7:0]seg_cs
); 

	wire clk_cpu;
	//clk_wiz_0 clk_div(.clk_out1(clk_cpu), .reset(reset), .locked(), .clk_in1(clk_100));
	assign clk_cpu = clk_100;


	wire [31:0]pc;
	wire [31:0]inst;
	wire [31:0]addr;
	wire [31:0]wdata;
	wire we;
	wire [31:0]rdata;
   	CPU CPU_(
	    .clock(clk_cpu),
	    .reset(reset),
	    .instruction(inst),//IMEM读出的指�?
	    .read_data(rdata),//DMEM读出的数�?
	    .PC(pc),
	    .DMEM_address(addr),//DMEM的读写地�?
	    .write_data(wdata),//写入DMEM的数�?
	    .DMEM_WRITE(we)//DMEM写有效信�?
	);

    wire Seg_we;
	Seg Seg_(
		.clk(clk_100),
		.wdata(wdata),
		.we(Seg_we),
		.atog(atog),
		.seg_cs(seg_cs)
	);

   	wire [31:0]actual_pc = pc - 32'h00400000;
	imem imem_(actual_pc[12:2], inst);

	wire [31:0]actual_dmem_addr = addr - 32'h10010000;
	wire DMEM_we;
	wire [31:0]DMEM_out;
	dmem dmem_(actual_dmem_addr[10:0], wdata, ~clk_100, DMEM_we, DMEM_out);

	WriteSelect WS(
		.addr(addr),
		.we(we),
		.DMEM_we(DMEM_we),
		.Seg_we(Seg_we)
	);

	ReadSelect RS(
        .addr(addr),
        .DMEM(DMEM_out),
        .rdata(rdata)
    );
endmodule