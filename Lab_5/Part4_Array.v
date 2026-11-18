module Part4_Array(
    input  [9:0] SW,
    input  [1:0] KEY,
    output [9:0] LEDR,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5
);

   reg [7:0] operand_A, operand_B;
    wire [7:0] selected_operand;
    wire [15:0] product;

    always @(posedge KEY[0]) begin
        if (SW[8])
            operand_B <= SW[7:0];
        else
            operand_A <= SW[7:0];
    end

    RegisteredArray8x8 multiplier(
        .A(operand_A),
        .B(operand_B),
        .Clk(KEY[1]),
        .P(product)
    );

    assign selected_operand = SW[8] ? operand_B : operand_A;
    assign LEDR = {1'd0, SW[8:0]};

    Seg7_Display display_operand_high(
        .bin_number(selected_operand[7:4]),
        .seg_display(HEX5)
    );

    Seg7_Display display_operand_low(
        .bin_number(selected_operand[3:0]),
        .seg_display(HEX4)
    );

    Seg7_Display display_product_3(
        .bin_number(product[15:12]),
        .seg_display(HEX3)
    );

    Seg7_Display display_product_2(
        .bin_number(product[11:8]),
        .seg_display(HEX2)
    );

    Seg7_Display display_product_1(
        .bin_number(product[7:4]),
        .seg_display(HEX1)
    );

    Seg7_Display display_product_0(
        .bin_number(product[3:0]),
        .seg_display(HEX0)
    );

endmodule