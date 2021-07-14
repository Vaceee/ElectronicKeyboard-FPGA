module Display7(
	input clk,
    input rst,
    input init,
    input [17:0] data1,
    input [2:0] data2,
    input [3:0] data3,
    output reg [6:0] seg_data,
    output reg [7:0] seg_sel,
    output reg DP 
);
localparam
    L_1=18'd191101, //261.63
    L_2=18'd170259, //293.67 
    L_3=18'd151685, //329.63
    L_4=18'd143172, //349.23 
    L_5=17'd127554, //391.99 
    L_6=17'd113636, //440
    L_6p=17'd107259, //466.16 
    L_7=17'd101239, //493.88
    M_1=17'd95556, //523.25 
    M_2=17'd85131, //587.33
    M_2p=17'd80353, //622.25
    M_3=17'd75843, //659.25 
    M_4=17'd71586, //698.46 
    M_5=16'd63776, //783.99 
    M_6=16'd56818, //880 
    M_7=16'd50619, //987.76
    H_1=17'd47778, //1046.50 
    H_2=17'd42565, //1174.66 
    H_3=16'd37921, //1318.51 
    H_4=16'd35793, //1396.92 
    H_5=16'd31888, //1567.98
    H_6=16'd28409, //1760 
    H_7=16'd25310, //1975.52
    HH_1=16'd23889, //2093
    HH_2=16'd21283, //2349.3
    HH_3=16'd18960; //2637

wire[2:0] s;	 
reg[3:0] digit;
wire[7:0] aen;
reg[19:0] clkdiv;

reg[26:0] scan_count;
reg[3:0] sec_ten=0;
reg[3:0] sec_one=0;
reg[3:0] min_ten=0;
reg[3:0] min_one=0;
wire[17:0] tune;
wire[3:0] track;
reg[3:0] pre_track;

assign tune=data1;
assign track=data3;


assign s = clkdiv[19:17];
assign aen = 8'b11111111; // all turned off 
localparam SEC_SCAN_FREQ=100000000; //100MHz

always @(posedge clk) 
begin
clkdiv<= clkdiv+1;
end

//Time Counting
always@(posedge clk)
    begin
    if(~init || track!=pre_track)
        begin
        sec_ten<=0;
        sec_one<=0;
        min_ten<=0;
        min_one<=0;
        scan_count<=0;
        pre_track<=track;
        end
    else
        begin
        if(scan_count==SEC_SCAN_FREQ)
            begin
            scan_count<=0;
            sec_one<=sec_one+4'd1;
            if(sec_one==4'd9)
                begin
                sec_one<=0;
                sec_ten<=sec_ten+1;
                if(sec_ten==4'd5)
                    begin
                    min_one<=min_one+1;
                    sec_ten<=0;
                    end
                end
            end
        else
            scan_count<=scan_count+1;
        end
    end

always @(posedge clk)
begin
case(s)
	0: begin
        if(tune>=L_7 && tune<=L_1)
            digit<=4'd4;
        else if(tune>=M_7 && tune<=M_1)
            digit<=4'd5;
        else if(tune>=H_7 && tune<=H_1)
            digit<=4'd6;
        else if(tune>=HH_3 && tune<=HH_1)
            digit<=4'd7;
        else
            digit<=4'd0;
    end
	1: begin
        case(tune)
            L_1,M_1,H_1,HH_1: digit<=4'hC;
            L_2,M_2,H_2,HH_2: digit<=4'hD;
            L_3,M_3,H_3,HH_3: digit<=4'hE;
            L_4,M_4,H_4: digit<=4'hF;
            L_5,M_5,H_5: digit<=4'h9;//G
            L_6,M_6,H_6: digit<=4'hA;
            L_7,M_7,H_7: digit<=4'hB;
            default: digit<=4'd0;
        endcase
    end
	2:digit<= data2; 
	3:digit<= data3; 
	4:digit<= sec_one; 
    5:digit<= sec_ten; 
    6:digit<= min_one; 
    7:digit<= min_ten; 
	default:digit<= 4'd0;
endcase
end
	

always @(*)
begin
if(~rst)
    {seg_data,DP}<=8'b11111111;
if(~init && s>=3'b010 && s<=3'b111)
    {seg_data,DP}<=8'b11111111;
else
    begin
    case(digit)
//////////<---MSB-LSB<---
//////////////gfedcba////////////////////////////////////////////           
    0: seg_data<= 7'b1000000;////0000			
    1: seg_data<= 7'b1111001;////0001
    2: seg_data<= 7'b0100100;////0010
    3: seg_data<= 7'b0110000;////0011							
    4: seg_data<= 7'b0011001;////0100										
    5: seg_data<= 7'b0010010;////0101                                     
    6: seg_data<= 7'b0000010;////0110
    7: seg_data<= 7'b1111000;////0111
    8: seg_data<= 7'b0000000;////1000
    9: seg_data<= 7'b0010000;////1001
    'hA: seg_data<= 7'b0001000; 
    'hB: seg_data<= 7'b0000011; 
    'hC: seg_data<= 7'b1000110;
    'hD: seg_data<= 7'b0100001;
    'hE: seg_data<= 7'b0000110;
    'hF: seg_data<= 7'b0001110;
    default:seg_data<= 7'b0000000; // 
    endcase
    if(s==3'd2 || s==3'd6)
        DP<=0;
    else
        DP<=1;
    end
end


always @(*)
begin
seg_sel<=8'b11111111;
if(rst && aen[s] == 1)
    seg_sel[s]<= 0;
end


endmodule