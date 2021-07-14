module Beep(
    input clk, rst,
    input mode,
    input track,
    input [15:0]keycode,
    output beep,
    output music_out,
    output[17:0] tune
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
    
    wire[23:0] DELAY;
    assign DELAY=(track==0)?8000000:12000000;
    
    reg beep_p; //piano
    reg beep_m; //melody
    reg[17:0] countp=0;
    reg[17:0] countm=0;
    reg[17:0] countm_end=0; 
    reg[17:0] countp_end=0;
    reg [7:0] rhythm=8'b0;
    reg [23:0] div=24'b0;

    assign music_out=beep;
    assign beep=(mode==1'b1)?beep_m:beep_p; 
    assign tune=(mode==1'b0)?countp_end:countm_end;

    always@(posedge clk) 
    begin
    if(~rst) 
        begin 
        countp<=16'b0; 
        beep_p<=1'b0;  
        end  
    else 
        begin
        if(countp==countp_end) 
            begin  
            countp<=16'b0; 
            beep_p<=~beep_p;
            countp_end<=16'h2; 
            end 
        else  
            countp<=countp+1'b1; 
        case(keycode[7:0])
            8'h1A: countp_end<=L_1;
            8'h22: countp_end<=L_2;
            8'h21: countp_end<=L_3;
            8'h2A: countp_end<=L_4;
            8'h32: countp_end<=L_5;
            8'h31: countp_end<=L_6;
            8'h3A: countp_end<=L_7;
            8'h1C,8'h41: countp_end<=M_1;
            8'h1B,8'h49: countp_end<=M_2;
            8'h23,8'h4A: countp_end<=M_3;
            8'h2B: countp_end<=M_4;
            8'h34: countp_end<=M_5;
            8'h33: countp_end<=M_6;
            8'h3B: countp_end<=M_7;
            8'h15,8'h42: countp_end<=H_1;
            8'h1D,8'h4B: countp_end<=H_2;
            8'h24,8'h4C: countp_end<=H_3;
            8'h2D: countp_end<=H_4;
            8'h2C: countp_end<=H_5;
            8'h35: countp_end<=H_6;
            8'h3C: countp_end<=H_7;
            8'h43: countp_end<=HH_1;
            8'h44: countp_end<=HH_2;
            8'h4D: countp_end<=HH_3;
            8'hF0: countp_end<=16'h2;
        endcase
        if(keycode[15:8]==8'hF0)
            countp_end<=16'h2;
        end
    end

    always@(posedge clk)
    begin
    if(~rst)
        begin
        div<=0;
        rhythm<=0;
        end
    else if(div<DELAY)
        div<=div+1;
    else
        begin
        div<=0;
        if(track==1'b0)
        begin
        if(rhythm==8'd128)
            rhythm<=0;
        else 
            rhythm<=rhythm+1;
        case(rhythm)
            8'd0,8'd1,8'd2,8'd3: countm_end <= M_1;
            8'd4,8'd5: countm_end <= M_1;
            8'd6,8'd7: countm_end <= M_1;
            8'd8,8'd9: countm_end <= M_1;
            8'd10,8'd11: countm_end <= L_6;
            8'd12,8'd13: countm_end <= L_5; 
            8'd14,8'd15: countm_end <= L_6;

            8'd16,8'd17,8'd18,8'd19: countm_end <= M_1;  
            8'd20,8'd21: countm_end <= M_1;
            8'd22,8'd23: countm_end <= M_1;
            8'd24,8'd25: countm_end <= M_1;
            8'd26,8'd27: countm_end <= M_2;
            8'd28,8'd29: countm_end <= M_3;
            8'd30,8'd31: countm_end <= M_2;

            8'd32,8'd33,8'd34,8'd35: countm_end <= M_1;
            8'd36,8'd37: countm_end <= M_1;
            8'd38,8'd39: countm_end <= M_1;
            8'd40,8'd41: countm_end <= M_2;
            8'd42,8'd43: countm_end <= M_1;
            8'd44,8'd45: countm_end <= L_7;
            8'd46,8'd47: countm_end <= M_1;

            8'd48,8'd49,8'd50,8'd51,8'd52,8'd53,8'd54,8'd55,8'd56,8'd57,8'd58,8'd59: countm_end <= M_2; 
            8'd60,8'd61: countm_end <= M_1;
            8'd62,8'd63: countm_end <= M_2;

            8'd64,8'd65,8'd66,8'd67: countm_end <= M_4; 
            8'd68,8'd69: countm_end <= M_4;
            8'd70,8'd71: countm_end <= M_4;
            8'd72,8'd73: countm_end <= M_4;
            8'd74,8'd75: countm_end <= M_2;
            8'd76,8'd77: countm_end <= M_1;
            8'd78,8'd79: countm_end <= M_2;

            8'd80,8'd81,8'd82,8'd83: countm_end <= M_4;  
            8'd84,8'd85: countm_end <= M_4;
            8'd86,8'd87: countm_end <= M_4;  
            8'd88,8'd89: countm_end <= M_4;
            8'd90,8'd91: countm_end <= M_5; 
            8'd92,8'd93: countm_end <= M_6;
            8'd94,8'd95: countm_end <= M_5; 

            8'd96,8'd97,8'd98,8'd99: countm_end <= M_4;
            8'd100,8'd101: countm_end <= M_4;
            8'd102,8'd103: countm_end <= M_3; 
            8'd104,8'd105,8'd106,8'd107: countm_end <= M_2;
            8'd108,8'd109: countm_end <= M_2;
            8'd110,8'd111: countm_end <= M_1;

            8'd112,8'd113,8'd114,8'd115,8'd116,8'd117,8'd118,8'd119,8'd120,8'd121,8'd122,8'd123: countm_end <= L_7;
            8'd124,8'd125: countm_end <= L_6;
            8'd126,8'd127: countm_end <= L_7;
            default:countm_end <= 16'h2;
        endcase
        end
        else if(track==1'b1)
            begin
            if(rhythm==8'd205)
                rhythm<=0;
            else 
                rhythm<=rhythm+1;
            case(rhythm)
            8'd0,8'd1: countm_end <= M_3;
            8'd2: countm_end <= M_3;
            8'd3: countm_end <= 16'h2;
            8'd4,8'd5: countm_end <= M_3;
            8'd6: countm_end <= M_1;
            8'd7: countm_end <= M_3;
            8'd8, 8'd9: countm_end <= 16'h2;
            8'd10,8'd11: countm_end <= M_5;
            8'd12,8'd13: countm_end <= 16'h2; 
            8'd14,8'd15: countm_end <= L_5;

            8'd16,8'd17: countm_end <= 16'h2;
            8'd18,8'd19: countm_end <= M_1;  
            8'd20,8'd21: countm_end <= 16'h2;
            8'd22,8'd23: countm_end <= L_5;
            8'd24: countm_end <= 16'h2;
            8'd25,8'd26: countm_end <= L_3;
            8'd27: countm_end <= 16'h2;
            8'd28: countm_end <= L_6;
            8'd29: rhythm<=8'd31;

            8'd32,8'd33: countm_end <= L_7;
            8'd34: countm_end <= L_6p;
            8'd35: countm_end <= L_6;
            8'd36,8'd37: countm_end <= 16'h2;
            8'd38,8'd39: countm_end <= L_5;
            8'd40,8'd41: countm_end <= M_3;
            8'd42: countm_end <= M_5;
            8'd43,8'd44: countm_end <= M_6;
            8'd45: countm_end <= M_4;
            8'd46: begin 
                   countm_end <= M_5;
                   rhythm<=8'd47;
                   end

            8'd48: countm_end <= 16'h2;
            8'd49: countm_end <= M_3;
            8'd50: countm_end <= 16'h2;
            8'd51: countm_end <= M_1;
            8'd52: countm_end <= M_2;
            8'd53,8'd54: countm_end <= L_7;
            8'd55,8'd56: countm_end <= 16'h2;
            8'd57,8'd58: countm_end <= M_1;
            8'd59,8'd60: countm_end <= 16'h2;
            8'd61,8'd62: countm_end <= L_5;
            8'd63: countm_end <= 16'h2;
            8'd64: countm_end <= L_3;
            8'd65: rhythm<=8'd66;
            
            8'd67,8'd68: countm_end <= 16'h2;
            8'd69,8'd70: countm_end <= L_6;
            8'd71,8'd72: countm_end <= L_7;
            8'd73: countm_end <= L_6p;
            8'd74: countm_end <= L_6;
            8'd75: countm_end <= 16'h2;
            8'd76,8'd77: countm_end <= L_5;
            8'd78,8'd79: countm_end <= M_3;
            8'd80: begin 
                   countm_end <= M_5;
                   rhythm<=8'd81;
                   end
            8'd82,8'd83: countm_end <= M_6;
            8'd84: countm_end <= M_4;  
            8'd85: countm_end <= M_5;
            8'd86: countm_end <= 16'h2;
            8'd87: countm_end <= M_3;  
            8'd88: countm_end <= 16'h2;
            8'd89: countm_end <= M_1;
            8'd90: countm_end <= M_2;
            8'd91,8'd92,8'd93: countm_end <= L_7;
            8'd94,8'd95: countm_end <= 16'h2; 

            8'd96: countm_end <= M_5;
            8'd97: countm_end <= M_4;
            8'd98: countm_end <= M_3;
            8'd99: countm_end <= M_2;
            8'd100: countm_end <= 16'h2;
            8'd101: countm_end <= M_3;
            8'd102: countm_end <= 16'h2;
            8'd103: countm_end <= L_5;
            8'd104: countm_end <= L_6;
            8'd105: begin 
                    countm_end <= M_1;
                    rhythm<=8'd111;
                    end

            8'd112: countm_end <= 16'h2;
            8'd113: countm_end <= L_6;
            8'd114: countm_end <= M_1;
            8'd115: countm_end <= 16'h2;
            8'd116: countm_end <= M_5;
            8'd117: countm_end <= M_4;
            8'd118: countm_end <= M_3;
            8'd119: countm_end <= M_2;
            8'd120: countm_end <= 16'h2;
            8'd121, 8'd122: countm_end <= M_3;
            8'd123: countm_end <= 16'h2;
            8'd124: begin
                    countm_end <= H_1;
                    rhythm<=8'd128;
                    end

            8'd129: countm_end <= H_1;
            8'd130: countm_end <= 16'h2;
            8'd131,8'd132: countm_end <= H_1;
            8'd133,8'd134: countm_end <= 16'h2;
            8'd135: countm_end <= M_5;
            8'd136: countm_end <= M_4;
            8'd137: countm_end <= M_3;
            8'd138: countm_end <= M_2;
            8'd139: countm_end <= 16'h2;
            8'd140: countm_end <= M_3;
            8'd141: countm_end <= 16'h2;
            8'd142: countm_end <= L_5;
            8'd143: rhythm<=8'd144;

            8'd145,8'd146: countm_end <= L_6;
            8'd147,8'd148: countm_end <= M_1;
            8'd149,8'd150: countm_end <= 16'h2;
            8'd151,8'd152: countm_end <= M_2p;
            8'd153,8'd154: countm_end <= 16'h2;
            8'd155,8'd156: countm_end <= M_2;
            8'd157,8'd158: countm_end <= M_1;
            8'd159,8'd160: countm_end <= 16'h2;

            8'd161,8'd162: countm_end <= M_1;
            8'd163: countm_end <= 16'h2;
            8'd164: countm_end <= M_1;
            8'd165: countm_end <= 16'h2;
            8'd166: countm_end <= M_1;
            8'd167: countm_end <= M_1;
            8'd168: countm_end <= M_2;
            8'd169: countm_end <= 16'h2;
            8'd170: countm_end <= M_3;
            8'd171: countm_end <= M_1;
            8'd172: countm_end <= 16'h2; 
            8'd173: countm_end <= L_6;
            8'd174: countm_end <= L_5;
            8'd175,8'd176: countm_end <= 16'h2;

            8'd177,8'd178: countm_end <= M_1;
            8'd179: countm_end <= 16'h2;
            8'd180: countm_end <= M_1;
            8'd181: countm_end <= 16'h2;
            8'd182: countm_end <= M_1;
            8'd183: countm_end <= M_1;
            8'd184: countm_end <= M_2;
            8'd185: countm_end <= M_3;
            8'd186,8'd187,8'd188,8'd189: countm_end <= 16'h2;
            8'd190: countm_end <= M_1;
            8'd191: countm_end <= 16'h2;
            8'd192: countm_end <= M_1;

            8'd193: countm_end <= 16'h2;
            8'd194: countm_end <= M_1;
            8'd195: countm_end <= M_1;
            8'd196: countm_end <= M_2;
            8'd197: countm_end <= 16'h2;
            8'd198: countm_end <= M_3;
            8'd199: countm_end <= M_1;
            8'd200: countm_end <= 16'h2; 
            8'd201: countm_end <= L_6;
            8'd202: countm_end <= L_5;
            8'd203,8'd204: countm_end <= 16'h2;
            default:countm_end <= 16'h2;
            endcase
            end
        end
    end

    always@(posedge clk) 
    begin 
    if(~rst) 
        begin 
        countm<=16'b0; 
        beep_m<=1'b0;  
        end  
    else 
        begin
        if(countm==countm_end) 
            begin  
            countm<=16'b0; 
            beep_m<=~beep_m; 
            end 
        else  
            countm<=countm+1; 
        end
    end

endmodule