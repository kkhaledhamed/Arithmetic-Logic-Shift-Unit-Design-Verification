import shared_pkg::*;

interface shift_reg_if ();

  logic serial_in;
  direction_e direction;
  mode_e mode;
  logic [5:0] datain, dataout;

  // Modport
  modport SHIFT_REG_DUT_MP (input serial_in, direction, mode,datain,output dataout);
endinterface : shift_reg_if