`timescale 1 ps / 1 ps
// synopsys translate_on
module Counter_LPM (
	clock,
	cnt_en,
	sclr,
	q);

	input	  clock;
	input	  cnt_en;
	input	  sclr;
	output	[15:0]  q;

	wire [15:0] sub_wire0;
	wire [15:0] q = sub_wire0[15:0];

	lpm_counter	LPM_COUNTER_component (
				.clock (clock),
				.cnt_en (cnt_en),
				.sclr (sclr),
				.q (sub_wire0),
				.aclr (1'b0),
				.aload (1'b0),
				.aset (1'b0),
				.cin (1'b1),
				.clk_en (1'b1),
				.cout (),
				.data ({16{1'b0}}),
				.eq (),
				.sload (1'b0),
				.sset (1'b0),
				.updown (1'b1));
	defparam
		LPM_COUNTER_component.lpm_direction = "UP",
		LPM_COUNTER_component.lpm_port_updown = "PORT_UNUSED",
		LPM_COUNTER_component.lpm_type = "LPM_COUNTER",
		LPM_COUNTER_component.lpm_width = 16;


endmodule

