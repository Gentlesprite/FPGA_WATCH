module tb_top;
    // ������������ź�
    reg clk=0;          // �ⲿ����ʱ��
    reg rst;          // ��λ�ź�
    wire [7:0] seg8;  // 8λ����ܶ���
    wire [5:0] tab6;  // 6λ�����ѡ���ź�
    // ʵ��������ģ��
    top uut (
        .clk(clk),
        .rst(rst),
        .seg8(seg8),
        .tab6(tab6)
    );
    // ����ʱ���ź�
    always #1 clk = ~clk;
    // ���ɸ�λ�ź�
    initial begin
        rst = 0;  // ��ʼ��λ
        #20 rst = 1;  // 20ns���ͷŸ�λ
    end
endmodule