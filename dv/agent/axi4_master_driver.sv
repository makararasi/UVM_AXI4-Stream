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
    int Print_handle;
    int debug_count;

    function new(string name="axi4_master_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
	    if( !uvm_config_db#(virtual axi_intf#(`DATA_WIDTH))::get(this,"*", "vif", vif))
		    `uvm_fatal(get_full_name(),{"virtual interface must be set for:",".mem_vif"} )
        if( !uvm_config_db#(int)::get(this,"*", "handle", Print_handle))
		    `uvm_fatal(get_full_name(),{"pront handle must be set for in masterdriver:",".Print_handle"} )

    endfunction

    task run_phase(uvm_phase phase);
	forever
	    begin
	        seq_item_port.get_next_item(req);
            pre_req();
            drive_axi(req);
            debug_count =  0; 
	        seq_item_port.item_done();
	    end
    endtask

    task drive_axi(axi4_master_seq_item req);
        do begin
            @(posedge vif.clk)
                if(!vif.rst)
                begin
                    repeat(req.clk_count)
                    begin
                    @(posedge vif.clk);
                    end
                    vif.s_axis_tvalid   <= 1;
                    print_debug();
                    vif.s_axis_tdata    <= req.data.pop_front;
                    vif.tid             <= req.id;
                    vif.tdest           <= req.dest;
                    vif.tkeep           <= req.tkeep.pop_front;
                    vif.tstrb           <= req.tstrb.pop_front; 
                    if(req.data.size == 0 && req.size > 1)
                    begin
                    vif.tlast <= 1;
                    debug_count = 0;
                    end
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
                            debug_count = debug_count + 1;
                            end
                    end
                    while(!tr_complete && !vif.rst);

                    /*------------------------------------*/
                    `ifdef UART
                    do begin
                    @(posedge vif.clk);                    // UART part put defines
                    end while(vif.tx_busy);
                    `endif
                    /*------------------------------------*/
                    tr_complete = 0; 
                end           //waits till 1 transfer complete
                else
                begin
                    vif.s_axis_tvalid   <= 0;
                    vif.tlast           <= 0;
                    vif.tid             <= 0;
                    vif.tdest           <= 0;
                    vif.tkeep           <= 0;
                    vif.tstrb           <= 0;
                    vif.s_axis_tdata    <= 0;
                end

        end while(!req.data.size == 0 && !vif.rst);
    endtask

    function void pre_req();
        foreach(req.tstrb[i,j])
            begin
            if(req.tstrb[i][j] == 1'b0)
                req.data[i][(8*j+7)- :8] = j; 
            end
    endfunction

    function void print_debug();
        Print_handle = $fopen("data_debug_dump.txt","ab");
        for(int j = 3; j>=0; j--)
            $fdisplay(Print_handle,"|data_byte\t%b",req.data[0][(8*j+7)- : 8],"\t|time\t",$time, "\t|strb_bit\t\t",req.tstrb[0][j],"|","\t\t");
        $fdisplay(Print_handle,"|id\t\t\t   ",this.req.id,"|data\t\t%h",this.req.data[0],"|tstrb\t\t\t%b",this.req.tstrb[0],"|tkeep\t\t %b",this.req.tkeep[0],"|tdest\t",this.req.dest,"\t|time\t",$time,"|");
        $fclose(Print_handle);
    endfunction

endclass : axi4_master_driver
