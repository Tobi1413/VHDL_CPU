library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;

entity decode is
  port (inst_in : in  instruction;
        reg_1   : out reg_idx;
        reg_2   : out reg_idx;
        reg_w   : out reg_idx;
        op_code : out uOP);
end decode;

architecture behavioral of decode is

begin
  process(inst_in)
  begin
    case inst_in(6 downto 0) is
    
    
-- R-Types: alu register
      when opc_ALUR =>  -- uADD oder uSUB
        case inst_in(14 downto 12) is
          when "000" =>
            if inst_in(30) = '1' then
              op_code <= uSUB;
            else
              op_code <= uADD;
            end if;
            
          when "101" => -- uSRL oder uSRA
            if inst_in(30) = '1' then
              op_code <= uSRA;
            else
              op_code <= uSRL;
            end if;
          
          when "010" => op_code <= uSLT;
          when "011" => op_code <= uSLTU;
          when "111" => op_code <= uAND;
          when "110" => op_code <= uOR;
          when "100" => op_code <= uXOR;
          when "001" => op_code <= uSLL;
          when others => op_code <= uNOP;
        end case;
        
-- invalid opcode
      when others =>
        op_code <= uNOP;
    end case;
  end process;
  
  reg_1 <= inst_in(19 downto 15);
  reg_2 <= inst_in(24 downto 20);
  reg_w <= inst_in(11 downto  7);


end behavioral;
