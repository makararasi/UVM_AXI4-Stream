

DV_PATH=../dv

vivado: vivado_build_tb vivado_sim


vivado_build_tb:
	xvlog -sv -d COUNT=$(count) -d DATA_WIDTH=$(dataw) -L uvm $(DV_PATH)/tb/top.sv 
	xelab top -relax -s top -debug wave -timescale 1ns/1ps


vivado_sim:
	xsim  top --sv_seed SEED=$(seed) -testplusarg UVM_TESTNAME=basic_test -testplusarg UVM_VERBOSITY=UVM_LOW -runall

vivado_clean:
	rm -rf xsim.dir webtalk* xelab* xvlog* xsim* *.log *.vcd *.wdb

