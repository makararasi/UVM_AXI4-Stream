
class axi4_master_driver extends uvm_driver#(axi4_master_seq_item);

    `uvm_component_utils(axi4_master_driver)

    virtual axi_intf vif;
    bit tr_complete;

    function new(string name="axi4_master_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
	    if( !uvm_config_db#(virtual axi_intf)::get(this,"*", "vif", vif))
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

            /*------------------------------------*/
            do begin
                @(posedge vif.clk);                    // UART part put defines
            end while(vif.tx_busy);
            /*------------------------------------*/

            tr_complete = 0; //waits till 1 transfer complete 
	        seq_item_port.item_done();
	    end
    endtask

    task drive_axi(axi4_master_seq_item req);
        repeat(req.clk_count - 2)
        begin
            @(posedge vif.clk);
        end
        begin
            vif.s_axis_tvalid <= 1;
            vif.s_axis_tdata <= req.data;
        end
        begin
            do begin
                @(posedge vif.clk);
                if(vif.s_axis_tvalid && vif.s_axis_tready)    //AXI MAster PART
                begin
                    vif.s_axis_tvalid <= 0;
                    tr_complete = 1;
                end
            end
            while(!tr_complete);
        end  
    endtask


endclass : axi4_master_driver
