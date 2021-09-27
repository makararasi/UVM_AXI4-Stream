

class axi4_master_seq_item extends uvm_sequence_item;

    rand    bit [(`DATA_WIDTH)-1 : 0]               data[$];
    randc   int                                     clk_count;
    randc   bit [6:0]                               id;
    randc   bit [3:0]                               dest;
    rand    bit [5:0]                               size;
    rand    bit [(`DATA_WIDTH/8)-1 : 0]             tstrb[$];
    rand    bit [(`DATA_WIDTH/8)-1 : 0]             tkeep[$];  

    //later add null bytes 

    //Utility and Field macros,
    `uvm_object_utils_begin(axi4_master_seq_item)
    `uvm_object_utils_end
  
    constraint range            {   clk_count inside{[5:20]};    
                                
                                }  
    
    constraint q_size           {   data.size       == this.size;
                                    tstrb.size      == this.size;
                                    tkeep.size      == this.size;
                                }
                                    //help_ar.size== this.size;    }

    constraint size_var         {   size inside{[1:10]};         
                                
                                } //

    constraint order            {   solve size      before  data ;
                                    solve size      before  tstrb;
                                    solve size      before  tkeep; 
                                }
    
    constraint tkeep_data       { foreach(tkeep[i])

                                        tkeep[i] == {(`DATA_WIDTH/8){1'b1}}; } //later change this for null bytes


                                    //solve size      before  help_ar;
                                    //solve help_ar   before  tstrb;  }

    //   constraint help_ar_data     {   (size == 1) -> help_ar.sum()with(item) == inside{[0:1]}; 
    //                                  (size >  1) -> help_ar.sum()with(item) == inside{[0:size -1]};  }
                        
    

    //Constructor
    function new(string name = "axi4_master_seq_item");
        super.new(name);
    endfunction

  
  
endclass : axi4_master_seq_item
