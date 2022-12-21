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

entity control_unit_tb is
end control_unit_tb;

architecture behavioral of control_unit_tb is

  signal ram_i_instructionAdr : ram_addr_t;
  signal ram_i_dataAdr : ram_addr_t;
  signal ram_i_writeEnable : one_bit;
  signal ram_i_dataIn : word;


  --clk signal/clk period
	signal clk : std_logic;
	constant clk_period : time := 10 ns;
	
	signal reset : std_logic := '0';
	signal start : std_logic := '0';

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
    port map(
      clk => clk,
      reset => reset,
      start => start,
      
      ram_i_instructionAdr => ram_i_instructionAdr,
      ram_i_dataAdr => ram_i_dataAdr,
      ram_i_writeEnable => ram_i_writeEnable,
      ram_i_dataIn => ram_i_dataIn
    );
  
  
  stim_proc : process
  
  begin
    start <= '0';
    ram_i_writeEnable(0) <= '1';
    ram_i_instructionAdr <= "00000000000000";
    ram_i_dataIn <= "00000000010101000000010000010011";
    
    wait until rising_edge(clk);
    
    wait for 10 ns;
    ram_i_instructionAdr <= "00000000000100";
    ram_i_dataIn <= "00000000011101001000010010010011";
    
    wait for 10 ns;
    ram_i_instructionAdr <= "00000000001000";
    ram_i_dataIn <= "00000000100101000000010100110011";
    
    wait for 10 ns;
    start <= '1';
    
    wait for 100 ns;
    
    
    
    
  
  
    report "Ende der Tests!";
  wait;
  end process;
  

end behavioral;