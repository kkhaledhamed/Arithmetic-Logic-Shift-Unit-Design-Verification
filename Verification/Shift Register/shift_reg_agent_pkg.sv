package shift_reg_agent_pkg;
	import shift_reg_driver_pkg::*;
	import MySequencer_pkg::*;
	import shift_reg_config_pkg::*;
	import shift_reg_monitor_pkg::*;
	import shigt_reg_sequence_item_pkg::*;
	
	import uvm_pkg::*;	
	`include "uvm_macros.svh"
	class shift_reg_agent extends uvm_agent ;
		`uvm_component_utils(shift_reg_agent)
		MySequencer sqr;
		shift_reg_driver drv;
		shift_reg_monitor mon;
		shift_reg_config shift_reg_cfg;
		uvm_analysis_port #(shigt_reg_sequence_item) agt_ap; 

		function new(string name = "shift_reg_agent", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if (!uvm_config_db #(shift_reg_config)::get(this,"","CFG",shift_reg_cfg)) begin
			 	`uvm_fatal("build_phase","Driver - unable to get configuration object");
			 end 
			if (shift_reg_cfg.is_active == UVM_ACTIVE) begin
				drv = shift_reg_driver::type_id::create("drv",this);
				sqr = MySequencer::type_id::create("sqr",this);
			end
			mon = shift_reg_monitor::type_id::create("mon",this);
			agt_ap =new("agt_ap",this);
				
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			if (shift_reg_cfg.is_active == UVM_ACTIVE) begin
				drv.seq_item_port.connect(sqr.seq_item_export);
				drv.shift_reg_Vif=shift_reg_cfg.shift_reg_Vif;
			end
			mon.shift_reg_Vif=shift_reg_cfg.shift_reg_Vif;
			mon.mon_ap.connect(agt_ap);
		endfunction : connect_phase
	endclass : shift_reg_agent
endpackage : shift_reg_agent_pkg