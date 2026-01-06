`ifndef PRELU_Q_V
`define PRELU_Q_V

module PReLu_Q #(
    parameter WIDTH = 32,
    parameter FBITS = 24
) (
    input  signed [WIDTH-1:0] x,
    input  signed [WIDTH-1:0] a,
    output signed [WIDTH-1:0] y
);
    
    wire signed [(2*WIDTH)-1:0] product;
    wire sign = x[WIDTH-1];

    assign product = x * a;

    assign y = (sign) ? product[(FBITS + WIDTH - 1) : FBITS] : x;

endmodule

`endif