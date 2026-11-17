module Reg8(
    input            Clk,
    input            Reset_n,
    input      [7:0] D,
    output reg [7:0] Q
);

    always @(posedge Clk or negedge Reset_n) begin
        if (!Reset_n)
            Q <= 8'd0;
        else
            Q <= D;
    end

endmodule