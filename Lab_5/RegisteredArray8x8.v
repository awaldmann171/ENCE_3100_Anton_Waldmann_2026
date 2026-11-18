module RegisteredArray8x8(
    input  [7:0] A,
    input  [7:0] B,
    input        Clk,
    output reg [15:0] P
);

    reg [7:0] A_reg, B_reg;

    wire [7:0] row0, row1, row2, row3;
    wire [7:0] row4, row5, row6, row7;
    wire [8:0] sum1, sum2, sum3, sum4;
    wire [8:0] sum5, sum6, sum7;

    assign row0 = A_reg & {8{B_reg[0]}};
    assign row1 = A_reg & {8{B_reg[1]}};
    assign row2 = A_reg & {8{B_reg[2]}};
    assign row3 = A_reg & {8{B_reg[3]}};
    assign row4 = A_reg & {8{B_reg[4]}};
    assign row5 = A_reg & {8{B_reg[5]}};
    assign row6 = A_reg & {8{B_reg[6]}};
    assign row7 = A_reg & {8{B_reg[7]}};

    ripple_adder_8bit add1(
    .A({1'd0, row0[7:1]}), .B(row1), .cin(1'd0),
    .S(sum1[7:0]), .cout(sum1[8])
    );
    ripple_adder_8bit add2(
        .A(sum1[8:1]), .B(row2), .cin(1'd0),
        .S(sum2[7:0]), .cout(sum2[8])
    );
    ripple_adder_8bit add3(
        .A(sum2[8:1]), .B(row3), .cin(1'd0),
        .S(sum3[7:0]), .cout(sum3[8])
    );
    ripple_adder_8bit add4(
        .A(sum3[8:1]), .B(row4), .cin(1'd0),
        .S(sum4[7:0]), .cout(sum4[8])
    );
    ripple_adder_8bit add5(
        .A(sum4[8:1]), .B(row5), .cin(1'd0),
        .S(sum5[7:0]), .cout(sum5[8])
    );
    ripple_adder_8bit add6(
        .A(sum5[8:1]), .B(row6), .cin(1'd0),
        .S(sum6[7:0]), .cout(sum6[8])
    );
    ripple_adder_8bit add7(
        .A(sum6[8:1]), .B(row7), .cin(1'd0),
        .S(sum7[7:0]), .cout(sum7[8])
    );

    always @(posedge Clk) begin
        A_reg <= A;
        B_reg <= B;
        P <= {sum7, sum6[0], sum5[0], sum4[0],
                    sum3[0], sum2[0], sum1[0], row0[0]};
    end

endmodule