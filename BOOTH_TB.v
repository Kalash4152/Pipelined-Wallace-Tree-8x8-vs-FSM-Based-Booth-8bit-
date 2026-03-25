`timescale 1ns/1ps

module tb_booth_perf;

reg CLK, rst, ENABLE;
reg [7:0] Qin, M;
wire [15:0] PRODUCT;
wire DONE;

booth dut (
    .CLK(CLK),
    .rst(rst),
    .ENABLE(ENABLE),
    .Qin(Qin),
    .M(M),
    .PRODUCT(PRODUCT),
    .DONE(DONE)
);

always #5 CLK = ~CLK;

integer cycle;
integer start_cycle, end_cycle, latency;
integer total_cycles;
integer num_ops = 5;
integer i;

always @(posedge CLK)
    cycle = cycle + 1;

initial begin
    CLK = 0;
    rst = 1;
    ENABLE = 0;
    Qin = 0;
    M = 0;
    cycle = 0;
    total_cycles = 0;

    #10 rst = 0;

    for (i = 0; i < num_ops; i = i + 1) begin

        @(posedge CLK);
        Qin = i + 2;
        M   = i + 3;
        ENABLE = 1;
        start_cycle = cycle;

        @(posedge CLK);
        ENABLE = 0;

        wait(DONE);
        end_cycle = cycle;

        latency = end_cycle - start_cycle;

        $display("Input: %0d * %0d", Qin, M);
        $display("Output = %0d | Expected = %0d", PRODUCT, Qin * M);
        $display("Latency = %0d cycles\n", latency);

        total_cycles = total_cycles + latency;
    end

    $display("---- FINAL METRICS ----");
    $display("Total cycles = %0d", total_cycles);
    $display("Operations = %0d", num_ops);
    $display("Throughput = 1 result per %0f cycles", total_cycles * 1.0 / num_ops);

    #20 $finish;
end

endmodule
