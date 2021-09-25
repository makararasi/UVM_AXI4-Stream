

class basic_test extends uvm_test;

    `uvm_component_utils(basic_test)

    axi4_env env;
    axi4_sequence seq;

    function new(string name="basic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi4_env::type_id::create("env", this);
        seq = axi4_sequence::type_id::create("seq", this);
    endfunction

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      begin
          seq.start(env.agent.seqr);
         // #8210;
      end
      phase.drop_objection(this);
    endtask


endclass : basic_test
