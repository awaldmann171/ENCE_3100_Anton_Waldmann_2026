module Seg7_Display(
    input  [3:0] bin_number,
    output [7:0] seg_display
);

    wire a, b, c, d;
    wire [6:0] decimal_segments;

    assign a = bin_number[0];
    assign b = bin_number[1];
    assign c = bin_number[2];
    assign d = bin_number[3];

    assign decimal_segments[6] = (~d & ~c & ~b) | (c & b & a);
    assign decimal_segments[5] = (~d & ~c & a) | (~c & b) | (b & a);
    assign decimal_segments[4] = a | (c & ~b);
    assign decimal_segments[3] = (~d & ~c & ~b & a) | (c & ~b & ~a) | (c & b & a);
    assign decimal_segments[2] = ~c & b & ~a;
    assign decimal_segments[1] = (c & ~b & a) | (c & b & ~a);
    assign decimal_segments[0] = (~d & ~c & ~b & a) | (c & ~b & ~a);

    assign seg_display[7] = 1'b1;

    assign seg_display[6:0] = (bin_number == 4'hA) ? 7'h08 :
                              (bin_number == 4'hB) ? 7'h03 :
                              (bin_number == 4'hC) ? 7'h46 :
                              (bin_number == 4'hD) ? 7'h21 :
                              (bin_number == 4'hE) ? 7'h06 :
                              (bin_number == 4'hF) ? 7'h0E :
                              decimal_segments;

endmodule