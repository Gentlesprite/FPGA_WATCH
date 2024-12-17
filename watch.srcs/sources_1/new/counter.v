module counter(
    input clk_1hz,  // 1 Hz 时钟
    input rst,      // 复位信号
    output reg  [3:0]sec_low,  // 秒个位
    output reg  [2:0]sec_high, // 秒十位
    output reg  [3:0]min_low,  // 分个位
    output reg  [2:0]min_high, // 分十位
    output reg  [1:0]hour_low, // 时个位
    output reg  [1:0]hour_high // 时十位
);

    // 秒计数部分
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            sec_low <= 0;
        else if (sec_low == 9)
            sec_low <= 0;
        else
            sec_low <= sec_low + 1;
    end

    // 十秒计数部分
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            sec_high <= 0;
        else if (sec_high == 5 && sec_low == 9)
            sec_high <= 0;
        else if (sec_low == 9)
            sec_high <= sec_high + 1;
    end

    // 分计数部分
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            min_low <= 0;
        else if (min_low == 9 && sec_high == 5 && sec_low == 9)
            min_low <= 0;
        else if (sec_high == 5 && sec_low == 9)
            min_low <= min_low + 1;
    end

    // 十分钟计数部分
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            min_high <= 0;
        else if (min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            min_high <= 0;
        else if (min_low == 9 && sec_high == 5 && sec_low == 9)
            min_high <= min_high + 1;
    end

    // 小时计数部分
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            hour_low <= 0;
        else if (hour_low == 9 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            hour_low <= 0;
        else if (min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            hour_low <= hour_low + 1;
    end

    // 十小时计数部分
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            hour_high <= 0;
        else if (hour_high == 2 && hour_low == 3 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            hour_high <= 0;
        else if (hour_low == 3 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            hour_high <= hour_high + 1;
    end

endmodule