# vhdl files
FILES = ../HDL/RTL/*.vhd ../HDL/TB/*.vhd ../HDL/BHV/*.vhd
VHDLEX = .vhd

# testbench
TESTBENCH = pipeline_slv_tb
TESTBENCHPATH = ../HDL/TB/${TESTBENCH}$(VHDLEX)

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys --warn-no-vital-generic

SIMDIR = sim
# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
#GHDL_SIM_OPT = --stop-time=10000ns

WAVEFORM_VIEWER = gtkwave

all: compile run view

compile :
ifeq ($(strip $(TESTBENCH)),)
	@echo "TESTBENCH not set. Use TESTBENCH=value to set it."
	@exit 2
endif                                                                                             
	mkdir -p sim
	$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=sim --work=work $(TESTBENCHPATH) $(FILES)
	$(GHDL_CMD) -m  $(GHDL_FLAGS) --workdir=sim --work=work $(TESTBENCH)
	@mv $(TESTBENCH) sim/$(TESTBENCH)                                                                                
run :
	@$(SIMDIR)/$(TESTBENCH) $(GHDL_SIM_OPT) --wave=$(SIMDIR)/$(TESTBENCH).ghw
	#@$(SIMDIR)/$(TESTBENCH) $(GHDL_SIM_OPT) --vcdgz=$(SIMDIR)/$(TESTBENCH).vcdgz                                      
view :
	$(WAVEFORM_VIEWER) $(SIMDIR)/$(TESTBENCH).ghw wave.gtkw
	#gunzip --stdout $(SIMDIR)/$(TESTBENCH).vcdgz | $(WAVEFORM_VIEWER) --vcd                                   
clean :
	$(GHDL_CMD) --clean --workdir=sim
