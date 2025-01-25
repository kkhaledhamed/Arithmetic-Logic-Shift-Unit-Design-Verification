package ALSU_valid_sequence_pkg;
	import ALSU_shared_pkg::*;
	import uvm_pkg::*;
	import ALSU_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_valid_sequence extends uvm_sequence #(ALSU_sequence_item);
		`uvm_object_utils(ALSU_valid_sequence)

		int i =-1;

		ALSU_sequence_item seq_item;

		function new(string name = "ALSU_valid_sequence");
			super.new(name);
		endfunction

		task body;
			repeat (10) begin
			i++;
			seq_item=ALSU_sequence_item::type_id::create("seq_item");
			start_item(seq_item);
			assert(seq_item.randomize() with {opcode == i;});
			finish_item(seq_item);
			end
		endtask : body
	endclass : ALSU_valid_sequence
endpackage : ALSU_valid_sequence_pkg