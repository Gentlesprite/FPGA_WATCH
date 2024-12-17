module time_adjust(
    input clk_1hz,      // 1 Hz ʱ���ź�
    input rst,          // ��λ�ź�
    input adjust_enable,// ����ʹ���ź�
    input [2:0] select_pos, // ѡ��λ�� (���λ����ʮλ���ָ�λ����ʮλ��ʱ��λ��ʱʮλ)
    input adjust_up,       // �Ӳ���
    input adjust_down,     // ������
    input [3:0] sec_low_i, // ���λ����
    input [2:0] sec_high_i,// ��ʮλ����
    input [3:0] min_low_i, // �ָ�λ����
    input [2:0] min_high_i,// ��ʮλ����
    input [1:0] hour_low_i,// ʱ��λ����
    input [1:0] hour_high_i,// ʱʮλ����
    output reg [3:0] sec_low_o, // ���λ���
    output reg [2:0] sec_high_o,// ��ʮλ���
    output reg [3:0] min_low_o, // �ָ�λ���
    output reg [2:0] min_high_o,// ��ʮλ���
    output reg [1:0] hour_low_o,// ʱ��λ���
    output reg [1:0] hour_high_o// ʱʮλ���
);

// ��ʼ�������������ͬ
initial begin
    sec_low_o = sec_low_i;
    sec_high_o = sec_high_i;
    min_low_o = min_low_i;
    min_high_o = min_high_i;
    hour_low_o = hour_low_i;
    hour_high_o = hour_high_i;
end

// ״̬�Ĵ��������ڸ����Ƿ��ڵ���ģʽ
reg in_adjust_mode;

// ���ݵ��ڿ����źŵ���ʱ��
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
        in_adjust_mode <= 1; // �������ģʽ
    end else begin
        in_adjust_mode <= 0; // �˳�����ģʽ
    end
end

// �ڵ���ģʽ�£�������Ӧ��������
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
            3'b000: // ���λ
                if (adjust_up && sec_low_o < 9) sec_low_o <= sec_low_o + 1;
                else if (adjust_down && sec_low_o > 0) sec_low_o <= sec_low_o - 1;
            3'b001: // ��ʮλ
                if (adjust_up && sec_high_o < 5) sec_high_o <= sec_high_o + 1;
                else if (adjust_down && sec_high_o > 0) sec_high_o <= sec_high_o - 1;
            3'b010: // �ָ�λ
                if (adjust_up && min_low_o < 9) min_low_o <= min_low_o + 1;
                else if (adjust_down && min_low_o > 0) min_low_o <= min_low_o - 1;
            3'b011: // ��ʮλ
                if (adjust_up && min_high_o < 5) min_high_o <= min_high_o + 1;
                else if (adjust_down && min_high_o > 0) min_high_o <= min_high_o - 1;
            3'b100: // ʱ��λ
                if (adjust_up && hour_low_o < 9) hour_low_o <= hour_low_o + 1;
                else if (adjust_down && hour_low_o > 0) hour_low_o <= hour_low_o - 1;
            3'b101: // ʱʮλ
                if (adjust_up && (hour_high_o < 2 || (hour_high_o == 2 && hour_low_o < 3))) 
                    hour_high_o <= hour_high_o + 1;
                else if (adjust_down && hour_high_o > 0) hour_high_o <= hour_high_o - 1;
        endcase
    end
end

endmodule