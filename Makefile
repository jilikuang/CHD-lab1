SVSOURCE = rws_ff.sv cam_decoder.sv cam_mux.sv cam.sv
SVPART = rws_ff cam_decoder cam_mux cam
TEST = cam_test.sv
BENCH = testbench.exe
TEST_W = cam_test_write.sv
TEST_R = cam_test_read.sv
TEST_S = cam_test_search.sv
TEST_M = cam_test_multiaccess.sv

all: 
	make clean
	make test
	make view

test:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(SVSOURCE) $(TEST) -o $(BENCH)
	./$(BENCH)

test_w:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(SVSOURCE) $(TEST_W) -o $(BENCH)
	./$(BENCH)

test_r:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(SVSOURCE) $(TEST_R) -o $(BENCH)
	./$(BENCH)

test_s:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(SVSOURCE) $(TEST_S) -o $(BENCH)
	./$(BENCH)

test_m:
	vcs -full64 -PP -sverilog +define+SV +define+VPD $(SVSOURCE) $(TEST_M) -o $(BENCH)
	./$(BENCH)

view:
	#dve -full64 -vpd vcdplus.vpd &
	vpd2vcd vcdplus.vpd vcdplus.vcd &
	gtkwave vcdplus.vcd &
	
leda:
	leda -full64 -sverilog -top $(SVPART) $(SVSOURCE)
	
clean:
	rm -rf csrc *.exe.daidir *.exe *.log *.inf .leda_work *.key *.vpd *.vcd DVEfiles
