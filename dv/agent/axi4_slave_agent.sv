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

