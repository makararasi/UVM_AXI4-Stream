#MIT License

#Copyright (c) 2021 makararasi and nextdesignd

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE. 


DV_PATH=../dv

vivado: vivado_build_tb vivado_sim


vivado_build_tb:
	xvlog -sv -d COUNT=$(count) -d DATA_WIDTH=$(dataw) -L uvm $(DV_PATH)/tb/top.sv 
	xelab top -relax -s top -debug wave -timescale 1ns/1ps


vivado_sim:
	xsim  top --sv_seed SEED=$(seed) -testplusarg UVM_TESTNAME=basic_test -testplusarg UVM_VERBOSITY=UVM_LOW -runall

vivado_clean:
	rm -rf xsim.dir webtalk* xelab* xvlog* xsim* *.log *.vcd *.wdb *.txt

questa: questa_build questa_compile
	
questa_build:
	vlog $(DV_PATH)/tb/top.sv

questa_compile:
	vsim -c top +UVM_TESTNAME=basic_test -voptargs=+acc=npr -do "run -a; q" 

questa_clean:
	rm -rf work/ transcript *.txt *.vcd
	clear
