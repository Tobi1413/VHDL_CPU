-------------------------------------------------------------------------------------------------------------
-- Project: VHDL_CPU
-- Author: Maher Popal & Tobias Blumers 
-- Description: 
-- Additional Comments:
-------------------------------------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;

entity imm is
  port (
    instruction : in  instruction;
    opcode      : in  uOP;
    immediate   : out word
    );
end imm;

architecture behavioral of imm is

begin
  process(instruction, opcode)
  begin
    case instruction(6 downto 0) is
      
      -- I-Type
      when opc_JALR | opc_LOAD | opc_ALUI | opc_FENCE | opc_ECALL | opc_EBREAK =>
        immediate(31 downto 11) <= (others => instruction(31));
        immediate(10 downto  5) <= instruction(30 downto 25);
        immediate(4  downto  1) <= instruction(24 downto 21);
        immediate(0) <= instruction(20);
      
      -- S-Type  
      when opc_STORE =>
        immediate(31 downto 11) <= (others => instruction(31));
        immediate(10 downto  5) <= instruction(30 downto 25);
        immediate(4  downto  1) <= instruction(11 downto  8);
        immediate(0) <= instruction(7);
      
      -- B-Type  
      when opc_BRANCH =>
        immediate(31 downto 12) <= (others => instruction(31));
        immediate(11) <= instruction(7);
        immediate(10 downto  5) <= instruction(30 downto 25);
        immediate(4  downto  1) <= instruction(11 downto  8);
        immediate(0) <= '0';
        
      -- U-Type
      when opc_LUI | opc_AUIPC =>
        immediate(31 downto 12) <= instruction(31 downto 12);
        immediate(11 downto  0) <= (others => '0');
        
      -- J-Type
      when opc_JAL =>
        immediate(31 downto 20) <= (others => instruction(31));
        immediate(19 downto 12) <= instruction(19 downto 12);
        immediate(11) <= instruction(20);
        immediate(10 downto  5) <= instruction(30 downto 25);
        immediate( 4 downto  1) <= instruction(24 downto 21);
        immediate(0) <= '0';
      
      when others =>
        immediate <= (others => '0');
    
    end case;
  end process;
end behavioral;

