module counter(
    input clk_1hz,  // 1 Hz ʱ��
    input rst,      // ��λ�ź�
    output reg  [3:0]sec_low,  // ���λ
    output reg  [2:0]sec_high, // ��ʮλ
    output reg  [3:0]min_low,  // �ָ�λ
    output reg  [2:0]min_high, // ��ʮλ
    output reg  [1:0]hour_low, // ʱ��λ
    output reg  [1:0]hour_high // ʱʮλ
);

    // ���������
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            sec_low <= 0;
        else if (sec_low == 9)
            sec_low <= 0;
        else
            sec_low <= sec_low + 1;
    end

    // ʮ���������
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            sec_high <= 0;
        else if (sec_high == 5 && sec_low == 9)
            sec_high <= 0;
        else if (sec_low == 9)
            sec_high <= sec_high + 1;
    end

    // �ּ�������
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            min_low <= 0;
        else if (min_low == 9 && sec_high == 5 && sec_low == 9)
            min_low <= 0;
        else if (sec_high == 5 && sec_low == 9)
            min_low <= min_low + 1;
    end

    // ʮ���Ӽ�������
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            min_high <= 0;
        else if (min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            min_high <= 0;
        else if (min_low == 9 && sec_high == 5 && sec_low == 9)
            min_high <= min_high + 1;
    end

    // Сʱ��������
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            hour_low <= 0;
        else if (hour_low == 9 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            hour_low <= 0;
        else if (min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            hour_low <= hour_low + 1;
    end

    // ʮСʱ��������
    always @(posedge clk_1hz or negedge rst)
    begin
        if (!rst) 
            hour_high <= 0;
        else if (hour_high == 2 && hour_low == 3 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            hour_high <= 0;
        else if (hour_low == 3 && min_high == 5 && min_low == 9 && sec_high == 5 && sec_low == 9)
            hour_high <= hour_high + 1;
    end

endmodule