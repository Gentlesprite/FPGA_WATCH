`timescale 1ns/1ns
module tb_top;
    // 信号定义
    reg clk;           // 时钟信号
    reg rst;           // 复位信号
    reg [3:0] key;     // 按键输入
    wire [7:0] seg8;   // 8位数码管段码输出
    wire [5:0] tab6;   // 6位数码管选择信号输出

    // 实例化顶层模块
    top uut (
        .clk(clk),
        .rst(rst),
        .key(key),
        .seg8(seg8),
        .tab6(tab6)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // 复位信号生成
    initial begin
        rst = 0;
        #10 rst = 0; // 保持高电平一段时间
        #10 rst = 1;
    end

    // 按键输入模拟
    initial begin
        // 初始化按键状态
        key = 4'b0000;

        // 等待复位完成
        #20;

        // 测试正常计数
        $display("Testing normal counting...");
        #10000; // 等待足够长的时间以观察计数

        // 启动调节模式
        $display("Entering adjustment mode...");
        key[0] = 1;
        #10;
        key[0] = 0;
        #10;

        // 选择秒个位进行调整
        $display("Selecting seconds low for adjustment...");
        key[1] = 1;
        #10;
        key[1] = 0;
        #10;

        // 增加秒个位
        $display("Adjusting seconds low up...");
        key[2] = 1;
        #10;
        key[2] = 0;
        #10;

        // 减少秒个位
        $display("Adjusting seconds low down...");
        key[3] = 1;
        #10;
        key[3] = 0;
        #10;

        // 选择秒十位进行调整
        $display("Selecting seconds high for adjustment...");
        key[1] = 1;
        #10;
        key[1] = 0;
        #10;

        // 增加秒十位
        $display("Adjusting seconds high up...");
        key[2] = 1;
        #10;
        key[2] = 0;
        #10;

        // 减少秒十位
        $display("Adjusting seconds high down...");
        key[3] = 1;
        #10;
        key[3] = 0;
        #10;

        // 选择分钟个位进行调整
        $display("Selecting minutes low for adjustment...");
        key[1] = 1;
        #10;
        key[1] = 0;
        #10;

        // 增加分钟个位
        $display("Adjusting minutes low up...");
        key[2] = 1;
        #10;
        key[2] = 0;
        #10;

        // 减少分钟个位
        $display("Adjusting minutes low down...");
        key[3] = 1;
        #10;
        key[3] = 0;
        #10;

        // 选择分钟十位进行调整
        $display("Selecting minutes high for adjustment...");
        key[1] = 1;
        #10;
        key[1] = 0;
        #10;

        // 增加分钟十位
        $display("Adjusting minutes high up...");
        key[2] = 1;
        #10;
        key[2] = 0;
        #10;

        // 减少分钟十位
        $display("Adjusting minutes high down...");
        key[3] = 1;
        #10;
        key[3] = 0;
        #10;

        // 选择小时个位进行调整
        $display("Selecting hours low for adjustment...");
        key[1] = 1;
        #10;
        key[1] = 0;
        #10;

        // 增加小时个位
        $display("Adjusting hours low up...");
        key[2] = 1;
        #10;
        key[2] = 0;
        #10;

        // 减少小时个位
        $display("Adjusting hours low down...");
        key[3] = 1;
        #10;
        key[3] = 0;
        #10;

        // 选择小时十位进行调整
        $display("Selecting hours high for adjustment...");
        key[1] = 1;
        #10;
        key[1] = 0;
        #10;

        // 增加小时十位
        $display("Adjusting hours high up...");
        key[2] = 1;
        #10;
        key[2] = 0;
        #10;

        // 减少小时十位
        $display("Adjusting hours high down...");
        key[3] = 1;
        #10;
        key[3] = 0;
        #10;

        // 退出调节模式
        $display("Exiting adjustment mode...");
        key[0] = 1;
        #10;
        key[0] = 0;
        #10;

        // 继续正常计数
        $display("Resuming normal counting...");
        #10000; // 等待足够长的时间以观察计数

    end

    // 监测输出信号
    initial begin
        $monitor("Time: %d:%d:%d.%d, Seg8: %b, Tab6: %b", 
                 {uut.uut_counter.hour_high, uut.uut_counter.hour_low},
                 {uut.uut_counter.min_high, uut.uut_counter.min_low},
                 {uut.uut_counter.sec_high, uut.uut_counter.sec_low},
                 uut.uut_counter.sec_low,
                 seg8, tab6);
    end

endmodule