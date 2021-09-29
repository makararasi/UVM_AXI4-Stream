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

class axi4_master_sanity_sequence extends uvm_sequence#(axi4_master_seq_item);

    `uvm_object_utils(axi4_master_sanity_sequence)
    axi4_master_seq_item req;
    process job1;
    int count;
  
    function new(string name = "axi4_master_sanity_sequence");
        super.new(name);
    endfunction
   
    virtual task body();
        repeat(`COUNT)
        begin
            req  = axi4_master_seq_item::type_id::create("req");
            $display(count, "\t^^^^^\t", $time);
            start_item(req);
            req.size_var.constraint_mode(0);
            assert(req.randomize()with{size == 1;}); //single transfer per count 
            finish_item(req);
            count = count + 1;
        end
    endtask
   
endclass : axi4_master_sanity_sequence



