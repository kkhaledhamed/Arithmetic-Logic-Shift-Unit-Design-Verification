package ALSU_coverage_pkg;
	import uvm_pkg::*;
	import ALSU_shared_pkg::*;
	import ALSU_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class ALSU_coverage extends uvm_component;
		`uvm_component_utils(ALSU_coverage)
		uvm_analysis_export #(ALSU_sequence_item) cov_export;
		uvm_tlm_analysis_fifo #(ALSU_sequence_item) cov_fifo;
		ALSU_sequence_item seq_item_cov;

		// Covergroups
		bit [2:0] WALKING_ONES [2:0] = '{3'b001,3'b010,3'b100};
		covergroup cg;
			option.per_instance = 1;  // Enable per-instance options
			A_cp: coverpoint seq_item_cov.A {
				bins A_data_0 = {0};
				bins A_data_max = {MAXPOS}; 
				bins A_data_min = {MAXNEG};
				bins A_data_default = default ;
			}
			A_cp_walking_ones: coverpoint seq_item_cov.A iff (seq_item_cov.red_op_A) {
				bins A_data_walkingones[] = WALKING_ONES;
			}
			B_cp: coverpoint seq_item_cov.B {
				bins B_data_0 = {0};
				bins B_data_max = {MAXPOS}; 
				bins B_data_min = {MAXNEG};
				bins B_data_default = default ;
			}
			B_cp_walking_ones: coverpoint seq_item_cov.B iff ((seq_item_cov.red_op_B) && !(seq_item_cov.red_op_A)) {
				bins B_data_walkingones[] = WALKING_ONES;
			}
			ALU_cp: coverpoint seq_item_cov.opcode {
				bins Bins_shift[] = {SHIFT,ROTATE};
				bins Bins_arith[] = {ADD , MULT};
				bins Bins_bitwise[] ={OR,XOR};
				illegal_bins Bins_invalid ={INVALID_6,INVALID_7};
				bins Bins_trans =(0=>1=>2=>3=>4=>5);
			}
			opcode_cp: coverpoint seq_item_cov.opcode {option.weight = 0;}
			cin_cp: coverpoint seq_item_cov.cin {option.weight = 0;}
			serialin_cp: coverpoint seq_item_cov.serial_in {option.weight = 0;}
			direction_cp: coverpoint seq_item_cov.direction {option.weight = 0;}
			red_op_A_cp: coverpoint seq_item_cov.red_op_A {option.weight = 0;}
			red_op_B_cp: coverpoint seq_item_cov.red_op_B {option.weight = 0;}
			cross ALU_cp, A_cp, B_cp {
			// When the ALU is addition or multiplication, A and B should have taken all permutations of maxpos, maxneg and zero.
			bins ADD_MULT_EXTREEMS = binsof(ALU_cp.Bins_arith) && (binsof(A_cp) && binsof(B_cp));//Default bin won't be considered by default
            option.cross_auto_bin_max=0;
			} 
			// When the ALU is addition, c_in should have taken 0 or 1
			cross opcode_cp, cin_cp {
				bins ADD_CIN0 = binsof(opcode_cp) intersect {ADD} && binsof(cin_cp) intersect {0};
				bins ADD_CIN1 = binsof(opcode_cp) intersect {ADD} && binsof(cin_cp) intersect {1};
				option.cross_auto_bin_max=0;
			}
			// When the ALSU is shifting, then shift_in must take 0 or 1
			cross opcode_cp, serialin_cp {
				bins SHIFT_SERIALIN0 = binsof(opcode_cp) intersect {SHIFT} && binsof(serialin_cp) intersect {0};
				bins SHIFT_SERIALIN1 = binsof(opcode_cp) intersect {SHIFT} && binsof(serialin_cp) intersect {1};
				option.cross_auto_bin_max=0;
			}
			// When the ALSU is shifting or rotating, then direction must take 0 or 1
			cross ALU_cp, direction_cp {
				bins SHIFT_ROTATE_DIRECTION0 = binsof(ALU_cp.Bins_shift) && binsof(direction_cp) intersect {0};
				bins SHIFT_ROTATE_DIRECTION1 = binsof(ALU_cp.Bins_shift) && binsof(direction_cp) intersect {1};
				option.cross_auto_bin_max=0;
			} 
			// When the ALSU is OR or XOR and red_op_A is asserted, then A took all walking one patterns (001, 010, and 100) while B is taking the value 0
			cross A_cp_walking_ones, B_cp iff((seq_item_cov.opcode==OR || seq_item_cov.opcode==XOR ) && seq_item_cov.red_op_A) {
				bins OR_XOR_REDA = binsof(A_cp_walking_ones.A_data_walkingones) && binsof(B_cp.B_data_0);
				option.cross_auto_bin_max=0;
			} 
			//When the ALSU is OR or XOR and red_op_B is asserted, then B took all walking one patterns (001, 010, and 100) while A is taking the value 0 
			cross B_cp_walking_ones, A_cp iff((seq_item_cov.opcode==OR || seq_item_cov.opcode==XOR ) && seq_item_cov.red_op_B) {
				bins OR_XOR_REDB = binsof(B_cp_walking_ones.B_data_walkingones) && binsof(A_cp.A_data_0);
				option.cross_auto_bin_max=0;
			} 
			//Covering the invalid case: reduction operation is activated while the opcode is not OR or XOR
			cross red_op_A_cp, red_op_B_cp, opcode_cp {
				bins INVALID_REDUCTION = (binsof(red_op_A_cp) intersect {1} || binsof(red_op_B_cp) intersect {1}) &&(binsof(opcode_cp) intersect{[ADD:INVALID_7]});
				option.cross_auto_bin_max=0;
			}
		endgroup 

		function new(string name = "ALSU_coverage", uvm_component parent = null);
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
	endclass : ALSU_coverage
endpackage : ALSU_coverage_pkg