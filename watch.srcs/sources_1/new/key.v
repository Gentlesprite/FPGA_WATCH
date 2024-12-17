module key(
    input clk_1hz,          // 时钟信号
    input rst,          // 复位信号
    input [3:0] key,    // 四个按键输入
    output reg adjust_enable, // 调整使能信号
    output reg [2:0] select_pos, // 选择位置 (秒、分、小时)
    output reg adjust_up,       // 加操作
    output reg adjust_down      // 减操作
);

// 按键去抖动和消抖逻辑可以在这里添加
// 这里假设按键已经过外部去抖动处理

// 启动/关闭调节的按键（key[0]）
always @(posedge clk_1hz or negedge rst) begin
    if (!rst)
        adjust_enable <= 0;
    else if (key[0])
        adjust_enable <= ~adjust_enable; // 切换调节模式
end

// 位选按键（key[1]）
always @(posedge clk_1hz or negedge rst) begin
    if (!rst)
        select_pos <= 0;
    else if (key[1] && adjust_enable)
        select_pos <= (select_pos + 1) % 6; // 循环选择秒个位、秒十位、分个位、分十位、时个位、时十位
end

// 加操作按键（key[2]）
always @(posedge clk_1hz or negedge rst) begin
    if (!rst)
        adjust_up <= 0;
    else if (key[2] && adjust_enable)
        adjust_up <= 1;
    else
        adjust_up <= 0;
end

// 减操作按键（key[3]）
always @(posedge clk_1hz or negedge rst) begin
    if (!rst)
        adjust_down <= 0;
    else if (key[3] && adjust_enable)
        adjust_down <= 1;
    else
        adjust_down <= 0;
end

endmodule