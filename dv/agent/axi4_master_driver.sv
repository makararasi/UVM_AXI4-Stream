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
    bit                                     tr_complete;
    int                                     Print_handle;
    int                                     clk_count[int];
    bit [(`DATA_WIDTH)-1 : 0]               data[int][$];
    bit [3:0]                               dest[int];
    bit [5:0]                               size[int];
    bit [(`DATA_WIDTH/8)-1 : 0]             tstrb[int][$];
    bit [(`DATA_WIDTH/8)-1 : 0]             tkeep[int][$];
    int                                     interleave_id[$],interleave_count,interleave_help[],interleave_help_id[$];

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
            if(interleave_count <= 3 && req.interleave_en == 1) //5 is the interleavig depth and interleave enable should be high for at least 5 times inorder to interleave
            begin
                interleave_count = interleave_count + 1;
                data[req.id]    = req.data;
                dest[req.id]    = req.dest;
                size[req.id]    = req.size;
                tstrb[req.id]   = req.tstrb;
                tkeep[req.id]   = req.tkeep;
            end
            else
            begin
                data[req.id]       = req.data;
                dest[req.id]       = req.dest;
                size[req.id]       = req.size;
                tstrb[req.id]      = req.tstrb;
                tkeep[req.id]      = req.tkeep;
                foreach(size[i])
                begin
                for(int j = 0; j<size[i]; j++)
                begin
                    interleave_id.push_back(i);
                end
                end
                //if(interleave_count == 4)
                assert(std::randomize(interleave_help)with{ interleave_help.size == interleave_id.size;
                                                            foreach(interleave_help[i]){
                                                            foreach(interleave_help[j]){
                                                                if(i!=j)
                                                                    interleave_help[i] != interleave_help[j]; }}});
                //interleave_id.shuffle();
                foreach(interleave_help[i])
                begin
                    interleave_help_id.push_back(interleave_id[interleave_help[i]]);
                end
                $display("^^^^^^^^shuffled\t%p",interleave_help_id, "^^^^^^^^^^normal\t%p",interleave_id,"^^^^index_shuffle\t%p",interleave_help);
                //interleave_id = {interleave_help_id};
                drive_axi(req);
                interleave_id = '{};
                interleave_help_id = '{};
                interleave_help.delete();
                size.delete();// = null; 
                dest.delete();
                tstrb.delete();  //delete all interleave data structures
                tkeep.delete();
                data.delete();
                clk_count.delete();
                interleave_count = 0; 
            end
            seq_item_port.item_done();
	    end
    endtask

    task drive_axi(axi4_master_seq_item req);
        int temp_id;
        pre_req();
        do begin
            temp_id = interleave_id.pop_front(); 
            @(posedge vif.clk)
                if(vif.rst)
                begin
                    repeat(req.clk_count)
                    begin
                    @(posedge vif.clk);
                    end
                    vif.s_axis_tvalid   <= 1;
                    //print_debug();
                    $display("$$$$$$$$$$$$$\t",interleave_id.size,"\ttime",$time,"\tsize\t%p",size);
                    vif.s_axis_tdata    <= data[temp_id].pop_front();
                    vif.s_tid            <= temp_id;
                    vif.s_tdest           <= dest[temp_id];
                    vif.s_tkeep           <= tkeep[temp_id].pop_front();
                    vif.s_tstrb           <= tstrb[temp_id].pop_front(); 
                    if(data[temp_id].size == 0 && size[temp_id] > 1)
                    begin
                    vif.s_tlast <= 1;
                    end
                    do begin 
                        @(posedge vif.clk);
                            if(vif.s_axis_tvalid && vif.s_axis_tready)    //AXI MAster PART
                            begin
                            vif.s_axis_tvalid   <= 0;
                            vif.s_tlast           <= 0;
                            vif.s_tid            <= 0;
                            vif.s_tdest           <= 0;
                            vif.s_tkeep           <= 0;
                            vif.s_tstrb           <= 0;
                            vif.s_axis_tdata    <= 0;
                            tr_complete = 1;
                            end
                    end
                    while(!tr_complete && vif.rst);

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
                    vif.s_tlast           <= 0;
                    vif.s_tid            <= 0;
                    vif.s_tdest           <= 0;
                    vif.s_tkeep           <= 0;
                    vif.s_tstrb           <= 0;
                    vif.s_axis_tdata    <= 0;
                end

        end while(!interleave_id.size == 0 && vif.rst);
    endtask

    function void pre_req();
        foreach(tstrb[i,j,k])
            begin
            if(tstrb[i][j][k] == 1'b0)
                data[i][j][(8*k+7)- :8] = k; 
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
