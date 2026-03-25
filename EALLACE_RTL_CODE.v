module WALLACE_8x8_FINAL (
    input clk,
    input rst,
    input valid_in,
    input [7:0] A,
    input [7:0] B,
    output reg valid_out,
    output reg [15:0] Y
);

// ================= STAGE 1 =================
reg [7:0] L1_A, L1_B;
reg v1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        L1_A <= 0;
        L1_B <= 0;
        v1   <= 0;
    end else begin
        L1_A <= A;
        L1_B <= B;
        v1   <= valid_in;
    end
end


// ================= STAGE 2 =================
reg [15:0] pp [7:0];
reg v2;
integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        v2 <= 0;
        for(i=0;i<8;i=i+1)
            pp[i] <= 0;
    end else begin
        v2 <= v1;

        for(i=0;i<8;i=i+1)
            pp[i] <= (L1_A & {8{L1_B[i]}}) << i;
    end
end


// ================= STAGE 3 =================
// Level 1 CSA (8 → 6)
reg [15:0] s1_0, c1_0, s1_1, c1_1, s1_2, c1_2;
reg v3;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        v3 <= 0;
        s1_0 <= 0; c1_0 <= 0;
        s1_1 <= 0; c1_1 <= 0;
        s1_2 <= 0; c1_2 <= 0;
    end else begin
        v3 <= v2;

        s1_0 <= pp[0] ^ pp[1] ^ pp[2];
        c1_0 <= ((pp[0]&pp[1]) | (pp[1]&pp[2]) | (pp[0]&pp[2])) << 1;

        s1_1 <= pp[3] ^ pp[4] ^ pp[5];
        c1_1 <= ((pp[3]&pp[4]) | (pp[4]&pp[5]) | (pp[3]&pp[5])) << 1;

        s1_2 <= pp[6] ^ pp[7];
        c1_2 <= (pp[6] & pp[7]) << 1;
    end
end


// ================= STAGE 4 =================
// Level 2 CSA (6 → 4)
reg [15:0] s2_0, c2_0, s2_1, c2_1;
reg v4;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        v4 <= 0;
        s2_0 <= 0; c2_0 <= 0;
        s2_1 <= 0; c2_1 <= 0;
    end else begin
        v4 <= v3;

        s2_0 <= s1_0 ^ c1_0 ^ s1_1;
        c2_0 <= ((s1_0&c1_0) | (c1_0&s1_1) | (s1_0&s1_1)) << 1;

        s2_1 <= c1_1 ^ s1_2 ^ c1_2;
        c2_1 <= ((c1_1&s1_2) | (s1_2&c1_2) | (c1_1&c1_2)) << 1;
    end
end


// ================= STAGE 5 =================
// Level 3 CSA (4 → 2)
reg [15:0] sum_final, carry_final;
reg v5;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        v5 <= 0;
        sum_final <= 0;
        carry_final <= 0;
    end else begin
        v5 <= v4;

        sum_final <= s2_0 ^ c2_0 ^ s2_1;

        // IMPORTANT: shift ONLY ONCE here
        carry_final <= ((s2_0&c2_0) | (c2_0&s2_1) | (s2_0&s2_1)) << 1;
    end
end


// ================= STAGE 6 =================
// Final addition (NO EXTRA SHIFT)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        Y <= 0;
        valid_out <= 0;
    end else begin
        Y <= sum_final + carry_final;  // ✅ FIXED
        valid_out <= v5;
    end
end

endmodule
