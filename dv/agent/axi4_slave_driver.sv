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
class axi4_slave_driver extends uvm_driver#(axi4_slave_seq_item);

    `uvm_component_utils(axi4_slave_driver)

    virtual axi_intf#(`DATA_WIDTH) vif;
    bit tr_complete,local_ready_before_valid;
    bit [31:0] ar[bit[6:0]][$];
    bit stream_data[];
    int count;
    

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
            drive_axi(req); 
            this.tr_complete = 0;
	        seq_item_port.item_done();
	    end
    endtask

    task drive_axi(axi4_slave_seq_item req);
        do begin
            @(posedge vif.clk)
            count <= count + 1;
            if(!vif.rst)
            begin
            if(req.ready_before_valid == 1'b1 && !vif.rst)
                vif.m_axis_tready <= 1;
            else if(req.ready_before_valid == 1'b0 && !vif.rst)
                vif.m_axis_tready <= 0; 
            if(vif.m_axis_tvalid == 1)
            begin
                local_ready_before_valid <= req.ready_before_valid;
                ar[vif.tid].push_back(vif.s_axis_tdata);
                if(req.ready_before_valid == 1'b1)
                    vif.m_axis_tready <= 0;
                else
                    vif.m_axis_tready <= 1; //put if else for ready before valid 
                this.tr_complete = 1;
            end
            end
            else
            begin
                if(req.ready_before_valid == 1'b1)
                    vif.m_axis_tready <= 1;
                else
                    vif.m_axis_tready <= 0;
            end
        end while(!this.tr_complete && !vif.rst);
        if(req.ready_before_valid == 1'b0 && !vif.rst)
            @(posedge vif.clk) vif.m_axis_tready <= 0;
    endtask



endclass : axi4_slave_driver
