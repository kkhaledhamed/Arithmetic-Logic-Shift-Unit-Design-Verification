package shift_reg_scoreboard_pkg;
	import uvm_pkg::*;
	import shared_pkg::*;
	
	import shigt_reg_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class shift_reg_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(shift_reg_scoreboard)
		uvm_analysis_export #(shigt_reg_sequence_item) sb_export;
		uvm_tlm_analysis_fifo #(shigt_reg_sequence_item) sb_fifo;
		shigt_reg_sequence_item seq_item_sb;
		logic [5:0] dataout_ref;

		integer correct_counter=0;
		integer error_counter=0;		

		function new(string name = "shift_reg_scoreboard", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export =new("sb_export",this);
			sb_fifo =new("sb_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(seq_item_sb);
				ref_model(seq_item_sb);
				if (seq_item_sb.dataout != dataout_ref) begin
					`uvm_error("run_phase", $sformatf("There is an error!!, Transacton received by the DUT is: %s whilethe refernce output is: 0b%0b",
					 seq_item_sb.convert2string(), dataout_ref));
					error_counter++;
				end 
				else begin
					`uvm_info("run_phase", $sformatf("Correct Transacton received, Output is: %s",
								 seq_item_sb.convert2string()),UVM_HIGH)
					correct_counter++;
				end
			end
		endtask : run_phase

		task ref_model(shigt_reg_sequence_item seq_item_chk);
			if (seq_item_chk.reset) begin
				dataout_ref=0;
			end
			else begin
				if (seq_item_chk.mode) // rotate
        			if (seq_item_chk.direction) // left
            			dataout_ref = {seq_item_chk.datain[4:0], seq_item_chk.datain[5]};
         			else 
            			dataout_ref = {seq_item_chk.datain[0], seq_item_chk.datain[5:1]};
      			else // shift
         			if (seq_item_chk.direction) // left
            			dataout_ref = {seq_item_chk.datain[4:0], seq_item_chk.serial_in};
         			else
            			dataout_ref = {seq_item_chk.serial_in, seq_item_chk.datain[5:1]};
			end
		endtask : ref_model

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("Total coorect counts is: 0d%0d",correct_counter),UVM_LOW)
			`uvm_info("report_phase", $sformatf("Total error counts is: 0d%0d",error_counter),UVM_LOW)
		endfunction : report_phase
	endclass : shift_reg_scoreboard
endpackage : shift_reg_scoreboard_pkg