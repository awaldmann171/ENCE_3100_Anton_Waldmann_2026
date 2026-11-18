PART I: EIGHT-BIT REGISTERED ACCUMULATOR

Files
main.v: synthesizable circuit; set main as Quartus top-level entity.
main.sdc: internal timing analysis constraints, using a 20 ns reference clock.
tb_main.v: simulation-only testbench; do not add to synthesis sources.

Required hardware mapping (DE2-series assignment in the provided lab)
SW[7:0] -> input A, captured on each rising edge of KEY[1].
KEY[0] -> active-low asynchronous reset for A, S, and Overflow.
KEY[1] -> manual clock (rising edge; release on active-low pushbuttons).
LEDR[7:0] -> registered accumulated sum S.
LEDR[8] -> registered unsigned carry-out, called Overflow by the lab.
LEDR[17:9] -> zero.
No seven-segment decoder is required for Part I's specified LED outputs.

Behavior matching Figure 2
A_next = SW[7:0]
S_next = (A_old + S_old) modulo 256
Overflow_next = 1 when A_old + S_old >= 256, otherwise 0
The first rising edge after reset loads A while S remains zero.
Overflow is replaced on every edge; it is not a sticky flag.

Quartus setup and required implementation
1. Create a project, select the exact FPGA part printed on your board, and
   set the top-level entity to main. Do not assume all DE2-series boards use
   the same FPGA or pin assignments.
2. Add main.v and main.sdc. Keep tb_main.v out of synthesis sources.
3. Import the pin-assignment QSF for your exact board. Confirm SW[7:0],
   KEY[1:0], and LEDR[8:0] in Pin Planner. Assign all declared board ports
   using the matching board file. Physical pin numbers are not given in the
   lab and are not fabricated here. If the board is not a DE2-series board,
   adapt the port widths and use its own FPGA and pin assignment file.
4. Run full compilation. Check compilation errors and critical warnings.
5. Open the RTL Viewer. Expect 8 input flip-flops, 8 accumulator flip-flops,
   1 carry flip-flop, an 8-bit adder with carry, and feedback from S.
   Quartus may display grouped buses and arithmetic blocks differently.
6. Run functional simulation with tb_main.v as the simulation top level.
   Compile main.v and tb_main.v together, then run long enough to reach
   the PASS message (about 20.8 us). View SW, KEY, LEDR, and internal
   A, S, sum, carry, Overflow if desired.
7. Perform the lab's required post-fit timing simulation using the compiled
   timing netlist and generated SDF, in the simulator flow supported by
   your Quartus version. Use the testbench stimuli with checks sampled
   after the annotated propagation delay; increase testbench delays if
   necessary. Passing RTL simulation alone does not complete this step.
8. In TimeQuest, load the compiled timing netlist and main.sdc, update
   timing, and inspect the Fmax Summary for manual_clock. Record the
   actual result; 50 MHz in the SDC is a reference constraint, not an
   achieved fmax measurement. Report the slowest relevant timing corner.
9. Report the worst register-to-register setup path under manual_clock.
   Record its start register, end register, and data-path delay. Distinguish
   the reported data-path delay from the full minimum clock period, which
   also depends on setup time, clock skew, and uncertainty.
10. Use the Quartus Programmer with the board's programming cable and load
    the compiled .sof. Hold KEY0 down to reset, release it, set SW7-0,
    and press/release KEY1 for each clock cycle. Test several values and
    carry-out. Do not claim physical testing without using the board.

Timing scope
The SDC analyzes internal register-to-register logic. Switches and LEDs are
manual asynchronous interfaces and are excluded from synchronous I/O timing.
The reset timing cut excludes reset timing checks; this does not verify reset
recovery/removal or button behavior. Keep switches stable before a clock edge
and release reset away from a clock edge. Physical button behavior depends on
the board's button circuitry; this code models the clock shown in Figure 2.

Directed demonstration
Reset -> S=0, carry=0.
SW=200, edge 1 -> A=200, S=0, carry=0.
SW=100, edge 2 -> A=100, S=200, carry=0.
SW=60, edge 3 -> A=60, S=44, carry=1 (200+100=300).
SW=0, edge 4 -> A=0, S=104, carry=0 (44+60=104).
SW=0, edge 5 -> A=0, S=104, carry=0.

Verification performed
Icarus Verilog 12.0 compiled main.v and tb_main.v with Verilog-2005 and -Wall.
The simulation passed reset assertion without a clock, reset held during a
clock edge, input pipeline delay, unsigned carry boundaries, changing inputs,
and output holding on switch changes and falling clock edges. Tests include
1024 deterministic varying-input cycles plus directed cases.
Quartus fitting, post-fit timing simulation, fmax, longest-path delay, and
physical board programming/testing must be completed in your actual setup.
