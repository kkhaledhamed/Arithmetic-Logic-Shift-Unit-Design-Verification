package ALSU_sequence_item_valid_invalid_pkg;
    import uvm_pkg::*;
    import ALSU_shared_pkg::*;
    `include "uvm_macros.svh"
    
    class ALSU_sequence_item_valid_invalid extends ALSU_sequence_item;
        `uvm_object_utils(ALSU_sequence_item_valid_invalid)

        function new(string name = "ALSU_sequence_item_valid_invalid");
            super.new(name);
        endfunction

        constraint opcode_e_constraint {
            opcode dist {[OR:ROTATE]}; // Valid cases only
        }

    endclass : ALSU_sequence_item_valid_invalid
endpackage : ALSU_sequence_item_valid_invalid_pkg
