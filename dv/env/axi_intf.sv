interface axi_intf #(parameter DATA_WIDTH = 8) (input clk,rst);

    /*
     * AXI input
     */
    logic [DATA_WIDTH-1:0]  s_axis_tdata;
    logic                   s_axis_tvalid;
    logic                   s_axis_tready;

    /*
     * AXI output
     */
    logic [DATA_WIDTH-1:0]  m_axis_tdata;
    logic                   m_axis_tvalid;
    logic                   m_axis_tready;

    /*
     * UART interface
     */
    logic                   rxd;
    logic                   txd;

    /*
     * Status
     */
    logic                   tx_busy;
    logic                   rx_busy;
    logic                   rx_overrun_error;
    logic                   rx_frame_error;

    /*
     * Configuration
     */
    logic [15:0]            prescale;

endinterface
