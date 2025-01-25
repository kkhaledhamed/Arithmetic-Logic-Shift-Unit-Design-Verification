package ALSU_reset_sequence_pkg;
	import ALSU_shared_pkg::*;
	import uvm_pkg::*;
	import ALSU_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_reset_sequence extends uvm_sequence #(ALSU_sequence_item);
		`uvm_object_utils(ALSU_reset_sequence)

		ALSU_sequence_item seq_item;

		function new(string name = "ALSU_reset_sequence");
			super.new(name);
		endfunction

		task body;
			seq_item=ALSU_sequence_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst=1;
			seq_item.serial_in=0;
			seq_item.direction=0;
			seq_item.A=0;
			seq_item.B=0;
			seq_item.cin=0;
			seq_item.opcode=opcode_e'(0);
			seq_item.bypass_A=0;
			seq_item.bypass_B=0;
			seq_item.red_op_A=0;
			seq_item.red_op_B=0;
			finish_item(seq_item);
		endtask : body
	endclass : ALSU_reset_sequence
endpackage : ALSU_reset_sequence_pkg