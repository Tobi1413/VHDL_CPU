-------------------------------------------------------------------------------------------------------------
-- Project: VHDL_CPU
-- Author: Maher Popal & Tobias Blumers 
-- Description: 
-------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.NUMERIC_STD.ALL;


library work;
use work.riscv_types.all;

library std;
use std.textio.all;
use ieee.std_logic_textio.all;

entity control_unit_tb is
end control_unit_tb;

architecture behavioral of control_unit_tb is

  impure function init_ram(ram_block : integer) return ram_t is
    file text_file : text open read_mode is "program.mem";
    variable text_line : line;
    variable ram_instruction : std_logic_vector(31 downto 0);
    variable ram_data : ram_t;
    variable size : integer := 64;
  begin
--    ram_data := (others => (others => '0'));
    for i in 0 to size - 1 loop
      readline(text_file, text_line);
      hread(text_line, ram_instruction);
      ram_data(i) := ram_instruction((ram_block * 8) - 1 downto (ram_block * 8) - 8);
    end loop;
    ram_data(size to ram_block_size - 1) := (others => (others => '0'));
    return ram_data;
  end function;
  
  signal ram_init_data_0 : ram_t := init_ram(4);
  signal ram_init_data_1 : ram_t := init_ram(3);
  signal ram_init_data_2 : ram_t := init_ram(2);
  signal ram_init_data_3 : ram_t := init_ram(1);
  
  
  
  --clk signal/clk period
	signal clk : std_logic;
	constant clk_period : time := 10 ns;
	
	signal reset : std_logic := '0';

begin
  
  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  
  uut : entity work.control_unit(behavioral)
    generic map(
      ram_init_data_0 => ram_init_data_0,
      ram_init_data_1 => ram_init_data_1,
      ram_init_data_2 => ram_init_data_2,
      ram_init_data_3 => ram_init_data_3
    )
    port map(
      clk100Mhz => clk,
      nreset => reset
    );
  
  
  stim_proc : process
  
  begin
    wait until rising_edge(clk);
    
    wait for 100 ns;
    
    
    
    
  
  
    report "Ende der Tests!";
  wait;
  end process;
  

end behavioral;