-------------------------------------------------------------------------------------------------------------
-- Project: VHDL_CPU
-- Author: Maher Popal & Tobias Blumers 
-- Description: 
-------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.riscv_types.all;

entity imm_TB is
end imm_TB;

architecture Behavioral of imm_TB is

  -- Clock
  signal clk : std_logic;
  
  -- Inputs
  signal instruction : word    := X"00000000";
  signal opcode      : uOP     := uNOP;
  
  -- Outputs
  signal immediate : word := X"00000000";

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : entity work.imm(Behavioral)
    port map (
      instruction => instruction,
      opcode      => opcode,
      immediate   => immediate 
    );

  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  -- Stimulus process
  stim_proc : process
  
  begin

    -- Wait for the first rising edge
    wait until rising_edge(clk);

    report "Beginne Simulation:";


    
    -- immediate    reg1  add rd    i type
    -- 000000000010 00001 000 00001 0010011
    
    instruction <= "00000000001000001000000010010011";
    opcode <= uADDI;
    
    wait for 10 ns;
    
   
    assert immediate = "00000000000000000000000000000010" report "I Type: Test1 fehlgeschlagen!";
    report "Test1 I Type abgeschlossen";


    -- no flag imm   reg1  sll rd    i type
    -- 0000000 00100 00001 001 00001 0010011
    instruction <= "00000000010000001001000010010011";
    opcode <= uSLLI;
    
    wait for 10 ns;
    
    assert immediate = "00000000000000000000000000000100" report "I Type shift: Test2 fehlgeschlagen!";
    report "Test2 I Type shift abgeschlossen";



    -- imm     reg2  reg1  bge imm   b-type
    -- 0001101 00100 00001 101 00101 1100011
    -- imm = 010011010010
    instruction <= "00011010010000001101001011100011";
    opcode <= uBGE;
    
    wait for 10 ns;
    
    assert immediate = "00000000000000000000100110100100" report "B type: Test3 fehlgeschlagen!";
    report "Test3 B Type abgeschlossen";
    


    -- imm     reg2  reg1  sw  imm   s-type
    -- 0100110 00100 00001 010 10010 0100011
    -- imm = 010011010010
    instruction <= "01001100010000001010100100100011";
    opcode <= uSW;
    
    wait for 10 ns;
    
    assert immediate = "00000000000000000000010011010010" report "S type: Test4 fehlgeschlagen!";
    report "Test4 S Type abgeschlossen";    


    -- imm                  rd   u-type
    -- 01001100010000001010 00001 0110111
    -- imm = 010011010010
    instruction <= "01001100010000001010000010110111";
    opcode <= uLUI;
    
    wait for 10 ns;
    
    
    assert immediate = "00000000000001001100010000001010" report "U type: Test5 fehlgeschlagen!";
    report "Test5 U Type abgeschlossen";  


    
    -- imm                  rd    j-type
    -- 01001100010000001010 00001 1101111
    -- imm = 00000101001001100010
    instruction <= "01001100010000001010000011101111";
    opcode <= uJAL;
    
    wait for 10 ns;
    
    assert immediate = "00000000000000001010010011000100" report "J type: Test6 fehlgeschlagen!";
    report "Test6 J Type abgeschlossen"; 
    
    report "Ende der Simulation";
        
    -- Simply wait forever
    wait;
    
  end process;

end architecture;
 
