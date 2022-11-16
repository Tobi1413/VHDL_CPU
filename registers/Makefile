GHDL = ghdl

WORK_DEPS = vhdl/riscv_types.vhd vhdl/registers.vhd tb/register_tb.vhd


.PRECIOUS: register_TB.vcd
registers_TB.vcd: work-obj93.cf
	$(GHDL) -r register_tb --vcd=register_tb.vcd

work-obj93.cf: $(WORK_DEPS)
	$(GHDL) -a $(WORK_DEPS)

.PHONY: clean
clean:
	rm work-obj93.cf register_TB.vcd
