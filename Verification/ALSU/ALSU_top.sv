import uvm_pkg::*;
import ALSU_test_pkg::*;
import shared_pkg::*;

`include "uvm_macros.svh"

module ALSU_top ();

 bit clk;

 initial begin
 	clk=0;
 	forever 
 		#1 clk=~clk;
 end

ALSU_interface ALSU_if (clk);

ALSU ALSU_DUT (ALSU_if);

ALSU_gm ALSU_ref (ALSU_if);

bind ALSU ALSU_SVA SVA (ALSU_if);

shift_reg_if shift_regif ();

shift_reg SHIFT_REG_DUT (shift_regif);

assign shift_regif.datain =ALSU_if.out;
assign ALSU_if.out_shift_reg = shift_regif.dataout ;
assign shift_regif.serial_in = ALSU_DUT.serial_in_reg;
assign shift_regif.direction = direction_e'(ALSU_DUT.direction_reg);
assign shift_regif.mode = mode_e'(ALSU_DUT.opcode_reg);

initial begin
	uvm_config_db#(virtual ALSU_interface)::set(null, "uvm_test_top", "ALSU_IF", ALSU_if);
	uvm_config_db#(virtual shift_reg_if)::set(null, "uvm_test_top", "shift_reg_Vif", shift_regif);
	run_test("ALSU_test");
end

endmodule : ALSU_top

