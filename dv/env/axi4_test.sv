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


class basic_test extends uvm_test;

    `uvm_component_utils(basic_test)

    axi4_env env;
    axi4_master_sanity_sequence master_seq;
    axi4_slave_sanity_sequence  slave_seq;
    int Print_handle;

    function new(string name="basic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(int)::set(this, "*", "handle", Print_handle);
        env = axi4_env::type_id::create("env", this);
        master_seq = axi4_master_sanity_sequence::type_id::create("master_seq", this);
        slave_seq  = axi4_slave_sanity_sequence::type_id::create("slave_seq", this);
    endfunction

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      begin
      $display("enetering into seq start of master and slave");
          fork
              begin
                  master_seq.get_print(Print_handle);
                  master_seq.start(env.master_agent.master_seqr);
              end
              begin
                  slave_seq.start(env.slave_agent.slave_seqr);
              end
          join_any
      $display("leaving from seq start of master and slave");
          //disable fork;
      end
      phase.drop_objection(this);
    endtask


endclass : basic_test
