`timescale 1ns/1ps

module ALSU_tb ();
// Signals Declaration
reg [2:0] A_tb, B_tb; 
reg [2:0] opcode_tb;
reg cin_tb, serial_in_tb, direction_tb, red_op_A_tb, red_op_B_tb, bypass_A_tb, bypass_B_tb;
reg clk_tb, rst_tb;
wire [5:0] out_dut;
wire [15:0] leds_dut;

// Clock Generation 
initial begin
    clk_tb = 0;
    forever 
    #5 clk_tb = ~clk_tb;
end

// DUT instantiation
ALSU DUT (
    .A(A_tb), .B(B_tb), .opcode(opcode_tb), .cin(cin_tb), .serial_in(serial_in_tb), 
    .direction(direction_tb), .red_op_A(red_op_A_tb), .red_op_B(red_op_B_tb),
    .bypass_A(bypass_A_tb), .bypass_B(bypass_B_tb), .clk(clk_tb), .rst(rst_tb),
    .out(out_dut), .leds(leds_dut)
    );

// Test Stimulus Generator
initial begin
    // Initialize all inputs 
    rst_tb = 0;
    cin_tb = 0;
    serial_in_tb = 0;
    direction_tb = 0;
    red_op_A_tb = 0;
    red_op_B_tb = 0;
    bypass_A_tb = 0;
    bypass_B_tb = 0;
    A_tb = 0;
    B_tb = 0;
    opcode_tb = 0;

    // Test reset
    rst_tb = 1;
    @(negedge clk_tb);
    rst_tb = 0;
    @(negedge clk_tb);

    // Test case: AND Operation (no reduction, no bypass)
    opcode_tb = 3'b000;
    A_tb = 3'b101;
    B_tb = 3'b110;
    @(negedge clk_tb);
    $display("AND Operation: out_dut = %b", out_dut);

    // Test case: AND Operation (reduction A)
    red_op_A_tb = 1;
    @(negedge clk_tb);
    $display("AND Operation (reduction A): out_dut = %b", out_dut);
    red_op_A_tb = 0;

    // Test case: AND Operation (reduction B)
    red_op_B_tb = 1;
    @(negedge clk_tb);
    $display("AND Operation (reduction B): out_dut = %b", out_dut);
    red_op_B_tb = 0;

    // Test case: AND Operation (reduction A and B)
    red_op_A_tb = 1;
    red_op_B_tb = 1;
    @(negedge clk_tb);
    $display("AND Operation (reduction A and B): out_dut = %b", out_dut);
    red_op_A_tb = 0;
    red_op_B_tb = 0;

    // Test case: XOR Operation
    opcode_tb = 3'b001;
    A_tb = 3'b101;
    B_tb = 3'b110;
    @(negedge clk_tb);
    $display("XOR Operation: out_dut = %b", out_dut);

    // Test case: ADD Operation
    opcode_tb = 3'b010;
    A_tb = 3'b001;
    B_tb = 3'b010;
    cin_tb = 1;
    @(negedge clk_tb);
    $display("ADD Operation: out_dut = %b", out_dut);
    cin_tb = 0;

    // Test case: Multiplication Operation
    opcode_tb = 3'b011;
    A_tb = 3'b010;
    B_tb = 3'b011;
    @(negedge clk_tb);
    $display("Multiplication Operation: out_dut = %b", out_dut);

    // Test case: Invalid Operation
    opcode_tb = 3'b111; // Invalid opcode
    @(negedge clk_tb);
    $display("Invalid Operation: out_dut = %b, leds_dut = %b", out_dut, leds_dut);

    // Test case: Invalid Operation
    opcode_tb = 3'b110; // Invalid opcode
    @(negedge clk_tb);
    $display("Invalid Operation: out_dut = %b, leds_dut = %b", out_dut, leds_dut);

    // Test case: Shift Operation (left)
    opcode_tb = 3'b100;
    serial_in_tb = 1;
    direction_tb = 1;
    @(negedge clk_tb);
    $display("Shift Operation (left): out_dut = %b", out_dut);

    // Test case: Shift Operation (right)
    direction_tb = 0;
    @(negedge clk_tb);
    $display("Shift Operation (right): out_dut = %b", out_dut);

    // Test case: Rotate Operation (left)
    opcode_tb = 3'b101;
    direction_tb = 1;
    @(negedge clk_tb);
    $display("Rotate Operation (left): out_dut = %b", out_dut);

    // Test case: Rotate Operation (right)
    direction_tb = 0;
    @(negedge clk_tb);
    $display("Rotate Operation (right): out_dut = %b", out_dut);

    // Test case: Bypass A
    bypass_A_tb = 1;
    A_tb = 3'b101;
    opcode_tb = 3'b000;
    @(negedge clk_tb);
    $display("Bypass A: out_dut = %b", out_dut);
    bypass_A_tb = 0;

    // Test case: Bypass B
    bypass_B_tb = 1;
    B_tb = 3'b110;
    @(negedge clk_tb);
    $display("Bypass B: out_dut = %b", out_dut);
    bypass_B_tb = 0;

    $stop;
end

//Test Monitor & Results
initial begin
    $monitor("clk_tb = %b ,rst_tb = %b , A_tb = %b , B_tb = %b , opcode_tb = %b , cin_tb = %b , serial_in_tb = %b , direction_tb = %b , red_op_A_tb = %b , red_op_B_tb = %b ,bypass_A_tb = %b ,bypass_B_tb = %b , out_dut = %b , leds_dut = %b",
             clk_tb, rst_tb, A_tb, B_tb, opcode_tb, cin_tb, serial_in_tb, direction_tb, red_op_A_tb, red_op_B_tb, bypass_A_tb, bypass_B_tb, out_dut, leds_dut);
end

endmodule
