`timescale 1ns/1ps
`include "pe.v"

module pe_tb;
    parameter WIDTH = 32;
    parameter FBITS = 24;
    parameter N_REG = 31;

    reg signed [N_REG*WIDTH-1:0] all_a, all_w;
    reg signed [WIDTH-1:0] b, alpha;
    wire signed [WIDTH-1:0] y;

    // Instance UUT
    pe #(.WIDTH(WIDTH), .FBITS(FBITS), .N_REG(N_REG)) uut (
        .all_a(all_a), .all_w(all_w), .b(b), .alpha(alpha), .y(y)
    );

    reg signed [WIDTH-1:0] a_array [N_REG-1:0];
    reg signed [WIDTH-1:0] w_array [N_REG-1:0];
    integer i;

    // Task untuk input desimal
    task set_val;
        input integer idx;
        input real val_a;
        input real val_w;
        begin
            a_array[idx] = val_a * (2**FBITS);
            w_array[idx] = val_w * (2**FBITS);
        end
    endtask

    // Proses flattening array
    always @(*) begin
        for (i = 0; i < N_REG; i = i + 1) begin
            all_a[i*WIDTH +: WIDTH] = a_array[i];
            all_w[i*WIDTH +: WIDTH] = w_array[i];
        end
    end

    initial begin
        // Setup GTKWave
        $dumpfile("pe_tb.vcd");
        $dumpvars(0, pe_tb);

        // Header Tabel
        $display("\n==========================================================================");
        $display("   TEST CASE: FULL UTILIZATION (31 REGISTERS ACTIVE)");
        $display("==========================================================================");
        $display(" Time |   Status   |   Bias   |   Alpha  |   Total X  |   Output Y  ");
        $display("--------------------------------------------------------------------------");

        // Inisialisasi awal
        alpha = 0.5 * (2**FBITS); // Alpha = 0.5
        
        // --- TEST CASE 3: SEMUA TERPAKAI (HASIL POSITIF) ---
        // Kita isi: a_i = 0.2, w_i = 0.5 untuk semua 31 elemen
        // Perhitungan: (0.2 * 0.5) * 31 = 0.1 * 31 = 3.1
        for (i = 0; i < N_REG; i = i + 1) begin
            set_val(i, 0.2, 0.5); 
        end
        b = 0.9 * (2**FBITS); // 3.1 + 0.9 = 4.0
        #20;
        $display("%4tns | POSITIF  | %8.4f | %8.4f | %10.4f | %10.4f", 
                 $time, $itor(b)/(2**FBITS), $itor(alpha)/(2**FBITS), 
                 (3.1 + 0.9), $itor(y)/(2**FBITS));

        // --- TEST CASE 4: SEMUA TERPAKAI (HASIL NEGATIF) ---
        // Kita isi: a_i = 1.0, w_i = -0.1 untuk semua 31 elemen
        // Perhitungan: (1.0 * -0.1) * 31 = -3.1
        for (i = 0; i < N_REG; i = i + 1) begin
            set_val(i, 1.0, -0.1); 
        end
        b = 0.1 * (2**FBITS); // -3.1 + 0.1 = -3.0
        #20;
        // Ekspektasi Y: -3.0 * alpha(0.5) = -1.5
        $display("%4tns | NEGATIF  | %8.4f | %8.4f | %10.4f | %10.4f", 
                 $time, $itor(b)/(2**FBITS), $itor(alpha)/(2**FBITS), 
                 (-3.1 + 0.1), $itor(y)/(2**FBITS));

        $display("==========================================================================\n");
        $finish;
    end
//     // -----------------------------------------------------------
// // DEBUG HELPER: Add this inside your Testbench module
// // -----------------------------------------------------------

// // 1. Define the parameters again if needed
// localparam DEBUG_WIDTH = 32;
// localparam DEBUG_N     = 31;

// // 2. Use a Generate Loop to create separate wires for GTKWave
// genvar k;
// generate
//     for (k = 0; k < DEBUG_N; k = k + 1) begin : probe
//         // This slices the big bus "all_mult" into 32-bit chunks
//         // Replace 'uut.all_mult' with the actual path to your signal
//         wire signed [DEBUG_WIDTH-1:0] a;
//         wire signed [DEBUG_WIDTH-1:0] b;
        
//         assign a = uut.all_a[(k+1)*DEBUG_WIDTH-1 : k*DEBUG_WIDTH];
//         assign b = uut.all_b[(k+1)*DEBUG_WIDTH-1 : k*DEBUG_WIDTH];
//     end
// endgenerate
endmodule