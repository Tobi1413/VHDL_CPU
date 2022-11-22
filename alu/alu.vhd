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
    alu_opc : in  aluOP;  -- alu opcode.
    input1  : in  word;   -- input1 of alu (reg1 / pc address) rs1
    input2  : in  word;   -- input2 of alu (reg2 / immediate)  rs2
    result  : out word    -- alu output.
    );
end alu;


architecture Behavioral of alu is
  process(alu_opc, input1, input2)
  begin
    case alu_opc is
      when uNOP  => -- no operation?
        result <= (others => '0'); -- alles auf 0 setzen

      when uADD  => -- Addieren
        -- todo

      when uSUB  => -- Subtrahieren
        -- todo

      when uSLL  => -- Shift Left Locical
        result <= (input1 sll 1);

      when uSLT  => -- Set on Less Than (Test if less than)
        -- todo

      when uSLTU => -- Set on Less Than Unsigned(Test if less than)
        -- todo

      when uXOR  => -- XOR
        result <= (input1 xor input2);

      when uSRL  => -- Shift Right Locical      |a|b|c|d|   mit   >>   wird zu   |0|a|b|c|
        result <= (input1 srl 1);

      when uSRA  => -- Shift Right Arithmetic   |a|b|c|d|   mit   >>   wird zu   |a|a|b|c|
        result <= (input1 sra 1);

      when uOR   => -- OR
        result <= (input1 or input2);

      when uAND  => -- AND
        result <= (input1 and input2);

      when others =>
        result <= (others => '0'); -- alles auf 0 setzen

  end process;