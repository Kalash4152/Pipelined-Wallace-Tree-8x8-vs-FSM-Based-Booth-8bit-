module booth (
    input  wire        CLK,
    input  wire        rst,
    input  wire        ENABLE,
    input  wire [7:0]  Qin,
    input  wire [7:0]  M,
    output reg  [15:0] PRODUCT,
    output reg         DONE
);

reg signed [7:0] A;
reg signed [7:0] Q;
reg signed [7:0] A_next;
reg              Q1;
reg [3:0]        count;

always @(posedge CLK) begin
    if (rst) begin
        A <= 0; Q <= 0; Q1 <= 0;
        count <= 0;
        PRODUCT <= 0;
        DONE <= 0;
    end

    // LOAD
    else if (ENABLE && count == 0) begin
        A <= 0;
        Q <= Qin;
        Q1 <= 0;
        count <= 8;
        DONE <= 0;
    end

    // RUN
    else if (count > 0) begin

        // Default
        A_next = A;

        case ({Q[0], Q1})
            2'b01: A_next = A + M;
            2'b10: A_next = A - M;
        endcase

        // Shift
        Q1 <= Q[0];
        Q  <= {A_next[0], Q[7:1]};
        A  <= {A_next[7], A_next[7:1]};

        count <= count - 1;

        if (count == 1) begin
            PRODUCT <= {A_next, {A_next[0], Q[7:1]}};
            DONE <= 1;
        end else begin
            DONE <= 0;
        end
    end

    else begin
        DONE <= 0;
    end
end

endmodule
