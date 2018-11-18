// MEM WB 间的寄存器
module Pipe_mwreg(
    input clk,
    input reset,
    input mem_rf_we,
    input [31:0]mem_Z,
    input [31:0]mem_dmem_out,
    input [4:0]mem_rf_waddr,
    input mem_rf_data_sel,
    output reg wb_rf_we, //Regfile 写有效信号
    output reg [31:0]wb_Z,
    output reg [31:0]wb_Saver,
    output reg [4:0]wb_rf_waddr,
    output reg wb_rf_data_sel
);
    always @(posedge reset or posedge clk) begin
        if(reset) begin
            wb_rf_we <= 1'b0;
            wb_Z <= 32'b0;
            wb_Saver <= 32'b0;
            wb_rf_waddr <= 5'b0;
            wb_rf_data_sel <= 1'b0;
        end else begin
            wb_rf_we <= mem_rf_we;
            wb_Z <= mem_Z;
            wb_Saver <= mem_dmem_out;
            wb_rf_waddr <= mem_rf_waddr;
            wb_rf_data_sel <= mem_rf_data_sel;
        end
    end
endmodule


// EXE MEM 间的寄存器
module Pipe_emreg(
    input clk,
    input reset,
    input exe_rf_we,
    input [31:0]exe_Z,
    input [4:0]exe_rf_waddr,
    input exe_rf_data_sel,
    input [31:0]exe_dmem_wdata, // MEM 级写入内容
    input exe_dmem_we, // MEM 级读写指示
    output reg mem_rf_we,
    output reg [31:0]mem_Z,
    output reg [4:0]mem_rf_waddr,
    output reg mem_rf_data_sel,
    output reg [31:0]mem_dmem_wdata,
    output reg mem_dmem_we
);
    always @(posedge reset or posedge clk) begin
        if(reset) begin
            mem_rf_we <= 1'b0;
            mem_Z <= 32'b0;
            mem_rf_waddr <= 5'b0;
            mem_rf_data_sel <= 1'b0;
            mem_dmem_wdata <= 32'b0;
            mem_dmem_we <= 1'b0;
        end else begin
            mem_rf_we <= exe_rf_we;
            mem_Z <= exe_Z;
            mem_rf_waddr <= exe_rf_waddr;
            mem_rf_data_sel <= exe_rf_data_sel;
            mem_dmem_wdata <= exe_dmem_wdata;
            mem_dmem_we <= exe_dmem_we;
        end
    end
endmodule

// ID EXE 间的寄存器
module Pipe_iereg(
    input clk,
    input reset,
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
    input [4:0]id_rf_waddr,
    input id_rf_data_sel,
    input [31:0]id_dmem_wdata,
    input id_dmem_we,
    output reg [31:0]exe_rs_value,
    output reg [31:0]exe_ze5,
    output reg [31:0]exe_se16,
    output reg [31:0]exe_ze16,
    output reg [31:0]exe_rt_value,
    output reg exe_amux_sel,
    output reg [1:0]exe_bmux_sel,
    output reg [3:0]exe_aluc,
    output reg exe_rf_we,
    output reg [4:0]exe_rf_waddr
    output reg exe_rf_data_sel,
    output reg [31:0]exe_dmem_wdata,
    output reg exe_dmem_we
);
    always @(posedge reset or posedge clk) begin
        if(reset) begin
            exe_rs_value <= 32'b0;
            exe_ze5 <= 32'b0;
            exe_se16 <= 32'b0;
            exe_ze16 <= 32'b0;
            exe_rt_value <= 32'b0;
            exe_amux_sel <= 1'b0;
            exe_bmux_sel <= 2'b0;
            exe_aluc <= 4'b0;
            exe_rf_we <= 'b0;
            exe_rf_waddr <= 5'b0;
            exe_rf_data_sel <= 1'b0;
            exe_dmem_wdata <= 32'b0;
            exe_dmem_we <= 1'b0;
        end else begin
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
                exe_rf_waddr <= id_rf_waddr;
                exe_rf_data_sel <= id_rf_data_sel;
                exe_dmem_wdata <= id_dmem_wdata;
                exe_dmem_we <= id_dmem_we;
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
                exe_rf_waddr <= exe_rf_waddr;
                exe_rf_data_sel <= exe_rf_data_sel;
                exe_dmem_wdata <= exe_dmem_wdata;
                exe_dmem_we <= exe_dmem_we;
            end
        end
    end
endmodule

//IF ID 间的寄存器
module Pipe_iireg(
    input clk,
    input reset,
    input we,
    input [31:0]inst,
    output reg [31:0]id_inst
);
    always @(posedge reset or posedge clk) begin
        if(reset) begin
            id_inst <= 32'b0;
        end else begin
            if(we) begin
                id_inst <= inst;
            end else begin
                id_inst <= id_inst;
            end
        end
    end
endmodule