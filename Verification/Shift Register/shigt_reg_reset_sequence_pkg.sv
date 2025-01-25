package shigt_reg_reset_sequence_pkg;
	import shared_pkg::*;
	import uvm_pkg::*;
	import shigt_reg_sequence_item_pkg::*;
	
	`include "uvm_macros.svh"
	class shigt_reg_reset_sequence extends uvm_sequence #(shigt_reg_sequence_item) ;
		`uvm_object_utils(shigt_reg_reset_sequence)

		shigt_reg_sequence_item seq_item;

		function new(string name = "shigt_reg_reset_sequence");
			super.new(name);
		endfunction

		task body;
			seq_item = shigt_reg_sequence_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.reset=1;
			seq_item.serial_in=0;
			seq_item.datain=0;
			seq_item.direction= direction_e'(0) ;
			seq_item.mode=mode_e'(0);
			finish_item(seq_item);
		endtask : body
	endclass : shigt_reg_reset_sequence
	
	
endpackage : shigt_reg_reset_sequence_pkg