# UVM based AMBA 4 AXI-Stream protocol
## Introduction
This is for now is a simple master-slave AXI-stream Environment where support for default signals are present for both Master and Slave. Optional Signals like **TID**,**TLAST**,**TDEST**,**TKEEP** are supported partially for the master. These will be changed when there are more sequences that covers different types of data streams, hand-shakes. <br />

**NOTE : Here by default signals I mean **TDATA**,**TVALID**,**TREADY** although naming convention is from [AXI-Stream Specification](https://developer.arm.com/documentation/ihi0051/a/)**

## File Structure
dv <br />
|___agent <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_master_agent.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_slave_agent.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_master_driver.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_slave_driver.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___README.md <br />
| <br />
|_____env <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_env.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_test.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi_intf.sv <br />
| <br />
|___sequence <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_master_seq_item.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_master_sequence.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_slave_seq_item.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_seqr.sv <br />
|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___axi4_slave_sequence.sv <br />
| <br />
|_______tb <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___top.sv <br />
sim <br />
|______Makefile <br />
<br />
verilog-uart-master <br />
|_____rtl <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___uart.v <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___uart_tx.v <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|___uart_tx.v <br />
___
## Feature Set <br />
* Posedge clk and Posedge rst
* Ready_before_valid.
* Valid_before_ready.
* Randomized Ready_before_valid and Valid_before_ready.
* Single transfer per master sequence count.
* Packet transfer per master sequence count.
* Continuous aligned stream per master sequence count.
* Continuous unaligned stream per master sequence count.
* Sparse stream per master sequence count.
* Position byte updation in stream(packet) per master sequence count.
* Slave ready assertion randomized between 1 to 16 clocks.
* Interleaving of streams(packets)[**TO-DO**][**This is updated in second branch as vivado doesn't support certain system verilog feature**] .
___ 
## Working of UVM Environment <br />
### Introduction <br />
Firstly, I took [DUT](https://github.com/alexforencich/verilog-uart) for testing purposes which is a **UART** module with AXI-Stream user interface. This DUT consisted of default AXI-stream signals to communicate to and fro. DUT has both Tx and Rx instansiated inside which means user can repalce any of these two with user specific Tx or Rx if they are compatible. Inside Top module Tx is Driven by AXI-stream Master and Rx Drives AXI-stream Slave.  

### Running a testcase <br />
Xilinx Vivado 2020.02 is supporting UVM. To Know More follow [this](https://forums.xilinx.com/t5/Design-and-Debug-Techniques-Blog/UVM-Universal-Verification-Methodology-Support-in-Vivado/ba-p/1070861). <br />
#### Install vivado 2020.02
follow [this](https://www.koheron.com/support/tutorials/install-vivado-2017-1-ubuntu-16-04/) for linux users. ***Install only vivado 2020.02. Other versions not allowed*** <br />
#### Sourcing tool
**Example command :-** ```
                          source /tools/Xilinx/Vivado/2020.02/settings64.sh
                        ``` 
(source /path/to/vivado/settings64.sh). I guess 64 means 64bit computer. This worked for me. Users should Workout theirs.  <br />
Makefile inside sim folder has all the options for tool like **sv_seed**,**master_sequence_count**,**DATA_WIDTH**(which is parameter on interface and DUT).  <br />
**Example command :-** ``` make vivado count=10 dataw=32 seed=$(random)``` runs "**basic_test**" which is a common ready-valid handshake where for each count 1 packet of transfers occur.for now it is sparse data stream. <br />
UVM Environment has been tested for only 32 bit DATA_WIDTH. <br />

There is define for UART in **top.sv** which is when turned off then AXI_stream Master and Slave Communicates. Users can also replace their Slaves and Masters for testing <br />
## Waveform <br />
![Alt text](./images/axi.png?raw=true" "Valid_Before_Ready") <br />

***MORE TO COME***
:)<br />



