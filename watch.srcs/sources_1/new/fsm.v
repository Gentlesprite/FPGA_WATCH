module fsm(clk,rst,clk_1hz,clk_1khz);
    input clk,rst;         // ����ʱ��
    output clk_1hz;   // ���1 Hzʱ��
    output clk_1khz;   // ���1000 Hzʱ��
    reg _clk_1,_clk_1k; //�м����
    reg [27:0] counter1=0; 
    reg [15:0] counter2=0;
parameter R1 = 50000000;
    always @(posedge clk)
        begin
            if (!rst)
                begin
                counter1<=0;
                _clk_1<=0;
                end
            else if(counter1==R1)
                begin
                    counter1<=0;
                    _clk_1<=1;
                end
            else
                begin
                    counter1<=counter1+1;
                    _clk_1<=0;
                end
        end
parameter R2 = 50000;
        always @(posedge clk)
             begin
             if (!rst)
                begin
                    counter2<=0;
                    _clk_1k<=0;
                end
                else if(counter2==R2)
                    begin
                        counter2<=0;
                        _clk_1k<=1;
                    end
                else
                    begin
                        counter2<=counter2+1;
                        _clk_1k<=0;
                    end
            end
    assign clk_1hz =_clk_1;
    assign clk_1khz =_clk_1k;
endmodule
        