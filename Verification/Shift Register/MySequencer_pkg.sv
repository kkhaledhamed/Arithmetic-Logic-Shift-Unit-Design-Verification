package MySequencer_pkg;
import shigt_reg_sequence_item_pkg::*;

import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class MySequencer extends uvm_sequencer #(shigt_reg_sequence_item);
	`uvm_component_utils(MySequencer)

	function new(string name = "MySequencer", uvm_component parent = null);
		super.new(name,parent);
	endfunction

endclass : MySequencer
endpackage : MySequencer_pkg