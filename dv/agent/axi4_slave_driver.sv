class axi4_slave_driver extends uvm_driver#(axi4_slave_seq_item);

    `uvm_component_utils(axi4_slave_driver)

    virtual axi_intf#(`DATA_WIDTH) vif;
    bit tr_complete;
    

    function new(string name="axi4_slave_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
	    if( !uvm_config_db#(virtual axi_intf#(`DATA_WIDTH))::get(this,"*", "vif", vif))
		    `uvm_fatal(get_full_name(),{"virtual interface must be set for:",".mem_vif"} )
    endfunction

    task run_phase(uvm_phase phase);
	forever
	    begin
	        seq_item_port.get_next_item(req);
            do begin
                @(posedge vif.clk)
                if(!vif.rst)
                begin
                    drive_axi(req); 
                end
            end while(vif.rst);
            this.tr_complete = 0;
	        seq_item_port.item_done();
	    end
    endtask

    task drive_axi(axi4_slave_seq_item req);
        do begin
            @(posedge vif.clk)
            if(vif.m_axis_tvalid == 1)
            begin
                vif.m_axis_tready <= 1;
            end
            else 
            begin
                vif.m_axis_tready <= 0;
                this.tr_complete = 1;
            end
        end while(this.tr_complete);
    endtask


endclass : axi4_slave_driver
