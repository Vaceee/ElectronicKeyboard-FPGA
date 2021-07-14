module VGA_Driver(
    input clk,
    input rst,
    output reg h_sync,  //tells the monitor that a line has been completed
    output reg v_sync,  //tells the monitor when a screen has been completed
    output reg[9:0] x_counter,
    output reg[9:0] y_counter,
    output reg in_display_area
);
    localparam H_ACTIVE_PIXELS=640;
    localparam H_FRONT_PORCH=16;
    localparam H_SYNC_WIDTH=96;
    localparam H_BACK_PORCH=48;
    localparam H_TOTAL_PIEXLS=(H_ACTIVE_PIXELS+H_FRONT_PORCH+H_BACK_PORCH+H_SYNC_WIDTH); 
    localparam V_ACTIVE_PIXELS=480; 
    localparam V_FRONT_PORCH=2; 
    localparam V_SYNC_WIDTH=10; 
    localparam V_BACK_PORCH=33; 
    localparam V_TOTAL_PIEXLS=(V_ACTIVE_PIXELS+V_FRONT_PORCH+V_BACK_PORCH+V_SYNC_WIDTH); 

    initial
    begin
        x_counter=0;
        y_counter=0;
    end

    wire x_counter_max;
    wire y_counter_max;
    assign x_counter_max=(x_counter==H_TOTAL_PIEXLS);
    assign y_counter_max=(y_counter==V_TOTAL_PIEXLS);
    
    always@(posedge clk)
    begin
    if(rst)
        begin
        if(x_counter_max)
            x_counter<=0;
        else
            x_counter<=x_counter+1;
        end
    else
        x_counter<=0;
    end

    always@(posedge clk) 
    begin
    if(rst)
        begin
        if(x_counter_max)
            begin
            if(y_counter_max)
                y_counter<=0;
            else
                y_counter<=y_counter+1;
            end 
        end
    else
        y_counter<=0;
    end

    always@(posedge clk)
    begin
    h_sync<=!(x_counter>H_ACTIVE_PIXELS+H_FRONT_PORCH && x_counter<H_ACTIVE_PIXELS+H_FRONT_PORCH+H_SYNC_WIDTH);
    v_sync<=!(y_counter>V_ACTIVE_PIXELS+V_FRONT_PORCH && y_counter<V_ACTIVE_PIXELS+V_FRONT_PORCH+V_SYNC_WIDTH);
    in_display_area<=(x_counter>=0 && x_counter<=H_ACTIVE_PIXELS && y_counter>=0 && y_counter<=V_ACTIVE_PIXELS);
    end
   
endmodule


