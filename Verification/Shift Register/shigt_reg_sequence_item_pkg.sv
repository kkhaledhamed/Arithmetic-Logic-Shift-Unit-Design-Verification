package shigt_reg_sequence_item_pkg;
	import shared_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class shigt_reg_sequence_item extends uvm_sequence_item ;
		`uvm_object_utils(shigt_reg_sequence_item)

		rand bit reset;
  		rand bit serial_in;
  		rand mode_e mode;
  		rand direction_e direction;
  		rand logic [5:0] datain;
  		logic [5:0] dataout;

		function new(string name = "shigt_reg_sequence_item");
			super.new(name);
		endfunction

  		constraint reset_constraint {
  			reset dist {0:/98, 1:/2};
  		}
  		constraint datain_constraint {
  			datain dist {[63:0]:=1};
  		}

  		function string convert2string();
  			return $sformatf("%s reset = 0b%0b, serial_in = 0b%0b, mode = %s, direction = %s, data_in = 0b%0b",
  			 super.convert2string(), reset, serial_in, mode, direction, datain);
  		endfunction : convert2string

  		function string convert2string_stimulus();
  			return $sformatf("reset = 0b%0b, serial_in = 0b%0b, mode = %s, direction = %s, data_in = 0b%0b"
  								, reset, serial_in, mode, direction, datain);
  		endfunction : convert2string_stimulus
	endclass : shigt_reg_sequence_item
	
	
endpackage : shigt_reg_sequence_item_pkg