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
    // 1. OUTPUT MAPPING
    // --------------------------------------------------------
    genvar g;
    generate
        for (g = 0; g < N_REG; g = g + 1) begin : output_map
            assign all_weight[(g+1)*WIDTH-1 : g*WIDTH] = reg_f[g];
        end
    endgenerate

    // --------------------------------------------------------
    // 2. COUNTER & ADDRESS LOGIC
    // --------------------------------------------------------
    reg [3:0] count;
    wire [4:0] addr;

    // Address calculation: count * 2
    assign addr = {count, 1'b0}; 

    // --------------------------------------------------------
    // 3. SEQUENTIAL PROCESS (Counter + Write)
    // --------------------------------------------------------
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            // Reset Counter to top
            count <= 4'd15;

            // Reset all registers to 0
            for (i = 0; i < N_REG; i = i + 1) begin
                reg_f[i] <= {WIDTH{1'b0}};
            end
        end
        else if (en) begin
            // 1. Write Data
            
            if (addr < N_REG) 
                reg_f[addr] <= w_2;
            
            if (addr >= 1)    
                reg_f[addr-1] <= w_1;

            // 2. Decrement Counter
            if (count != 0) begin
                count <= count - 1;
            end
        end
    end

endmodule