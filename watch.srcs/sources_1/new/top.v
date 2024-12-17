module top(
    input clk,          // �ⲿʱ������
    input rst,          // ��λ�ź�
    output [7:0] seg8,  // 8λ����ܶ������
    output [5:0] tab6   // 6λ�����ѡ���ź����
);

    // �ڲ��źŶ���
    wire clk_1hz;       // 1 Hz ʱ��
    wire clk_1khz;      // 1 kHz ʱ��
    wire [3:0] sec_low;
    wire [2:0] sec_high;
    wire [3:0] min_low;
    wire [2:0] min_high;
    wire [1:0] hour_low;
    wire [1:0] hour_high;

    // ʵ���� fsm ģ��
    fsm uut_fsm (
        .clk(clk),
        .rst(rst),
        .clk_1hz(clk_1hz),
        .clk_1khz(clk_1khz)
    );

    // ʵ���� counter ģ��
    counter uut_counter (
        .clk_1hz(clk_1hz),
        .rst(rst),
        .sec_low(sec_low),
        .sec_high(sec_high),
        .min_low(min_low),
        .min_high(min_high),
        .hour_low(hour_low),
        .hour_high(hour_high)
    );

    // ʵ���� display ģ��
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