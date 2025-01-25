package ALSU_agent_pkg;
	import ALSU_shared_pkg::*;
	import ALSU_sequencer_pkg::*;
	import ALSU_sequence_item_pkg::*;
	import ALSU_config_obj_pkg::*;
	import ALSU_monitor_pkg::*;
	import ALSU_driver_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_agent extends uvm_agent;
		`uvm_component_utils(ALSU_agent)

		ALSU_sequencer sqr;
		ALSU_monitor mon;
		ALSU_driver drv;
		ALSU_config_obj ALSU_cfg;
		uvm_analysis_port #(ALSU_sequence_item) agt_ap;

		function new(string name = "ALSU_agent", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if (!uvm_config_db #(ALSU_config_obj)::get(this,"","CFG",ALSU_cfg)) begin
			 	`uvm_fatal("build_phase","Driver - unable to get configuration object");
			 end 
			if (ALSU_cfg.is_active == UVM_ACTIVE) begin
				drv = ALSU_driver::type_id::create("drv",this);
				sqr = ALSU_sequencer::type_id::create("sqr",this);
			end
			mon = ALSU_monitor::type_id::create("mon",this);
			agt_ap =new("agt_ap",this);	
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			if (ALSU_cfg.is_active == UVM_ACTIVE) begin
				drv.seq_item_port.connect(sqr.seq_item_export);
				drv.ALSU_vif=ALSU_cfg.ALSU_config_vif;
			end
			mon.ALSU_vif=ALSU_cfg.ALSU_config_vif;
			mon.mon_ap.connect(agt_ap);
		endfunction : connect_phase
	endclass : ALSU_agent
endpackage : ALSU_agent_pkg