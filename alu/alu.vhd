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

entity alu is
  port (
    alu_opc : in  uOP;  -- alu opcode. -- von aluOP zu uOP geändert, da ich keine Übersetzung zwischen den beiden implementieren möchte
    input1  : in  word;   -- input1 of alu (reg1 / pc address) rs1
    input2  : in  word;   -- input2 of alu (reg2 / immediate)  rs2
    result  : out word    -- alu output.
    );
end alu;


architecture Behavioral of alu is
begin
  process(alu_opc, input1, input2)
  begin
  
    case alu_opc is	
      when uNOP  => -- no operation
        result <= (others => '0'); -- alles auf 0 setzen

      when uADD | uADDI | uJALR | uBLT | uBGE | uBLTU | uBGEU => -- Addieren
        result <= std_logic_vector(signed(input1) + signed(input2));

      when uSUB  => -- Subtrahieren
        result <= std_logic_vector(signed(input1) - signed(input2));

      when uSLL | uSLLI => -- Shift Left Logical
        result <= std_logic_vector(unsigned(input1) sll to_integer(unsigned(input2(4 downto 0))));
        --(std_logic_vector(unsigned(input1)) sll 1);

      when uSLT | uSLTI => -- Set on Less Than (Test if less than)
        if signed(input1) < signed(input2) then
			    result <= X"00000001";
		    else
			    result <= X"00000000";
		    end if;
          
      when uSLTU | uSLTIU => -- Set on Less Than Unsigned(Test if less than)
        if unsigned(input1) < unsigned(input2) then
			    result <= X"00000001";
		    else
			    result <= X"00000000";
		    end if;
          
      when uXOR | uXORI => -- XOR
        result <= (input1 xor input2);

      when uSRL | uSRLI => -- Shift Right Logical      |a|b|c|d|   mit   >>   wird zu   |0|a|b|c|
        result <= std_logic_vector(unsigned(input1) srl to_integer(unsigned(input2(4 downto 0))));
        --result <= input1 sll 3;

      when uSRA | uSRAI => -- Shift Right Arithmetic   |a|b|c|d|   mit   >>   wird zu   |a|a|b|c|
        result <= To_StdLogicVector(to_bitvector(input1) sra to_integer(unsigned(input2(4 downto 0))));

      when uOR | uORI => -- OR
        result <= (input1 or input2);

      when uAND | uANDI => -- AND
        result <= (input1 and input2);

      when others =>
        result <= (others => '0'); -- alles auf 0 setzen
	end case;
	
  end process;
 end architecture;
