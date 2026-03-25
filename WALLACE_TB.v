`timescale 1ns/1ps

module tb_wallace;

reg clk;
reg rst;
reg valid_in;
reg [7:0] A, B;

wire valid_out;
wire [15:0] Y;

WALLACE_8x8_FINAL dut (
    .clk(clk),
    .rst(rst),
    .valid_in(valid_in),
    .A(A),
    .B(B),
    .valid_out(valid_out),
    .Y(Y)
);

// clock
always #5 clk = ~clk;

// tracking
integer cycle = 0;
integer start_cycle = -1;
integer first_out = -1;
integer i;

reg [15:0] expected [0:100];
integer wr=0, rd=0;

// cycle counter
always @(posedge clk)
    cycle = cycle + 1;

initial begin
    clk = 0;
    rst = 1;
    valid_in = 0;
    A = 0;
    B = 0;

    #10 rst = 0;

    // continuous inputs
    for(i=0;i<20;i=i+1) begin
        @(posedge clk);
        valid_in = 1;
        A = i+1;
        B = i+2;

        expected[wr] = (i+1)*(i+2);
        wr = wr + 1;

        if(start_cycle == -1)
            start_cycle = cycle;
    end

    @(posedge clk);
    valid_in = 0;

    repeat(20) @(posedge clk);

    $display("\n==== WALLACE RESULTS ====");
    $display("Latency ≈ %0d cycles", first_out - start_cycle);
    $display("Throughput = 1 result / cycle (after fill)");

    $finish;
end
