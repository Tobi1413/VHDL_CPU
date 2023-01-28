--author: Maher Popal & Tobias Blumers
--date:12.11.2022

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;

entity registers is

	generic (initReg : regFile := (others =>(others => '0')));
	
  port (
    led          : out std_logic_vector(15 downto 0);
    
    clk          : in  std_logic;
    en_reg_wb    : in  one_bit;
    data_in      : in  word;
    wr_idx       : in  reg_idx;
    r1_idx       : in  reg_idx;
    r2_idx       : in  reg_idx;
    write_enable : in  one_bit;
	
    r1_out       : out word;
    r2_out       : out word
    );
end registers;

architecture Behavioral of registers is

	signal store : regFile := initReg;

begin

  led(14 downto 0) <= store(18)(14 downto 0);
  led(15) <= '1';

	process(clk)
	begin
		if rising_edge(clk) then
		
		--one write port synchron
			if write_enable = "1" and en_reg_wb = "1" and wr_idx /= "00000" then
				store(to_integer(unsigned(wr_idx))) <= data_in;
			end if;
			
		--two read ports synchron
			if r1_idx= "00000" then
				r1_out <= X"00000000";
			else
				r1_out <= store(to_integer(unsigned(r1_idx)));
			end if;

			if r2_idx = "00000" then
				r2_out <= X"00000000";
			else
				r2_out <= store(to_integer(unsigned(r2_idx)));
			end if;
		end if;
	end process;
end architecture;