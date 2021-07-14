module Divider #(parameter N=10000)(
    input clk_in,
    output reg clk_out
    );
    integer i=0;
    initial clk_out=0;
    always@(posedge clk_in)
    begin
    if(i==N/2-1)
        begin
        clk_out<=~clk_out;
        i<=0;
        end
    else
        i<=i+1;
    end
endmodule
