`timescale 1ns/1ps

module tb_main;
    reg  [17:0] SW;
    reg  [3:0]  KEY;
    wire [17:0] LEDR;
    integer errors;
    integer expected_A;
    integer expected_S;
    integer expected_carry;
    integer total;
    integer i;

    main dut (.SW(SW), .KEY(KEY), .LEDR(LEDR));

    task check_outputs;
        begin
            if (LEDR[7:0] !== expected_S[7:0] ||
                LEDR[8] !== expected_carry[0] ||
                LEDR[17:9] !== 9'b0) begin
                errors = errors + 1;
                $display("FAIL t=%0t: got LEDR=%h, expected S=%h carry=%b",
                         $time, LEDR, expected_S[7:0], expected_carry[0]);
            end
        end
    endtask

    task clock_step;
        input [7:0] switches;
        begin
            SW[7:0] = switches;
            #5;
            check_outputs; // Changing switches must not change the output.
            KEY[1] = 1'b0; // Button press: no rising edge.
            #5;
            check_outputs;
            total = expected_A + expected_S;
            expected_S = total % 256;
            expected_carry = total / 256;
            expected_A = switches;
            KEY[1] = 1'b1; // Release: rising clock edge.
            #10;
            check_outputs;
        end
    endtask

    initial begin
        SW = 18'b0;
        KEY = 4'b1111;
        errors = 0;
        expected_A = 0;
        expected_S = 0;
        expected_carry = 0;
        $dumpfile("part1.vcd");
        $dumpvars(0, tb_main);

        // Assert reset without producing a clock edge.
        #2 KEY[0] = 1'b0;
        #2 check_outputs;
        #2 KEY[0] = 1'b1;

        // Outputs after these edges: 0, 200, 44(carry=1), 104, 104.
        clock_step(8'd200);
        clock_step(8'd100);
        clock_step(8'd60);
        clock_step(8'd0);
        clock_step(8'd0);

        // Reset a nonzero accumulator while the clock remains high.
        #3 KEY[0] = 1'b0;
        expected_A = 0;
        expected_S = 0;
        expected_carry = 0;
        #2 check_outputs;
        clock_step(8'd255); // Reset held low across a clock edge.
        expected_A = 0;
        #3 KEY[0] = 1'b1;

        // Carry boundaries and an addition with signed but no unsigned overflow.
        clock_step(8'd255);
        clock_step(8'd1);
        clock_step(8'd127);
        clock_step(8'd1);
        clock_step(8'd0);

        // Deterministic varying inputs; reference model uses the previous A.
        for (i = 0; i < 1024; i = i + 1)
            clock_step((i * 73 + 19) % 256);

        if (errors == 0)
            $display("PASS: reset, input pipeline, accumulation, carry, and output holding.");
        else
            $display("FAIL: %0d output mismatches.", errors);
        $finish;
    end
endmodule
