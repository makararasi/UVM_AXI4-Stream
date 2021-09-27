
class axi4_master_sequence extends uvm_sequence#(axi4_master_seq_item);

    `uvm_object_utils(axi4_master_sequence)
    axi4_master_seq_item req;
    process job1;
  
    function new(string name = "axi4_master_sequence");
        super.new(name);
    endfunction
   
    virtual task body();
        repeat(`COUNT)
        begin
            job1 = process::self();
            job1.srandom($urandom());
            req  = axi4_master_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize);
            finish_item(req);
        end
    endtask
   
endclass : axi4_master_sequence

