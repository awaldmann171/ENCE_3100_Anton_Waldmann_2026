module main(
    input       MAX10_CLK1_50,
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

    reg key0_prev;
    reg key1_prev;
	 reg [7:0] A;
    reg [7:0] B;
    reg [15:0] P_reg;


    wire [15:0] P;
	 wire [7:0] display_number;
	assign display_number = SW[8] ? B : A;

    Multiplier_8x8 mult(
        .A(A),
        .B(B),
        .P(P)
    );

    always @(posedge MAX10_CLK1_50) begin
        key0_prev <= KEY[0];
        key1_prev <= KEY[1];

        if (key0_prev && !KEY[0])
            A <= SW[7:0];

        if (key1_prev && !KEY[1])
            B <= SW[7:0];

        P_reg <= P;
    end
	
	Seg7_Display display0(
        .bin_number(P_reg[3:0]),
        .seg_display(HEX0)
    );

    Seg7_Display display1(
        .bin_number(P_reg[7:4]),
        .seg_display(HEX1)
    );

    Seg7_Display display2(
        .bin_number(P_reg[11:8]),
        .seg_display(HEX2)
    );

    Seg7_Display display3(
        .bin_number(P_reg[15:12]),
        .seg_display(HEX3)
    );

    Seg7_Display display4(
        .bin_number(display_number[3:0]),
        .seg_display(HEX4)
    );

    Seg7_Display display5(
        .bin_number(display_number[7:4]),
        .seg_display(HEX5)
    );


	assign LEDR = 10'b0;
	
	endmodule 















/*
module main(
	// Board I/Os
	input		MAX10_CLK1_50,
	input 	[9:0]		SW,
	input		[1:0]		KEY,
	output [9:0] LEDR,
   output [7:0] HEX0,
   output [7:0] HEX1,
   output [7:0] HEX2,
   output [7:0] HEX3,
   output [7:0] HEX4,
   output [7:0] HEX5
);

	wire w_clk = MAX10_CLK1_50;

	wire w_tick;
	wire w_dir = SW[7];
	wire w_en = SW[8];
	wire rst = SW[9];
	
	
	
	 reg [7:0] A;
    reg [7:0] B;
    reg [15:0] P_reg;

    reg key0_prev;
    reg key1_prev;

    wire [15:0] P;

    Multiplier_8x8 MULT(
        .A(A),
        .B(B),
        .P(P)
    );
 always @(posedge MAX10_CLK1_50) begin
        key0_prev <= KEY[0];
        key1_prev <= KEY[1];

        if (key0_prev && !KEY[0])
            A <= SW[7:0];

        if (key1_prev && !KEY[1])
            B <= SW[7:0];

        P_reg <= P;
    end

 


endmodule

module main (
    input [9:0] SW,
    input [1:0] KEY,

    output [9:0] LEDR
);

    reg [7:0] A;
    reg [7:0] S;
    reg Overflow;

    wire [7:0] sum;
    wire carry;

    assign {carry, sum} = {1'b0, A} + {1'b0, S};

    always @(posedge KEY[1] or negedge KEY[0]) begin
        if (!KEY[0]) begin
            A <= 8'd0;
            S <= 8'd0;
            Overflow <= 1'b0;
        end
        else begin
            A <= SW[7:0];
            S <= sum;
            Overflow <= carry;
        end
    end

    assign LEDR[7:0] = S;
    assign LEDR[8] = Overflow;
    assign LEDR[9] = 1'b0;

endmodule
*/ 	