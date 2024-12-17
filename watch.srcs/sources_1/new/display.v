module display(
    input clk_1khz,          // 主时钟信号
    input rst,               // 异步复位信号，低电平有效
    input [3:0] sec_low,
    input [2:0] sec_high,
    input [3:0] min_low,
    input [2:0] min_high,
    input [1:0] hour_low,
    input [1:0] hour_high,
    output reg [7:0] seg8,
    output reg [5:0] tab6
);

    reg [2:0] address;  // 地址寄存器，控制选择的数码管
    reg [3:0] A;        // 数码管显示的数字
    reg [7:0] segment;  // 当前段码输出

    // 复位逻辑
    always @(posedge clk_1khz or negedge rst) begin
        if (!rst)
            address <= 3'd0;
        else
            address <= (address + 1) % 6;
    end

    // 控制数码管显示内容
    always @(*) begin
        case (address)
            3'b000: begin A = sec_high; tab6 = 6'b111110; end // 秒十位
            3'b001: begin A = sec_low;  tab6 = 6'b111101; end // 秒个位
            3'b010: begin A = min_high; tab6 = 6'b111011; end // 分十位
            3'b011: begin A = min_low;  tab6 = 6'b110111; end // 分个位
            3'b100: begin A = hour_high;tab6 = 6'b101111; end // 时十位
            3'b101: begin A = hour_low;  tab6 = 6'b011111; end // 时个位
            default: begin A = 4'b0000;   tab6 = 6'b111111; end // 默认关闭
        endcase
    end

    // 数码管段码转换
    always @(*) begin
        case (A)
            4'b0000: segment = 8'b1100_0000; // 0
            4'b0001: segment = 8'b1111_1001; // 1
            4'b0010: segment = 8'b1010_0100; // 2
            4'b0011: segment = 8'b1011_0000; // 3
            4'b0100: segment = 8'b1001_1001; // 4
            4'b0101: segment = 8'b1001_0010; // 5
            4'b0110: segment = 8'b1000_0010; // 6
            4'b0111: segment = 8'b1111_1000; // 7
            4'b1000: segment = 8'b1000_0000; // 8
            4'b1001: segment = 8'b1001_0000; // 9
            default: segment = 8'b1111_1111; // 默认关闭
        endcase
    end

    // 通过选择信号控制显示
    always @(posedge clk_1khz or negedge rst) begin
        if (!rst)
            seg8 <= 8'b1111_1111;  // 复位时关闭显示
        else
            seg8 <= segment;      // 输出段码
    end

endmodule