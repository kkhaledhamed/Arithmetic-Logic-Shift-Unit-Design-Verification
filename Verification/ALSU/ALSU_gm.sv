module ALSU_gm (ALSU_interface.GM ALSU_if);
    // Parameters for configurability
    parameter INPUT_PRIORITY = "A"; 
    parameter FULL_ADDER = "ON";
    // Internal registers to store inputs after clock one cycle
    reg serial_in_FF, red_op_A_FF, red_op_B_FF, bypass_A_FF, bypass_B_FF, direction_FF;
    reg signed [1:0] cin_FF;
    reg signed [2:0] A_FF, B_FF;
    reg [2:0] opcode_FF;
    // Wires for invalid operation detection
    wire invalid_red_op, invalid_opcode, invalid;
    // Invalid operation detection logic
    assign invalid_red_op = (red_op_A_FF | red_op_B_FF) & (opcode_FF[1] | opcode_FF[2]);
    assign invalid_opcode = opcode_FF[1] & opcode_FF[2];
    assign invalid = invalid_red_op | invalid_opcode;
    // First Register Level - Capturing inputs on clock edge
    always @(posedge ALSU_if.clk or posedge ALSU_if.rst) begin 
        if (ALSU_if.rst) begin
            A_FF <= 0; B_FF <= 0; opcode_FF <= 0; cin_FF <= 0; serial_in_FF <= 0; red_op_A_FF <= 0;
            red_op_B_FF <= 0; bypass_A_FF <= 0; bypass_B_FF <= 0; direction_FF <= 0;
        end 
	else begin
            A_FF <= ALSU_if.A; B_FF <= ALSU_if.B; opcode_FF <= ALSU_if.opcode; cin_FF <= ALSU_if.cin; serial_in_FF <= ALSU_if.serial_in; red_op_A_FF <= ALSU_if.red_op_A;
            red_op_B_FF <= ALSU_if.red_op_B; bypass_A_FF <= ALSU_if.bypass_A; bypass_B_FF <= ALSU_if.bypass_B; direction_FF <= ALSU_if.direction;
        end
    end
    // LED Functionality - Blinking when invalid operation detected
    always @(posedge ALSU_if.clk or posedge ALSU_if.rst) begin
        if (ALSU_if.rst) begin
            ALSU_if.leds_ref <= 0;
        end else begin
            if (invalid) begin
                ALSU_if.leds_ref <= ~ALSU_if.leds_ref;
            end else begin
                ALSU_if.leds_ref <= 0;
            end
        end
    end
    // ALSU Functionality - Core processing logic
    always @(posedge ALSU_if.clk or posedge ALSU_if.rst) begin
        if (ALSU_if.rst) begin
            ALSU_if.out_ref <= 0;
        end else begin
            if (invalid) begin
                ALSU_if.out_ref <= 0;
            end else if (bypass_A_FF && bypass_B_FF) begin
                // Handling the bypass logic for both inputs
                ALSU_if.out_ref <= (INPUT_PRIORITY == "A") ? A_FF : B_FF;
            end else if (bypass_A_FF) begin
                ALSU_if.out_ref <= A_FF;
            end else if (bypass_B_FF) begin
                ALSU_if.out_ref <= B_FF;
            end else begin
                // Valid Arithmetic Operations
                case (opcode_FF)
                    3'b000: begin
                        // AND operation with reduction if enabled
                        if (red_op_A_FF && red_op_B_FF) begin
                            ALSU_if.out_ref <= (INPUT_PRIORITY == "A") ? |A_FF : |B_FF;
                        end else if (red_op_A_FF) begin
                            ALSU_if.out_ref <= |A_FF;
                        end else if (red_op_B_FF) begin
                            ALSU_if.out_ref <= |B_FF;
                        end else begin
                            ALSU_if.out_ref <= A_FF | B_FF;
                        end
                    end
                    3'b001: begin
                        // XOR operation with reduction if enabled
                        if (red_op_A_FF && red_op_B_FF) begin
                            ALSU_if.out_ref <= (INPUT_PRIORITY == "A") ? ^A_FF : ^B_FF;
                        end else if (red_op_A_FF) begin
                            ALSU_if.out_ref <= ^A_FF;
                        end else if (red_op_B_FF) begin
                            ALSU_if.out_ref <= ^B_FF;
                        end else begin
                            ALSU_if.out_ref <= A_FF ^ B_FF;
                        end
                    end
                    3'b010: begin
                        // ADD operation with optional carry-in based on FULL_ADDER parameter
                        if (FULL_ADDER == "ON") begin
                            ALSU_if.out_ref <= A_FF + B_FF + cin_FF;
                        end else begin
                            ALSU_if.out_ref <= A_FF + B_FF;
                        end
                    end
                    3'b011: begin
                        // Multiplication operation
                        ALSU_if.out_ref <= A_FF * B_FF;
                    end
                    3'b100: begin
                        // Shift operation with direction and serial input
                        if (direction_FF) begin
                            ALSU_if.out_ref <= {ALSU_if.out_ref[4:0], serial_in_FF};
                        end else begin
                            ALSU_if.out_ref <= {serial_in_FF, ALSU_if.out_ref[5:1]};
                        end
                    end
                    3'b101: begin
                        // Rotate operation with direction
                        if (direction_FF) begin
                            ALSU_if.out_ref <= {ALSU_if.out_ref[4:0], ALSU_if.out_ref[5]};
                        end else begin
                            ALSU_if.out_ref <= {ALSU_if.out_ref[0], ALSU_if.out_ref[5:1]};
                        end
                    end
                endcase
            end
        end
    end
endmodule
