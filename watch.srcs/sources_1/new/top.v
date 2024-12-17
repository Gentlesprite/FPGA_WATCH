module top(
    input clk,          // 外部时钟输入 (50 MHz)
    input rst,          // 复位信号
    input [3:0] key,    // 按键输入
    output [7:0] seg8,  // 8位数码管段码输出
    output [5:0] tab6   // 6位数码管选择信号输出
);

// 内部信号定义
wire clk_1hz;           // 1 Hz 时钟
wire clk_1khz;          // 1 kHz 时钟
wire [3:0] sec_low;
wire [2:0] sec_high;
wire [3:0] min_low;
wire [2:0] min_high;
wire [1:0] hour_low;
wire [1:0] hour_high;

// 调节控制信号
wire adjust_enable;
wire [2:0] select_pos;
wire adjust_up;
wire adjust_down;

// 实例化 fsm 模块
fsm uut_fsm (
    .clk(clk),
    .rst(rst),
    .clk_1hz(clk_1hz),
    .clk_1khz(clk_1khz)
);

// 实例化 key 模块
key uut_key (
    .clk_1hz(clk_1hz),
    .rst(rst),
    .key(key),
    .adjust_enable(adjust_enable),
    .select_pos(select_pos),
    .adjust_up(adjust_up),
    .adjust_down(adjust_down)
);

// 定义时间调整模块的内部信号
wire [3:0] adj_sec_low;
wire [2:0] adj_sec_high;
wire [3:0] adj_min_low;
wire [2:0] adj_min_high;
wire [1:0] adj_hour_low;
wire [1:0] adj_hour_high;

// 实例化 time_adjust 模块
time_adjust uut_time_adjust (
    .clk_1hz(clk_1hz),  // 1 Hz 时钟
    .rst(rst),
    .adjust_enable(adjust_enable),
    .select_pos(select_pos),
    .adjust_up(adjust_up),
    .adjust_down(adjust_down),
    .sec_low_i(sec_low), // 使用当前计数器输出作为初始值
    .sec_high_i(sec_high),
    .min_low_i(min_low),
    .min_high_i(min_high),
    .hour_low_i(hour_low),
    .hour_high_i(hour_high),
    .sec_low_o(adj_sec_low), // 输出到 counter 模块
    .sec_high_o(adj_sec_high),
    .min_low_o(adj_min_low),
    .min_high_o(adj_min_high),
    .hour_low_o(adj_hour_low),
    .hour_high_o(adj_hour_high)
);
// 实例化 counter 模块
counter uut_counter (
    .clk_1hz(clk_1hz),
    .rst(rst),
    .sec_low_i(adj_sec_low), // 接收来自 time_adjust 的调整值
    .sec_high_i(adj_sec_high),
    .min_low_i(adj_min_low),
    .min_high_i(adj_min_high),
    .hour_low_i(adj_hour_low),
    .hour_high_i(adj_hour_high),
    .adjust_enable(adjust_enable), // 传递调整使能信号
    .sec_low(sec_low), // 输出到 display 模块
    .sec_high(sec_high),
    .min_low(min_low),
    .min_high(min_high),
    .hour_low(hour_low),
    .hour_high(hour_high)
);

// 实例化 display 模块
display uut_display (
    .clk_1khz(clk_1khz),
    .rst(rst),
    .sec_low(sec_low),
    .sec_high(sec_high),
    .min_low(min_low),
    .min_high(min_high),
    .hour_low(hour_low),
    .hour_high(hour_high),
    .seg8(seg8),
    .tab6(tab6)
);

endmodule