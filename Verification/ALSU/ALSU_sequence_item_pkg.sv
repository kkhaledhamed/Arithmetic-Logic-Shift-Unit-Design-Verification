package ALSU_sequence_item_pkg;
	import uvm_pkg::*;
	import ALSU_shared_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_sequence_item extends uvm_sequence_item;
		`uvm_object_utils(ALSU_sequence_item)

		function new(string name = "ALSU_sequence_item");
			super.new(name);
		endfunction

		// Signals
		rand bit rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
		rand opcode_e opcode;
		rand bit signed [2:0] A, B;
		rand logic [15:0] leds;
		rand logic signed [5:0] out;
		logic [15:0] leds_ref;
		logic signed [5:0] out_ref;
		rand opcode_e opcode_array[5:0];
		bit [2:0] EXTREEMS [2:0] = '{MAXNEG,ZERO,MAXPOS};
		bit [2:0] INTERNALS [] = {3'b101, 3'b110, 3'b111, 3'b000, 3'b011} ;//!=EXTREEMS
		bit [2:0] WALKING_ONES [2:0] = '{3'b001,3'b010,3'b100};
		bit [2:0] SLEEPING_ONES [] = {3'b000,3'b011,3'b101,3'b110,3'b111};//!= WALKING_ONES

		// Constraint blocks
		constraint rst_constraint {
			rst dist {0:/95,1:/5};//Reset to be asserted with a low probability , 95% off & 5% on
		}
		constraint opcode_e_constraint {
			opcode dist {[OR:ROTATE]:/90,[INVALID_6:INVALID_7]:/10};//Invalid cases should occur less frequent(10%) than the valid cases(90%)
		}
		constraint A_B_constraints {
			if (opcode == ADD || opcode == MULT )  
			{	//A & B to take the values (MAXPOS, ZERO and MAXNEG) more often than the other values				 
				A dist { EXTREEMS:/75 ,INTERNALS:/25};
				B dist { EXTREEMS:/75 ,INTERNALS:/25};
			}
			else if ((opcode == OR || opcode == XOR))
			{
				if (red_op_A){//(red_op_A_package==1)
						//A most of the time to have one bit high in its 3 bits while constraining the B to be low
						A dist  { WALKING_ONES:/80 ,SLEEPING_ONES:/20 }; 
						B == 0;
					}
				else if(red_op_B && !red_op_A ){//(red_op_B_package==1 && red_op_A_package==0)
						//B most of the time to have one bit high in its 3 bits while constraining the A to be low
						B dist { WALKING_ONES:/80 ,SLEEPING_ONES:/20 }; 
						A == 0;
					}
			} 
			else {
				//Do not constraint the inputs A or B when the operation is shift or rotate 
				A inside {[MAXNEG:MAXPOS]};
				B inside {[MAXNEG:MAXPOS]};
				}
		}
		constraint bypass_constraint {
			//bypass_A and bypass_B should be disabled most of the time 
			bypass_A dist {0:/90,1:/10};//90% off & 10% on
			bypass_B dist {0:/90,1:/10};//90% off & 10% on
		}
		constraint unique_opcodes {
    		foreach (opcode_array[i]) {
       		// Ensure elements that are not manually overridden are unique
        		opcode_array[i] inside {[OR:ROTATE]};
        			foreach (opcode_array[j]) {
            			if (i != j) { // Exclude overridden elements
               				opcode_array[i] != opcode_array[j];
                		}
            		}
        		}
    		}

		// Convert to string functions
		function string convert2string();
  			return $sformatf(
   			"%s rst = %0b, cin = %0b, red_op_A = %0b, red_op_B = %0b, bypass_A = %0b, bypass_B = %0b, direction = %0b, serial_in = %0b, opcode = %s, A = %0d, B = %0d, leds = 0x%0h, out = %0d",
    		super.convert2string(), rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode.name(), A, B, leds, out);
			endfunction : convert2string


  		function string convert2string_stimulus();
  			return $sformatf(
    		"rst = %0b, cin = %0b, red_op_A = %0b, red_op_B = %0b, bypass_A = %0b, bypass_B = %0b, direction = %0b, serial_in = %0b, opcode = %s, A = %0d, B = %0d, leds = 0x%0h, out = %0d",
    		rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode.name(), A, B, leds, out);
			endfunction : convert2string_stimulus

	endclass : ALSU_sequence_item
/*
	class ALSU_sequence_item_valid_invalid extends ALSU_sequence_item;
        `uvm_object_utils(ALSU_sequence_item_valid_invalid)

        function new(string name = "ALSU_sequence_item_valid_invalid");
            super.new(name);
        endfunction

        constraint opcode_e_constraint {
            opcode dist {[OR:ROTATE]}; // Valid cases only
        }
    endclass : ALSU_sequence_item_valid_invalid*/

endpackage : ALSU_sequence_item_pkg