// MEM WB 间的寄存器
module pipe_mwreg(
    input clk,
    input mem_rf_we,
    input [31:0]mem_Z,
    input [31:0]mem_dmem_out,
    input [4:0]mem_rt,
    input [4:0]mem_rd,
    input mem_rf_addr_sel,
    input mem_rf_data_sel,
    output reg wb_rf_we, //Regfile 写有效信号
    output reg [31:0]wb_Z,
    output reg [31:0]wb_Saver,
    output reg [4:0]wb_rt,
    output reg [4:0]wb_rd,
    output reg wb_rf_addr_sel,
    output reg wb_rf_data_sel
);
    always @(posedge clk) begin
        wb_rf_we <= mem_rf_we;
        wb_Z <= mem_Z;
        wb_Saver <= mem_dmem_out;
        wb_rt <= mem_rt;
        wb_rd <= mem_rd;
        wb_addr_sel <= mem_addr_sel;
        wb_data_sel <= mem_addr_sel;
    end
endmodule


// EXE MEM 间的寄存器
module pipe_emreg(
    input clk,
    input exe_rf_we,
    input [31:0]exe_Z,
    input [4:0]exe_rt,
    input [4:0]exe_rd,
    input exe_rf_addr_sel,
    input exe_rf_data_sel,
    input [31:0]exe_dmem_wdata, // MEM 级写入内容
    input exe_dmem_wr_ena, // MEM 级读写指示
    output reg mem_rf_we,
    output reg [31:0]mem_Z,
    output reg [4:0]mem_rt,
    output reg [4:0]mem_rd,
    output reg mem_rf_addr_sel,
    output reg mem_rf_data_sel,
    output reg [31:0]mem_dmem_wdata,
    output reg mem_dmem_wr_ena
);
    always @(posedge clk) begin
        mem_rf_we <= exe_rf_we;
        mem_Z <= exe_Z;
        mem_rt <= exe_rt;
        mem_rd <= exe_rd;
        mem_rf_addr_sel <= exe_rf_addr_sel;
        mem_rf_data_sel <= exe_rf_data_sel;
        mem_dmem_wdata <= exe_dmem_wdata;
        mem_dmem_wr_ena <= exe_dmem_wr_ena;
    end
endmodule

// ID EXE 间的寄存器
module pipe_iereg(
    input clk,
    input we,
    input [31:0]id_rs_value,
    input [31:0]id_ze5,
    input [31:0]id_se18,
    input [31:0]id_se16,
    input [31:0]id_rt_value,
    input id_amux_sel,
    input [1:0]id_bmux_sel,
    input [3:0]id_aluc,
    input id_rf_we,
    input [4:0]id_rt,
    input [4:0]id_rd,
    input id_rf_addr_sel,
    input id_rf_data_sel,
    input [31:0]id_dmem_wdata,
    input id_dmem_wr_ena,
    output reg [31:0]exe_rs_value,
    output reg [31:0]exe_ze5,
    output reg [31:0]exe_se16,
    output reg [31:0]exe_ze16,
    output reg [31:0]exe_rt_value,
    output reg exe_amux_sel,
    output reg [1:0]exe_bmux_sel,
    output reg [3:0]exe_aluc,
    output reg exe_rf_we,
    output reg [4:0]exe_rt,
    output reg [4:0]exe_rd,
    output reg exe_rf_addr_sel,
    output reg exe_rf_data_sel,
    output reg [31:0]exe_dmem_wdata,
    output reg exe_dmem_wr_ena
);
    always @(clk) begin
        if(we) begin 
            exe_rs_value <= id_rs_value;
            exe_ze5 <= id_ze5;
            exe_se16 <= id_se16;
            exe_ze16 <= id_ze16;
            exe_rt_value <= id_rt_value;
            exe_amux_sel <= id_amux_sel;
            exe_bmux_sel <= id_bmux_sel;
            exe_aluc <= id_aluc;
            exe_rf_we <= id_rf_we;
            exe_rt <= id_rt;
            exe_rd <= id_rd;
            exe_rf_addr_sel <= id_rf_addr_sel;
            exe_rf_data_sel <= id_rf_data_sel;
            exe_dmem_wdata <= id_dmem_wdata;
            exe_dmem_wr_ena <= id_dmem_wr_ena;
        end else begin
            exe_rs_value <= exe_rs_value;
            exe_ze5 <= exe_ze5;
            exe_se16 <= exe_se16;
            exe_ze16 <= exe_ze16;
            exe_rt_value <= exe_rt_value;
            exe_amux_sel <= exe_amux_sel;
            exe_bmux_sel <= exe_bmux_sel;
            exe_aluc <= exe_aluc;
            exe_rf_we <= exe_rf_we;
            exe_rt <= exe_rt;
            exe_rd <= exe_rd;
            exe_rf_addr_sel <= exe_rf_addr_sel;
            exe_rf_data_sel <= exe_rf_data_sel;
            exe_dmem_wdata <= exe_dmem_wdata;
            exe_dmem_wr_ena <= exe_dmem_wr_ena;
        end
    end
endmodule