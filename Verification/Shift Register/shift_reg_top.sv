import package_shift_reg_test_pkg::*;
import package_shift_reg_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top();
	bit clk;
	initial begin
		clk=1;
		forever 
			#1 clk=~clk;
	end

	shift_reg_if shift_regif (clk);
	shift_reg DUT (
		clk,
		shift_regif.reset,
		shift_regif.serial_in,
		shift_regif.direction,
		shift_regif.mode,
		shift_regif.datain,
		shift_regif.dataout);

	initial begin
		uvm_config_db #(virtual shift_reg_if)::set(null, "uvm_test_top", "shift_reg_Vif", shift_regif);
		run_test("shift_reg_test");
	end

endmodule	