module MULT(a, b, z);
    input [31:0] a;//被乘数
    input [31:0] b;//乘数
    output [63:0] z;//除积输出

    wire [63:0]part1;
    wire [63:0]part2;
    wire [63:0]part3;
    wire [63:0]part4;
    wire [63:0]part5;
    wire [63:0]part6;
    wire [63:0]part7;
    wire [63:0]part8;
    wire [63:0]part9;
    wire [63:0]part10;
    wire [63:0]part11;
    wire [63:0]part12;
    wire [63:0]part13;
    wire [63:0]part14;
    wire [63:0]part15;
    wire [63:0]part16;
    wire [63:0]part17;
    wire [63:0]part18;
    wire [63:0]part19;
    wire [63:0]part20;
    wire [63:0]part21;
    wire [63:0]part22;
    wire [63:0]part23;
    wire [63:0]part24;
    wire [63:0]part25;
    wire [63:0]part26;
    wire [63:0]part27;
    wire [63:0]part28;
    wire [63:0]part29;
    wire [63:0]part30;
    wire [31:0]part31;
    wire [31:0]part32;

    assign part1 = b[0]? {{32{a[31]}}, a[31:0]}: 64'b0;
    assign part2 = b[1]? {{31{a[31]}}, a[31:0], 1'b0}: 64'b0;
    assign part3 = b[2]? {{30{a[31]}}, a[31:0], 2'b0}: 64'b0;
    assign part4 = b[3]? {{29{a[31]}}, a[31:0], 3'b0}: 64'b0;
    assign part5 = b[4]? {{28{a[31]}}, a[31:0], 4'b0}: 64'b0;
    assign part6 = b[5]? {{27{a[31]}}, a[31:0], 5'b0}: 64'b0;
    assign part7 = b[6]? {{26{a[31]}}, a[31:0], 6'b0}: 64'b0;
    assign part8 = b[7]? {{25{a[31]}}, a[31:0], 7'b0}: 64'b0;
    assign part9 = b[8]? {{24{a[31]}}, a[31:0], 8'b0}: 64'b0;
    assign part10 = b[9]? {{23{a[31]}}, a[31:0], 9'b0}: 64'b0;
    assign part11 = b[10]? {{22{a[31]}}, a[31:0], 10'b0}: 64'b0;
    assign part12 = b[11]? {{21{a[31]}}, a[31:0], 11'b0}: 64'b0;
    assign part13 = b[12]? {{20{a[31]}}, a[31:0], 12'b0}: 64'b0;
    assign part14 = b[13]? {{19{a[31]}}, a[31:0], 13'b0}: 64'b0;
    assign part15 = b[14]? {{18{a[31]}}, a[31:0], 14'b0}: 64'b0;
    assign part16 = b[15]? {{17{a[31]}}, a[31:0], 15'b0}: 64'b0;
    assign part17 = b[16]? {{16{a[31]}}, a[31:0], 16'b0}: 64'b0;
    assign part18 = b[17]? {{15{a[31]}}, a[31:0], 17'b0}: 64'b0;
    assign part19 = b[18]? {{14{a[31]}}, a[31:0], 18'b0}: 64'b0;
    assign part20 = b[19]? {{13{a[31]}}, a[31:0], 19'b0}: 64'b0;
    assign part21 = b[20]? {{12{a[31]}}, a[31:0], 20'b0}: 64'b0;
    assign part22 = b[21]? {{11{a[31]}}, a[31:0], 21'b0}: 64'b0;
    assign part23 = b[22]? {{10{a[31]}}, a[31:0], 22'b0}: 64'b0;
    assign part24 = b[23]? {{9{a[31]}}, a[31:0], 23'b0}: 64'b0;
    assign part25 = b[24]? {{8{a[31]}}, a[31:0], 24'b0}: 64'b0;
    assign part26 = b[25]? {{7{a[31]}}, a[31:0], 25'b0}: 64'b0;
    assign part27 = b[26]? {{6{a[31]}}, a[31:0], 26'b0}: 64'b0;
    assign part28 = b[27]? {{5{a[31]}}, a[31:0], 27'b0}: 64'b0;
    assign part29 = b[28]? {{4{a[31]}}, a[31:0], 28'b0}: 64'b0;
    assign part30 = b[29]? {{3{a[31]}}, a[31:0], 29'b0}: 64'b0;
    assign part31 = b[30]? {a[31], a[31:1]}: 32'b0;
    assign part32 = b[31]? ~a: 32'b0;

    wire [63:0]part1_2;
    wire [63:0]part3_4;
    wire [63:0]part5_6;
    wire [63:0]part7_8;
    wire [63:0]part9_10;
    wire [63:0]part11_12;
    wire [63:0]part13_14;
    wire [63:0]part15_16;
    wire [63:0]part17_18;
    wire [63:0]part19_20;
    wire [63:0]part21_22;
    wire [63:0]part23_24;
    wire [63:0]part25_26;
    wire [63:0]part27_28;
    wire [63:0]part29_30;
    wire [63:0]part31_32;
    wire [31:0]part31_32_temp;
    wire part31_32_carry;
    wire part31_highest;
    wire part32_highest;
    Adder_64bits add_1_2(.a(part1), .b(part2), .carry_in(1'b0), .sum(part1_2), .carry_out());
    Adder_64bits add_3_4(.a(part3), .b(part4), .carry_in(1'b0), .sum(part3_4), .carry_out());
    Adder_64bits add_5_6(.a(part5), .b(part6), .carry_in(1'b0), .sum(part5_6), .carry_out());
    Adder_64bits add_7_8(.a(part7), .b(part8), .carry_in(1'b0), .sum(part7_8), .carry_out());
    Adder_64bits add_9_10(.a(part9), .b(part10), .carry_in(1'b0), .sum(part9_10), .carry_out());
    Adder_64bits add_11_12(.a(part11), .b(part12), .carry_in(1'b0), .sum(part11_12), .carry_out());
    Adder_64bits add_13_14(.a(part13), .b(part14), .carry_in(1'b0), .sum(part13_14), .carry_out());
    Adder_64bits add_15_16(.a(part15), .b(part16), .carry_in(1'b0), .sum(part15_16), .carry_out());
    Adder_64bits add_17_18(.a(part17), .b(part18), .carry_in(1'b0), .sum(part17_18), .carry_out());
    Adder_64bits add_19_20(.a(part19), .b(part20), .carry_in(1'b0), .sum(part19_20), .carry_out());
    Adder_64bits add_21_22(.a(part21), .b(part22), .carry_in(1'b0), .sum(part21_22), .carry_out());
    Adder_64bits add_23_24(.a(part23), .b(part24), .carry_in(1'b0), .sum(part23_24), .carry_out());
    Adder_64bits add_25_26(.a(part25), .b(part26), .carry_in(1'b0), .sum(part25_26), .carry_out());
    Adder_64bits add_27_28(.a(part27), .b(part28), .carry_in(1'b0), .sum(part27_28), .carry_out());
    Adder_64bits add_29_30(.a(part29), .b(part30), .carry_in(1'b0), .sum(part29_30), .carry_out());
    //Adder_64bits add_31_32(.a(part31), .b(part32), .carry_in(1'b0), .sum(part31_32), .carry_out());
    Adder_32bits add_31_32(.a(part31), .b(part32), .carry_in(b[31]), .sum(part31_32_temp), .carry_out(part31_32_carry));
    assign part31_highest = a[31] & b[30];
    assign part32_highest = (~a[31]) & b[31];
    assign part31_32 = {part31_highest ^ part32_highest ^ part31_32_carry, part31_32_temp[31:0], a[0] & b[30], 30'b0};

    wire [63:0]part1_4;
    wire [63:0]part5_8;
    wire [63:0]part9_12;
    wire [63:0]part13_16;
    wire [63:0]part17_20;
    wire [63:0]part21_24;
    wire [63:0]part25_28;
    wire [63:0]part29_32;
    Adder_64bits add_1_4(.a(part1_2), .b(part3_4), .carry_in(1'b0), .sum(part1_4), .carry_out());
    Adder_64bits add_5_8(.a(part5_6), .b(part7_8), .carry_in(1'b0), .sum(part5_8), .carry_out());
    Adder_64bits add_9_12(.a(part9_10), .b(part11_12), .carry_in(1'b0), .sum(part9_12), .carry_out());
    Adder_64bits add_13_16(.a(part13_14), .b(part15_16), .carry_in(1'b0), .sum(part13_16), .carry_out());
    Adder_64bits add_17_20(.a(part17_18), .b(part19_20), .carry_in(1'b0), .sum(part17_20), .carry_out());
    Adder_64bits add_21_24(.a(part21_22), .b(part23_24), .carry_in(1'b0), .sum(part21_24), .carry_out());
    Adder_64bits add_25_28(.a(part25_26), .b(part27_28), .carry_in(1'b0), .sum(part25_28), .carry_out());
    Adder_64bits add_29_32(.a(part29_30), .b(part31_32), .carry_in(1'b0), .sum(part29_32), .carry_out());

    wire [63:0]part1_8;
    wire [63:0]part9_16;
    wire [63:0]part17_24;
    wire [63:0]part25_32;
    Adder_64bits add_1_8(.a(part1_4), .b(part5_8), .carry_in(1'b0), .sum(part1_8), .carry_out());
    Adder_64bits add_9_16(.a(part9_12), .b(part13_16), .carry_in(1'b0), .sum(part9_16), .carry_out());
    Adder_64bits add_17_24(.a(part17_20), .b(part21_24), .carry_in(1'b0), .sum(part17_24), .carry_out());
    Adder_64bits add_25_32(.a(part25_28), .b(part29_32), .carry_in(1'b0), .sum(part25_32), .carry_out());

    wire [63:0]part1_16;
    wire [63:0]part17_32;
    Adder_64bits add_1_16(.a(part1_8), .b(part9_16), .carry_in(1'b0), .sum(part1_16), .carry_out());
    Adder_64bits add_17_32(.a(part17_24), .b(part25_32), .carry_in(1'b0), .sum(part17_32), .carry_out());

    wire [63:0]result;
    Adder_64bits add_all(.a(part1_16), .b(part17_32), .carry_in(1'b0), .sum(result), .carry_out());

    assign z = result;
endmodule

module MULTU(a, b, z);
    //input reset;//复位信号，低电平有效
    input [31:0]a;//被乘数
    input [31:0]b;//乘数
    //input sign;//1有符号 0无符号
    output [63:0]z;//乘积输出

    wire [63:0]part1;
    wire [63:0]part2;
    wire [63:0]part3;
    wire [63:0]part4;
    wire [63:0]part5;
    wire [63:0]part6;
    wire [63:0]part7;
    wire [63:0]part8;
    wire [63:0]part9;
    wire [63:0]part10;
    wire [63:0]part11;
    wire [63:0]part12;
    wire [63:0]part13;
    wire [63:0]part14;
    wire [63:0]part15;
    wire [63:0]part16;
    wire [63:0]part17;
    wire [63:0]part18;
    wire [63:0]part19;
    wire [63:0]part20;
    wire [63:0]part21;
    wire [63:0]part22;
    wire [63:0]part23;
    wire [63:0]part24;
    wire [63:0]part25;
    wire [63:0]part26;
    wire [63:0]part27;
    wire [63:0]part28;
    wire [63:0]part29;
    wire [63:0]part30;
    wire [63:0]part31;
    wire [63:0]part32;
    assign part1 = b[0]? {32'b0, a}: 64'b0;
    assign part2 = b[1]? {31'b0, a, 1'b0}: 64'b0;
    assign part3 = b[2]? {30'b0, a, 2'b0}: 64'b0;
    assign part4 = b[3]? {29'b0, a, 3'b0}: 64'b0;
    assign part5 = b[4]? {28'b0, a, 4'b0}: 64'b0;
    assign part6 = b[5]? {27'b0, a, 5'b0}: 64'b0;
    assign part7 = b[6]? {26'b0, a, 6'b0}: 64'b0;
    assign part8 = b[7]? {25'b0, a, 7'b0}: 64'b0;
    assign part9 = b[8]? {24'b0, a, 8'b0}: 64'b0;
    assign part10 = b[9]? {23'b0, a, 9'b0}: 64'b0;
    assign part11 = b[10]? {22'b0, a, 10'b0}: 64'b0;
    assign part12 = b[11]? {21'b0, a, 11'b0}: 64'b0;
    assign part13 = b[12]? {20'b0, a, 12'b0}: 64'b0;
    assign part14 = b[13]? {19'b0, a, 13'b0}: 64'b0;
    assign part15 = b[14]? {18'b0, a, 14'b0}: 64'b0;
    assign part16 = b[15]? {17'b0, a, 15'b0}: 64'b0;
    assign part17 = b[16]? {16'b0, a, 16'b0}: 64'b0;
    assign part18 = b[17]? {15'b0, a, 17'b0}: 64'b0;
    assign part19 = b[18]? {14'b0, a, 18'b0}: 64'b0;
    assign part20 = b[19]? {13'b0, a, 19'b0}: 64'b0;
    assign part21 = b[20]? {12'b0, a, 20'b0}: 64'b0;
    assign part22 = b[21]? {11'b0, a, 21'b0}: 64'b0;
    assign part23 = b[22]? {10'b0, a, 22'b0}: 64'b0;
    assign part24 = b[23]? {9'b0, a, 23'b0}: 64'b0;
    assign part25 = b[24]? {8'b0, a, 24'b0}: 64'b0;
    assign part26 = b[25]? {7'b0, a, 25'b0}: 64'b0;
    assign part27 = b[26]? {6'b0, a, 26'b0}: 64'b0;
    assign part28 = b[27]? {5'b0, a, 27'b0}: 64'b0;
    assign part29 = b[28]? {4'b0, a, 28'b0}: 64'b0;
    assign part30 = b[29]? {3'b0, a, 29'b0}: 64'b0;
    assign part31 = b[30]? {2'b0, a, 30'b0}: 64'b0;
    assign part32 = b[31]? {1'b0, a, 31'b0}: 64'b0;

    wire [63:0]part1_2;
    wire [63:0]part3_4;
    wire [63:0]part5_6;
    wire [63:0]part7_8;
    wire [63:0]part9_10;
    wire [63:0]part11_12;
    wire [63:0]part13_14;
    wire [63:0]part15_16;
    wire [63:0]part17_18;
    wire [63:0]part19_20;
    wire [63:0]part21_22;
    wire [63:0]part23_24;
    wire [63:0]part25_26;
    wire [63:0]part27_28;
    wire [63:0]part29_30;
    wire [63:0]part31_32;
    Adder_64bits add_1_2(.a(part1), .b(part2), .carry_in(1'b0), .sum(part1_2), .carry_out());
    Adder_64bits add_3_4(.a(part3), .b(part4), .carry_in(1'b0), .sum(part3_4), .carry_out());
    Adder_64bits add_5_6(.a(part5), .b(part6), .carry_in(1'b0), .sum(part5_6), .carry_out());
    Adder_64bits add_7_8(.a(part7), .b(part8), .carry_in(1'b0), .sum(part7_8), .carry_out());
    Adder_64bits add_9_10(.a(part9), .b(part10), .carry_in(1'b0), .sum(part9_10), .carry_out());
    Adder_64bits add_11_12(.a(part11), .b(part12), .carry_in(1'b0), .sum(part11_12), .carry_out());
    Adder_64bits add_13_14(.a(part13), .b(part14), .carry_in(1'b0), .sum(part13_14), .carry_out());
    Adder_64bits add_15_16(.a(part15), .b(part16), .carry_in(1'b0), .sum(part15_16), .carry_out());
    Adder_64bits add_17_18(.a(part17), .b(part18), .carry_in(1'b0), .sum(part17_18), .carry_out());
    Adder_64bits add_19_20(.a(part19), .b(part20), .carry_in(1'b0), .sum(part19_20), .carry_out());
    Adder_64bits add_21_22(.a(part21), .b(part22), .carry_in(1'b0), .sum(part21_22), .carry_out());
    Adder_64bits add_23_24(.a(part23), .b(part24), .carry_in(1'b0), .sum(part23_24), .carry_out());
    Adder_64bits add_25_26(.a(part25), .b(part26), .carry_in(1'b0), .sum(part25_26), .carry_out());
    Adder_64bits add_27_28(.a(part27), .b(part28), .carry_in(1'b0), .sum(part27_28), .carry_out());
    Adder_64bits add_29_30(.a(part29), .b(part30), .carry_in(1'b0), .sum(part29_30), .carry_out());
    Adder_64bits add_31_32(.a(part31), .b(part32), .carry_in(1'b0), .sum(part31_32), .carry_out());

    wire [63:0]part1_4;
    wire [63:0]part5_8;
    wire [63:0]part9_12;
    wire [63:0]part13_16;
    wire [63:0]part17_20;
    wire [63:0]part21_24;
    wire [63:0]part25_28;
    wire [63:0]part29_32;
    Adder_64bits add_1_4(.a(part1_2), .b(part3_4), .carry_in(1'b0), .sum(part1_4), .carry_out());
    Adder_64bits add_5_8(.a(part5_6), .b(part7_8), .carry_in(1'b0), .sum(part5_8), .carry_out());
    Adder_64bits add_9_12(.a(part9_10), .b(part11_12), .carry_in(1'b0), .sum(part9_12), .carry_out());
    Adder_64bits add_13_16(.a(part13_14), .b(part15_16), .carry_in(1'b0), .sum(part13_16), .carry_out());
    Adder_64bits add_17_20(.a(part17_18), .b(part19_20), .carry_in(1'b0), .sum(part17_20), .carry_out());
    Adder_64bits add_21_24(.a(part21_22), .b(part23_24), .carry_in(1'b0), .sum(part21_24), .carry_out());
    Adder_64bits add_25_28(.a(part25_26), .b(part27_28), .carry_in(1'b0), .sum(part25_28), .carry_out());
    Adder_64bits add_29_32(.a(part29_30), .b(part31_32), .carry_in(1'b0), .sum(part29_32), .carry_out());

    wire [63:0]part1_8;
    wire [63:0]part9_16;
    wire [63:0]part17_24;
    wire [63:0]part25_32;
    Adder_64bits add_1_8(.a(part1_4), .b(part5_8), .carry_in(1'b0), .sum(part1_8), .carry_out());
    Adder_64bits add_9_16(.a(part9_12), .b(part13_16), .carry_in(1'b0), .sum(part9_16), .carry_out());
    Adder_64bits add_17_24(.a(part17_20), .b(part21_24), .carry_in(1'b0), .sum(part17_24), .carry_out());
    Adder_64bits add_25_32(.a(part25_28), .b(part29_32), .carry_in(1'b0), .sum(part25_32), .carry_out());

    wire [63:0]part1_16;
    wire [63:0]part17_32;
    Adder_64bits add_1_16(.a(part1_8), .b(part9_16), .carry_in(1'b0), .sum(part1_16), .carry_out());
    Adder_64bits add_17_32(.a(part17_24), .b(part25_32), .carry_in(1'b0), .sum(part17_32), .carry_out());

    wire [63:0]result;
    Adder_64bits add_all(.a(part1_16), .b(part17_32), .carry_in(1'b0), .sum(result), .carry_out());

    assign z = result;
endmodule

module DIVU(dividend, divisor, start, clock, reset, q, r, busy);
    input [31:0]dividend;//被除数
    input [31:0]divisor;//除数
    input start;//启动除法运算
    input clock;
    input reset;
    output reg [31:0]q = 32'b0;//商
    output reg [31:0]r = 32'b0;//余数
    output busy;//除法器忙标志位

    parameter WAIT = 1'b0;
    parameter CALCULATE =1'b1;
    reg current_state = WAIT;
    reg next_state;
    reg [5:0]counter = 6'b0;
    reg [31:0]reg_q;
    reg [31:0]reg_r;
    reg [31:0]reg_divisor;
    reg r_sign;

    wire [31:0]to_add;
    wire [32:0]sub_add; 
    wire carry_out;
    assign to_add = r_sign? reg_divisor: ~reg_divisor;
    Adder_32bits get_sub_add(.a({reg_r[30:0], reg_q[31]}), .b(to_add), .carry_in(~r_sign), .sum(sub_add[31:0]), .carry_out(carry_out));
    assign sub_add[32] = carry_out ^ reg_r[31] ^ ~r_sign;

    wire [31:0]r_divisor;
    Adder_32bits add_r_divisor(.a(reg_r), .b(reg_divisor), .carry_in(1'b0), .sum(r_divisor), .carry_out());

    always @(negedge clock or posedge reset) begin
        if(reset) begin
            current_state <= WAIT;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case(current_state)
            WAIT: begin
                if(~start) begin
                    next_state = CALCULATE;
                end else begin
                    next_state = WAIT;
                end
            end
            CALCULATE: begin
                if(counter == 6'd32) begin
                    next_state = WAIT;
                end else begin
                    next_state = CALCULATE;
                end
            end
        endcase
    end

    always @(posedge clock) begin
        case(current_state)
            WAIT: begin
                counter <= 6'b0;
            end
            CALCULATE: begin
                counter <= counter + 1'b1;
            end
        endcase
    end

    always @(posedge clock) begin
        case(current_state)
            WAIT: begin
                reg_q <= dividend;
            end
            CALCULATE: begin
                reg_q <= {reg_q[30:0], ~sub_add[32]};
            end
        endcase
    end

    always @(posedge clock) begin
        case(current_state)
            WAIT: begin
                r_sign <= 1'b0;
                reg_r <= 32'b0;
            end
            CALCULATE: begin
                r_sign <= sub_add[32];
                reg_r <= sub_add[31:0];
            end
        endcase
    end

    always @(posedge clock) begin
        case(current_state)
            WAIT: begin
                reg_divisor <= divisor;
            end
            CALCULATE: begin
                reg_divisor <= reg_divisor;
            end
        endcase
    end

    assign busy = current_state;
    //assign q = reg_q;
    //assign r = r_sign? (reg_r + reg_divisor): reg_r;
    always @(negedge clock) begin
        if(counter == 6'd32) begin
            q <= reg_q;
            r <= r_sign? r_divisor: reg_r;
        end else begin
            q <= q;
            r <= r;
        end
    end
endmodule

module DIV(dividend, divisor, start, clock, reset, q, r, busy);
    input [31:0]dividend;//被除数
    input [31:0]divisor;//除数
    input start;//启动除法运算
    input clock;
    input reset;
    output [31:0]q;//商
    output [31:0]r;//余数
    output reg busy;//除法器忙标志位

    reg [4:0]counter;
    reg [31:0]reg_q;
    reg [31:0]reg_r;
    reg [31:0]reg_divisor;
    reg r_sign;
    reg q_sign;

    wire [31:0]dividend_abs;
    wire [31:0]divisor_abs;
    wire [31:0]r_abs;
    wire [32:0]sub_add;

    assign dividend_abs = dividend[31]? (~dividend + 1'b1): dividend;
    assign divisor_abs = divisor[31]? (~divisor + 1'b1): divisor;
    assign r_abs = r_sign? (reg_r + reg_divisor): reg_r;
    assign sub_add = r_sign? ({reg_r, reg_q[31]} + {1'b0, reg_divisor}): ({reg_r, reg_q[31]} - {1'b0, reg_divisor}); 

    always @(posedge clock or posedge reset) begin
        if(reset) begin
            counter <= 5'b0;
            busy <= 1'b0;
        end else begin
            if(start) begin
                q_sign <= dividend[31] ^ divisor[31];
                reg_r <= 32'b0;
                reg_q <= dividend_abs;
                reg_divisor <= divisor_abs;
                r_sign <= 1'b0;
                counter <= 5'b0;
                busy <= 1'b1;
            end else begin//start == 0
                if(busy) begin
                    reg_r <= sub_add[31:0];
                    r_sign <= sub_add[32];
                    reg_q <= {reg_q[30:0], ~sub_add[32]};
                    counter <= counter + 1'b1;
                    if(counter == 5'd31) begin
                        busy <= 1'b0;
                    end else begin
                        busy <= 1'b1;
                    end
                end else begin
                    busy <= 1'b0;
                end
            end
        end
    end

    assign q= q_sign? (~reg_q + 1'b1): reg_q;
    assign r= dividend[31]? (~r_abs + 1'b1): r_abs;
endmodule

module MDU(clk, a, b, MDUC, start, busy, r1, r2);
    input clk;
    input [31:0]a;
    input [31:0]b;
    input [1:0]MDUC;
    input start;
    output reg busy;
    output reg [31:0]r1;
    output reg [31:0]r2;
    
    // wire [31:0]div_q;
    // wire [31:0]div_r;
    // assign div_q = a / b;
    // assign div_r = a % b;
    // wire [32:0]temp_q;
    // wire [32:0]temp_r;
    // wire [31:0]divu_q;
    // wire [31:0]divu_r;
    // assign temp_q = {1'b0, a} / {1'b0, b};
    // assign temp_r = {1'b0, a} % {1'b0, b};
    // assign divu_q = temp_q[31:0];
    // assign divu_r = temp_r[31:0];

    // assign busy = 1'b0;
    // always @(*) begin
    //     case(MDUC)
    //         2'b00: {r1, r2} = mult_result;
    //         2'b01: {r1, r2} = multu_result;
    //         2'b10: {r1, r2} = {div_r, div_q};
    //         2'b11: {r1, r2} = {divu_r, divu_q};
    //     endcase
    // end

    reg [31:0]a_reg;
    reg [31:0]b_reg;

    reg div_start = 1'b0;
    reg div_reset = 1'b0;
    wire [31:0]div_q;
    wire [31:0]div_r;
    wire div_busy;
    DIV DIV_(a_reg, b_reg, div_start, clk, div_reset, div_q, div_r, div_busy);

    reg divu_start = 1'b0;
    reg divu_reset = 1'b0;
    wire [31:0]divu_q;
    wire [31:0]divu_r;
    wire divu_busy;
    DIVU DIVU_(a_reg, b_reg, divu_start, clk, divu_reset, divu_q, divu_r, divu_busy);

    wire [63:0]mult_result;
    MULT MULT_(a_reg, b_reg, mult_result);
    wire [63:0]multu_result;
    MULTU MULTU_(a_reg, b_reg, multu_result);
    

    parameter IDLE = 4'b0000;
    parameter READ = 4'b0001;
    parameter MULT = 4'b0011;
    parameter MULTU = 4'b0010;
    parameter DIV = 4'b0110;
    parameter DIVWAIT = 4'b0111;
    parameter DIVU = 4'b0101;
    parameter DIVUWAIT = 4'b0100;
    parameter WRITE = 4'b1100;

    reg [3:0]current_state = IDLE;
    reg [3:0]next_state;

    always @(posedge clk) begin
        current_state <= next_state;
    end

    always @(*) begin
        case(current_state)
            IDLE: begin
                if(start) begin
                    next_state = READ;
                end else begin
                    next_state = IDLE;
                end
            end
            READ: begin
                case(MDUC)
                    2'b00: next_state = MULT;
                    2'b01: next_state = MULTU;
                    2'b10: next_state = DIV;
                    2'b11: next_state = DIVU;
                endcase
            end
            MULT: begin
                next_state = WRITE;
            end
            MULTU: begin
                next_state = WRITE;
            end
            DIV: begin
                next_state = DIVWAIT;
            end
            DIVU: begin
                next_state = DIVUWAIT;
            end
            DIVWAIT: begin
                if(div_busy) begin
                    next_state = DIVWAIT;
                end else begin
                    next_state = WRITE;
                end
            end
            DIVUWAIT: begin
                if(divu_busy) begin
                    next_state = DIVUWAIT;
                end else begin
                    next_state = WRITE;
                end
            end
            WRITE: begin
                next_state = IDLE;
            end
        endcase
    end

    //areg breg
    always @(negedge clk) begin
        case(current_state)
            READ: begin
                a_reg <= a;
                b_reg <= b;
            end
            default: begin
                a_reg <= a_reg;
                b_reg <= b_reg;
            end
        endcase
    end

    //DIV计算
    always @(negedge clk) begin
        if(current_state == IDLE) begin
            div_reset <= 1'b1;
            divu_reset <= 1'b1;
        end else begin
            divu_reset <= 1'b0;
            div_reset <= 1'b0;
        end
    end
    always @(negedge clk) begin
        case(current_state)
            DIV: begin
                div_start = 1'b1;
                divu_start = 1'b0;
            end
            DIVU: begin
                divu_start = 1'b1;
                div_start = 1'b0;
            end
            default: begin
                divu_start = 1'b0;
                div_start = 1'b0;
            end
        endcase
    end

    //r1 r2
    always @(negedge clk) begin
        case(current_state)
            WRITE: begin
                case(MDUC)
                    2'b00: begin
                        r1 <= mult_result[63:32];
                        r2 <= mult_result[31:0];
                    end
                    2'b01: begin
                        r1 <= multu_result[63:32];
                        r2 <= multu_result[31:0];
                    end
                    2'b10: begin
                        r1 <= div_r;
                        r2 <= div_q;
                    end
                    2'b11: begin
                        r1 <= divu_r;
                        r2 <= divu_q;
                    end
                endcase
            end
            default: begin
                r1 <= r1;
                r2 <= r2;
            end
        endcase
    end

    always @(negedge clk) begin
        case(current_state)
            IDLE: busy <= 1'b0;
            default: busy <= 1'b1;
        endcase
    end
endmodule