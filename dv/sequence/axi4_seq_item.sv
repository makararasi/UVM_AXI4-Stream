

class axi4_seq_item extends uvm_sequence_item;

    rand bit [31:0] data;
    randc int clk_count;
    //Utility and Field macros,
    `uvm_object_utils_begin(axi4_seq_item)
        `uvm_field_int(data,UVM_ALL_ON)
    `uvm_object_utils_end
  
    constraint range{clk_count inside{[5:20]};}
    //Constructor
    function new(string name = "axi4_seq_item");
        super.new(name);
    endfunction
  
  
endclass : axi4_seq_item
