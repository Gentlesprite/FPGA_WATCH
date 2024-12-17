module key(
    input clk,
    input rst,
    input key_start_stop,
    input key_select,
    input key_inc,
    input key_dec,
    output reg manual_mode,
    output reg [2:0] select_reg,
    output reg inc_dec
);

    reg start_stop_state;
    reg [2:0] select_cnt;

    // 同步按键输入
    reg key_start_stop_sync, key_select_sync, key_inc_sync, key_dec_sync;
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            key_start_stop_sync <= 0;
            key_select_sync <= 0;
            key_inc_sync <= 0;
            key_dec_sync <= 0;
        end else begin
            key_start_stop_sync <= key_start_stop;
            key_select_sync <= key_select;
            key_inc_sync <= key_inc;
            key_dec_sync <= key_dec;
        end
    end

    // 处理启动/停止按键
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            start_stop_state <= 0;
            manual_mode <= 0;
        end else if (key_start_stop_sync) begin
            start_stop_state <= ~start_stop_state;
            manual_mode <= start_stop_state;
        end
    end

    // 处理选择按键
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            select_cnt <= 0;
            select_reg <= 0;
        end else if (key_select_sync) begin
            select_cnt <= select_cnt + 1;
            select_reg <= select_cnt[2:0];
        end
    end

    // 处理增加/减少按键
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            inc_dec <= 0;
        end else if (key_inc_sync) begin
            inc_dec <= 1;
        end else if (key_dec_sync) begin
            inc_dec <= 0;
        end
    end

endmodule