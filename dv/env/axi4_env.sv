
class axi4_env extends uvm_env;

    `uvm_component_utils(axi4_env)
    axi4_master_agent agent;

    function new(string name="axi4_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = axi4_master_agent::type_id::create("agent", this);
    endfunction



endclass : axi4_env
