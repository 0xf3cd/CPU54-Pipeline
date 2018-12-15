module WriteSelect(
	input [31:0]addr,
	input we,
	output reg DMEM_we,
	output reg Seg_we
	// output reg VGA_we,
	// output reg Timer_we,
	// output reg EthRst_we,
	// output reg EthSendData_we,
	// output reg EthSendEna_we
);

//sw 800 804 814   81c
//   VGA Seg Timer EthRst

    always @(*) begin
        // if(addr[11] == 1'b1) begin //是外??
            
        // end else begin //普??? DMEM 写操??
        //     DMEM_we = we;
        //     Seg_we = 1'b0;
        // end
		case(addr[12:0])
			13'h1004: begin
				Seg_we = we;
				DMEM_we = 1'b0;
			end
			default: begin
				Seg_we = 1'b0;
				DMEM_we = we;
			end
		endcase
    end

	// always @(*) begin
	// 	if(addr[11] == 1'b1) begin
	// 		//外设
	// 		case(addr[11:0])
	// 			12'h800: begin
	// 				VGA_we = we;
	// 				Seg_we = 1'b0;
	// 				DMEM_we = 1'b0;
	// 				Timer_we = 1'b0;
	// 				EthRst_we = 1'b0;
	// 				EthSendData_we = 1'b0;
	// 				EthSendEna_we = 1'b0;
	// 			end
	// 			12'h804: begin
	// 				VGA_we = 1'b0;
	// 				Seg_we = we;
	// 				DMEM_we = 1'b0;
	// 				Timer_we = 1'b0;
	// 				EthRst_we = 1'b0;
	// 				EthSendData_we = 1'b0;
	// 				EthSendEna_we = 1'b0;
	// 			end
	// 			12'h814: begin
	// 				VGA_we = 1'b0;
	// 				Seg_we = 1'b0;
	// 				DMEM_we = 1'b0;
	// 				Timer_we = we;
	// 				EthRst_we = 1'b0;
	// 				EthSendData_we = 1'b0;
	// 				EthSendEna_we = 1'b0;
	// 			end
	// 			12'h81c: begin
	// 				VGA_we = 1'b0;
	// 				Seg_we = 1'b0;
	// 				DMEM_we = 1'b0;
	// 				Timer_we = 1'b0;
	// 				EthRst_we = we;
	// 				EthSendData_we = 1'b0;
	// 				EthSendEna_we = 1'b0;
	// 			end
	// 			12'h82c: begin
	// 				VGA_we = 1'b0;
	// 				Seg_we = 1'b0;
	// 				DMEM_we = 1'b0;
	// 				Timer_we = 1'b0;
	// 				EthRst_we = 1'b0;
	// 				EthSendData_we = 1'b0;
	// 				EthSendEna_we = we;
	// 			end
	// 			12'h830: begin
	// 				VGA_we = 1'b0;
	// 				Seg_we = 1'b0;
	// 				DMEM_we = 1'b0;
	// 				Timer_we = 1'b0;
	// 				EthRst_we = 1'b0;
	// 				EthSendData_we = we;
	// 				EthSendEna_we = 1'b0;
	// 			end
	// 			default: begin
	// 				VGA_we = 1'b0;
	// 				Seg_we = 1'b0;
	// 				DMEM_we = 1'b0;
	// 				Timer_we = 1'b0;
	// 				EthRst_we = 1'b0;
	// 				EthSendData_we = 1'b0;
	// 				EthSendEna_we = 1'b0;
	// 			end
	// 		endcase
	// 	end else begin
	// 		//普???DMEM
	// 		VGA_we = 1'b0;
	// 		Seg_we = 1'b0;
	// 		DMEM_we = we;
	// 		Timer_we = 1'b0;
	// 		EthRst_we = 1'b0;
	// 		EthSendData_we = 1'b0;
	// 		EthSendEna_we = 1'b0;
	// 	end
	// end
endmodule