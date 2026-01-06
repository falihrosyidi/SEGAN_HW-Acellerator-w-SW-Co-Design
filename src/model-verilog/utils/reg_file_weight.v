module reg_file_weight #(
    parameter WIDTH = 32,
    parameter N_REG = 31
) (
    // CONTROL
    input wire clk,
    input wire rst,
    input wire en,

    // DATA INPUTS
    input wire signed [WIDTH-1:0] w_1,
    input wire signed [WIDTH-1:0] w_2,

    // FLATTENED OUTPUT
    output wire signed [WIDTH*N_REG-1:0] all_weight
);

    // Internal Memory Array
    reg signed [WIDTH-1:0] reg_f [N_REG-1:0];

    // --------------------------------------------------------
    // 1. OUTPUT MAPPING (GENERATE BLOCK)
    // --------------------------------------------------------
    // NOTES: To get Register N => all_weight[(N+1)*WIDTH-1 : N*WIDTH]
    genvar g;
    generate
        for (g = 0; g < N_REG; g = g + 1) begin : output_map
            assign all_weight[(g+1)*WIDTH-1 : g*WIDTH] = reg_f[g];
        end
    endgenerate

    // --------------------------------------------------------
    // 2. SEQUENTIAL LOGIC
    // --------------------------------------------------------
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to 0
            for (i = 0; i < N_REG; i = i + 1) begin
                reg_f[i] <= {WIDTH{1'b0}};
            end
        end
        else if (en) begin
            for (i = 1; i < N_REG; i = i + 1) begin
            reg_f[N_REG-(2*i)] <= w_1;
            reg_f[N_REG-(1*i)] <= w_2;
            end
        end
    end

endmodule