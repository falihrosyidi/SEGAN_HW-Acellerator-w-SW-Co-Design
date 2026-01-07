`ifndef ELMNT_WISE_MULT
`define ELMNT_WISE_MULT

`include "mult_Q.v"

module elmnt_wise_mult #(
    parameter WIDTH = 32,
    parameter FBITS = 24,
    parameter N_REG = 31
) (
    input wire signed [N_REG*WIDTH-1:0] all_a,
    input wire signed [N_REG*WIDTH-1:0] all_w,
    output wire signed [N_REG*WIDTH-1:0] all_mult
);

    // Internal Memory Array to hold multiplication results
    wire signed [WIDTH-1:0] out_mult [N_REG-1:0];
    
    // Accumulator register
    reg signed [WIDTH-1:0] out;

    // --------------------------------------------------------
    // 1. MULT MAPPING (GENERATE BLOCK)
    // --------------------------------------------------------
    // NOTES: To get Register N => all_outputs[(N+1)*WIDTH-1 : N*WIDTH]
    genvar g;
    generate
        for (g = 0; g < N_REG; g = g + 1) begin : mult_all
            assign all_mult[(g+1)*WIDTH-1 : g*WIDTH] = out_mult[g];

            mult_Q #(
                .WIDTH(WIDTH),
                .FBITS(FBITS)
            ) u_mult (
                // Use 'g' here, not 'N'
                .a(all_a[(g+1)*WIDTH-1 : g*WIDTH]),
                .b(all_w[(g+1)*WIDTH-1 : g*WIDTH]),
                .y(out_mult[g])
            );
        end
    endgenerate

endmodule
`endif