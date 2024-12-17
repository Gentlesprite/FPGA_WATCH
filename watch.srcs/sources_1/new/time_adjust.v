module time_adjust(
    input clk_1hz,      // 1 Hz 时钟信号
    input rst,          // 复位信号
    input adjust_enable,// 调整使能信号
    input [2:0] select_pos, // 选择位置 (秒个位、秒十位、分个位、分十位、时个位、时十位)
    input adjust_up,       // 加操作
    input adjust_down,     // 减操作
    input [3:0] sec_low_i, // 秒个位输入
    input [2:0] sec_high_i,// 秒十位输入
    input [3:0] min_low_i, // 分个位输入
    input [2:0] min_high_i,// 分十位输入
    input [1:0] hour_low_i,// 时个位输入
    input [1:0] hour_high_i,// 时十位输入
    output reg [3:0] sec_low_o, // 秒个位输出
    output reg [2:0] sec_high_o,// 秒十位输出
    output reg [3:0] min_low_o, // 分个位输出
    output reg [2:0] min_high_o,// 分十位输出
    output reg [1:0] hour_low_o,// 时个位输出
    output reg [1:0] hour_high_o// 时十位输出
);

// 初始化输出与输入相同
initial begin
    sec_low_o = sec_low_i;
    sec_high_o = sec_high_i;
    min_low_o = min_low_i;
    min_high_o = min_high_i;
    hour_low_o = hour_low_i;
    hour_high_o = hour_high_i;
end

// 状态寄存器，用于跟踪是否处于调整模式
reg in_adjust_mode;

// 根据调节控制信号调整时间
always @(posedge clk_1hz or negedge rst) begin
    if (!rst) begin
        sec_low_o <= 0;
        sec_high_o <= 0;
        min_low_o <= 0;
        min_high_o <= 0;
        hour_low_o <= 0;
        hour_high_o <= 0;
        in_adjust_mode <= 0;
    end else if (adjust_enable) begin
        in_adjust_mode <= 1; // 进入调整模式
    end else begin
        in_adjust_mode <= 0; // 退出调整模式
    end
end

// 在调整模式下，立即响应按键输入
always @(posedge clk_1hz or negedge rst) begin
    if (!rst) begin
        sec_low_o <= 0;
        sec_high_o <= 0;
        min_low_o <= 0;
        min_high_o <= 0;
        hour_low_o <= 0;
        hour_high_o <= 0;
    end else if (in_adjust_mode && adjust_enable) begin
        case (select_pos)
            3'b000: // 秒个位
                if (adjust_up && sec_low_o < 9) sec_low_o <= sec_low_o + 1;
                else if (adjust_down && sec_low_o > 0) sec_low_o <= sec_low_o - 1;
            3'b001: // 秒十位
                if (adjust_up && sec_high_o < 5) sec_high_o <= sec_high_o + 1;
                else if (adjust_down && sec_high_o > 0) sec_high_o <= sec_high_o - 1;
            3'b010: // 分个位
                if (adjust_up && min_low_o < 9) min_low_o <= min_low_o + 1;
                else if (adjust_down && min_low_o > 0) min_low_o <= min_low_o - 1;
            3'b011: // 分十位
                if (adjust_up && min_high_o < 5) min_high_o <= min_high_o + 1;
                else if (adjust_down && min_high_o > 0) min_high_o <= min_high_o - 1;
            3'b100: // 时个位
                if (adjust_up && hour_low_o < 9) hour_low_o <= hour_low_o + 1;
                else if (adjust_down && hour_low_o > 0) hour_low_o <= hour_low_o - 1;
            3'b101: // 时十位
                if (adjust_up && (hour_high_o < 2 || (hour_high_o == 2 && hour_low_o < 3))) 
                    hour_high_o <= hour_high_o + 1;
                else if (adjust_down && hour_high_o > 0) hour_high_o <= hour_high_o - 1;
        endcase
    end
end

endmodule