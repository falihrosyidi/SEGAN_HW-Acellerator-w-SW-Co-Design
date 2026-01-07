`ifndef ELMNT_WISE_ADD
`define ELMNT_WISE_ADD


module elmnt_wise_add #(
    parameter WIDTH = 32,
    parameter FBITS = 24,
    parameter N_REG = 31
) (
    input wire signed  [N_REG*WIDTH-1:0] out_multiply,
    output reg signed [WIDTH-1:0] y
);
    integer i;
    reg signed [WIDTH-1:0] temp_sum;

    always @* begin
        temp_sum = 0; 
        for (i = 0; i < N_REG; i = i + 1) begin
            temp_sum = temp_sum + out_multiply[i*WIDTH +: WIDTH];
        end
        y = temp_sum;
    end

endmodule
`endif