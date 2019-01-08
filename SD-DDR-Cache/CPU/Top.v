module Top(
	input clk100,
	input reset,
	input [14:0]switch,
	input [4:0]button,
	inout [3:0]SD_DAT,
	input SD_CD, 
	output SD_RESET, 
	output SD_SCK, 
	output SD_CMD,
	output [7:0]atog,
	output [7:0]seg_cs,
	output [15:0]led,

	// DDR2 chip signals
	inout [15:0]            ddr2_dq,
    inout [1:0]             ddr2_dqs_n,
    inout [1:0]             ddr2_dqs_p,
    output [12:0]           ddr2_addr,
    output [2:0]            ddr2_ba,
    output                  ddr2_ras_n,
    output                  ddr2_cas_n,
    output                  ddr2_we_n,
    output [0:0]            ddr2_ck_p,
    output [0:0]            ddr2_ck_n,
    output [0:0]            ddr2_cke,
    output [0:0]            ddr2_cs_n,
    output [1:0]            ddr2_dm,
    output [0:0]            ddr2_odt
); 

	wire clk50, clk200, clk333;
	clk_wiz_0 clk_div(.clk_in1(clk100), .clk_out1(clk50), .clk_out2(clk200), .clk_out3(clk333));
	//assign clk_cpu = clk_100;
	wire clk_cpu, clk_sd, clk_ddr, clk_ddr_ref;
	assign clk_cpu = clk50;
	assign clk_sd = clk50;
	assign clk_ddr = clk333;
	assign clk_ddr_ref = clk200;
	
	wire sd_cs, sd_din, sd_dout, sd_clk;
	assign SD_DAT[2] = 1;
    assign SD_DAT[3] = sd_cs;
    assign SD_CMD = sd_din;
    assign SD_RESET = 0;
    assign SD_SCK = sd_clk;
    assign sd_dout = SD_DAT[0];
    assign SD_DAT[1] = 1;
    

	wire [31:0]pc;
	wire [31:0]inst;
	wire [31:0]addr;
	wire [31:0]wdata;
	wire we;
	wire [31:0]rdata;
   	CPU CPU_(
	    .clock(clk_cpu),
	    .reset(reset),
	    .instruction(inst),//IMEMè¯»å‡ºçš�?�æŒ�?�ï�????
	    .read_data(rdata),//DMEMè¯»å‡ºçš�?�æ�?�°ï�????
	    .PC(pc),
	    .DMEM_address(addr),//DMEMçš„è¯»å�?�™åœ°ï¿???
	    .write_data(wdata),//å†™å…¥DMEMçš„æ�?�°ï�????
	    .DMEM_WRITE(we)//DMEMå†™æœ‰æ�?�ˆä¿¡ï�????
	);



   	// *** 1 ***
   	wire SD_WB_Addr_we;
   	wire [31:0]SD_WB_Addr_out;
   	Reg_Out SD_WB_Addr(clk_cpu, reset, SD_WB_Addr_we, wdata, SD_WB_Addr_out);

   	// *** 2 ***
   	wire SD_WB_Control_we;
   	wire [31:0]SD_WB_Control_out;
   	Reg_Out SD_WB_Control(clk_cpu, reset, SD_WB_Control_we, wdata, SD_WB_Control_out);

   	// *** 3 ***
   	wire SD_WB_Wdata_we;
   	wire [31:0]SD_WB_Wdata_out;
   	Reg_Out SD_WB_Wdata(clk_cpu, reset, SD_WB_Wdata_we, wdata, SD_WB_Wdata_out);

   	wire [4095:0]sd_buffer;
	SD_Write_Buffer SWB(
		.clk(clk_cpu),
		.reset(reset || SD_WB_Control_out[1]),
		.data(SD_WB_Wdata_out),
		.addr(SD_WB_Addr_out[6:0]),
		.we(SD_WB_Control_out[0]),
		.buffer(sd_buffer)
	);



	// *** 4 ***
	wire SD_Addr_we;
   	wire [31:0]SD_Addr_out;
	Reg_Out SD_Addr(clk_cpu, reset, SD_Addr_we, wdata, SD_Addr_out);

	// *** 5 ***
   	wire SD_Control_we;
   	wire [31:0]SD_Control_out;
   	Reg_Out SD_Control(clk_cpu, reset, SD_Control_we, wdata, SD_Control_out);

   	wire [4095:0]sd_rdata;
   	wire init_ok, err, sd_wend, sd_rend;
   	wire [31:0]SD_Status;
   	assign SD_Status = {28'b0, init_ok, err, sd_wend, sd_rend};

   	wire [6:0]st;
    wire [4:0]ist;
    wire [7:0]rst;
    wire [10:0]wst;
   	SD SD_(
	    .clk(clk_sd),
	    .reset(reset || SD_Control_out[2]),
	    .dout(sd_dout),
	    .addr(SD_Addr_out),
	    .wdata(sd_buffer),
	    .we(SD_Control_out[1]),
	    .re(SD_Control_out[0]),
	    .sdclk(sd_clk),
	    .din(sd_din),
	    .cs(sd_cs),
	    .rdata(sd_rdata),
	    .init_ok(init_ok),
	    .err(err),
	    .wend(sd_wend),
	    .rend(sd_rend)
	);

   	// *** 6 ***
   	wire SD_RD_Addr_we;
   	wire [31:0]SD_RD_Addr_out;
   	Reg_Out SD_RD_Addr(clk_cpu, reset, SD_RD_Addr_we, wdata, SD_RD_Addr_out);

   	wire [31:0] SD_RD_out;
   	SD_Read_Div SRD(
		.data_in(sd_rdata),
		.addr(SD_RD_Addr_out[6:0]),
		.data_out(SD_RD_out)
	);



	// *** 7 ***
	wire DDR2_WB_Wdata_we;
	wire [31:0]DDR2_WB_Wdata_out;
	Reg_Out DDR2_RD_Wdata(clk_cpu, reset, DDR2_WB_Wdata_we, wdata, DDR2_WB_Wdata_out);

	// *** 8 ***
	wire DDR2_WB_Addr_we;
	wire [31:0]DDR2_WB_Addr_out;
	Reg_Out DDR2_WB_Addr(clk_cpu, reset, DDR2_WB_Addr_we, wdata, DDR2_WB_Addr_out);

	// *** 9 ***
	wire DDR2_WB_Control_we;
	wire [31:0]DDR2_WB_Control_out;
	Reg_Out DDR2_RD_Control(clk_cpu, reset, DDR2_WB_Control_we, wdata, DDR2_WB_Control_out);

	wire [127:0]ddr2_buffer;
	DDR2_Write_Buffer DWB(
	    .clk(clk_ddr),
	    .reset(reset || DDR2_WB_Control_out[1]),
	    .data(DDR2_WB_Wdata_out),
	    .addr(DDR2_WB_Addr_out[1:0]),
	    .we(DDR2_WB_Control_out[0]),
	    .buffer(ddr2_buffer)
	);




	// *** 10 ***
	wire DDR2_Addr_we;
	wire [31:0]DDR2_Addr_out;
	Reg_Out DDR2_Addr(clk_cpu, reset, DDR2_Addr_we, wdata, DDR2_Addr_out);

	// *** 11 ***
	wire DDR2_Control_we;
	wire [31:0]DDR2_Control_out;
	Reg_Out DDR2_Control(clk_cpu, reset, DDR2_Control_we, wdata, DDR2_Control_out);

	wire [127:0]ddr2_rdata;
	wire ddr2_wend, ddr2_rend;
	wire [31:0]DDR2_Status;
	assign DDR2_Status = {30'b0, ddr2_wend, ddr2_rend};
	DDR2_Ram DDR2_(
	    .clk200(clk_ddr_ref),
	    .clk333(clk_ddr),
	    .reset(reset || DDR2_Control_out[2]),
	    .we(DDR2_Control_out[1]),
	    .re(DDR2_Control_out[0]),
	    .addr(DDR2_Addr_out[23:0]),
	    .wdata(ddr2_buffer),
	    .rdata(ddr2_rdata),
	    .wend(ddr2_wend),
	    .rend(ddr2_rend),

	    // DDR2 chip signals
	    .ddr2_dq(ddr2_dq),
	    .ddr2_dqs_n(ddr2_dqs_n),
	    .ddr2_dqs_p(ddr2_dqs_p),
	    .ddr2_addr(ddr2_addr),
	    .ddr2_ba(ddr2_ba),
	    .ddr2_ras_n(ddr2_ras_n),
	    .ddr2_cas_n(ddr2_cas_n),
	    .ddr2_we_n(ddr2_we_n),
	    .ddr2_ck_p(ddr2_ck_p),
	    .ddr2_ck_n(ddr2_ck_n),
	    .ddr2_cke(ddr2_cke),
	    .ddr2_cs_n(ddr2_cs_n),
	    .ddr2_dm(ddr2_dm),
	    .ddr2_odt(ddr2_odt)
	);



	// *** 12 ***
	wire DDR2_RD_Addr_we;
	wire [31:0]DDR2_RD_Addr_out;
	Reg_Out DDR2_RD_Addr(clk_cpu, reset, DDR2_RD_Addr_we, wdata, DDR2_RD_Addr_out);

	wire [31:0]DDR2_RD_out;
	DDR2_Read_Div DRD(
	    .data_in(ddr2_rdata),
	    .addr(DDR2_RD_Addr_out[1:0]),
	    .data_out(DDR2_RD_out)
	);



	// *** 13 ***
    wire Seg_we;
	Seg Seg_(
		.clk(clk_cpu),
		.wdata(wdata),
		.we(Seg_we),
		.atog(atog),
		.seg_cs(seg_cs)
	);

	// *** 14 ***
	wire LED_we;
	wire [31:0]LED_out;
	Reg_Out LED(clk_cpu, reset, LED_we, wdata, LED_out);
	assign led = LED_out[15:0];

	// *** 15 ***
	wire IMEM_Addr_we;
	wire [31:0]IMEM_Addr_out;
	Reg_Out IMEM_Addr(clk_cpu, reset, IMEM_Addr_we, wdata, IMEM_Addr_out);

	// *** 16 ***
	wire IMEM_Control_we;
	wire [31:0]IMEM_Control_out;
	Reg_Out IMEM_Control(clk_cpu, reset, IMEM_Control_we, wdata, IMEM_Control_out);

   	wire [31:0]actual_pc = pc - 32'h00400000;
	//imem imem_(actual_pc[13:2], inst);
	imem imem_(
		.a(IMEM_Addr_out[13:2]),
		.d(DDR2_RD_out),
		.dpra(actual_pc[13:2]),
		.clk(~clk_cpu),
		.we(IMEM_Control_out[0]),
		.dpo(inst)
	);

	// // *** 17 ***
	// wire DMEM_Addr_we;
	// wire [31:0]DMEM_Addr_out;
	// Reg_Out DMEM_Addr(clk_cpu, reset, DMEM_Addr_we, wdata, DMEM_Addr_out);

	// // *** 18 ***
	// wire DMEM_Control_we;
	// wire [31:0]DMEM_Control_out;
	// Reg_Out DMEM_Control(clk_cpu, reset, DMEM_Control_we, wdata, DMEM_Control_out);

	wire [31:0]actual_dmem_addr = addr - 32'h10010000;
	wire DMEM_we;
	wire [31:0]DMEM_out;
	dmem dmem_(
		.a(actual_dmem_addr[13:2]),
		.d(wdata),
		.clk(~clk_cpu),
		.we(DMEM_we),
		.spo(DMEM_out)
	);

	// WriteSelect WS(
	// 	.addr(addr),
	// 	.we(we),
	// 	.DMEM_we(DMEM_we),
	// 	.Seg_we(Seg_we)
	// );

	WriteSelect WS(
		.addr(addr),
		.we(we),
		.DMEM_we(DMEM_we),
		.SD_WB_Addr_we(SD_WB_Addr_we),
		.SD_WB_Control_we(SD_WB_Control_we),
		.SD_WB_Wdata_we(SD_WB_Wdata_we),
		.SD_Addr_we(SD_Addr_we),
		.SD_Control_we(SD_Control_we),
		.SD_RD_Addr_we(SD_RD_Addr_we),
		.DDR2_WB_Wdata_we(DDR2_WB_Wdata_we),
		.DDR2_WB_Addr_we(DDR2_WB_Addr_we),
		.DDR2_WB_Control_we(DDR2_WB_Control_we),
		.DDR2_Addr_we(DDR2_Addr_we),
		.DDR2_Control_we(DDR2_Control_we),
		.DDR2_RD_Addr_we(DDR2_RD_Addr_we),
		.IMEM_Addr_we(IMEM_Addr_we),
		.IMEM_Control_we(IMEM_Control_we),
		// .DMEM_Addr_we(DMEM_Addr_we),
		// .DMEM_Control_we(DMEM_Control_we),
		.LED_we(LED_we),
		.Seg_we(Seg_we)
	);

    ReadSelect RS(
		.addr(addr),
        .DMEM(DMEM_out),
		.SD_Status(SD_Status),
		.DDR2_Status(DDR2_Status),
		.Switch({17'b0, switch}),
		.Button({27'b0, button}),
		.SD_RD(SD_RD_out),
		.DDR2_RD(DDR2_RD_out),
		.rdata(rdata)
	);
endmodule