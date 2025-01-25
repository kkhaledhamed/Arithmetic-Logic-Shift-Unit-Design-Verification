module ALSU (A,B,opcode,cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clk,rst,out,leds);
input clk,rst,cin,serial_in,red_op_A,red_op_B,bypass_A,bypass_B,direction;
reg cin_FF,serial_in_FF,red_op_A_FF,red_op_B_FF,bypass_A_FF,bypass_B_FF,direction_FF;
input [2:0] A,B,opcode;
reg [2:0] A_FF,B_FF,opcode_FF;
output reg [5:0] out;
output reg [15:0] leds;
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
wire invalid_red_op, invalid_opcode, invalid;
assign invalid_red_op = (red_op_A_FF | red_op_B_FF) && (opcode_FF[1] | opcode_FF[2]);
assign invalid_opcode = opcode_FF[1] & opcode_FF[2];
assign invalid = invalid_red_op | invalid_opcode;
//First Register Level
always @(posedge clk or posedge rst) begin
	if (rst) begin
		A_FF <= 0;B_FF <= 0;opcode_FF <= 0;cin_FF<=0 ; serial_in_FF<=0;
		red_op_A_FF<=0;red_op_B_FF<=0;bypass_A_FF<=0;bypass_B_FF<=0;direction_FF<=0;
	end
	else begin
		A_FF <= A;B_FF <= B;opcode_FF <= opcode;cin_FF<=cin ;serial_in_FF<=serial_in;red_op_A_FF<=red_op_A;
		red_op_B_FF<=red_op_B;bypass_A_FF<=bypass_A;bypass_B_FF<=bypass_B;direction_FF<=direction;
	end
end
//LEDS
always @(posedge clk or posedge rst) begin
	if (rst) begin
		leds<=0;		
	end
	else 
	if (invalid) begin
			leds<=~leds;
		end
	leds<=0;
	end
end
//ALSU Functionality
always @(posedge clk or posedge rst) begin
	if (rst) begin
		out<=0;
	end
	else if ( bypass_A && bypass_B) begin
		if (INPUT_PRIORITY=="A") begin
			out<=A_FF;		
		end	
		else if (INPUT_PRIORITY=="B") begin
			out<=B_FF;
		end	
	end
	else if (bypass_A) begin
		out<=A_FF;	
	end
	else if (bypass_B) begin
		out<=B_FF;
	end
	else begin //Valid Arithmetic Operations
		case (opcode_FF)
			3'b000 : begin
				if (red_op_A && red_op_B) begin
					if (INPUT_PRIORITY=="A") begin
						out<= &A_FF ;
					end
					else if (INPUT_PRIORITY=="B") begin
						out<= &B_FF;
					end
				end
				else if(red_op_A) begin
					out<= &A_FF;
				end
				else if (red_op_B) begin
					out<= &B_FF;
				end
				else begin
					out<= A & B;
				end
			end
			3'b001 : begin
				if (red_op_A && red_op_B) begin
					if (INPUT_PRIORITY=="A") begin
						out<= ^A_FF; 
					end
					else if (INPUT_PRIORITY=="B") begin
						out<=^B_FF; 
					end
				end
				else if(red_op_A) begin
					out<=^A_FF; 
				end
				else if (red_op_B) begin
					out<=^B_FF; 
				end
				else begin
					out<= A_FF ^ B_FF;
				end
			end
			3'b010 : begin
				if (FULL_ADDER=="ON") begin
					out<=A_FF+B_FF+cin_FF;
				end
				else if (FULL_ADDER=="OFF")begin
					out<=A_FF+B_FF;
				end
			end
			3'b011 : begin
				out<= A_FF * B_FF;
			end
			3'b100 : begin
				if (direction_FF) begin
					out<={out[4:0],serial_in_FF};
				end
				else begin
					out<={serial_in_FF,out[5:1]};
				end
			end
			3'b101 : begin
				if (direction_FF) begin
					out<={out[4:0],out[5]};
				end
				else begin
					out<={out[0],out[5:1]};
				end
			end
		endcase
	end
end
endmodule