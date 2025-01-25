package ALSU_config_obj_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	class ALSU_config_obj extends uvm_object;
		`uvm_object_utils(ALSU_config_obj)

		virtual ALSU_interface ALSU_config_vif;

		uvm_active_passive_enum is_active;

		function new(string name ="ALSU_config_obj");
			super.new(name);
		endfunction : new

	endclass : ALSU_config_obj
endpackage : ALSU_config_obj_pkg