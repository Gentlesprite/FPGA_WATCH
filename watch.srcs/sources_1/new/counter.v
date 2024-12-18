module counter(
    input clk_1hz,           // 1 Hz 时钟
    input rst,               // 复位信号
    input manual_mode,       // 手动模式控制
    input [2:0] select_reg,  // 选择要调节的位
    input inc_dec,           // 增加或减少控制
    output reg [3:0] sec_low,  // 秒个位
    output reg [2:0] sec_high, // 秒十位
    output reg [3:0] min_low,  // 分个位
    output reg [2:0] min_high, // 分十位
    output reg [3:0] hour_low, // 时个位
    output reg [1:0] hour_high // 时十位
);

    // 秒个位计数
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst)
            sec_low <= 0;
        else if (sec_low >= 9)
            sec_low <= 0;
        else if (manual_mode && select_reg == 0)
            sec_low <= inc_dec ? (sec_low + 1) % 10 : (sec_low == 0) ? 9 : sec_low - 1;

        else
            sec_low <= sec_low + 1;
    end

    // 秒十位计数
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst)
            sec_high <= 0;
        else if (sec_high >= 5)
            sec_high <= 0;
        else if ((sec_low == 9 && !manual_mode) || (manual_mode && select_reg == 0 && sec_low == 9))
        begin
            sec_high <= sec_high + 1;
        end
    end

    // 分个位计数
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst)
            min_low <= 0;
        else if (manual_mode && select_reg == 1)
            min_low <= inc_dec ? (min_low + 1) % 10 : (min_low == 0) ? 9 : min_low - 1;
        else if (sec_high == 5 && sec_low == 9)
        begin
            if (min_low >= 9)
                min_low <= 0;
            else
                min_low <= min_low + 1;
        end
    end

    // 分十位计数
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst)
            min_high <= 0;
        else if (min_low == 9 && sec_high == 5 && sec_low == 9)
        begin
            if (min_high >= 5)
                min_high <= 0;
            else
                min_high <= min_high + 1;
        end
        else if (manual_mode && select_reg == 1)
            min_high <= inc_dec ? (min_high + 1) % 6 : (min_high == 0) ? 5 : min_high - 1;
    end

    // 小时个位计数
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst)
            hour_low <= 0;
        else if (manual_mode && select_reg == 2)
            hour_low <= inc_dec ? (hour_low + 1) % 10 : (hour_low == 0) ? 9 : hour_low - 1;
        else if (min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
        begin
            // 根据小时高位动态调整小时低位的范围
            if (hour_high == 2)  // 如果小时高位为 2
            begin
                if (hour_low >= 4)  // 小时低位最大为 3
                    hour_low <= 0;
                else
                    hour_low <= hour_low + 1;
            end
            else if (hour_high == 1 || hour_high == 0)  // 如果小时高位为 0 或 1
            begin
                if (hour_low >= 9)  // 小时低位最大为 9
                    hour_low <= 0;
                else
                    hour_low <= hour_low + 1;
            end
        end
    end

    // 小时十位计数
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst)
            hour_high <= 0;
        else if(hour_low == 3 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            begin
                    if (hour_high == 2)  // 小时高位为 2 时，不能再进位
                        begin
                            hour_high <= 0;  // 重置为 00:00
                            hour_low <= 0;
                            min_high <= 0;
                            min_low <= 0;
                            sec_high <= 0;
                            sec_low <=0;
                        end
            end
        else if (hour_low == 9 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
        begin
                hour_high <= hour_high + 1;  // 小时高位进位
        end

        else if (manual_mode && select_reg == 2)
            hour_high <= inc_dec ? (hour_high + 1) % 3 : (hour_high == 0) ? 2 : hour_high - 1;
            
    end

endmodule
