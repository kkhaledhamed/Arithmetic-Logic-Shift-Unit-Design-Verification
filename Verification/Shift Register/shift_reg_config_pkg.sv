package shift_reg_config_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class shift_reg_config extends uvm_object;
		`uvm_object_utils(shift_reg_config);

		virtual shift_reg_if shift_reg_Vif;

		uvm_active_passive_enum is_active;
		
		function new(string name = "shift_reg_config");
			super.new(name);
		endfunction	
	endclass 	
endpackage 
