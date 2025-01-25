package shift_reg_monitor_pkg;
	import shift_reg_config_pkg::*;
	import shigt_reg_sequence_item_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class shift_reg_monitor extends uvm_monitor ;
		`uvm_component_utils(shift_reg_monitor);
		virtual shift_reg_if shift_reg_Vif;
		shigt_reg_sequence_item rsp_seq_item;
		uvm_analysis_port #(shigt_reg_sequence_item) mon_ap;

		function new(string name = "shift_reg_monitor", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase (uvm_phase phase);
			super.build_phase(phase);
			mon_ap = new("mon_ap",this);		
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase (phase);
			forever begin
				rsp_seq_item = shigt_reg_sequence_item::type_id::create("rsp_seq_item");
				#2;
				rsp_seq_item.direction=shift_reg_Vif.direction;
				rsp_seq_item.serial_in=shift_reg_Vif.serial_in;
				rsp_seq_item.datain=shift_reg_Vif.datain;
				rsp_seq_item.mode=shift_reg_Vif.mode;
				mon_ap.write(rsp_seq_item);
				`uvm_info("run_phase",rsp_seq_item.convert2string_stimulus(), UVM_HIGH)
			end
		endtask 

	endclass	
endpackage 
