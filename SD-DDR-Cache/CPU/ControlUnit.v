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

	assign Z_zero = (Z == 32'b0);

	reg cycle2;
	reg cycle3;
	reg cycle4;
	always @(*) begin
		if(J | JR | MFHI | MFLO | MTC0 | MTHI | MTLO) begin
			//这些指令2个周期可以结束
			cycle2 = 1;
			cycle3 = 0;
			cycle4 = 0;
		end else if(BEQ | BNE | LW | CLZ | DIVU | LB | LBU | LHU | SB | SH | LH | MUL | MULTU | DIV | SYSCALL | BREAK | TEQ) begin
			//4
			cycle2 = 0;
			cycle3 = 0;
			cycle4 = 1;
		end else begin
			//3
			cycle2 = 0;
			cycle3 = 1;
			cycle4 = 0;
		end
	end

	parameter t1 = 4'b0001;
	parameter t2 = 4'b0010;
	parameter t3 = 4'b0100;
	parameter t4 = 4'b1000;
	reg [3:0]current_state = t1;
	reg [3:0]next_state;
	//上升沿状态反转，下降沿执行操作
	always @(posedge clk or posedge reset) begin
		if(reset) begin
			current_state <= t1;
		end else begin
			current_state <= next_state;
		end
	end

	always @(*) begin
		case(current_state)
			t1: begin
				if(BGEZ) begin
					if(rs_31) begin
						//rs为负则直接执行下一条指令，不进行跳转
						next_state = t1;
					end else begin
						next_state = t2;
					end
				end else begin
					next_state = t2;
				end
			end
			t2: begin
				if(BEQ) begin
					//BEQ BNE第二个周期计算[rs]-[rt]
					if(Z_zero) begin
						next_state = t3;
					end else begin
						next_state = t1;
					end
				end else if(BNE) begin
					if(Z_zero) begin
						next_state = t1;
					end else begin
						next_state = t3;
					end
				end else if(BREAK) begin
					if(CP0_status[0] & CP0_status[2]) begin
						next_state = t3;
					end else begin
						next_state = t1;
					end
				end else if(SYSCALL) begin
					if(CP0_status[0] & CP0_status[1]) begin
						next_state = t3;
					end else begin
						next_state = t1;
					end
				end else if(TEQ) begin
					if(CP0_status[0] & CP0_status[3]) begin
						next_state = t3;
					end else begin
						next_state = t1;
					end
				end else begin
					if(cycle2) begin
						next_state = t1;
					end else begin
						next_state = t3;
					end
				end
			end
			t3: begin
				if(CLZ) begin
					if(CLZ_busy) begin
						next_state = t3;
					end else begin
						next_state = t4;
					end
				end else if(MUL | MULTU | DIV | DIVU) begin
					if(MDU_busy) begin
						next_state = t3;
					end else begin
						next_state = t4;
					end
				end else if (TEQ) begin
					if(Z_zero) begin
						next_state = t4;
					end else begin
						next_state = t1;
					end
				end else begin
					if(cycle4) begin
						next_state = t4;
					end else begin
						next_state = t1;
					end
				end
			end
			t4: begin
				next_state = t1;
			end
			default: begin
				next_state = t1;
			end
		endcase
	end

	wire in1 = current_state[0];
	wire in2 = current_state[1];
	wire in3 = current_state[2];
	wire in4 = current_state[3];

	//PC
	always @(*) begin
		if((BEQ & in4)|(BGEZ & in3)|(BNE & in4)) begin
			PCMUX_sel = 3'b001;
			PC_we = 1;
		end else if((J & in2)|(JAL & in3)) begin
			PCMUX_sel = 3'b010;
			PC_we = 1;
		end else if((JALR & in3)|(JR & in2)) begin
			PCMUX_sel = 3'b011;
			PC_we = 1;
		end else if((BREAK | SYSCALL | TEQ) & in4) begin
			PCMUX_sel = 3'b101;
			PC_we = 1;
		end else if(ERET & in3) begin
			PCMUX_sel = 3'b100;
			PC_we = 1;
		end else if(in1) begin
			PCMUX_sel = 3'b000;
			PC_we = 1;
		end else begin
			PCMUX_sel = 3'bxxx;
			PC_we = 0;
		end
	end

	//IR
	always @(*) begin
		if(in1) begin
			IR_we = 1;
		end else begin
			IR_we = 0;
		end
	end

	//DMEM
	// always @(*) begin
	// 	//DMEM_CS
	// 	if(in3) begin
	// 		if(LH|LHU|LB|LBU|LW|SW) begin
	// 			DMEM_CS = 1'b1;
	// 		end else begin
	// 			DMEM_CS = 1'b0;
	// 		end
	// 	end else if(in4) begin
	// 		if(SB|SH) begin
	// 			DMEM_CS = 1'b1;
	// 		end else begin
	// 			DMEM_CS = 1'b0;
	// 		end
	// 	end else begin
	// 		DMEM_CS = 1'b0;
	// 	end
	// end
	// always @(*) begin
	// 	//DMEM_R
	// 	if(in3) begin
	// 		if(LH|LHU|LB|LBU|LW) begin
	// 			DMEM_R = 1'b1;
	// 		end else begin
	// 			DMEM_R = 1'b0;
	// 		end
	// 	end else begin
	// 		DMEM_R = 1'b0;
	// 	end
	// end
	always @(*) begin
		if(SB & in4) begin
			DMEM_we = 1;
			DMEMMUX_sel = 2'b00;
		end else if(SH & in4) begin
			DMEM_we = 1;
			DMEMMUX_sel = 2'b01;
		end else if(SW & in3) begin
			DMEM_we = 1;
			DMEMMUX_sel = 2'b10;
		end else begin
			DMEM_we = 0;
			DMEMMUX_sel = 2'bxx;
		end
	end

	//RegFile
	always @(*) begin
		case(current_state)
			t2: begin
				if(JAL) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b11;
					RFDataMUX_sel = 4'b0110;
				end else if(JALR) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b10;
					RFDataMUX_sel = 4'b0110;
				end else if(MFHI) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b10;
					RFDataMUX_sel = 4'b1000;
				end else if(MFLO) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b10;
					RFDataMUX_sel = 4'b1001;
				end else begin
					RF_we = 0;
					RFAddrMUX_sel = 2'bxx;
					RFDataMUX_sel = 4'bxxxx;
				end
			end
			t3: begin
				if(ADDI|ADDIU|ANDI|LUI|ORI|SLTI|SLTIU|XORI) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b01;
					RFDataMUX_sel = 4'b0000;
				end else if(ADD|ADDU|AND|NOR|OR|SLL|SLLV|SLT|SLTU|SRA|SRAV|SRL|SRLV|SUB|SUBU|XOR) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b10;
					RFDataMUX_sel = 4'b0000;
				end else if(MFC0) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b01;
					RFDataMUX_sel = 4'b0101;
				end else begin
					RF_we = 0;
					RFAddrMUX_sel = 2'bxx;
					RFDataMUX_sel = 4'bxxxx;
				end
			end
			t4: begin
				if(LB) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b01;
					RFDataMUX_sel = 4'b0001;
				end else if(LBU) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b01;
					RFDataMUX_sel = 4'b0010;
				end else if(LH) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b01;
					RFDataMUX_sel = 4'b0011;
				end else if(LHU) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b01;
					RFDataMUX_sel = 4'b0100;
				end else if(LW) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b01;
					RFDataMUX_sel = 4'b0101;
				end else if(CLZ) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b10;
					RFDataMUX_sel = 4'b0111;
				end else if(MUL) begin
					RF_we = 1;
					RFAddrMUX_sel = 2'b10;
					RFDataMUX_sel = 4'b1010;
				end else begin
					RF_we = 0;
					RFAddrMUX_sel = 2'bxx;
					RFDataMUX_sel = 4'bxxxx;
				end
			end
			default: begin
				RF_we = 0;
				RFAddrMUX_sel = 2'bxx;
				RFDataMUX_sel = 4'bxxxx;
			end
		endcase
	end

	//ALU
	always @(*) begin
		if(in1 |(BEQ & in3)|(BGEZ & in2)|(BNE & in3)) begin
			ALUAMUX_sel = 2'b00;
		end else if((SLL & in2)|(SRA & in2)|(SRL & in2)) begin
			ALUAMUX_sel = 2'b10;
		end else begin
			ALUAMUX_sel = 2'b01;
		end
	end
	always @(*) begin
		if((ADDI & in2)|(ADDIU & in2)|(LB & in2)|(LBU & in2)|(LH & in2)|(LHU & in2)|(LUI & in2)|(LW & in2)|(SB & in2)|(SH & in2)|(SLTI & in2)|(SW & in2))begin
			ALUBMUX_sel = 3'b000;
			Z_we = 1;
		end else if((ANDI & in2)|(ORI & in2)|(SLTIU & in2)|(XORI & in2)) begin
			ALUBMUX_sel = 3'b001;
			Z_we = 1;
		end else if((BEQ & in3)|(BGEZ & in2)|(BNE & in3)) begin
			ALUBMUX_sel = 3'b011;
			Z_we = 1;
		end else if(in1) begin
			ALUBMUX_sel = 3'b100;
			Z_we = 0;
		end else begin
			if(in2) begin
				ALUBMUX_sel = 3'b010;
				Z_we = 1;
			end else begin
				ALUBMUX_sel = 3'bxxx;
				Z_we = 0;
			end
		end
	end
	always @(*) begin
		case(current_state)
			t1: begin
				ALUC = `ALUC_ADD;
			end
			t2: begin
				if(ADDI|BGEZ|LB|LBU|LH|LHU|LW|SB|SH|SW|ADD) begin
					ALUC = `ALUC_ADD;
				end else if(ADDIU|ADDU) begin
					ALUC = `ALUC_ADDU;
				end else if(ANDI|AND) begin
					ALUC = `ALUC_AND;
				end else if(BEQ|BNE|SUB|TEQ) begin
					ALUC = `ALUC_SUB;
				end else if(LUI) begin
					ALUC = `ALUC_LUI;
				end else if(ORI|OR) begin
					ALUC = `ALUC_OR;
				end else if(SLTI|SLT) begin
					ALUC = `ALUC_SLT;
				end else if(SLTIU|SLTU) begin
					ALUC = `ALUC_SLTU;
				end else if(XORI|XOR) begin
					ALUC = `ALUC_XOR;
				end else if(NOR) begin
					ALUC = `ALUC_NOR;
				end else if(SLL|SLLV) begin
					ALUC = `ALUC_SLL;
				end else if(SRA|SRAV) begin
					ALUC = `ALUC_SRA;
				end else if(SRL|SRLV) begin
					ALUC = `ALUC_SRL;
				end else if(SUBU) begin
					ALUC = `ALUC_SUBU;
				end else begin
					ALUC = 4'bxxxx;
				end
			end
			t3: begin
				if(BEQ|BNE) begin
					ALUC = `ALUC_ADD;
				end else begin
					ALUC = 4'bxxxx;
				end
			end
			default: begin
				ALUC = 4'bxxxx;
			end
		endcase
	end

	//MDU
	always @(*) begin
		if((DIV|DIVU|MUL|MULTU)&(in1|in2)) begin
			MDU_start = 1;
		end else begin
			MDU_start = 0;
		end
	end
	always @(*) begin
		if(DIV) begin
			MDUC = 2'b10;
		end else if(DIVU) begin
			MDUC = 2'b11;
		end else if(MUL) begin
			MDUC = 2'b00;
		end else if(MULTU) begin
			MDUC = 2'b01;
		end else begin
			MDUC = 2'bxx;
		end
	end

	//Saver
	always @(*) begin
		if(in3) begin
			if(LB|LBU|LH|LHU|LW) begin
				SaverMUX_sel = 1;
				Saver_we = 1;
			end else begin
				SaverMUX_sel = 1'bx;
				Saver_we = 0;
			end
		end else if(in2) begin
			if(MFC0) begin
				SaverMUX_sel = 0;
				Saver_we = 1;
			end else begin
				SaverMUX_sel = 1'bx;
				Saver_we = 0;
			end
		end else begin
			SaverMUX_sel = 1'bx;
			Saver_we = 0;
		end
	end

	//SignExt16
	always @(*) begin
		if(in2) begin
			if(ADDI|ADDIU|LB|LBU|LH|LHU|LUI|LW|SB|SH|SLTI|SW) begin
				SignExt16MUX_sel = 1;
			end else begin
				SignExt16MUX_sel = 1'bx;
			end
		end else if(in4) begin
			if(LH) begin
				SignExt16MUX_sel = 0;
			end else begin
				SignExt16MUX_sel = 1'bx;
			end
		end else begin
			SignExt16MUX_sel = 1'bx;
		end
	end

	//ZeroExt16
	always @(*) begin
		if(in2) begin
			if(ANDI|ORI|SLTIU|XORI) begin
				ZeroExt16MUX_sel = 1;
			end else begin
				ZeroExt16MUX_sel = 1'bx;
			end
		end else if(in4) begin
			if(LHU) begin
				ZeroExt16MUX_sel = 0;
			end else begin
				ZeroExt16MUX_sel = 1'bx;
			end
		end else begin
			ZeroExt16MUX_sel = 1'bx;
		end
	end

	//CLZCounter
	always @(*) begin
		if(CLZ & in2) begin
			CLZCounter_start = 1;
		end else begin
			CLZCounter_start = 0;
		end
	end

	//HI LO
	always @(*) begin
		if((DIV|DIVU|MULTU)&in4) begin
			HIMUX_sel = 0;
			HI_we = 1;
		end else if(MTHI & in2) begin
			HIMUX_sel = 1;
			HI_we = 1;
		end else begin
			HIMUX_sel = 1'bx;
			HI_we = 0;
		end
	end

	always @(*) begin
		if((DIV|DIVU|MULTU)&in4) begin
			LOMUX_sel = 0;
			LO_we = 1;
		end else if(MTLO & in2) begin
			LOMUX_sel = 1;
			LO_we = 1;
		end else begin
			LOMUX_sel = 1'bx;
			LO_we = 0;
		end
	end

	//CP0
	assign CP0_mfc0 = (MFC0 & in2);
	assign CP0_mtc0 = (MTC0 & in2);
	assign CP0_exception = (((BREAK|SYSCALL) & in3)|(TEQ & in4));
	assign CP0_eret = (ERET & in2);
	always @(*) begin
		if(in3) begin
			if(BREAK) begin
				CP0_cause = 4'b1001;
			end else if(SYSCALL) begin
				CP0_cause = 4'b1000;
			end else begin
				CP0_cause = 4'bxxxx;
			end
		end else if(in4) begin
			if(TEQ) begin
				CP0_cause = 4'b1101;
			end else begin
				CP0_cause = 4'b0000;
			end
		end else begin
			CP0_cause = 4'bxxxx;
		end
	end
endmodule































