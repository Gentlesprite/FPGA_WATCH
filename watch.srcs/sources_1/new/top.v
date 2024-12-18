module top(
    input clk,          // 外部时钟输入
    input rst,          // 复位信号
    input key_start_stop, // 启动/停止按键
    input [2:0]key_select,     // 选择按键
    input key_inc,        // 增加按键
    input key_dec,        // 减少按键
    output [7:0] seg8,  // 8位数码管段码输出
    output [5:0] tab6   // 6位数码管选择信号输出
);

    // 内部信号定义
    wire clk_1hz;       // 1 Hz 时钟
    wire clk_1khz;      // 1 kHz 时钟
    wire [3:0] sec_low;
    wire [2:0] sec_high;
    wire [3:0] min_low;
    wire [2:0] min_high;
    wire [3:0] hour_low;
    wire [1:0] hour_high;
    wire manual_mode;
    wire [2:0] select_reg;
    wire inc_dec;

    // 实例化 fsm 模块
    fsm uut_fsm (
        .clk(clk),
        .rst(rst),
        .clk_1hz(clk_1hz),
        .clk_1khz(clk_1khz)
    );

    // 实例化 key 模块
    key uut_key (
        .clk(clk),
        .rst(rst),
        .key_start_stop(key_start_stop),
        .key_select(key_select),
        .key_inc(key_inc),
        .key_dec(key_dec),
        .manual_mode(manual_mode),
        .select_reg(select_reg),
        .inc_dec(inc_dec)
    );

    // 实例化 counter 模块
    counter uut_counter (
        .clk_1hz(clk_1hz),
        .rst(rst),
        .manual_mode(manual_mode),
        .select_reg(select_reg),
        .inc_dec(inc_dec),
        .sec_low(sec_low),
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