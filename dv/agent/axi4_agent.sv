class axi4_master_agent extends uvm_agent;

    `uvm_component_utils(axi4_master_agent)

    axi4_master_driver driver;
    axi4_seqr seqr;

    function new(string name="axi4_master_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver  = axi4_master_driver::type_id::create("driver", this);
        seqr    = axi4_seqr::type_id::create("seqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(seqr.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info("AGENT", "Agent in place", UVM_MEDIUM)
    endtask


endclass : axi4_master_agent

