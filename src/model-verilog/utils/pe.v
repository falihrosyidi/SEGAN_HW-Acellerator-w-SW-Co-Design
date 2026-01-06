`ifndef PE
`define PE

`include "mult_Q.v"

module PE #(
    parameter WIDTH = 32,
    parameter FBITS = 24,
    parameter N_REG = 31
) (
    input wire signed [N_REG*WIDTH-1:0] all_a,
    input wire signed [N_REG*WIDTH-1:0] all_w,
    input wire signed [WIDTH-1:0] b,
    output wire signed [WIDTH-1:0] y
);

    // Internal Memory Array to hold multiplication results
    wire signed [WIDTH-1:0] out_mult [N_REG-1:0];
    
    // Accumulator register
    reg signed [WIDTH-1:0] out;

    // --------------------------------------------------------
    // 1. MULT MAPPING (GENERATE BLOCK)
    // --------------------------------------------------------
    genvar g;
    generate
        for (g = 0; g < N_REG; g = g + 1) begin : mult_all
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

    // --------------------------------------------------------
    // 2. ADD ALL OUT MULT (Combinational Sum)
    // --------------------------------------------------------
    integer i;
    always @(*) begin
        out = b; 
        
        for (i = 0; i < N_REG; i = i + 1) begin
            out = out + out_mult[i];
        end
    end

    assign y = out;

endmodule
`endif