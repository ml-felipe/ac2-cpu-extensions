IVERILOG ?= iverilog
VVP ?= vvp
IVFLAGS ?=
SOURCES = tests/drac_pkg_fixture.sv rtl/alu.sv rtl/branch_unit.sv rtl/branch_prediction_checker.sv tests/tb_units.sv
.PHONY: test clean
test:
	mkdir -p build
	$(IVERILOG) $(IVFLAGS) -g2012 -s tb_units -o build/units $(SOURCES)
	$(VVP) build/units
	$(IVERILOG) $(IVFLAGS) -g2012 -DBP_ENABLE -s tb_units -o build/units-bp $(SOURCES)
	$(VVP) build/units-bp
clean:
	rm -rf build
