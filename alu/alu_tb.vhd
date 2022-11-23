----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2022 15:54:05
-- Design Name: 
-- Module Name: alu_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.riscv_types.all;


library std;
use std.textio.all;


entity alu_tb is
end alu_tb;

architecture Behavioral of alu_tb is

	--clk signal/clk period
	signal clk : std_logic;
	constant clk_period : time := 10 ns;
	
	
	signal alu_opc : aluOP;
	signal input1 : word;
	signal input2 : word;
	signal result : word;
	
	signal rand_num1 : word;
	signal rand_num2 : word;
	
begin
  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  
  uut : entity work.alu(Behavioral)
    port map(alu_opc => alu_opc,
             input1 => input1,
             input2 => input2,
             result => result);


  stim_proc : process
  variable seed1 : integer;
  variable seed2 : integer;
  variable rand : real;
  variable rand_range : real := real(2**wordWidth - 1);
  begin
    wait until rising_edge(clk);
	   report "Start simulation:";
	   
	   for I in 0 to 9 loop
--	     seed1 := I+534524;
--	     seed2 := I+154326;
--	     uniform(seed1,seed2, rand);
--	     rand_num1 <= std_logic_vector(to_unsigned(integer(rand * rand_range),wordWidth));
	    
	     input1 <= std_logic_vector(to_unsigned(integer(I * 34124),wordWidth));
       input2 <= std_logic_vector(to_unsigned(integer(I * 82521516 + 1),wordWidth)); -- max 51 durchläufe
       
       wait for 10 ns;
       
       report "Number 1 is: " & integer'image(to_integer(unsigned(input1)));
       report "Number 2 is: " & integer'image(to_integer(unsigned(input2)));
       
       alu_opc <= uNOP;
       wait for 10 ns;
       if result /= X"00000000" then
         report "Fehler im Durchlauf " & integer'image(I) & " bei NOP.";
       end if;
       
       alu_opc <= uADD;
       wait for 10 ns;
       if result /= std_logic_vector(signed(input1) + signed(input2)) then
        report "Fehler im Durchlauf " & integer'image(I) & " bei ADD.";
       end if;
       
       alu_opc <= uSUB;
       wait for 10 ns;
       if result /= std_logic_vector(signed(input1) - signed(input2)) then
        report "Fehler im Durchlauf " & integer'image(I) & " bei SUB.";
       end if;
       
       alu_opc <= uSLL;
       wait for 10 ns;
       if result /= input1(wordwidth - 2 downto 0) & '0' then
        report "Fehler im Durchlauf " & integer'image(I) & " bei SLL.";
       end if;
       
       alu_opc <= uSLT;
       wait for 10 ns;
       if result /= X"00000001" then
        report "Fehler im Durchlauf " & integer'image(I) & " bei SLT.";
       end if;
       
       alu_opc <= uSLTU;
       wait for 10 ns;
       if result /= X"00000001" then
        report "Fehler im Durchlauf " & integer'image(I) & " bei SLTU.";
       end if;
       
       alu_opc <= uXOR;
       wait for 10 ns;
       if result /= (input1 xor input2) then
        report "Fehler im Durchlauf " & integer'image(I) & " bei XOR.";
       end if;
       
       alu_opc <= uSRL;
       wait for 10 ns;
       if result /= '0' & input1(wordwidth - 1 downto 1) then
        report "Fehler im Durchlauf " & integer'image(I) & " bei SRL.";
       end if;
       
       alu_opc <= uSRA;
       wait for 10 ns;
       if result /= input1(wordwidth - 1) & input1(wordwidth - 1 downto 1) then
        report "Fehler im Durchlauf " & integer'image(I) & " bei SRA.";
       end if;
       
       alu_opc <= uOR;
       wait for 10 ns;
       if result /= (input1 or input2) then
        report "Fehler im Durchlauf " & integer'image(I) & " bei OR.";
       end if;
       
       alu_opc <= uAND;
       wait for 10 ns;
       if result /= (input1 and input2) then
        report "Fehler im Durchlauf " & integer'image(I) & " bei AND.";
       end if;
       
       report "Test-Durchlauf " & integer'image(I) & " abgeschlossen.";
	   end loop;
		
		report "Ende der Simulation!";
		--simply wait forever
		wait;
  end process;
  
end Behavioral;
