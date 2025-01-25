module ALSU_SVA (ALSU_interface.DUT ALSU_if);

	//Make cin signed 2 bits to perform correct signed addition
	logic signed [1:0] cin_signed;
	assign cin_signed = ALSU_if.cin;

	always_comb begin 
		if (ALSU_if.rst) begin
			reset_assertion: assert final (ALSU_if.out==0 && ALSU_if.leds==0);
			reset_cover: cover (ALSU_if.out==0 && ALSU_if.leds==0);
		end
	end

	property invalid_property;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		(((ALSU_if.red_op_A | ALSU_if.red_op_B) & (ALSU_if.opcode[1] | ALSU_if.opcode[2])) | (ALSU_if.opcode[1] & ALSU_if.opcode[2])) 
		|-> ##2 ((ALSU_if.out == 0) && (ALSU_if.leds==~$past(ALSU_if.leds)));
	endproperty

	property bypass_A_property;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.bypass_A) && !(((ALSU_if.red_op_A | ALSU_if.red_op_B) & (ALSU_if.opcode[1] | ALSU_if.opcode[2])) | (ALSU_if.opcode[1] & ALSU_if.opcode[2]))) 
		|-> ##2 (ALSU_if.out == $past(ALSU_if.A,2));
	endproperty

	property bypass_B_property;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((!ALSU_if.bypass_A && ALSU_if.bypass_B) && !(((ALSU_if.red_op_A | ALSU_if.red_op_B) & (ALSU_if.opcode[1] | ALSU_if.opcode[2])) | (ALSU_if.opcode[1] & ALSU_if.opcode[2]))) 
		|-> ##2 (ALSU_if.out == $past(ALSU_if.B,2));
	endproperty

	property red_OR_A;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==1'h0 && ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == |$past(ALSU_if.A,2));
	endproperty

	property red_OR_B;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==1'h0 && ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == |$past(ALSU_if.B,2));
	endproperty

	property red_OR_A_B;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==1'h0 && !ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == $past(ALSU_if.A,2) | $past(ALSU_if.B,2));
	endproperty

	property red_XOR_A;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==1'h1 && ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == ^$past(ALSU_if.A,2));
	endproperty

	property red_XOR_B;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==1'h1 && ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == ^$past(ALSU_if.B,2));
	endproperty

	property red_XOR_A_B;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==1'h1 && !ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == $past(ALSU_if.A,2) ^ $past(ALSU_if.B,2));
	endproperty

	property Add;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==3'h2 && !ALSU_if.red_op_B && !ALSU_if.red_op_A && !ALSU_if.bypass_A && !ALSU_if.bypass_B)) 
		|-> ##2 (ALSU_if.out == ($past(ALSU_if.A,2) + $past(ALSU_if.B,2) + $past(cin_signed,2)));
	endproperty

	property Mult;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==3'h3 && !ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == $past(ALSU_if.A,2) * $past(ALSU_if.B,2));
	endproperty

	property shift_left;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==3'h4 && ALSU_if.direction && !ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == {$past(ALSU_if.out[4:0]),$past(ALSU_if.serial_in,2) });
	endproperty

	property shift_right;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==3'h4 && !ALSU_if.direction && !ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == {$past(ALSU_if.serial_in,2),$past(ALSU_if.out[5:1]) });
	endproperty

	property rotate_left;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==3'h5 && ALSU_if.direction && !ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == {$past(ALSU_if.out[4:0]),$past(ALSU_if.out[5]) });
	endproperty

	property rotate_right;
		@(posedge ALSU_if.clk) disable iff (ALSU_if.rst)
		((ALSU_if.opcode==3'h5 && !ALSU_if.direction && !ALSU_if.red_op_B && !ALSU_if.red_op_A) && !ALSU_if.bypass_A && !ALSU_if.bypass_B) 
		|-> ##2 (ALSU_if.out == {$past(ALSU_if.out[0]),$past(ALSU_if.out[5:1]) });
	endproperty

	invalid_property_assertion: assert property (invalid_property);
	invalid_property_cover: cover property (invalid_property);

	bypass_A_property_assertion: assert property (bypass_A_property);
	bypass_A_property_cover: cover property (bypass_A_property);

	bypass_B_property_assertion: assert property (bypass_B_property);
	bypass_B_property_cover: cover property (bypass_B_property);

	red_OR_A_property_assertion: assert property (red_OR_A);
	red_OR_A_property_cover: cover property (red_OR_A);

	red_OR_B_property_assertion: assert property (red_OR_B);
	red_OR_B_property_cover: cover property (red_OR_B);

	red_OR_A_B_property_assertion: assert property (red_OR_A_B);
	red_OR_A_B_property_cover: cover property (red_OR_A_B);

	red_XOR_A_property_assertion: assert property (red_XOR_A);
	red_XOR_A_property_cover: cover property (red_XOR_A);

	red_XOR_B_property_assertion: assert property (red_XOR_B);
	red_XOR_B_property_cover: cover property (red_XOR_B);

	red_XOR_A_B_property_assertion: assert property (red_XOR_A_B);
	red_XOR_A_B_property_cover: cover property (red_XOR_A_B);

	Add1_assertion: assert property (Add);
	Add1_cover: cover property (Add);

	Mult_assertion: assert property (Mult);
	Mult_cover: cover property (Mult);

	shift_left_assertion: assert property (shift_left);
	shift_left_cover: cover property (shift_left);

	shift_right_assertion: assert property (shift_right);
	shift_right_cover: cover property (shift_right);

	rotate_left_assertion: assert property (rotate_left);
	rotate_left_cover: cover property (rotate_left);

	rotate_right_assertion: assert property (rotate_right);
	rotate_right_cover: cover property (rotate_right);

endmodule : ALSU_SVA