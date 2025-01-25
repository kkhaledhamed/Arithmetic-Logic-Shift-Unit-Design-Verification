
module ALSU(ALSU_interface.DUT ALSU_if);

// Parameters & Internal signals
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg signed [1:0] cin_reg;//Make cin_reg signed 2bits to perform correct signed addition
reg [2:0] opcode_reg;
reg signed [2:0] A_reg, B_reg;//A & B registers are signed as well as A & B
wire invalid_red_op, invalid_opcode, invalid;

//Invalid handling
assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;
//Registering input signals
always @(posedge ALSU_if.clk or posedge ALSU_if.rst) begin
  if(ALSU_if.rst) begin
     cin_reg <= 0;
     red_op_B_reg <= 0;
     red_op_A_reg <= 0;
     bypass_B_reg <= 0;
     bypass_A_reg <= 0;
     direction_reg <= 0;
     serial_in_reg <= 0;
     opcode_reg <= 0;
     A_reg <= 0;
     B_reg <= 0;
  end else begin
     cin_reg <= ALSU_if.cin;
     red_op_B_reg <= ALSU_if.red_op_B;
     red_op_A_reg <= ALSU_if.red_op_A;
     bypass_B_reg <= ALSU_if.bypass_B;
     bypass_A_reg <= ALSU_if.bypass_A;
     direction_reg <= ALSU_if.direction;
     serial_in_reg <= ALSU_if.serial_in;
     opcode_reg <= ALSU_if.opcode;
     A_reg <= ALSU_if.A;
     B_reg <= ALSU_if.B;
  end
end
//leds output blinking 
always @(posedge ALSU_if.clk or posedge ALSU_if.rst) begin
  if(ALSU_if.rst) begin
     ALSU_if.leds <= 0;
  end else begin
      if (invalid)
        ALSU_if.leds <= ~ALSU_if.leds;
      else
        ALSU_if.leds <= 0;
  end
end
//ALSU output processing
always @(posedge ALSU_if.clk or posedge ALSU_if.rst) begin
  if(ALSU_if.rst) begin
    ALSU_if.out <= 0;
  end
  else begin
    if (invalid) 
        ALSU_if.out <= 0;
    else if (bypass_A_reg && bypass_B_reg)
      ALSU_if.out <= (INPUT_PRIORITY == "A")? A_reg: B_reg;
    else if (bypass_A_reg)
      ALSU_if.out <= A_reg;
    else if (bypass_B_reg)
      ALSU_if.out <= B_reg;
    else begin
        case (opcode_reg)//Bug: opcode --> opcode_reg
          3'h0: begin 
            //Third bug --> AND replaced with OR
            if (red_op_A_reg && red_op_B_reg)
              ALSU_if.out = (INPUT_PRIORITY == "A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              ALSU_if.out <= |A_reg;
            else if (red_op_B_reg)
              ALSU_if.out <= |B_reg;
            else 
              ALSU_if.out <= A_reg | B_reg;
          end
          3'h1: begin
            //Fourth bug --> OR replaced with XOR
            if (red_op_A_reg && red_op_B_reg)
              ALSU_if.out <= (INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
            else if (red_op_A_reg) 
              ALSU_if.out <= ^A_reg;
            else if (red_op_B_reg)
              ALSU_if.out <= ^B_reg;
            else 
              ALSU_if.out <= A_reg ^ B_reg;
          end
          //Fifth bug --> Added logic condition for FULL_ADDER operation 
          3'h2: if(FULL_ADDER=="ON") begin
            ALSU_if.out <= A_reg + B_reg + cin_reg;
          end
          else if (FULL_ADDER=="OFF") begin
             ALSU_if.out <= A_reg + B_reg ;
          end
          3'h3: ALSU_if.out <= A_reg * B_reg;
          3'h4: begin
            if (direction_reg)
              ALSU_if.out <= ALSU_if.out_shift_reg;
            else
              ALSU_if.out <= ALSU_if.out_shift_reg;
          end
          3'h5: begin
            if (direction_reg)
              ALSU_if.out <= ALSU_if.out_shift_reg;
            else
              ALSU_if.out <= ALSU_if.out_shift_reg;
          end
        endcase
    end 
  end
end
endmodule