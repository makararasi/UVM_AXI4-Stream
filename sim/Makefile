

DV_PATH=../dv

vivado: vivado_build_tb vivado_sim


vivado_build_tb:
#	xvlog -sv -L uvm $(DV_PATH)/env/axi_intf.sv
	xvlog -sv -L uvm $(DV_PATH)/tb/top.sv
	xelab top -relax -s top -debug wave -timescale 1ns/1ps


vivado_sim:
	xsim  top -runall

vivado_clean:
	rm -rf xsim.dir webtalk* xelab* xvlog* xsim* *.log *.vcd *.wdb

