////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Shift register Design 
// 
////////////////////////////////////////////////////////////////////////////////
module shift_reg (shift_reg_if.SHIFT_REG_DUT_MP shift_regif);

always @(*) begin
   if (shift_regif.mode) // rotate
      if (shift_regif.direction) // left
         shift_regif.dataout <= {shift_regif.datain[4:0], shift_regif.datain[5]};
      else// Right
         shift_regif.dataout <= {shift_regif.datain[0], shift_regif.datain[5:1]};
   else  // shift
      if (shift_regif.direction) // left
         shift_regif.dataout <= {shift_regif.datain[4:0], shift_regif.serial_in};
      else // Right
         shift_regif.dataout <= {shift_regif.serial_in, shift_regif.datain[5:1]};
end
endmodule