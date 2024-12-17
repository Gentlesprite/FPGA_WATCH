module key(
    input clk_1hz,          // ʱ���ź�
    input rst,          // ��λ�ź�
    input [3:0] key,    // �ĸ���������
    output reg adjust_enable, // ����ʹ���ź�
    output reg [2:0] select_pos, // ѡ��λ�� (�롢�֡�Сʱ)
    output reg adjust_up,       // �Ӳ���
    output reg adjust_down      // ������
);

// ����ȥ�����������߼���������������
// ������谴���Ѿ����ⲿȥ��������

// ����/�رյ��ڵİ�����key[0]��
always @(posedge clk_1hz or negedge rst) begin
    if (!rst)
        adjust_enable <= 0;
    else if (key[0])
        adjust_enable <= ~adjust_enable; // �л�����ģʽ
end

// λѡ������key[1]��
always @(posedge clk_1hz or negedge rst) begin
    if (!rst)
        select_pos <= 0;
    else if (key[1] && adjust_enable)
        select_pos <= (select_pos + 1) % 6; // ѭ��ѡ�����λ����ʮλ���ָ�λ����ʮλ��ʱ��λ��ʱʮλ
end

// �Ӳ���������key[2]��
always @(posedge clk_1hz or negedge rst) begin
    if (!rst)
        adjust_up <= 0;
    else if (key[2] && adjust_enable)
        adjust_up <= 1;
    else
        adjust_up <= 0;
end

// ������������key[3]��
always @(posedge clk_1hz or negedge rst) begin
    if (!rst)
        adjust_down <= 0;
    else if (key[3] && adjust_enable)
        adjust_down <= 1;
    else
        adjust_down <= 0;
end

endmodule