package shift_reg_coverage_pkg;
	import uvm_pkg::*;
	import shared_pkg::*;
	import shigt_reg_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class shift_reg_coverage extends uvm_component;
		`uvm_component_utils(shift_reg_coverage)
		uvm_analysis_export #(shigt_reg_sequence_item) cov_export;
		uvm_tlm_analysis_fifo #(shigt_reg_sequence_item) cov_fifo;
		shigt_reg_sequence_item seq_item_cov;
	
		// Covergroups
		covergroup cg;
			data_in_cp: coverpoint seq_item_cov.datain;
			direction_cp: coverpoint seq_item_cov.direction;
			mode_cp: coverpoint seq_item_cov.mode;
			serial_in_cp: coverpoint seq_item_cov.serial_in;
		endgroup : cg

		function new(string name = "shift_reg_scoreboard", uvm_component parent = null);
			super.new(name,parent);
			cg=new();
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export =new("cov_export",this);
			cov_fifo =new("cov_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item_cov);
				cg.sample();
			end
		endtask : run_phase


	endclass : shift_reg_coverage
endpackage : shift_reg_coverage_pkg