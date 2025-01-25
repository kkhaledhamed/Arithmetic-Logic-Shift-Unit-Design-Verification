import ALSU_shared_pkg::*;

interface ALSU_interface (input bit clk);

// Signals
bit rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
opcode_e opcode;
bit signed [2:0] A, B;
logic [15:0] leds;
logic signed [5:0] out,out_shift_reg;
logic [15:0] leds_ref;
logic signed [5:0] out_ref;

// Modports
modport DUT (input clk ,rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode, A, B,
			 output leds, out, out_shift_reg);
modport GM (input clk ,rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode, A, B,
			 output leds_ref, out_ref, out_shift_reg);
endinterface : ALSU_interface