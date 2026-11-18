module Part2 (
    input  [9:0] SW,
    input  [1:0] KEY,
    output [9:0] LEDR
);

    reg  [7:0] A;
    reg  [7:0] S;
    reg  Overflow;

    wire [7:0] sum;
    wire     carry;
    wire     add_sub;

    assign add_sub = SW[8];

    assign {carry, sum} = add_sub ? ({1'd0, S} - {1'd0, A})
                        : ({1'd0, S} + {1'd0, A});

    always @(posedge KEY[1] or negedge KEY[0]) begin
        if (!KEY[0]) begin
            A        <= 8'd0;
            S        <= 8'd0;
            Overflow <= 1'd0;
        end
        else begin
            A        <= SW[7:0];
            S        <= sum;
            Overflow <= carry;
        end
    end

    assign LEDR[7:0] = S;
    assign LEDR[8]   = Overflow;
    assign LEDR[9]   = 1'd0;

endmodule