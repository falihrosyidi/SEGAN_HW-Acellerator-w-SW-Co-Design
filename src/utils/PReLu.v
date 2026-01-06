`ifndef PRELU_V
`define PRELU_V

module  PReLu#(
    parameter WIDTH = 32,
    parameter FBITS = 27
) (
    input  signed [WIDTH-1:0] x,
    input  signed [WIDTH-1:0] a,
    output signed [WIDTH-1:0] y
);
    wire signed [WIDTH:0] out_y;
    wire sign = x[WIDTH-1];
    
    always @* begin
    if (sign == 1'b1) begin
        y = x * a;
    end else begin
        y = x ;
    end
end

endmodule

`endif