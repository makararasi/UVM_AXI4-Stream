
class axi4_master_sequence extends uvm_sequence#(axi4_master_seq_item);

    `uvm_object_utils(axi4_master_sequence)
    axi4_master_seq_item req;
  
    function new(string name = "axi4_master_sequence");
        super.new(name);
    endfunction
   
    virtual task body();
        repeat(1000)
        begin
            req = axi4_master_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize);
            finish_item(req);
        end
    endtask
   
endclass : axi4_master_sequence

