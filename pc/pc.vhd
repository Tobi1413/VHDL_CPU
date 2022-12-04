library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;

entity PC is

  port (clk       : in  std_logic;
        en_pc     : in  one_bit;
        addr_calc : in  ram_addr_t;         -- From ALU
        doJump    : in  one_bit;
        addr      : out ram_addr_t);

end PC;

architecture Behavioral of PC is

signal addr_reg : ram_addr_t;
signal addr_next: ram_addr_t;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if doJump = "1" then
                 addr_reg <= addr_calc;
            elsif en_pc = "1" then
                 addr_reg <= addr_next;
            end if;
        end if;
    end process;
    --Next state logic
    addr_next <= std_logic_vector(unsigned(addr_reg) + 4);

    --Output logic
    addr <= addr_reg;

end architecture;