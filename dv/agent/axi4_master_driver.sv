/*MIT License

Copyright (c) 2021 makararasi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */

class axi4_master_driver extends uvm_driver#(axi4_master_seq_item);

    `uvm_component_utils(axi4_master_driver)

    virtual axi_intf#(`DATA_WIDTH) vif;
    bit tr_complete;

    function new(string name="axi4_master_driver", uvm_component parent = null);
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
                else
                begin
                    vif.s_axis_tvalid <= 0;
                    vif.tid   <= 0;
                    vif.tdest <= 0;
                    vif.tkeep <= 0;
                    vif.tstrb <= 0;
                end
            end while(vif.rst);
	        seq_item_port.item_done();
	    end
    endtask

    task drive_axi(axi4_master_seq_item req);
        do begin
        repeat(req.clk_count - 2)
        begin
            @(posedge vif.clk);
        end
        begin
            vif.s_axis_tvalid <= 1;
            vif.s_axis_tdata <= req.data.pop_front;
            vif.tid   <= req.id;
            vif.tdest <= req.dest;
            vif.tkeep <= req.tkeep.pop_front;
            vif.tstrb <= req.tstrb.pop_front; 
            if(req.data.size == 0 && req.size > 1)
            begin
                vif.tlast <= 1;
            end

        end
        begin
            do begin
                @(posedge vif.clk);
                if(vif.s_axis_tvalid && vif.s_axis_tready)    //AXI MAster PART
                begin
                    vif.s_axis_tvalid   <= 0;
                    vif.tlast           <= 0;
                    vif.tid             <= 0;
                    vif.tdest           <= 0;
                    vif.tkeep           <= 0;
                    vif.tstrb           <= 0;
                    vif.s_axis_tdata    <= 0;
                    tr_complete = 1;
                end
            end
            while(!tr_complete);
        end

        /*------------------------------------*/
        `ifdef UART
        do begin
            @(posedge vif.clk);                    // UART part put defines
        end while(vif.tx_busy);
        `endif
        /*------------------------------------*/
        tr_complete = 0;            //waits till 1 transfer complete 
        end while(!req.data.size == 0);
        vif.tid   <= 0;
        vif.tdest <= 0;
        vif.tkeep <= 0;
        vif.tstrb <= 0;

    endtask


endclass : axi4_master_driver
