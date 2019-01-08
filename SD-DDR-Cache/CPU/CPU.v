module CPU(
    input clock,
    input reset,
    input [31:0]instruction,//IMEM读出的指令
    input [31:0]read_data,//DMEM读出的数据
    output [31:0]PC,
    output [31:0]DMEM_address,//DMEM的读写地址
    output [31:0]write_data,//写入DMEM的数据
    //output DM_CS,
    //output DM_R,
    output DMEM_WRITE//DMEM写有效信号
);

    wire [31:0]ALU_A;
    wire [31:0]ALU_B;
    wire [3:0]ALUC;
    wire [31:0]ALU_result;
    ALU ALU_(
        .a(ALU_A), 
        .b(ALU_B), 
        .aluc(ALUC), 
        .result(ALU_result), 
        .zero(), 
        .carry(), 
        .negative(), 
        .overflow()
    );

    wire Z_we;
    wire [31:0]Z_out;
    ZReg Z(
        .clk(clock),
        .write_ena(Z_we),
        .in(ALU_result),
        .out(Z_out)
    );

    wire PC_we;
    wire [31:0]PC_in;
    wire [31:0]PC_out;
    ProgramCounterReg PC_(
        .clock(clock), 
        .reset(reset), 
        .enable(PC_we), 
        .data_in(PC_in), 
        .data_out(PC_out)
    );
    assign PC = PC_out;

    wire IR_we;
    wire [31:0]IR_out;
    IRReg IR(
        .clk(clock),
        .write_ena(IR_we),
        .IMEM_in(instruction),
        .instruction(IR_out)
    );

    wire [5:0]op;
    wire [4:0]rs;
    wire [4:0]rt;
    wire [4:0]rd;
    wire [4:0]shamt;
    wire [5:0]func;
    wire [15:0]imm16;
    wire [25:0]index;
    InstructionDecoder ID(
        .instruction(IR_out), 
        .op(op), 
        .rs(rs), 
        .rt(rt), 
        .rd(rd), 
        .shamt(shamt), 
        .func(func), 
        .imm16(imm16), 
        .index(index)
    );

    wire RF_we;
    wire [4:0]RF_addr;
    wire [31:0]RF_data;
    wire [31:0]rs_value;
    wire [31:0]rt_value;
    RegFile RF(
        .clock(clock), 
        .reset(reset), 
        .write_enable(RF_we), 
        .raddr1(rs), 
        .raddr2(rt), 
        .waddr(RF_addr), 
        .wdata(RF_data), 
        .rdata1(rs_value), 
        .rdata2(rt_value)
    );

    wire [1:0]MDUC;
    wire MDU_start;
    wire MDU_busy;
    wire [31:0]MDU_r1;
    wire [31:0]MDU_r2;
    MDU MDU_(
        .clk(clock), 
        .a(rs_value), 
        .b(rt_value), 
        .MDUC(MDUC), 
        .start(MDU_start), 
        .busy(MDU_busy), 
        .r1(MDU_r1), 
        .r2(MDU_r2)
    );

    wire Saver_we;
    wire [31:0]Saver_in;
    wire [31:0]Saver_out;
    SaverReg Saver(
        .clk(clock),
        .write_ena(Saver_we),
        .in(Saver_in),
        .out(Saver_out)
    );  

    wire [15:0]SignExt16_in;
    wire [15:0]ZeroExt16_in;
    wire [31:0]SignExt16_out;
    wire [31:0]ZeroExt16_out;
    wire [31:0]SignExt18_out;
    wire [31:0]SignExt8_out;
    wire [31:0]ZeroExt8_out;
    wire [31:0]ZeroExt5_out;
    Extender Extender_(
        .SignExt16_in(SignExt16_in),
        .ZeroExt16_in(ZeroExt16_in),
        .SignExt18_in(imm16),
        .SignExt8_in(Saver_out[7:0]),
        .ZeroExt8_in(Saver_out[7:0]),
        .ZeroExt5_in(shamt),
        .SignExt16_out(SignExt16_out),
        .ZeroExt16_out(ZeroExt16_out),
        .SignExt18_out(SignExt18_out),
        .SignExt8_out(SignExt8_out),
        .ZeroExt8_out(ZeroExt8_out),
        .ZeroExt5_out(ZeroExt5_out)
    );

    wire [31:0]out_8;
    wire [31:0]out_16;
    wire [31:0]out_J;
    Concatenater Concatenater_(
        .DMEM(read_data[31:8]),
        .rt_value(rt_value[15:0]),
        .PC(PC_out[31:28]),
        .index(index),
        .out_8(out_8),
        .out_16(out_16),
        .out_J(out_J)
    );

    wire CP0_mfc0;
    wire CP0_mtc0;
    wire CP0_exception;
    wire CP0_eret;
    wire [3:0]CP0_cause;
    wire [31:0]CP0_out;
    wire [31:0]CP0_status;
    wire [31:0]CP0_epc;
    CP0 CP0_(
        .clk(clock),
        .rst(reset),
        .mfc0(CP0_mfc0),
        .addr(rd),
        .mtc0(CP0_mtc0),
        .data(rt_value),
        .exception(CP0_exception),
        .eret(CP0_eret),
        .pc(PC_out),
        .cause(CP0_cause),
        .CP0_out(CP0_out),
        .status(CP0_status),
        .epc_out(CP0_epc)
    );

    wire HI_we;
    wire [31:0]HI_in;
    wire [31:0]HI_out;
    HIReg HI(
        .clk(clock),
        .write_ena(HI_we),
        .in(HI_in),
        .out(HI_out)
    );

    wire LO_we;
    wire [31:0]LO_in;
    wire [31:0]LO_out;
    LOReg LO(
        .clk(clock),
        .write_ena(LO_we),
        .in(LO_in),
        .out(LO_out)
    );

    wire CLZCounter_start;
    wire CLZCounter_busy;
    wire [31:0]CLZCounter_result;
    CLZCounter CLZCounter_(
        .rs_value(rs_value),
        .start(CLZCounter_start),
        .busy(CLZCounter_busy),
        .result(CLZCounter_result)
    );

    wire [2:0]PCMUX_sel;
    PCMUX PCMUX_(
        .ALU(ALU_result),
        .Z(Z_out),
        .out_J(out_J),
        .rs_value(rs_value),
        .EPC(CP0_epc),
        .sel(PCMUX_sel),
        .out(PC_in)
    );

    wire SaverMUX_sel;
    SaverMUX SaverMUX_(
        .DMEM(read_data),
        .CP0_out(CP0_out),
        .sel(SaverMUX_sel),
        .out(Saver_in)
    );

    wire [1:0]RFAddrMUX_sel;
    RegFileAddrMUX RegFileAddrMUX_(
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .sel(RFAddrMUX_sel),
        .out(RF_addr)
    );

    wire [3:0]RFDataMUX_sel;
    RegFileDataMUX RegFileDataMUX_(
        .Z(Z_out),
        .SignExt8(SignExt8_out),
        .ZeroExt8(ZeroExt8_out),
        .SignExt16(SignExt16_out),
        .ZeroExt16(ZeroExt16_out),
        .Saver(Saver_out),
        .PC(PC_out),
        .CLZ_result(CLZCounter_result),
        .HI(HI_out),
        .LO(LO_out),
        .MDU_r2(MDU_r2),
        .sel(RFDataMUX_sel),
        .out(RF_data)
    );

    wire SignExt16MUX_sel;
    SignExt16MUX SignExt16MUX_(
        .imm16(imm16),
        .Saver(Saver_out[15:0]),
        .sel(SignExt16MUX_sel),
        .out(SignExt16_in)
    );

    wire ZeroExt16MUX_sel;
    ZeroExt16MUX ZeroExt16MUX_(
        .imm16(imm16),
        .Saver(Saver_out[15:0]),
        .sel(ZeroExt16MUX_sel),
        .out(ZeroExt16_in)
    );

    wire HIMUX_sel;
    HIMUX HIMUX_(
        .rs_value(rs_value),
        .MDU_r1(MDU_r1),
        .sel(HIMUX_sel),
        .out(HI_in)
    );

    wire LOMUX_sel;
    LOMUX LOMUX_(
        .rs_value(rs_value),
        .MDU_r2(MDU_r2),
        .sel(LOMUX_sel),
        .out(LO_in)
    );

    wire [1:0]ALUAMUX_sel;
    ALUAMUX ALUAMUX_(
        .PC(PC_out),
        .rs_value(rs_value),
        .ZeroExt5(ZeroExt5_out),
        .sel(ALUAMUX_sel),
        .out(ALU_A)
    );

    wire [2:0]ALUBMUX_sel;
    ALUBMUX ALUBMUX_(
        .SignExt16(SignExt16_out),
        .ZeroExt16(ZeroExt16_out),
        .rt_value(rt_value),
        .SignExt18(SignExt18_out),
        .sel(ALUBMUX_sel),
        .out(ALU_B)
    );

    wire [1:0]DMEMMUX_sel;
    DMEMMUX DMEMMUX_(
        .out_8(out_8),
        .out_16(out_16),
        .rt_value(rt_value),
        .sel(DMEMMUX_sel),
        .out(write_data)
    );

    assign DMEM_address = Z_out;

    ControlUnit CU(
        .clk(clock),
        .reset(reset),
        .op(op),
        .rs(rs),
        .func(func),
        .Z(Z_out),
        .rs_31(rs_value[31]),
        .CLZ_busy(CLZCounter_busy),
        .MDU_busy(MDU_busy),
        .CP0_status(CP0_status),
        .PCMUX_sel(PCMUX_sel),
        .PC_we(PC_we),
        .IR_we(IR_we),
        //.DMEM_CS(DM_CS),
        //.DMEM_R(DM_R),
        .DMEM_we(DMEM_WRITE),
        .DMEMMUX_sel(DMEMMUX_sel),
        .RF_we(RF_we),
        .RFAddrMUX_sel(RFAddrMUX_sel),
        .RFDataMUX_sel(RFDataMUX_sel),
        .ALUAMUX_sel(ALUAMUX_sel),
        .ALUBMUX_sel(ALUBMUX_sel),
        .ALUC(ALUC),
        .Z_we(Z_we),
        .MDU_start(MDU_start),
        .MDUC(MDUC),
        .SaverMUX_sel(SaverMUX_sel),
        .Saver_we(Saver_we),
        .SignExt16MUX_sel(SignExt16MUX_sel),
        .ZeroExt16MUX_sel(ZeroExt16MUX_sel),
        .CLZCounter_start(CLZCounter_start),
        .HIMUX_sel(HIMUX_sel),
        .HI_we(HI_we),
        .LOMUX_sel(LOMUX_sel),
        .LO_we(LO_we),
        .CP0_mfc0(CP0_mfc0),
        .CP0_mtc0(CP0_mtc0),
        .CP0_exception(CP0_exception),
        .CP0_eret(CP0_eret),
        .CP0_cause(CP0_cause)
    );
endmodule