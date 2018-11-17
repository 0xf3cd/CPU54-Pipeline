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

    
endmodule