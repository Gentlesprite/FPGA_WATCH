module display(
    input clk_1khz,          // ��ʱ���ź�
    input rst,        // �첽��λ�źţ��͵�ƽ��Ч
    input [3:0] sec_low,
    input [2:0] sec_high,
    input [3:0] min_low,
    input [2:0] min_high,
    input [1:0] hour_low,
    input [1:0] hour_high,
    output reg [7:0] seg8,
    output reg [5:0] tab6
);

    reg [2:0] address;  // ��ַ�Ĵ���������ѡ��������
    reg [3:0] A;        // �������ʾ������
    reg [7:0] segment;  // ��ǰ�������

    // ��λ�߼�
    always @(posedge clk_1khz or negedge rst) begin
        if (!rst)
            address <= 3'd0;
        else
            address <= (address + 1) % 6;
    end

    // �����������ʾ����
    always @(*) begin
        case (address)
            3'b000: begin A = sec_high; tab6 = 6'b111110; end // ��ʮλ
            3'b001: begin A = sec_low;  tab6 = 6'b111101; end // ���λ
            3'b010: begin A = min_high; tab6 = 6'b111011; end // ��ʮλ
            3'b011: begin A = min_low;  tab6 = 6'b110111; end // �ָ�λ
            3'b100: begin A = hour_high;tab6 = 6'b101111; end // ʱʮλ
            3'b101: begin A = hour_low;  tab6 = 6'b011111; end // ʱ��λ
            default: begin A = 4'b0000;   tab6 = 6'b111111; end // Ĭ�Ϲر�
        endcase
    end

    // ����ܶ���ת��
    always @(*) begin
        case (A)
            4'b0000: segment = 8'b1100_0000; // 0
            4'b0001: segment = 8'b1111_1001; // 1
            4'b0010: segment = 8'b1010_0100; // 2
            4'b0011: segment = 8'b1011_0000; // 3
            4'b0100: segment = 8'b1001_1001; // 4
            4'b0101: segment = 8'b1001_0010; // 5
            4'b0110: segment = 8'b1000_0010; // 6
            4'b0111: segment = 8'b1111_1000; // 7
            4'b1000: segment = 8'b1000_0000; // 8
            4'b1001: segment = 8'b1001_0000; // 9
            default: segment = 8'b1111_1111; // Ĭ�Ϲر�
        endcase
    end

    // ͨ��ѡ���źſ�����ʾ
    always @(posedge clk_1khz or negedge rst) begin
        if (!rst)
            seg8 <= 8'b1111_1111;  // ��λʱ�ر���ʾ
        else
            seg8 <= segment;      // �������
    end

endmodule