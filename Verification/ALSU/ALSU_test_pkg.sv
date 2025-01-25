package ALSU_test_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	import ALSU_env_pkg::*;
	import package_shift_reg_env_pkg::*;	
	import ALSU_config_obj_pkg::*;
	import shift_reg_config_pkg::*;
	import ALSU_agent_pkg::*;
	import ALSU_main_sequence_pkg::*;
	import ALSU_reset_sequence_pkg::*;
	import ALSU_valid_sequence_pkg::*;
	import shigt_reg_main_sequence_pkg::*;
	import shift_reg_agent_pkg::*;
	import ALSU_sequence_item_pkg::*;

	class ALSU_test extends uvm_test ;
		`uvm_component_utils(ALSU_test)

		ALSU_config_obj ALSU_config_obj_test;
		shift_reg_config shift_reg_cfg;
		ALSU_env env;
		shift_reg_env env2;
		virtual ALSU_interface ALSU_test_vif;
		ALSU_reset_sequence reset_seq;
		ALSU_main_sequence main_seq;
		ALSU_valid_sequence valid_seq;

		function new(string name ="ALSU_test", uvm_component parent = null);
			super.new(name,parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env = ALSU_env::type_id::create("env",this);
			env2 = shift_reg_env::type_id::create("env2",this); 
			ALSU_config_obj_test = ALSU_config_obj::type_id::create("ALSU_config_obj_test");
			shift_reg_cfg = shift_reg_config::type_id::create("shift_reg_cfg"); 
			reset_seq = ALSU_reset_sequence::type_id::create("reset_seq");
			main_seq = ALSU_main_sequence::type_id::create("main_seq");
			valid_seq = ALSU_valid_sequence::type_id::create("valid_seq");

			if (!uvm_config_db#(virtual ALSU_interface)::get(this, "", "ALSU_IF", ALSU_config_obj_test.ALSU_config_vif)) begin
			 	`uvm_fatal("build_phase","Test - unable to get the virtual interface");
			 end 

			 if (!uvm_config_db#(virtual shift_reg_if)::get(this,"","shift_reg_Vif",shift_reg_cfg.shift_reg_Vif)) begin
			 	`uvm_fatal("build_phase","Test - unable to get the virtual interface");
			 end
			 
			ALSU_config_obj_test.is_active=UVM_ACTIVE;
			shift_reg_cfg.is_active=UVM_PASSIVE;

			uvm_config_db #(shift_reg_config)::set(this,"*","CFG",shift_reg_cfg); 
			uvm_config_db#(ALSU_config_obj)::set(this, "*", "CFG", ALSU_config_obj_test);		

			//set_type_override_by_type(ALSU_sequence_item::get_type(), ALSU_sequence_item_valid_invalid::get_type());

		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			`uvm_info("run_phase","Reset asserted", UVM_LOW)
			reset_seq.start(env.agt.sqr);
			
			`uvm_info("run_phase","Stimulus generation started", UVM_LOW)
			main_seq.start(env.agt.sqr);

			`uvm_info("run_phase","Valid opcodes sequence started", UVM_LOW)
			valid_seq.start(env.agt.sqr);

			phase.drop_objection(this);
		endtask 

	endclass : ALSU_test
endpackage : ALSU_test_pkg
