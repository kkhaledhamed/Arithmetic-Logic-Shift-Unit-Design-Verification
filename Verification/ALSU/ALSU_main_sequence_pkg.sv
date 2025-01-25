package ALSU_main_sequence_pkg;
	import ALSU_shared_pkg::*;
	import uvm_pkg::*;
	import ALSU_sequence_item_pkg::*;
	`include "uvm_macros.svh"

	class ALSU_main_sequence extends uvm_sequence #(ALSU_sequence_item);
		`uvm_object_utils(ALSU_main_sequence)

		ALSU_sequence_item seq_item;

		function new(string name = "ALSU_main_sequence");
			super.new(name);
		endfunction

		task body;
			repeat(10_000) begin
				seq_item=ALSU_sequence_item::type_id::create("seq_item");
				start_item(seq_item);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body

	endclass : ALSU_main_sequence

endpackage : ALSU_main_sequence_pkg