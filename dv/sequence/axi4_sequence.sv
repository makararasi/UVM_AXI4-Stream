
class axi4_sequence extends uvm_sequence#(axi4_seq_item);

    `uvm_object_utils(axi4_sequence)
    axi4_seq_item req;
  
    function new(string name = "axi4_sequence");
        super.new(name);
    endfunction
   
    virtual task body();
        repeat(10)
        begin
            req = axi4_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize);
            finish_item(req);
        end
    endtask
   
endclass : axi4_sequence

