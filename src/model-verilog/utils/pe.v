`ifndef PE
`define PE

`include "elmnt_wise_mult.v"
`include "elmnt_add_all.v"
`include "prelu_Q.v"

module pe #(
    parameter WIDTH = 32,
    parameter FBITS = 24,
    parameter N_REG = 31
) (
    // Control/Config signal
    // input wire conf, // 0: normal PE, 1: just Addition from all input

    // Data Signal
    input wire signed [N_REG*WIDTH-1:0] all_a,
    input wire signed [N_REG*WIDTH-1:0] all_w,
    input wire signed [WIDTH-1:0] b,
    input wire signed [WIDTH-1:0] alpha,
    output wire signed [WIDTH-1:0] y
);
    // INTERNAL SIGNAL
    wire signed [N_REG*WIDTH-1:0] out_all_mult;
    wire signed [WIDTH-1:0] out_add_all;
    wire signed [WIDTH-1:0] out_add_b;
    wire signed [WIDTH-1:0] out_acttivation;

    // STAGE ELEMENT WISE MULTIPLICATION
    elmnt_wise_mult #(
        .WIDTH(WIDTH), .FBITS(FBITS), .N_REG(N_REG)
    ) u_elmnt_wise_mult (
        .all_a(all_a), .all_w(all_w), .all_mult(out_all_mult)
    );

    // STAGE ADD ALL OUT MULT
    elmnt_add_all #(
        .WIDTH(WIDTH), .FBITS(FBITS), .N_REG(N_REG)
    ) u_elmnt_add_all (
        .out_multiply(out_all_mult), .y(out_add_all)
    );

    // STAGE ADD BIAS
    assign out_add_b = out_add_all + b;

    // STAGE ACTIVATION
    prelu_Q #(
        .WIDTH(WIDTH), .FBITS(FBITS)
    ) u_prelu_Q (
        .x(out_add_b), .a(alpha), .y(out_acttivation)
    );

    // OUTPUT
    assign y = out_acttivation;

endmodule
`endif 