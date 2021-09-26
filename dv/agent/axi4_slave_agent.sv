class axi4_slave_agent extends uvm_agent;

    `uvm_component_utils(axi4_slave_agent)

    axi4_slave_driver slave_driver;
    axi4_slave_seqr slave_seqr;

    function new(string name="axi4_slave_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        slave_driver  = axi4_slave_driver::type_id::create("slave_driver", this);
        slave_seqr    = axi4_slave_seqr::type_id::create("slave_seqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        slave_driver.seq_item_port.connect(slave_seqr.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info("AGENT", "Agent in place", UVM_MEDIUM)
    endtask


endclass : axi4_slave_agent

