`define UART
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "./../env/axi_intf.sv"
`include "./../sequence/axi4_master_seq_item.sv"
`include "./../sequence/axi4_slave_seq_item.sv"
`include "./../agent/axi4_master_driver.sv"
`include "./../agent/axi4_slave_driver.sv"
`include "./../sequence/axi4_seqr.sv"
`include "./../agent/axi4_master_agent.sv"
`include "./../agent/axi4_slave_agent.sv"
`include "./../env/axi4_env.sv"
`include "./../sequence/axi4_master_sequence.sv"
`include "./../sequence/axi4_slave_sequence.sv"
`include "./../env/axi4_test.sv"

`ifdef UART
    `include "./../../verilog-uart-master/rtl/uart_tx.v"
    `include "./../../verilog-uart-master/rtl/uart_rx.v"
    `include "./../../verilog-uart-master/rtl/uart.v"
`endif

module top ;



    bit clk,rst;
    axi_intf#(`DATA_WIDTH) inf(clk,rst);

/*----------------DUT_INSTANCE_START------------------*/

    `ifdef UART
     
    uart #(`DATA_WIDTH) UART_DUT( .clk(inf.clk),
                                    .rst(inf.rst),
                                    .rxd(inf.txd),
                                    .txd(inf.txd),
                                    .tx_busy(inf.tx_busy),
                                    .rx_busy(inf.rx_busy),
                                    .prescale(inf.prescale),
                                    .s_axis_tdata (inf.s_axis_tdata) ,
                                    .s_axis_tvalid(inf.s_axis_tvalid),
                                    .s_axis_tready(inf.s_axis_tready),
                                    .m_axis_tdata (inf.m_axis_tdata) ,
                                    .m_axis_tvalid(inf.m_axis_tvalid),
                                    .m_axis_tready(inf.m_axis_tready),
                                    .rx_overrun_error(inf.rx_overrun_error),
                                    .rx_frame_error(inf.rx_frame_error)
                                          
                                    );
    `endif   

/*------------------DUT_INSTANCE_END---------------*/

    initial
    begin
        forever
        #4 clk = ~clk;
    end

    initial
    begin
        `ifdef UART
        inf.prescale = 1;
        `endif    
        rst  =  1;
        #9 ;
        #2 rst  =  0; 
    end

    initial
    begin
        $dumpfile("uart_axi4_stream.vcd");
        $dumpvars(0,top);
    end

   initial
   begin
       uvm_config_db#(virtual axi_intf#(`DATA_WIDTH))::set(null, "*", "vif", inf);
       run_test();
   end


endmodule
