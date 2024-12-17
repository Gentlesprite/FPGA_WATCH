`timescale 1ns / 1ps
module tb_fsm;
    reg clk=0,rst;         // 输入时钟
    wire clk_1hz;   // 输出1 Hz时钟
    wire clk_1khz;   // 输出1000 Hz时钟
    fsm u1(.clk(clk),
    .rst(rst),
    .clk_1hz(clk_1hz),
    .clk_1khz(clk_1khz));
    always #1 clk = ~clk;
   
    // 复位信号生成
    initial begin
        rst = 0;#10
        rst = 1;
    end

endmodule
