module VGA_RGB(
    input clk,
    input [17:0]select,
    input [9:0]x_counter,
    input [9:0]y_counter,
    output reg[3:0]R,G,B
    );
    localparam
        M_1=17'd95556, //523.25 
        M_2=17'd85131, //587.33
        M_3=17'd75843, //659.25 
        M_4=17'd71586, //698.46 
        M_5=16'd63776, //783.99 
        M_6=16'd56818, //880 
        M_7=16'd50619, //987.
        H_1=17'd47778; //1046.50 

    reg[15:0] addr=16'b0;
    wire[11:0] data0,data1,data2,data3,data4,data5,data6,data7,data8;
    reg[11:0] d_data;
    blk_mem_gen_0 bram0(.clka(clk),.ena(1),.addra(addr),.douta(data0));
    blk_mem_gen_1 bram1(.clka(clk),.ena(1),.addra(addr),.douta(data1));
    blk_mem_gen_2 bram2(.clka(clk),.ena(1),.addra(addr),.douta(data2));
    blk_mem_gen_3 bram3(.clka(clk),.ena(1),.addra(addr),.douta(data3));
    blk_mem_gen_4 bram4(.clka(clk),.ena(1),.addra(addr),.douta(data4));
    blk_mem_gen_5 bram5(.clka(clk),.ena(1),.addra(addr),.douta(data5));
    blk_mem_gen_6 bram6(.clka(clk),.ena(1),.addra(addr),.douta(data6));
    blk_mem_gen_7 bram7(.clka(clk),.ena(1),.addra(addr),.douta(data7));
    blk_mem_gen_8 bram8(.clka(clk),.ena(1),.addra(addr),.douta(data8));

    always@(posedge clk)
    begin
    case(select)
        M_1: d_data<=data1;
        M_2: d_data<=data2;
        M_3: d_data<=data3;
        M_4: d_data<=data4;
        M_5: d_data<=data5;
        M_6: d_data<=data6;
        M_7: d_data<=data7;
        H_1: d_data<=data8;
        default: d_data<=data0;
    endcase
    end
    
    always@(posedge clk)
    begin
    if(x_counter>=0 && x_counter<=640 && y_counter>=125 && y_counter<=355)
    	begin
    	addr<=((y_counter-125)>>1)*10'd320+((x_counter)>>1);
        R<=d_data[11:8];
		G<=d_data[7:4];
        B<=d_data[3:0];
        end
    else
        {R,G,B}<=12'b0000_0000_0000;
    end
endmodule
