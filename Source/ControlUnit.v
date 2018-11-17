`define ALUC_ADDU 4'b0000
`define ALUC_ADD 4'b0010
`define ALUC_SUBU 4'b0001
`define ALUC_SUB 4'b0011
`define ALUC_AND 4'b0100
`define ALUC_OR 4'b0101
`define ALUC_XOR 4'b0110
`define ALUC_NOR 4'b0111
`define ALUC_LUI 4'b100x
`define ALUC_SLT 4'b1011
`define ALUC_SLTU 4'b1010
`define ALUC_SRA 4'b1100
`define ALUC_SLL 4'b111x
`define ALUC_SRL 4'b1101

`define MDUC_MULT 2'b00
`define MDUC_MULTU 2'b01
`define MDUC_DIV 2'b10
`define MDUC_DIVU 2'b11

`define OP_000000 6'b000000
`define FUNC_ADD 6'b100000//==`FUNC_CLZ
`define FUNC_ADDU 6'b100001
`define FUNC_SUB 6'b100010
`define FUNC_SUBU 6'b100011
`define FUNC_AND 6'b100100
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_NOR 6'b100111
`define FUNC_SLT 6'b101010
`define FUNC_SLTU 6'b101011
`define FUNC_SLL 6'b000000
`define FUNC_SRL 6'b000010//==`FUNC_MUL
`define FUNC_SRA 6'b000011
`define FUNC_SLLV 6'b000100
`define FUNC_SRLV 6'b000110
`define FUNC_SRAV 6'b000111
`define FUNC_JR 6'b001000
`define FUNC_DIV 6'b011010
`define FUNC_DIVU 6'b011011
`define FUNC_MULTU 6'b011001
`define FUNC_JALR 6'b001001
`define FUNC_MFHI 6'b010000
`define FUNC_MFLO 6'b010010
`define FUNC_MTHI 6'b010001
`define FUNC_MTLO 6'b010011
`define FUNC_SYSCALL 6'b001100
`define FUNC_TEQ 6'b110100
`define FUNC_BREAK 6'b001101

`define OP_010000 6'b010000
`define RS_ERET 5'b10000
`define RS_MFC0 5'b00000
`define RS_MTC0 5'b00100

