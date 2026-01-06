module reg_file_input #(
    parameter WIDTH = 32,
    parameter FBITS = 24,
    parameter N_REG = 31
) (
    // CONTROL
    input wire clk,
    input wire rst,
    input wire en,

    // DATA
    input wire signed [WIDTH-1:0] in_1,
    input wire signed [WIDTH-1:0] in_2,
    
    // OUTPUTS
    output wire signed [WIDTH-1:0] out_1,
    output wire signed [WIDTH-1:0] out_2,
    output wire signed [WIDTH-1:0] out_3,
    output wire signed [WIDTH-1:0] out_4,
    output wire signed [WIDTH-1:0] out_5,
    output wire signed [WIDTH-1:0] out_6,
    output wire signed [WIDTH-1:0] out_7,
    output wire signed [WIDTH-1:0] out_8,
    output wire signed [WIDTH-1:0] out_9,
    output wire signed [WIDTH-1:0] out_10,
    output wire signed [WIDTH-1:0] out_11,
    output wire signed [WIDTH-1:0] out_12,
    output wire signed [WIDTH-1:0] out_13,
    output wire signed [WIDTH-1:0] out_14,
    output wire signed [WIDTH-1:0] out_15,
    output wire signed [WIDTH-1:0] out_16,
    output wire signed [WIDTH-1:0] out_17,
    output wire signed [WIDTH-1:0] out_18,
    output wire signed [WIDTH-1:0] out_19,
    output wire signed [WIDTH-1:0] out_20,
    output wire signed [WIDTH-1:0] out_21,
    output wire signed [WIDTH-1:0] out_22,
    output wire signed [WIDTH-1:0] out_23,
    output wire signed [WIDTH-1:0] out_24,
    output wire signed [WIDTH-1:0] out_25,
    output wire signed [WIDTH-1:0] out_26,
    output wire signed [WIDTH-1:0] out_27,
    output wire signed [WIDTH-1:0] out_28,
    output wire signed [WIDTH-1:0] out_29,
    output wire signed [WIDTH-1:0] out_30,
    output wire signed [WIDTH-1:0] out_31
);

    // Unpacked array for storage
    reg signed [WIDTH-1:0] reg_f [N_REG-1:0];
    
    // 1. OUTPUT ASSIGNMENTS
    assign out_1  = reg_f[0];
    assign out_2  = reg_f[1];
    assign out_3  = reg_f[2];
    assign out_4  = reg_f[3];
    assign out_5  = reg_f[4];
    assign out_6  = reg_f[5];
    assign out_7  = reg_f[6];
    assign out_8  = reg_f[7];
    assign out_9  = reg_f[8];
    assign out_10 = reg_f[9];
    assign out_11 = reg_f[10];
    assign out_12 = reg_f[11];
    assign out_13 = reg_f[12];
    assign out_14 = reg_f[13];
    assign out_15 = reg_f[14];
    assign out_16 = reg_f[15];
    assign out_17 = reg_f[16];
    assign out_18 = reg_f[17];
    assign out_19 = reg_f[18];
    assign out_20 = reg_f[19];
    assign out_21 = reg_f[20];
    assign out_22 = reg_f[21];
    assign out_23 = reg_f[22];
    assign out_24 = reg_f[23];
    assign out_25 = reg_f[24];
    assign out_26 = reg_f[25];
    assign out_27 = reg_f[26];
    assign out_28 = reg_f[27];
    assign out_29 = reg_f[28];
    assign out_30 = reg_f[29];
    assign out_31 = reg_f[30];

    // Loop variable
    integer i;

    // 2. PROCESS
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Non-blocking assignment and correct width handling
            for (i = 0; i < N_REG; i = i + 1) begin
                reg_f[i] <= {WIDTH{1'b0}};
            end
        end
        else if (en) begin
            // Shift operations
            // We shift everything down by 2 positions
            for (i = 0; i < N_REG-2; i = i + 1) begin
                reg_f[i] <= reg_f[i+2];
            end

            // Load new inputs into the top 2 slots
            reg_f[N_REG-2] <= in_1; // Index 29
            reg_f[N_REG-1] <= in_2; // Index 30
        end
    end

endmodule