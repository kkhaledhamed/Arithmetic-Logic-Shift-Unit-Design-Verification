package shift_reg_driver_pkg;
	import shift_reg_config_pkg::*;
	import shigt_reg_sequence_item_pkg::*;
	import shigt_reg_main_sequence_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class shift_reg_driver extends uvm_driver #(shigt_reg_sequence_item);
		`uvm_component_utils(shift_reg_driver);
		virtual shift_reg_if shift_reg_Vif;
		shigt_reg_sequence_item stim_seq_item;

		function new(string name = "shift_reg_driver", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase (phase);
			forever begin
				stim_seq_item=shigt_reg_sequence_item::type_id::create("stim_seq_item");
				seq_item_port.get_next_item(stim_seq_item);
				shift_reg_Vif.direction=stim_seq_item.direction;
				shift_reg_Vif.serial_in=stim_seq_item.serial_in;
				shift_reg_Vif.datain=stim_seq_item.datain;
				shift_reg_Vif.mode=stim_seq_item.mode;
				#2;
				seq_item_port.item_done();
				`uvm_info("run_phase",stim_seq_item.convert2string_stimulus(), UVM_HIGH)
			end
		endtask 
	endclass	
endpackage 
