module ReadSelect(
	input [31:0]addr,
	input [31:0]DMEM,
	output [31:0]rdata
);

//lw 808 80c 814   820    824      828
//   Rdm Sw  Timer EthNew EthData1 EthData2

	// always @(*) begin
	// 	if(addr[11] == 1'b1) begin
	// 		//外设
	// 		case(addr[11:0])
	// 			12'h808: rdata = Random;
	// 			12'h80c: rdata = Switch;
	// 			12'h814: rdata = Timer;
	// 			12'h820: rdata = EthNew;
	// 			12'h824: rdata = EthData1;
	// 			12'h828: rdata = EthData2;
	// 			12'h834: rdata = EthSendFinish;
	// 			default: rdata = DMEM;
	// 		endcase
	// 	end else begin
	// 		//DMEM
	// 		rdata = DMEM;
	// 	end
	// end
    //暂时没有�?要读取数据的外设
    assign rdata = DMEM;
endmodule