module SD(
    input clk,
    input reset,
    input dout,
    input [31:0]addr,
    input [4095:0]wdata,
    input we,
    input re,
    output sdclk,
    output reg din,
    output reg cs,
    output [4095:0]rdata,
    output init_ok,
    output reg err,
    output reg wend,
    output reg rend
);
	wire clk_low;
	reg [9:0]cnt = 10'b0;
    always @(posedge clk) begin
        cnt <= cnt + 1'b1;
    end
    assign clk_low = cnt[9];

    reg sdclk_cs = 1'b0; // 由状态机提供
    reg [1:0]din_cs = 2'b0; // 由状态机提供 0x init; 10 read; 11 write
    reg [1:0]cs_cs = 2'b0; // 由状态机提供 0x init; 10 read; 11 write
    wire sdclk_;
    assign sdclk = sdclk_;

  

    // reg init_start = 1'b0;
    wire init_cs, init_din, init_err;
    SD_Initialize SI(sdclk_, reset, 1'b1, dout, init_cs, init_din, init_ok, init_err);

    reg sr_en = 1'b0; // 由状态机提供
    wire sr_cs, sr_din, sr_end, sr_err;
    SD_Read SR(sdclk_, reset, addr, sr_en, dout, sr_cs, sr_din, rdata, sr_end, sr_err);

    reg sw_en = 1'b0; // 由状态机控制
    wire sw_cs, sw_din, sw_end, sw_err;
    SD_Write SW(sdclk_, reset, addr, wdata, sw_en, dout, sw_cs, sw_din, sw_end, sw_err);
	
	parameter INIT = 7'd1;
	parameter IDLE = 7'd2;
	parameter READ = 7'd4;
	parameter READ_END = 7'd8;
	parameter WRITE = 7'd16;
	parameter WRITE_END = 7'd32;
	parameter ERROR = 7'd64;

	reg [6:0]current_state = INIT;
	reg [6:0]next_state = INIT;

	always @(posedge clk or posedge reset) begin
		if(reset) begin
			current_state <= INIT;
		end else begin
			current_state <= next_state;
		end
	end

	always @(*) begin
		case(current_state)
			INIT: begin
				if(init_ok) begin
					next_state = IDLE;
				end else if(init_err) begin
					next_state = ERROR;
				end else begin
					next_state = INIT;
				end
			end
			IDLE: begin
				if(re) begin
					next_state = READ;
				end else if(we) begin
					next_state = WRITE;
				end else begin
					next_state = IDLE;
				end
			end
			READ: begin
				if(sr_end) begin
					next_state = READ_END;
				end else if(sr_err) begin
					next_state = ERROR;
				end else begin
					next_state = READ;
				end
			end
			READ_END: begin
				if(re) begin
					next_state = READ_END;
				end else begin
					next_state = IDLE;
				end
			end
			WRITE: begin
				if(sw_end) begin
					next_state = WRITE_END;
				end else if(sw_err) begin
					next_state = ERROR;
				end else begin
					next_state = WRITE;
				end
			end
			WRITE_END: begin
				if(we) begin
					next_state = WRITE_END;
				end else begin
					next_state = IDLE;
				end
			end
			ERROR: begin
				next_state = ERROR;
			end
			default: begin
				next_state = INIT;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			READ_END: begin
				err = 1'b0;
				rend = 1'b1;
				wend = 1'b0;
			end
			WRITE_END: begin
				err = 1'b0;
				rend = 1'b0;
				wend = 1'b1;
			end
			ERROR: begin
				err = 1'b1;
				rend = 1'b0;
				wend = 1'b0;
			end
			default: begin
				err = 1'b0;
				rend = 1'b0;
				wend = 1'b0;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			READ: begin
				sw_en = 1'b0;
				sr_en = 1'b1;
			end
			READ_END: begin
				sw_en = 1'b0;
				sr_en = 1'b1;
			end
			WRITE: begin
				sw_en = 1'b1;
				sr_en = 1'b0;
			end
			WRITE_END: begin
				sw_en = 1'b1;
				sr_en = 1'b0;
			end
			default: begin
				sw_en = 1'b0;
				sr_en = 1'b0;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			INIT: begin
				sdclk_cs = 1'b0;
			end
			default: begin
				sdclk_cs = 1'b1;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			INIT: begin
				din_cs = 2'b0x;
				cs_cs = 2'b0x;
			end
			READ: begin
				din_cs = 2'b10;
				cs_cs = 2'b10;
			end
			READ_END: begin
				din_cs = 2'b10;
				cs_cs = 2'b10;				
			end
			WRITE: begin
				din_cs = 2'b11;
				cs_cs = 2'b11;				
			end
			WRITE_END: begin
				din_cs = 2'b11;
				cs_cs = 2'b11;				
			end
			default: begin
				din_cs = 2'b0x;
				cs_cs = 2'b0x;
			end
		endcase
	end
    
    assign sdclk_ = sdclk_cs? clk: clk_low;
      
	always @(*) begin // 0x init; 10 read; 11 write
		if(din_cs[1]) begin
			if(din_cs[0]) begin
				din = sw_din;
			end else begin
				din = sr_din;
			end
		end else begin
			// 0x
			din = init_din;
		end
	end

	always @(*) begin // 0x init; 10 read; 11 write
		if(cs_cs[1]) begin
			if(cs_cs[0]) begin
				cs = sw_cs;
			end else begin
				cs = sr_cs;
			end
		end else begin
			// 0x
			cs = init_cs;
		end
	end
endmodule

module SD_Write_Buffer(
	input clk,
	input reset,
	input [31:0]data,
	input [6:0]addr,
	input we,
	output reg [4095:0]buffer
);
	always @(negedge clk or posedge reset) begin
		if(reset) begin
			buffer <= 4096'd0;
		end else begin
			if(we) begin
				buffer[{addr, 5'd31}] <= data[0];
				buffer[{addr, 5'd30}] <= data[1];
				buffer[{addr, 5'd29}] <= data[2];
				buffer[{addr, 5'd28}] <= data[3];
				buffer[{addr, 5'd27}] <= data[4];
				buffer[{addr, 5'd26}] <= data[5];
				buffer[{addr, 5'd25}] <= data[6];
				buffer[{addr, 5'd24}] <= data[7];
				buffer[{addr, 5'd23}] <= data[8];
				buffer[{addr, 5'd22}] <= data[9];
				buffer[{addr, 5'd21}] <= data[10];
				buffer[{addr, 5'd20}] <= data[11];
				buffer[{addr, 5'd19}] <= data[12];
				buffer[{addr, 5'd18}] <= data[13];
				buffer[{addr, 5'd17}] <= data[14];
				buffer[{addr, 5'd16}] <= data[15];
				buffer[{addr, 5'd15}] <= data[16];
				buffer[{addr, 5'd14}] <= data[17];
				buffer[{addr, 5'd13}] <= data[18];
				buffer[{addr, 5'd12}] <= data[19];
				buffer[{addr, 5'd11}] <= data[20];
				buffer[{addr, 5'd10}] <= data[21];
				buffer[{addr, 5'd9}] <= data[22];
				buffer[{addr, 5'd8}] <= data[23];
				buffer[{addr, 5'd7}] <= data[24];
				buffer[{addr, 5'd6}] <= data[25];
				buffer[{addr, 5'd5}] <= data[26];
				buffer[{addr, 5'd4}] <= data[27];
				buffer[{addr, 5'd3}] <= data[28];
				buffer[{addr, 5'd2}] <= data[29];
				buffer[{addr, 5'd1}] <= data[30];
				buffer[{addr, 5'd0}] <= data[31];
			end	
		end
	end
endmodule

module SD_Write(
	input sdclk,
	input reset,
	input [31:0]addr,
	input [4095:0]wdata,
	input we,
	input dout,
	output reg cs,
	output din,
	output reg wend,
	output reg werr
);
	parameter CMD24_HEAD = 8'h58;
	parameter CMD24_CRC = 8'hFF;
	parameter CMD24_RSPS = 8'h00;

	reg din_cs = 1'b0; // 由状态机控制
	reg c_din = 1'b1; // command
	reg d_din = 1'b1; // data
	assign din = din_cs? d_din: c_din;

	reg [47:0]cmd_reg; // = {CMD24_HEAD, addr, CMD24_CRC};
	reg cmd_update = 1'b0;  // 由状态机控制
	reg cmd_send_ena = 1'b0;  // 由状态机控制
	reg [5:0]cmd_cnt = 6'b0;

	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			cmd_cnt <= 6'b0;
		end else begin
			if(cmd_send_ena) begin
				cmd_cnt <= cmd_cnt + 1'b1;
			end else begin
				cmd_cnt <= 6'b0;
			end
		end
	end
	
	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			cmd_reg <= 48'HFF_FF_FF_FF_FF_FF;
			c_din <= 1'b1;
		end else begin
			if(cmd_update) begin
				cmd_reg <= {CMD24_HEAD, addr, CMD24_CRC};
				c_din <= 1'b1;
			end else begin
				if(cmd_send_ena) begin
					if(cmd_cnt >= 6'd1 && cmd_cnt <= 6'd48) begin
						cmd_reg <= {cmd_reg[46:0], 1'b1};
						c_din <= cmd_reg[47];
					end else begin
						cmd_reg <= cmd_reg;
						c_din <= 1'b1;
					end
				end else begin
					cmd_reg <= cmd_reg;
					c_din <= 1'b1;
				end
			end
		end
	end

	reg [7:0]rsps_reg = 8'hFF;
	reg rsps_read_ena = 1'b0; // 由状态机控制

	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			rsps_reg <= 8'hFF;
		end else begin
			if(rsps_read_ena) begin
				if(rsps_reg[7]) begin
					rsps_reg <= {rsps_reg[6:0], dout};
				end else begin
					rsps_reg <= rsps_reg; // 首位为 0 说明接收结束
				end
			end else begin
				rsps_reg <= 8'hFF;
			end
		end
	end

	reg [4:0]empty_clk_cnt = 5'b0;
	reg empty_clk_ena = 1'b0; // 由状态机控制

	always @(posedge sdclk or posedge reset) begin
		if(reset) begin
			empty_clk_cnt <= 5'b0;
		end else begin
			if(empty_clk_ena) begin
				empty_clk_cnt <= empty_clk_cnt + 1'b1;
			end else begin
				empty_clk_cnt <= 5'b0;
			end
		end
	end

	reg [4097:0]w_reg = {4098{1'b1}};
	reg write_data_save = 1'b0; // 由状态机提供
	reg write_data_en = 1'b0; // 由状态机提供

	always @(posedge sdclk or posedge reset) begin
		if(reset) begin
			w_reg <= {4098{1'b1}};
			d_din <= 1'b1;
		end else begin
			if(write_data_save) begin
				w_reg <= {wdata, 1'b0, 1'b1};
				d_din <= 1'b1;
			end else begin
				if(write_data_en) begin
					d_din <= w_reg[0];
					w_reg <= {1'b1, w_reg[4097:1]};
				end else begin
					d_din <= 1'b1;
					w_reg <= w_reg;
				end
			end
		end
	end

	reg [12:0]w_cnt = 13'b0;
	reg w_cnt_ena = 1'b0; // 由状态机提供

	always @(posedge sdclk) begin
		if(w_cnt_ena) begin
			w_cnt <= w_cnt + 1'b1;
		end else begin
			w_cnt <= 13'b0;
		end
	end

	reg [7:0]dout_reg = 8'b0;
	always @(negedge sdclk) begin
		dout_reg <= {dout_reg[6:0], dout};
	end



	parameter IDLE = 11'd1;
	parameter WCMD_PRE = 11'd2;
	parameter WCMD_SEND = 11'd4;
	parameter WCMD_RSPS = 11'd8;
	parameter SEND_EMPTY_CLOCK = 11'd16;
	parameter WRITE = 11'd32;
	parameter WAIT_0x05 = 11'd64;
	parameter WAIT_0XFF = 11'd128;
	parameter PAUSE = 11'd256;
	parameter END = 11'd512;
	parameter ERROR = 11'd1024;

	reg [10:0]current_state = IDLE;
	reg [10:0]next_state = IDLE;

	always @(posedge sdclk or posedge reset) begin
		if(reset) begin
			current_state <= IDLE;
		end else begin
			current_state <= next_state;
		end
	end

	always @(*) begin
		case(current_state)
			IDLE: begin
				if(we) begin
					next_state = WCMD_PRE;
				end else begin
					next_state = IDLE;
				end
			end
			WCMD_PRE: begin
				next_state = WCMD_SEND;
			end
			WCMD_SEND: begin
				if(cmd_cnt >= 6'd49) begin
					next_state = WCMD_RSPS;
				end else begin
					next_state = WCMD_SEND;
				end
			end
			WCMD_RSPS: begin
				if(rsps_reg[7] == 1'b0) begin
					if(rsps_reg == CMD24_RSPS) begin
						next_state = SEND_EMPTY_CLOCK;
					end else begin
						next_state = ERROR;
					end
				end else begin
					next_state = WCMD_RSPS;
				end
			end
			SEND_EMPTY_CLOCK: begin
				if(empty_clk_cnt[4]) begin
					next_state = WRITE;
				end else begin
					next_state = SEND_EMPTY_CLOCK;
				end
			end
			WRITE: begin
				if(w_cnt == 13'd4099) begin
					next_state = WAIT_0x05;
				end else begin
					next_state = WRITE;
				end
			end
			WAIT_0x05: begin
				if(dout_reg != 8'hFF) begin
					next_state = WAIT_0XFF;
				end else begin
					next_state = WAIT_0x05;
				end
			end
			WAIT_0XFF: begin
				if(dout_reg == 8'hFF) begin
					next_state = PAUSE;
				end else begin
					next_state = WAIT_0XFF;
				end
			end
			PAUSE: begin
				if(empty_clk_cnt[4]) begin
					next_state = END;
				end else begin
					next_state = PAUSE;
				end
			end
			END: begin
				if(we) begin
					next_state = END;
				end else begin
					next_state = IDLE;
				end
			end
			ERROR: begin
				next_state = ERROR;
			end
			default: begin
				next_state = IDLE;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			WCMD_PRE: begin
				cmd_update = 1'b1;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
			end
			WCMD_SEND: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b1;
				rsps_read_ena = 1'b0;
			end
			WCMD_RSPS: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b1;
			end
			default: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			SEND_EMPTY_CLOCK: begin
				empty_clk_ena = 1'b1;
			end
			PAUSE: begin
				empty_clk_ena = 1'b1;
			end
			default: begin
				empty_clk_ena = 1'b0;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			SEND_EMPTY_CLOCK: begin
				write_data_save = 1'b1;
				write_data_en = 1'b0;
				w_cnt_ena = 1'b0;
			end
			WRITE: begin
				write_data_save = 1'b0;
				write_data_en = 1'b1;
				w_cnt_ena = 1'b1;
			end
			default: begin
				write_data_save = 1'b0;
				write_data_en = 1'b0;
				w_cnt_ena = 1'b0;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			WCMD_PRE: begin
				cs = 1'b0;
			end
			WCMD_SEND: begin
				cs = 1'b0;
			end
			WCMD_RSPS: begin
				cs = 1'b0;
			end
			SEND_EMPTY_CLOCK: begin
				cs = 1'b0;
			end
			WRITE: begin
				cs = 1'b0;
			end
			WAIT_0x05: begin
				cs = 1'b0;
			end
			WAIT_0XFF: begin
				cs = 1'b0;
			end
			default: begin
				cs = 1'b1;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			END: begin
				wend = 1'b1;
				werr = 1'b0;
			end
			ERROR: begin
				wend = 1'b0;
				werr = 1'b1;
			end
			default: begin
				wend = 1'b0;
				werr = 1'b0;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			WRITE: begin
				din_cs = 1'b1;
			end
			default: begin
				din_cs = 1'b0;
			end
		endcase
	end
endmodule

module SD_Read_Div(
	input [4095:0]data_in,
	input [6:0]addr,
	output [31:0]data_out
);
	assign data_out[31] = data_in[{addr, 5'd0}];
	assign data_out[30] = data_in[{addr, 5'd1}];
	assign data_out[29] = data_in[{addr, 5'd2}];
	assign data_out[28] = data_in[{addr, 5'd3}];
	assign data_out[27] = data_in[{addr, 5'd4}];
	assign data_out[26] = data_in[{addr, 5'd5}];
	assign data_out[25] = data_in[{addr, 5'd6}];
	assign data_out[24] = data_in[{addr, 5'd7}];
	assign data_out[23] = data_in[{addr, 5'd8}];
	assign data_out[22] = data_in[{addr, 5'd9}];
	assign data_out[21] = data_in[{addr, 5'd10}];
	assign data_out[20] = data_in[{addr, 5'd11}];
	assign data_out[19] = data_in[{addr, 5'd12}];
	assign data_out[18] = data_in[{addr, 5'd13}];
	assign data_out[17] = data_in[{addr, 5'd14}];
	assign data_out[16] = data_in[{addr, 5'd15}];
	assign data_out[15] = data_in[{addr, 5'd16}];
	assign data_out[14] = data_in[{addr, 5'd17}];
	assign data_out[13] = data_in[{addr, 5'd18}];
	assign data_out[12] = data_in[{addr, 5'd19}];
	assign data_out[11] = data_in[{addr, 5'd20}];
	assign data_out[10] = data_in[{addr, 5'd21}];
	assign data_out[9] = data_in[{addr, 5'd22}];
	assign data_out[8] = data_in[{addr, 5'd23}];
	assign data_out[7] = data_in[{addr, 5'd24}];
	assign data_out[6] = data_in[{addr, 5'd25}];
	assign data_out[5] = data_in[{addr, 5'd26}];
	assign data_out[4] = data_in[{addr, 5'd27}];
	assign data_out[3] = data_in[{addr, 5'd28}];
	assign data_out[2] = data_in[{addr, 5'd29}];
	assign data_out[1] = data_in[{addr, 5'd30}];
	assign data_out[0] = data_in[{addr, 5'd31}];
endmodule

module SD_Read(
	input sdclk,
	input reset,
	input [31:0]addr,
	input re,
	input dout,
	output reg cs,
	output reg din,
	output [4095:0]rdata,
	output reg rend,
	output reg rerr
);
	parameter CMD17_HEAD = 8'h51;
	parameter CMD17_CRC = 8'hFF;
	parameter CMD17_RSPS = 8'h00;

	reg [47:0]cmd_reg; // = {CMD17_HEAD, addr, CMD17_CRC};
	reg cmd_update = 1'b0;  // 由状态机控制
	reg cmd_send_ena = 1'b0;  // 由状态机控制
	reg [5:0]cmd_cnt = 6'b0;

	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			cmd_cnt <= 6'b0;
		end else begin
			if(cmd_send_ena) begin
				cmd_cnt <= cmd_cnt + 1'b1;
			end else begin
				cmd_cnt <= 6'b0;
			end
		end
	end
	
	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			cmd_reg <= 48'HFF_FF_FF_FF_FF_FF;
			din <= 1'b1;
		end else begin
			if(cmd_update) begin
				cmd_reg <= {CMD17_HEAD, addr, CMD17_CRC};
				din <= 1'b1;
			end else begin
				if(cmd_send_ena) begin
					if(cmd_cnt >= 6'd1 && cmd_cnt <= 6'd48) begin
						cmd_reg <= {cmd_reg[46:0], 1'b1};
						din <= cmd_reg[47];
					end else begin
						cmd_reg <= cmd_reg;
						din <= 1'b1;
					end
				end else begin
					cmd_reg <= cmd_reg;
					din <= 1'b1;
				end
			end
		end
	end

	reg [7:0]rsps_reg = 8'hFF;
	reg rsps_read_ena = 1'b0; // 由状态机控制

	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			rsps_reg <= 8'hFF;
		end else begin
			if(rsps_read_ena) begin
				if(rsps_reg[7]) begin
					rsps_reg <= {rsps_reg[6:0], dout};
				end else begin
					rsps_reg <= rsps_reg; // 首位为 0 说明接收结束
				end
			end else begin
				rsps_reg <= 8'hFF;
			end
		end
	end

	reg r_reg_clear = 1'b0; // 由状态机控制
	reg r_reg_ena = 1'b0; // 由状态机控制
	reg [4096:0]r_reg = {4097{1'b1}};
	assign rdata = r_reg[4096:1];

	always @(posedge sdclk or posedge reset or posedge r_reg_clear) begin
		if(reset || r_reg_clear) begin
			// rdata <= 4096'b0;
			r_reg <= {4097{1'b1}};
		end else begin
			if(r_reg_ena) begin
				if(r_reg[0]) begin
					r_reg <= {dout, r_reg[4096:1]};
					// rdata <= r_reg[4096:1];
				end else begin
					r_reg <= r_reg; // 如果首位为0，说明之后开始为读出的数据
					// rdata <= r_reg[4096:1];
				end
			end else begin
				// rdata <= rdata;
				r_reg <= r_reg;
			end
			
		end
	end

	reg [4:0]empty_clk_cnt = 5'b0;
	reg empty_clk_ena = 1'b0; // 由状态机控制

	always @(posedge sdclk or posedge reset) begin
		if(reset) begin
			empty_clk_cnt <= 5'b0;
		end else begin
			if(empty_clk_ena) begin
				empty_clk_cnt <= empty_clk_cnt + 1'b1;
			end else begin
				empty_clk_cnt <= 5'b0;
			end
		end
	end

	
	parameter IDLE = 8'd1;
	parameter RCMD_PRE = 8'd2;
	parameter RCMD_SEND = 8'd4;
	parameter RCMD_RSPS = 8'd8;
	parameter READ = 8'd16;
	parameter PAUSE = 8'd32;
	parameter END = 8'd64;
	parameter ERROR = 8'd128;

	reg [7:0]current_state = IDLE;
	reg [7:0]next_state = IDLE;

	// assign st = current_state;

	always @(posedge sdclk or posedge reset) begin
		if(reset) begin
			current_state <= IDLE;
		end else begin
			if(re) begin
				current_state <= next_state;
			end else begin
				current_state <= IDLE;
			end
		end
	end

	always @(*) begin
		case(current_state)
			IDLE: begin
				if(re) begin
					next_state = RCMD_PRE;
				end else begin
					next_state = IDLE;
				end
			end
			RCMD_PRE: begin
				next_state = RCMD_SEND;
			end
			RCMD_SEND: begin
				if(cmd_cnt >= 6'd49) begin
					next_state = RCMD_RSPS;
				end else begin
					next_state = RCMD_SEND;
				end
			end
			RCMD_RSPS: begin
				if(rsps_reg[7] == 1'b0) begin
					if(rsps_reg == CMD17_RSPS) begin
						next_state = READ;
					end else begin
						next_state = ERROR;
					end
				end else begin
					next_state = RCMD_RSPS;
				end
			end
			READ: begin
				if(r_reg[0]) begin
					next_state = READ;
				end else begin
					next_state = PAUSE;
				end
			end
			PAUSE: begin
				if(empty_clk_cnt[4]) begin
					next_state = END;
				end else begin
					next_state = PAUSE;
				end
			end
			END: begin
				if(re) begin
					next_state = END;
				end else begin
					next_state = IDLE;
				end
			end
			ERROR: begin
				next_state = ERROR;
			end
			default: begin
				next_state = IDLE;
			end
		endcase
	end

	// reg cmd_update = 1'b0;  // 由状态机控制
	// reg cmd_send_ena = 1'b0;  // 由状态机控制
	// reg rsps_read_ena = 1'b0; // 由状态机控制
	always @(*) begin
		case(current_state)
			RCMD_PRE: begin
				cmd_update = 1'b1;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
			end
			RCMD_SEND: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b1;
				rsps_read_ena = 1'b0;
			end
			RCMD_RSPS: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b1;
			end
			default: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
			end
		endcase
	end

	// r_reg_ena
	always @(*) begin
		case(current_state)
			IDLE: begin
				r_reg_clear = 1'b0;
				r_reg_ena = 1'b0;
			end
			RCMD_PRE: begin
				r_reg_clear = 1'b1;
				r_reg_ena = 1'b0;
			end
			READ: begin
				r_reg_clear = 1'b0;
				r_reg_ena = 1'b1;
			end
			default: begin
				r_reg_clear = 1'b0;
				r_reg_ena = 1'b0;
			end
		endcase
	end

	// reg empty_clk_ena = 1'b0; // 由状态机控制
	always @(*) begin
		case(current_state)
			PAUSE: begin
				empty_clk_ena = 1'b1;
			end
			default: begin
				empty_clk_ena = 1'b0;
			end
		endcase
	end

	always @(*) begin
		case(current_state)
			END: begin
				rend = 1'b1;
				rerr = 1'b0;
			end
			ERROR: begin
				rend = 1'b0;
				rerr = 1'b1;
			end
			default: begin
				rend = 1'b0;
				rerr = 1'b0;
			end
		endcase
	end

	// cs
	always @(*) begin
		case(current_state)
			RCMD_PRE: begin
				cs = 1'b0;
			end
			RCMD_SEND: begin
				cs = 1'b0;
			end
			RCMD_RSPS: begin
				cs = 1'b0;
			end
			READ: begin
				cs = 1'b0;
			end
			default: begin
				cs = 1'b1;
			end
		endcase
	end
endmodule

module SD_Initialize(
	input sdclk, // 初始化时时钟频率应小于 400KHz
	input reset,
	input start, // 是否开始初始化
	input dout,
	output reg cs = 1'b1,
	output reg din = 1'b1,
	output reg init_ok = 1'b0,
	output reg err = 1'b0
);
	parameter CMD0 = 48'h40_00_00_00_00_95;
	parameter CMD0_RSPS = 8'h01; //RSPS for ReSPonSe
	parameter CMD8 = 48'h48_00_00_01_AA_87;
	parameter CMD8_HEAD = 8'h01;
	parameter CMD8_TAIL = 8'hAA;
	parameter CMD55 = 48'h77_00_00_00_00_65;
	parameter CMD55_WAIT_RSPS = 8'h01;
	parameter CMD55_OK_RSPS = 8'h00;
	parameter ACMD41 = 48'h69_40_00_00_00_77;
	parameter ACMD41_AGAIN_RSPS = 8'h01;
	parameter ACMD41_OK_RSPS = 8'h00;
	parameter INIT_CMD = 48'hFF_FF_FF_FF_FF_FF;


	reg [9:0]await_cnt = 10'b0;

	always @(posedge sdclk or posedge reset) begin
		if(reset) begin
			await_cnt <= 10'b0;
		end else begin
			if(start) begin
				if(await_cnt[9]) begin
					await_cnt <= await_cnt;
				end else begin
					await_cnt <= await_cnt + 1'b1;
				end
			end else begin
				await_cnt <= 10'b0;
			end
		end
	end

	reg [47:0]cmd_to_send = INIT_CMD; // 由状态机控制
	reg [47:0]cmd_reg = INIT_CMD;
	reg cmd_update = 1'b0;  // 由状态机控制
	reg cmd_send_ena = 1'b0;  // 由状态机控制
	reg [5:0]cmd_cnt = 6'b0;

	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			cmd_cnt <= 6'b0;
		end else begin
			if(cmd_send_ena) begin
				cmd_cnt <= cmd_cnt + 1'b1;
			end else begin
				cmd_cnt <= 6'b0;
			end
		end
	end
	
	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			cmd_reg <= INIT_CMD;
			din <= 1'b1;
		end else begin
			if(cmd_update) begin
				cmd_reg <= cmd_to_send;
				din <= 1'b1;
			end else begin
				if(cmd_send_ena) begin
					if(cmd_cnt >= 6'd1 && cmd_cnt <= 6'd48) begin
						cmd_reg <= {cmd_reg[46:0], 1'b1};
						din <= cmd_reg[47];
					end else begin
						cmd_reg <= cmd_reg;
						din <= 1'b1;
					end
				end else begin
					cmd_reg <= cmd_reg;
					din <= 1'b1;
				end
			end
		end
	end

	// reg [7:0]rsps_buf = 8'b0;
	// reg rsps_start = 1'b0;
	// reg [3:0]rsps_cnt = 4'b0;
	reg [7:0]rsps_reg = 8'hFF;
	reg rsps_read_ena = 1'b0; // 由状态机控制

	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			rsps_reg <= 8'hFF;
		end else begin
			if(rsps_read_ena) begin
				if(rsps_reg[7]) begin
					rsps_reg <= {rsps_reg[6:0], dout};
				end else begin
					rsps_reg <= rsps_reg; // 首位为 0 说明接收结束
				end
			end else begin
				rsps_reg <= 8'hFF;
			end
		end
	end

	reg [39:0]cmd8_rsps_reg = 40'hFF_FF_FF_FF_FF;
	reg cmd8_rsps_read_ena = 1'b0; // 由状态机控制

	always @(negedge sdclk or posedge reset) begin
		if(reset) begin
			cmd8_rsps_reg <= 40'hFF_FF_FF_FF_FF;
		end else begin
			if(cmd8_rsps_read_ena) begin
				if(cmd8_rsps_reg[39]) begin
					cmd8_rsps_reg <= {cmd8_rsps_reg[38:0], dout};
				end else begin
					cmd8_rsps_reg <= cmd8_rsps_reg; // 首位为 0 说明接收结束
				end
			end else begin
				cmd8_rsps_reg <= 40'hFF_FF_FF_FF_FF;
			end
		end
	end

	reg [4:0]empty_clk_cnt = 5'b0;
	reg empty_clk_ena = 1'b0; // 由状态机控制

	always @(posedge sdclk or posedge reset) begin
		if(reset) begin
			empty_clk_cnt <= 5'b0;
		end else begin
			if(empty_clk_ena) begin
				empty_clk_cnt <= empty_clk_cnt + 1'b1;
			end else begin
				empty_clk_cnt <= 5'b0;
			end
		end
	end


	// all states
	parameter AWAIT = 5'd0;
	parameter CMD0_PRE = 5'd1;
	parameter CMD0_SEND = 5'd2;
	parameter CMD0_RCV = 5'd3;
	parameter CMD0_PAUSE = 5'd4;
	parameter CMD8_PRE = 5'd5;
    parameter CMD8_SEND = 5'd6;
    parameter CMD8_RCV = 5'd7;
    parameter CMD8_PAUSE = 5'd8;
	parameter CMD55_PRE = 5'd9;
	parameter CMD55_SEND = 5'd10;
	parameter CMD55_RCV = 5'd11;
	parameter CMD55_PAUSE = 5'd12;
	parameter ACMD41_PRE = 5'd13;
	parameter ACMD41_SEND = 5'd14;
	parameter ACMD41_RCV = 5'd15;
	parameter ACMD41_AGAIN_PAUSE = 5'd16;
	parameter ACMD41_SUCCESS_PAUSE = 5'd17;
	parameter SUCCESS = 5'd18;
	parameter ERROR = 5'd19;

	reg [4:0]current_state = AWAIT;
	reg [4:0]next_state = AWAIT;
	// assign st = current_state;

	always @(posedge sdclk or posedge reset) begin
		if(reset) begin
			current_state <= AWAIT;
		end else begin
			current_state <= next_state;
		end
	end

	always @(*) begin
		case(current_state)
			AWAIT: begin
				if(start && await_cnt[9]) begin
					next_state = CMD0_PRE;
				end else begin
					next_state = AWAIT;
				end
			end
			CMD0_PRE: begin
				next_state = CMD0_SEND;
			end
			CMD0_SEND: begin
				if(cmd_cnt >= 6'd49) begin
					next_state = CMD0_RCV;
				end else begin
					next_state = CMD0_SEND;
				end
			end
			CMD0_RCV: begin
				if(rsps_reg[7] == 1'b0) begin
					if(rsps_reg == CMD0_RSPS) begin
						next_state = CMD0_PAUSE;
					end else begin
						next_state = ERROR;
					end
				end else begin
					next_state = CMD0_RCV;
				end
			end
			CMD0_PAUSE: begin
				if(empty_clk_cnt[4]) begin
					next_state = CMD8_PRE;
				end else begin
					next_state = CMD0_PAUSE;
				end
			end
			CMD8_PRE: begin
				next_state = CMD8_SEND;
			end
			CMD8_SEND: begin
				if(cmd_cnt >= 6'd49) begin
					next_state = CMD8_RCV;
				end else begin
					next_state = CMD8_SEND;
				end
			end
			CMD8_RCV: begin
				if(cmd8_rsps_reg[39] == 1'b0) begin
					if(cmd8_rsps_reg[39:32] == CMD8_HEAD && cmd8_rsps_reg[7:0] == CMD8_TAIL) begin
						next_state = CMD8_PAUSE;
					end else begin
						next_state = ERROR;
					end
				end else begin
					next_state = CMD8_RCV;
				end
			end
			CMD8_PAUSE: begin
				if(empty_clk_cnt[4]) begin
					next_state = CMD55_PRE;
				end else begin
					next_state = CMD8_PAUSE;
				end
			end
			CMD55_PRE: begin
				next_state = CMD55_SEND;
			end
			CMD55_SEND: begin
				if(cmd_cnt >= 6'd49) begin
					next_state = CMD55_RCV;
				end else begin
					next_state = CMD55_SEND;
				end
			end
			CMD55_RCV: begin
				if(rsps_reg[7] == 1'b0) begin
					if(rsps_reg == CMD55_WAIT_RSPS || rsps_reg == CMD55_OK_RSPS) begin
						next_state = CMD55_PAUSE;
					end else begin
						next_state = ERROR;
					end
				end else begin
					next_state = CMD55_RCV;
				end
			end
			CMD55_PAUSE: begin
				if(empty_clk_cnt[4]) begin
					next_state = ACMD41_PRE;
				end else begin
					next_state = CMD55_PAUSE;
				end
			end
			ACMD41_PRE: begin
				next_state = ACMD41_SEND;
			end
			ACMD41_SEND: begin
				if(cmd_cnt >= 6'd49) begin
					next_state = ACMD41_RCV;
				end else begin
					next_state = ACMD41_SEND;
				end
			end
			ACMD41_RCV: begin
				if(rsps_reg[7] == 1'b0) begin
					if(rsps_reg == ACMD41_AGAIN_RSPS) begin
						next_state = ACMD41_AGAIN_PAUSE;
					end else if(rsps_reg == ACMD41_OK_RSPS) begin 
						next_state = ACMD41_SUCCESS_PAUSE;
					end else begin
						next_state = ERROR;
					end
				end else begin
					next_state = ACMD41_RCV;
				end
			end
			ACMD41_AGAIN_PAUSE: begin
				if(empty_clk_cnt[4]) begin
					next_state = CMD55_PRE;
				end else begin
					next_state = ACMD41_AGAIN_PAUSE;
				end
			end
			ACMD41_SUCCESS_PAUSE: begin
				if(empty_clk_cnt[4]) begin
					next_state = SUCCESS;
				end else begin
					next_state = ACMD41_SUCCESS_PAUSE;
				end
			end
			SUCCESS: begin
				next_state = SUCCESS;
			end
			ERROR: begin
				next_state = ERROR;
			end
			default: begin
				next_state = AWAIT;
			end
		endcase
	end

	// reg [47:0]cmd_to_send = INIT_CMD; // 由状态机控制
	always @(*) begin
		case(current_state)
			CMD0_PRE: begin
				cmd_to_send = CMD0;
			end
			CMD8_PRE: begin
				cmd_to_send = CMD8;
			end
			CMD55_PRE: begin
				cmd_to_send = CMD55;
			end
			ACMD41_PRE: begin
				cmd_to_send = ACMD41;
			end
			default: begin
				cmd_to_send = INIT_CMD;
			end
		endcase
	end

	// reg cmd_update = 1'b0;  // 由状态机控制
	// reg cmd_send_ena = 1'b0;  // 由状态机控制
	// reg rsps_read_ena = 1'b0; // 由状态机控制
	always @(*) begin
		case(current_state)
			CMD0_PRE: begin
				cmd_update = 1'b1;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
			CMD0_SEND: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b1;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
			CMD0_RCV: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b1;
				cmd8_rsps_read_ena = 1'b0;
			end
			CMD8_PRE: begin
				cmd_update = 1'b1;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
			CMD8_SEND: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b1;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
			CMD8_RCV: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b1;
			end
			CMD55_PRE: begin
				cmd_update = 1'b1;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
			CMD55_SEND: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b1;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
			CMD55_RCV: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b1;
				cmd8_rsps_read_ena = 1'b0;
			end
			ACMD41_PRE: begin
				cmd_update = 1'b1;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
			ACMD41_SEND: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b1;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
			ACMD41_RCV: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b1;
				cmd8_rsps_read_ena = 1'b0;
			end
			default: begin
				cmd_update = 1'b0;
				cmd_send_ena = 1'b0;
				rsps_read_ena = 1'b0;
				cmd8_rsps_read_ena = 1'b0;
			end
		endcase
	end


	// reg empty_clk_ena = 1'b0; // 由状态机控制
	always @(*) begin
		case(current_state)
			CMD0_PAUSE: begin
				empty_clk_ena = 1'b1;
			end
			CMD8_PAUSE: begin
				empty_clk_ena = 1'b1;
			end
			CMD55_PAUSE: begin
				empty_clk_ena = 1'b1;
			end
			ACMD41_AGAIN_PAUSE: begin
				empty_clk_ena = 1'b1;
			end
			ACMD41_SUCCESS_PAUSE: begin
				empty_clk_ena = 1'b1;
			end
			default: begin
				empty_clk_ena = 1'b0;
			end
		endcase
	end

	// output reg cs = 1'b1,
	// output reg init_ok = 1'b0,
	// output reg err = 1'b0
	always @(*) begin
		case(current_state)
//		    AWAIT: begin
//				cs = 1'b0;
//                init_ok = 1'b0;
//                err = 1'b0;		    
//		    end
			CMD0_PRE: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			CMD0_SEND: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			CMD0_RCV: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			CMD8_PRE: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			CMD8_SEND: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			CMD8_RCV: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			CMD55_PRE: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			CMD55_SEND: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			CMD55_RCV: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			ACMD41_PRE: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			ACMD41_SEND: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			ACMD41_RCV: begin
				cs = 1'b0;
				init_ok = 1'b0;
				err = 1'b0;
			end
			ERROR: begin
				cs = 1'b1;
				init_ok = 1'b0;
				err = 1'b1;
			end
			SUCCESS: begin
				cs = 1'b1;
				init_ok = 1'b1;
				err = 1'b0;
			end
			default: begin
				cs = 1'b1;
				init_ok = 1'b0;
				err = 1'b0;
			end
		endcase
	end
endmodule