-------------------------------------------------------------------------------------------------------------
-- Project: VHDL_CPU
-- Author: Maher Popal & Tobias Blumers 
-- Description: 
-- Additional Comments:
-------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



library work;
use work.riscv_types.all;

entity pc_tb is
end pc_tb;


architecture Behavioral of pc_tb is

  -- Clock
  signal clk : std_logic;
  constant clk_period : time := 10 ns;
  
  --inputs
  signal en_pc      : one_bit;
  signal addr_calc  : ram_addr_t;
  signal doJump     : one_bit;
  
  --output
  signal addr       : ram_addr_t;
  
begin
    uut : entity work.pc(Behavioral)
        port map(
            clk => clk,
            en_pc => en_pc,
            addr_calc => addr_calc,
            doJump => doJump,
            addr => addr
         );
         
  --clock process definitions
  clk_process : process
  
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  
   stim_proc : process
	 begin
        wait until rising_edge(clk);
        
        report "Start simulation";
        
        addr_calc <= "00000010000000";
        
        en_pc <= "0";
        doJump <= "1";
        
        wait for 11 ns;
                
        --beide auf 0
        en_pc <= "0";
        doJump <= "0";
                
        wait for 10 ns;
        assert addr = "00000010000000" report "Adresse nicht 00000010000000, sondern: " & integer'image(to_integer(unsigned(addr)));
        
        
        --doJump auf 1 en_pc 0
        en_pc <= "0";
        doJump <= "1";
        addr_calc <= "00000000000000";
        
        wait for 10 ns;
        assert "00000000000000" = addr report "Adresse nicht auf Null";
        
        
        --doJump auf 1 en_pc auf 1
        en_pc <= "1";
        doJump <= "1";
        addr_calc <= "00000000001000";
        
        wait for 10 ns;
        assert "00000000001000" = addr report "Adresse nicht auf Acht";  
       
       --doJump auf 0 en_pc auf 1
        en_pc <= "1";
        doJump <= "0";
        
        wait for 10 ns;
        assert "00000000001100" = addr report "Adresse nicht auf auf 12";
        
        wait; --wait forever
        
        
        
      end process;
end architecture;
