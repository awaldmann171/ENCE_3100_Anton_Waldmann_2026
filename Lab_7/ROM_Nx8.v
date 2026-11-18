`default_nettype none

module ROM_Nx8 #
(
    parameter N = 8
)
(
    input [$clog2(N)-1:0] address,
    output reg [7:0] data
);

    reg [6:0] select_instr;

    // Instruction format
    // data[7:4] = opcode
    // data[3:0] = operand

    // combinational
    always @(*) begin
        select_instr = 7'b0000000;

        case (address)
            3'd0: select_instr[0] = 1'b1; // 40: IN
            3'd1: select_instr[1] = 1'b1; // 12: ADD 2
            3'd2: select_instr[2] = 1'b1; // 30: OUT corrected reading
            3'd3: select_instr[3] = 1'b1; // 29: SUB 9
            3'd4: select_instr[4] = 1'b1; // 30: OUT difference
            3'd5: select_instr[5] = 1'b1; // 59: LDA 9
            3'd6: select_instr[6] = 1'b1; // 30: OUT target
            default: ;                  // Address 7 gives 00 NOP
        endcase
    end

    // combinational
    
    always @(*) begin
        // Opcode
        data[7] = 1'b0;
        data[6] = select_instr[0] | select_instr[5];
        data[5] = select_instr[2] | select_instr[3] |
                  select_instr[4] | select_instr[6];
        data[4] = select_instr[1] | select_instr[2] |
                  select_instr[4] | select_instr[5] | select_instr[6];

        // Operand
        data[3] = select_instr[3] | select_instr[5];
        data[2] = 1'b0;
        data[1] = select_instr[1];
        data[0] = select_instr[3] | select_instr[5];
    end

endmodule

`default_nettype wire
