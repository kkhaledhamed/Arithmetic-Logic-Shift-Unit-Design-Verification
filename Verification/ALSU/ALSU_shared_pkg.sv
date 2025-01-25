package ALSU_shared_pkg;
	typedef enum bit [2:0] {OR,XOR,ADD,MULT,SHIFT,ROTATE,INVALID_6,INVALID_7} opcode_e;
	parameter MAXPOS = 3;
	parameter MAXNEG = -4;
	parameter ZERO = 0 ;
endpackage : ALSU_shared_pkg