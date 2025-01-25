package shigt_reg_main_sequence_pkg;
	import shared_pkg::*;
	import uvm_pkg::*;
	import shigt_reg_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class shigt_reg_main_sequence extends uvm_sequence #(shigt_reg_sequence_item) ;
		`uvm_object_utils(shigt_reg_main_sequence)

		shigt_reg_sequence_item seq_item;

		function new(string name = "shigt_reg_main_sequence");
			super.new(name);
		endfunction

		task body;
			repeat(10_000) begin
				seq_item=shigt_reg_sequence_item::type_id::create("seq_item");
				start_item(seq_item);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body
	endclass : shigt_reg_main_sequence
	
	
endpackage : shigt_reg_main_sequence_pkg