`define OP_011100 6'b011100
`define FUNC_MUL 6'b000010
`define FUNC_CLZ 6'b100000

`define OP_ADDI 6'b001000
`define OP_ADDIU 6'b001001
`define OP_ANDI 6'b001100
`define OP_ORI 6'b001101
`define OP_XORI 6'b001110
`define OP_LW 6'b100011
`define OP_SW 6'b101011
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_SLTI 6'b001010
`define OP_SLTIU 6'b001011
`define OP_LUI 6'b001111
`define OP_J 6'b000010
`define OP_JAL 6'b000011
`define OP_LB 6'b100000
`define OP_LBU 6'b100100
`define OP_LH 6'b100001
`define OP_LHU 6'b100101
`define OP_SB 6'b101000
`define OP_SH 6'b101001
`define OP_BGEZ 6'b000001

module ControlUnit(
	input clk,
	input reset,
	input [5:0]op,
	input [4:0]rs,
	input [5:0]func,
	input [31:0]Z,
	input rs_31,
	input CLZ_busy,
	input MDU_busy,
	input [31:0]CP0_status,
	output reg [2:0]PCMUX_sel,
	output reg PC_we,
	output reg IR_we,
	//output reg DMEM_CS,
	//output reg DMEM_R,
	output reg DMEM_we,
	output reg [1:0]DMEMMUX_sel,
	output reg RF_we,
	output reg [1:0]RFAddrMUX_sel,
	output reg [3:0]RFDataMUX_sel,
	output reg [1:0]ALUAMUX_sel,
	output reg [2:0]ALUBMUX_sel,
	output reg [3:0]ALUC,
	output reg Z_we,
	output reg MDU_start,
	output reg [1:0]MDUC,
	output reg SaverMUX_sel,
	output reg Saver_we,
	output reg SignExt16MUX_sel,
	output reg ZeroExt16MUX_sel,
	output reg CLZCounter_start,
	output reg HIMUX_sel,
	output reg HI_we,
	output reg LOMUX_sel,
	output reg LO_we,
	output CP0_mfc0,
	output CP0_mtc0,
	output CP0_exception,
	output CP0_eret,
	output reg [3:0]CP0_cause
);
	
	wire ADDI = (op == `OP_ADDI);
	wire ADDIU = (op == `OP_ADDIU);
	wire ANDI = (op == `OP_ANDI);
	wire ORI = (op == `OP_ORI);
	wire SLTIU = (op == `OP_SLTIU);
	wire LUI = (op == `OP_LUI);
	wire XORI = (op == `OP_XORI);
	wire SLTI = (op == `OP_SLTI);
	wire ADDU = (op == `OP_000000 && func == `FUNC_ADDU);
	wire AND = (op == `OP_000000 && func == `FUNC_AND);
	wire BEQ = (op == `OP_BEQ);
	wire BNE = (op == `OP_BNE);
	wire J = (op == `OP_J);
	wire JAL = (op == `OP_JAL);
	wire JR = (op == `OP_000000 && func == `FUNC_JR);
	wire LW = (op == `OP_LW);
	wire XOR = (op == `OP_000000 && func == `FUNC_XOR);
	wire NOR = (op == `OP_000000 && func == `FUNC_NOR);
	wire OR = (op == `OP_000000 && func == `FUNC_OR);
	wire SLL = (op == `OP_000000 && func == `FUNC_SLL);
	wire SLLV = (op == `OP_000000 && func == `FUNC_SLLV);
	wire SLTU = (op == `OP_000000 && func == `FUNC_SLTU);
	wire SRA = (op == `OP_000000 && func == `FUNC_SRA);
	wire SRL = (op == `OP_000000 && func == `FUNC_SRL);
	wire SUBU = (op == `OP_000000 && func == `FUNC_SUBU);
	wire SW = (op == `OP_SW);
	wire ADD = (op == `OP_000000 && func == `FUNC_ADD);
	wire SUB = (op == `OP_000000 && func == `FUNC_SUB);
	wire SLT = (op == `OP_000000 && func == `FUNC_SLT);
	wire SRLV = (op == `OP_000000 && func == `FUNC_SRLV);
	wire SRAV = (op == `OP_000000 && func == `FUNC_SRAV);
	wire CLZ = (op == `OP_011100 && func == `FUNC_CLZ);
	wire DIVU = (op == `OP_000000 && func == `FUNC_DIVU);
	wire ERET = (op == `OP_010000 && rs == `RS_ERET);
	wire JALR = (op == `OP_000000 && func == `FUNC_JALR);
	wire LB = (op == `OP_LB);
	wire LBU = (op == `OP_LBU);
	wire LHU = (op == `OP_LHU);
	wire SB = (op == `OP_SB);
	wire SH = (op == `OP_SH);
	wire LH = (op == `OP_LH);
	wire MFC0 = (op == `OP_010000 && rs == `RS_MFC0);
	wire MFHI = (op == `OP_000000 && func == `FUNC_MFHI);
	wire MFLO = (op == `OP_000000 && func == `FUNC_MFLO);
	wire MTC0 = (op == `OP_010000 && rs == `RS_MTC0);
	wire MTHI = (op == `OP_000000 && func == `FUNC_MTHI);
	wire MTLO = (op == `OP_000000 && func == `FUNC_MTLO);
	wire MUL = (op == `OP_011100 && func == `FUNC_MUL);
	wire MULTU = (op == `OP_000000 && func == `FUNC_MULTU);
	wire SYSCALL = (op == `OP_000000 && func == `FUNC_SYSCALL);
	wire TEQ = (op == `OP_000000 && func == `FUNC_TEQ);
	wire BGEZ = (op == `OP_BGEZ);
	wire BREAK = (op == `OP_000000 && func == `FUNC_BREAK);
	wire DIV = (op == `OP_000000 && func == `FUNC_DIV);

	
endmodule