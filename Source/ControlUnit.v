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

`define OP_R_TYPE 6'b000000
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

module ID_ControlUnit(
	input [5:0]op,
	input [4:0]rs,
	input [4:0]rt,
	input [5:0]func,
	input exe_rf_we,
	input [4:0]exe_rf_waddr,
	input mem_rf_we,
	input [4:0]mem_rf_waddr,
	input [31:0]rs_value,
	input [31:0]rt_value,
	// input id_stop,
	output reg id_change_pc, //OK
	output reg [1:0]id_pc_mux_sel, //OK
	output reg id_amux_sel, //OK
	output reg [1:0]id_bmux_sel, //OK
	output reg [3:0]aluc, //OK
	// output reg id_stop,
	output reg id_rf_we, //OK
	output reg [1:0]id_rf_waddr_sel, //OK
	output reg [1:0]id_rf_data_sel, //OK
	output reg id_dmem_we //OK
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

	// wire R_TYPE = (op == `OP_R_TYPE);
	// wire J_TYPE = (J || JAL);
	// wire I_TYPE = (ADDI || );

	// wire rs_exe_conf = (exe_rf_we && exe_rf_waddr == rs && exe_rf_waddr != 5'b0);
	// wire rt_exe_conf = (exe_rf_we && exe_rf_waddr == rt && exe_rf_waddr != 5'b0);
	// wire rs_mem_conf = (mem_rf_we && mem_rf_waddr == rs && mem_rf_waddr != 5'b0);
	// wire rt_mem_conf = (mem_rf_we && mem_rf_waddr == rt && mem_rf_waddr != 5'b0);
	// wire conf = (rs_exe_conf || rt_exe_conf || rs_mem_conf || rt_mem_conf);
	// wire rs_conf = (rs_exe_conf || rs_mem_conf);

	// //id_stop
	// always @(*) begin
	// 	if(R_TYPE) begin
	// 		if(conf) begin
	// 			id_stop = 1'b1;
	// 		end else begin
	// 			id_stop = 1'b0;
	// 		end
	// 	end else if(I_TYPE) begin
	// 		if(BEQ || BNE) begin
	// 			if(conf) begin
	// 				id_stop = 1'b1;
	// 			end else begin
	// 				id_stop = 1'b0;
	// 			end
	// 		end else begin
	// 			if(rs_conf) begin
	// 				id_stop = 1'b1;
	// 			end else begin
	// 				id_stop = 1'b0;
	// 			end
	// 		end
	// 	end else begin //J_TYPE
	// 		id_stop = 1'b0;
	// 	end
	// end

	//ALUC输出
	always @(*) begin
		if(op == `OP_R_TYPE) begin
			//R类型操作
			case(func)
				`FUNC_ADD: begin
					aluc = `ALUC_ADD;
				end
				`FUNC_ADDU: begin
					aluc = `ALUC_ADDU;
				end
				`FUNC_SUB: begin
					aluc = `ALUC_SUB;
				end
				`FUNC_SUBU: begin
					aluc = `ALUC_SUBU;
				end
				`FUNC_AND: begin
					aluc = `ALUC_AND;
				end 
				`FUNC_OR: begin
					aluc = `ALUC_OR;
				end
				`FUNC_XOR: begin
					aluc = `ALUC_XOR;
				end 
				`FUNC_NOR: begin
					aluc = `ALUC_NOR;
				end 
				`FUNC_SLT: begin
					aluc = `ALUC_SLT;
				end 
				`FUNC_SLTU: begin
					aluc = `ALUC_SLTU;
				end
				`FUNC_SLL: begin
					aluc = `ALUC_SLL;
				end 
				`FUNC_SRL: begin
					aluc = `ALUC_SRL;
				end 
				`FUNC_SRA: begin
					aluc = `ALUC_SRA;
				end 
				`FUNC_SLLV: begin
					aluc = `ALUC_SLL;
				end
				`FUNC_SRLV: begin
					aluc = `ALUC_SRL;
				end
				`FUNC_SRAV: begin
					aluc = `ALUC_SRA;
				end
				default: begin
					aluc = 4'bxxxx;
				end
			endcase
		end else begin
			//非R类型操作
			case(op)
				`OP_ADDI: begin
					aluc = `ALUC_ADD;
				end
				`OP_ADDIU: begin
					aluc = `ALUC_ADDU;
				end
				`OP_ANDI: begin
					aluc = `ALUC_AND;
				end
				`OP_ORI: begin
					aluc = `ALUC_OR;
				end
				`OP_XORI: begin
					aluc = `ALUC_XOR;
				end
				`OP_LW: begin
					aluc = `ALUC_ADD;
				end
				`OP_SW: begin
					aluc = `ALUC_ADD;
				end
				// `OP_BEQ: begin
				// 	aluc = `ALUC_SUB;
				// end
				// `OP_BNE: begin
				// 	aluc = `ALUC_SUB;
				// end
				`OP_SLTI: begin
					aluc = `ALUC_SLT;
				end
				`OP_SLTIU: begin
					aluc = `ALUC_SLTU;
				end
				`OP_LUI: begin
					aluc = `ALUC_LUI;
				end
				default: begin
					aluc = 4'bxxxx;
				end
			endcase
		end
	end

	//id_amux_sel
	always @(*) begin
		if(SLL || SRA || SRL) begin
			id_amux_sel = 1'b1;
		end else begin
			id_amux_sel = 1'b0;
		end
	end

	//id_bmux_sel
	always @(*) begin
		if(ADDI || ADDIU || LUI || LW || SLTI || SW) begin
			id_bmux_sel = 2'b00;
		end else if(ANDI || ORI || SLTIU || XORI) begin
			id_bmux_sel = 2'b01;
		end else begin
			id_bmux_sel = 2'b1x;
		end
	end

	//id_change_pc
	always @(*) begin
		if(J || JAL || JR) begin
			id_change_pc = 1'b1;
		end else if(BNE) begin
			if(rs_value == rt_value) begin
				id_change_pc = 1'b0;
			end else begin
				id_change_pc = 1'b1;
			end
		end else if(BEQ) begin
			if(rs_value == rt_value) begin
				id_change_pc = 1'b1;
			end else begin
				id_change_pc = 1'b0;
			end
		end else begin
			id_change_pc = 1'b0;
		end
	end

	//id_pc_mux_sel
	always @(*) begin
		if(J || JAL) begin
			id_pc_mux_sel = 2'b00;
		end else if(JR) begin
			id_pc_mux_sel = 2'b01;
		end else if(BNE || BEQ) begin
			id_pc_mux_sel = 2'b1x;
		end else begin
			id_pc_mux_sel = 2'bxx;
		end
	end

	//id_dmem_we
	always @(*) begin
		if(SW) begin
			id_dmem_we = 1'b1;
		end else begin
			id_dmem_we = 1'b0;
		end
	end

	//id_rf_we
	// always @(*) begin
	// 	if(R_TYPE) begin
	// 		if(JR) begin
	// 			id_rf_we = 1'b0;
	// 		end else begin
	// 			id_rf_we = ~id_stop;
	// 		end
	// 	end else if(I_TYPE) begin
	// 		if(BEQ || BNE || SW) begin
	// 			id_rf_we = 1'b0;
	// 		end else begin
	// 			id_rf_we = ~id_stop;
	// 		end
	// 	end else if(J_TYPE) begin //J_TYPE
	// 		if(JAL) begin
	// 			id_rf_we = ~id_stop;
	// 		end else begin
	// 			id_rf_we = 1'b0;
	// 		end
	// 	end else begin 
	// 		id_rf_we = 1'b0;
	// 	end
	// end
	always @(*) begin
		// if(BEQ || BNE || SW || J || JAL || JR) begin
		// 	id_rf_we = 1'b0;
		// end
		if(ADDI||ADDIU||ANDI||LUI||LW||ORI||SLTI||SLTIU||XORI||ADD|ADDU||AND||NOR||OR||SLL||SLLV||SLT||SLTU||SRA||SRAV||SRL||SRLV||SUB||SUBU||XOR) begin
			id_rf_we = 1'b1; //~id_stop;
		end else begin
			id_rf_we = 1'b0;
		end
	end

	//id_rf_waddr_sel
	always @(*) begin
		if(JAL) begin
			id_rf_waddr_sel = 2'b1x;
		end else if(ADDI || ADDIU || ANDI || LUI || LW || ORI || SLTI || SLTIU || XORI) begin
			id_rf_waddr_sel = 2'b00;
		end else begin
			id_rf_waddr_sel = 2'b01;
		end 
	end

	//id_rf_data_sel
	always @(*) begin
		if(LW) begin
			id_rf_data_sel = 2'b01;
		end else if(JAL) begin
			id_rf_data_sel = 2'b1x;
		end else begin
			id_rf_data_sel = 2'b00;
		end
	end

	//id_lw
	// always @(*) begin
	// 	if(LW) begin
	// 		id_lw = 1'b1;
	// 	end else begin
	// 		id_lw = 1'b0;
	// 	end
	// end
endmodule

module IF_ControlUnit(
	input id_change_pc, //来自 ID 阶段的控制器�? PC 更改信号，遇�? JAL BEQ 等指令时（可能）会为 1
	// input id_stop_pc, //来自 ID 阶段的控制器信号，是否停止更�? PC 的�??
	output reg [1:0]if_pc_mux_sel
	// output reg IR_we
);
	always @(*) begin
		// if(id_stop_pc) begin
		// 	if_pc_mux_sel = 2'b1x;
		// end else begin
		// 	if(id_change_pc) begin
		// 		if_pc_mux_sel = 2'b01;
		// 	end else begin
		// 		if_pc_mux_sel = 2'b00;
		// 	end
		// end
		if(id_change_pc) begin
			if_pc_mux_sel = 2'b01;
		end else begin
			if_pc_mux_sel = 2'b00;
		end 
	end
endmodule