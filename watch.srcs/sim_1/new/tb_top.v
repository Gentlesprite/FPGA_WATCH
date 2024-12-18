module tb_top;
    // 定义输入输出信号
    reg key_start_stop;
    reg [2:0] key_select;
    reg key_inc;
    reg key_dec;
    reg clk=0;          // 外部输入时钟
    reg rst;          // 复位信号
    wire [7:0] seg8;  // 8位数码管段码
    wire [5:0] tab6;  // 6位数码管选择信号
    // 实例化被测模块
    top uut (
    
    .clk(clk),
            .rst(rst),
        .key_start_stop(key_start_stop),
        .key_select(key_select),
        .key_inc(key_inc),
        .key_dec(key_dec),

        .seg8(seg8),
        .tab6(tab6)
    );
    // 生成时钟信号
    always #1 clk = ~clk;
    // 生成复位信号
    initial begin
        rst = 0;  // 初始复位
        #20 rst = 1;  // 20ns后释放复位
        #1000;
        
        key_start_stop = 1;
        

        key_select = 0;
       
        key_inc = 0;
        #1000;
        key_dec = 1;
        #1000;

    end
endmodule