module counter(
    input clk_1hz,      // 1 Hz 时钟
    input rst,          // 复位信号
    input [3:0] sec_low_i, // 秒个位输入 (来自 time_adjust)
    input [2:0] sec_high_i,// 秒十位输入 (来自 time_adjust)
    input [3:0] min_low_i, // 分个位输入 (来自 time_adjust)
    input [2:0] min_high_i,// 分十位输入 (来自 time_adjust)
    input [1:0] hour_low_i,// 时个位输入 (来自 time_adjust)
    input [1:0] hour_high_i,// 时十位输入 (来自 time_adjust)
    input adjust_enable,   // 调整使能信号
    output reg [3:0] sec_low,  // 秒个位输出
    output reg [2:0] sec_high, // 秒十位输出
    output reg [3:0] min_low,  // 分个位输出
    output reg [2:0] min_high, // 分十位输出
    output reg [1:0] hour_low, // 时个位输出
    output reg [1:0] hour_high // 时十位输出
);

// 秒计数部分
always @(posedge clk_1hz or negedge rst) begin
    if (!rst) 
        sec_low <= 0;
    else if (adjust_enable) 
        sec_low <= sec_low_i; // 在调整模式下使用外部输入
    else if (sec_low == 9)
        sec_low <= 0;
    else
        sec_low <= sec_low + 1;
end

// 十秒计数部分
always @(posedge clk_1hz or negedge rst) begin
    if (!rst) 
        sec_high <= 0;
    else if (adjust_enable) 
        sec_high <= sec_high_i; // 在调整模式下使用外部输入
    else if (sec_high == 5 && sec_low == 0) // 只有当秒个位回零时才进位
        sec_high <= 0;
    else if (sec_low == 0)
        sec_high <= sec_high + 1;
end

// 分计数部分
always @(posedge clk_1hz or negedge rst) begin
    if (!rst) 
        min_low <= 0;
    else if (adjust_enable) 
        min_low <= min_low_i; // 在调整模式下使用外部输入
    else if (min_low == 9 && sec_high == 5 && sec_low == 0) // 只有当秒归零且秒十位为5时才进位
        min_low <= 0;
    else if (sec_high == 5 && sec_low == 0)
        min_low <= min_low + 1;
end

// 十分钟计数部分
always @(posedge clk_1hz or negedge rst) begin
    if (!rst) 
        min_high <= 0;
    else if (adjust_enable) 
        min_high <= min_high_i; // 在调整模式下使用外部输入
    else if (min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 0) // 只有当分归零且分十位为5时才进位
        min_high <= 0;
    else if (min_low == 9 && sec_high == 5 && sec_low == 0)
        min_high <= min_high + 1;
end

// 小时计数部分
always @(posedge clk_1hz or negedge rst) begin
    if (!rst) 
        hour_low <= 0;
    else if (adjust_enable) 
        hour_low <= hour_low_i; // 在调整模式下使用外部输入
    else if (hour_low == 9 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 0) // 只有当分归零且分十位为5时才进位
        hour_low <= 0;
    else if (min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 0)
        hour_low <= hour_low + 1;
end

// 十小时计数部分
always @(posedge clk_1hz or negedge rst) begin
    if (!rst) 
        hour_high <= 0;
    else if (adjust_enable) 
        hour_high <= hour_high_i; // 在调整模式下使用外部输入
    else if (hour_high == 2 && hour_low == 3 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 0) // 24小时制
        hour_high <= 0;
    else if (hour_low == 3 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 0)
        hour_high <= hour_high + 1;
end

endmodule