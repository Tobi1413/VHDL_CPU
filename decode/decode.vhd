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
      when opc_ALUR => 
        reg_1 <= inst_in(19 downto 15);
        reg_2 <= inst_in(24 downto 20);
        reg_w <= inst_in(11 downto  7);
        case inst_in(14 downto 12) is
          when "000" =>
            if inst_in(30) = '1' then
              op_code <= uSUB;
            else
              op_code <= uADD;
            end if;

          when "101" =>
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
        
-- I-types: alu immediate
      when opc_ALUI =>
        reg_1 <= inst_in(19 downto 15);
        reg_2 <= "00000";
        reg_w <= inst_in(11 downto 7);
          
        case inst_in(14 downto 12) is
          
          when "101" =>
            if inst_in(30) = '1' then
              op_code <= uSRAI;
            else
              op_code <= uSRLI;
            end if;
            
          when "000" => op_code <= uADDI;
          when "010" => op_code <= uSLTI;
          when "011" => op_code <= uSLTIU;
          when "111" => op_code <= uANDI;
          when "110" => op_code <= uORI;
          when "100" => op_code <= uXORI;
          when "001" => op_code <= uSLLI; 
          when others => op_code <= uNOP;
        end case;
            
-- load befehle
      when opc_LOAD =>
          reg_1 <= inst_in(19 downto 15);
          reg_2 <= "00000";
          reg_w <= inst_in(11 downto 7);
          
       case inst_in(14 downto 12) is
          when "000" => op_code <= uLB;
          when "001" => op_code <= uLH;
          when "010" => op_code <= uLW;
          when "100" => op_code <= uLBU;
          when "101" => op_code <= uLHU;
          when others => op_code <= uNOP;  
       end case;   
     
-- JALR: Jump and link register
      when opc_JALR =>
        reg_1 <= inst_in(19 downto 15);
        reg_2 <= "00000";
        reg_w <= inst_in(11 downto 7);
      
        case inst_in(14 downto 12) is
          when "000" => op_code <= uJALR;
          when others => op_code <= uNOP;
        end case;
-- ECALL: ENVIRONMENTAL CALL        
      when opc_ECALL =>
        reg_1 <= inst_in(19 downto 15);
        reg_2 <= "00000";
        reg_w <= inst_in(11 downto 7);
        case inst_in(14 downto 12) is
          when "000" =>
            if(inst_in(20) = '0') then
              op_code <= uECALL;
            else
              op_code <= uNOP;
            end if;
          when others => op_code <= uNOP;
        end case;            

-- J-Type
      when opc_JAL =>
        reg_1 <= "00000";
        reg_2 <= "00000";
        reg_w <= inst_in(11 downto  7);
        op_code <=uJAL;
            
-- B-Type
		  when opc_BRANCH =>
        reg_1 <= inst_in(19 downto 15);
        reg_2 <= inst_in(24 downto 20);
        reg_w <= "00000";
        case inst_in(14 downto 12) is 
			    when branch_EQ   => op_code <= uBEQ;
			    when branch_NE   => op_code <= uBNE;
			    when branch_LT   => op_code <= uBLT;
			    when branch_GE   => op_code <= uBGE;
			    when branch_LTU  => op_code <= uBLTU;
			    when branch_GEU  => op_code <= uBGEU;
			    when others      => op_code <= uNOP;
		    end case;
		     
-- S-Type
		  when opc_STORE =>
		    reg_1 <= inst_in(19 downto 15);
		    reg_2 <= inst_in(24 downto 20);
		    reg_w <= "00000";
		    case inst_in(14 downto 12) is 
		      when store_B => op_code <= uSB;
		      when store_H => op_code <= uSH;
		      when store_W => op_code <= uSW;
		      when others  => op_code <= uNOP;
		    end case;
		
-- invalid opcode
      when others =>
        reg_1 <= "00000";
        reg_2 <= "00000";
        reg_w <= "00000";
        op_code <= uNOP;

    end case;
  end process;




end behavioral;
