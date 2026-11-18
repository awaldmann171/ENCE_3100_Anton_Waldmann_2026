
module main(
	// Pinout Assignment
	input MAX10_CLK1_50,
	input		[9:0]		SW,
	input		[1:0]		KEY,
	output 	[9:0]		LEDR,
	output	[7:0]		HEX0,
	output	[7:0]		HEX1,
	output	[7:0]		HEX2,
	output	[7:0]		HEX3,
	output	[7:0]		HEX4,
	output	[7:0]		HEX5
);




wire w_clk;
wire [3:0] w_position;

Counter_1Hz counter_1(
	.in_clk(MAX10_CLK1_50),
	.clear(SW[1]),
	.out_clk(w_clk)
);

assign LEDR[3:0] = w_position; 
assign LEDR[9:4] = 6'd0;


Hello_Scroll Scroll_1(
        .clk(MAX10_CLK1_50),
        .clear(KEY[0]),
        .ena(w_clk),
        .position(w_position)
    );
Hello_Display Display_1(
		  .position(w_position),
		  .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7)
    );
	 
	
endmodule
