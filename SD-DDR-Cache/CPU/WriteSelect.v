module WriteSelect(
	input [31:0]addr,
	input we,
	output DMEM_we,
	output SD_WB_Addr_we,
	output SD_WB_Control_we,
	output SD_WB_Wdata_we,
	output SD_Addr_we,
	output SD_Control_we,
	output SD_RD_Addr_we,
	output DDR2_WB_Wdata_we,
	output DDR2_WB_Addr_we,
	output DDR2_WB_Control_we,
	output DDR2_Addr_we,
	output DDR2_Control_we,
	output DDR2_RD_Addr_we,
	output IMEM_Addr_we,
	output IMEM_Control_we,
	// output DMEM_Addr_we,
	// output DMEM_Control_we,
	output LED_we,
	output Seg_we
);
	assign DMEM_we = we && ~addr[14];

    assign SD_WB_Addr_we = we && (addr[14:0] == 15'h4000);
	assign SD_WB_Control_we = we && (addr[14:0] == 15'h4004);
	assign SD_WB_Wdata_we = we && (addr[14:0] == 15'h4008);
	assign SD_Addr_we = we && (addr[14:0] == 15'h400C);
	assign SD_Control_we = we && (addr[14:0] == 15'h4010);
	assign SD_RD_Addr_we = we && (addr[14:0] == 15'h4018);
	assign DDR2_WB_Wdata_we = we && (addr[14:0] == 15'h401C);
	assign DDR2_WB_Addr_we = we && (addr[14:0] == 15'h4020);
	assign DDR2_WB_Control_we = we && (addr[14:0] == 15'h4024);
	assign DDR2_Addr_we = we && (addr[14:0] == 15'h4028);
	assign DDR2_Control_we = we && (addr[14:0] == 15'h402C);
	assign DDR2_RD_Addr_we = we && (addr[14:0] == 15'h4034);
	assign IMEM_Addr_we = we && (addr[14:0] == 15'h4038);
	assign IMEM_Control_we = we && (addr[14:0] == 15'h403C);
	// assign DMEM_Addr_we = we && (addr[14:0] == 15'h4040);
	// assign DMEM_Control_we= we && (addr[14:0] == 15'h4044);
	assign LED_we = we && (addr[14:0] == 15'h4054);
	assign Seg_we = we && (addr[14:0] == 15'h4050);
endmodule