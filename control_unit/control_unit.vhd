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

entity control_unit is
  port(
    clk, reset : in std_logic
  );
end control_unit;

architecture Behavioral of control_unit is

type state_t is (start, fetch, state_decode, rtype, itype_alu, itype_jalr_1, itype_jalr_2, itype_load_1, itype_load_2);
signal state_reg , state_next : state_t;



-- ALU Signals
signal alu_i_alu_opc : aluOP; --unused
signal alu_i_input1 : word;
signal alu_i_input2 : word;

signal alu_o_result : word;


-- decode Signals
signal decode_i_inst_in : instruction; --unused

signal decode_o_reg_1 : reg_idx;
signal decode_o_reg_2 : reg_idx;
signal decode_o_reg_w : reg_idx;
signal decode_o_op_code : uOP;


-- imm Signals
signal imm_i_instruction : instruction; --unused

signal imm_o_immediate : word;


-- PC Signals
signal pc_i_en_pc : one_bit;
signal pc_i_addr_calc : ram_addr_t; -- unused
signal pc_i_doJump : one_bit;

signal pc_o_addr : ram_addr_t;


-- RAM Signals
signal ram_i_instructionAdr : ram_addr_t; --unused
signal ram_i_dataAdr : ram_addr_t; --unused
signal ram_i_writeEnable : one_bit;
signal ram_i_dataIn : word; --unused

signal ram_o_instruction : word;
signal ram_o_dataOut : word;


-- Register Signals
signal reg_i_en_reg_wb : one_bit;
signal reg_i_data_in : word;
signal reg_i_wr_idx : reg_idx; --unused
signal reg_i_r1_idx : reg_idx; --unused
signal reg_i_r2_idx : reg_idx; --unused
signal reg_i_write_enable : one_bit;

signal reg_o_r1_out : word;
signal reg_o_r2_out : word;




begin


  transition : process (clk, reset)
  begin
    if (reset = '1') then
      state_reg <= start; -- set initial state
    elsif (rising_edge(clk)) then -- changes on rising edge
      state_reg <= state_next;
    end if;  
  end process;
  
  
  -- Endlicher Automat
  next_state_proc: process(state_reg, clk)
  begin
    case state_reg is
      when start =>
        alu_i_input1          <= reg_o_r1_out;  --
        alu_i_input2          <= reg_o_r2_out;  --
        pc_i_en_pc(0)         <= '0';           -- 
        pc_i_doJump(0)        <= '0';           --
        ram_i_writeEnable(0)  <= '0';           --
        reg_i_en_reg_wb(0)    <= '0';           --
        reg_i_data_in         <= alu_o_result;  -- 
        reg_i_write_enable(0) <= '0';           --
        
        state_next <= fetch;
    
      when fetch =>
        alu_i_input1          <= reg_o_r1_out;  --
        alu_i_input2          <= reg_o_r2_out;  --
        pc_i_en_pc(0)         <= '0';           -- 
        pc_i_doJump(0)        <= '0';           --
        ram_i_writeEnable(0)  <= '0';           --
        reg_i_en_reg_wb(0)    <= '0';           --
        reg_i_data_in         <= alu_o_result;  -- 
        reg_i_write_enable(0) <= '0';           --
        
        state_next <= state_decode;
        
      when state_decode =>
        alu_i_input1          <= reg_o_r1_out;  --
        alu_i_input2          <= reg_o_r2_out;  --
        pc_i_en_pc(0)         <= '0';           -- 
        pc_i_doJump(0)        <= '0';           --
        ram_i_writeEnable(0)  <= '0';           --
        reg_i_en_reg_wb(0)    <= '0';           --
        reg_i_data_in         <= alu_o_result;  -- 
        reg_i_write_enable(0) <= '0';
        
        case decode_o_op_code is
          
          when uADD | uSUB | uSLL | uSLT | uSLTU | uXOR | uSRL | uSRA | uOR | uAND  =>
            state_next <= rtype;
            
          when uADDI | uSLTI | uSLTIU | uXORI | uORI | uANDI | uSLLI | uSRLI | uSRAI =>
            state_next <= itype_alu;
            
          when uJALR =>
            state_next <= itype_jalr_1;
            
          when uLB | uLH | uLW | uLBU | uLHU =>
            state_next <= itype_load_1;
            
            
          when others =>
            state_next <= fetch; -- kein unterstütze instruction
            
        end case;
    
    -- Alle R-Type befehle
    when rtype =>
      alu_i_input1          <= reg_o_r1_out;  --
      alu_i_input2          <= reg_o_r2_out;  --
      pc_i_en_pc(0)         <= '1';           -- enable pc
      pc_i_doJump(0)        <= '0';           --
      ram_i_writeEnable(0)  <= '0';           --
      reg_i_en_reg_wb(0)    <= '1';           -- on
      reg_i_data_in         <= alu_o_result;  -- 
      reg_i_write_enable(0) <= '1';           -- on
      
      state_next <= fetch;
    
    -- itype alle instructions für die ALU
    when itype_alu =>
      alu_i_input1          <= reg_o_r1_out;     --
      alu_i_input2          <= imm_o_immediate;  -- output immediate
      pc_i_en_pc(0)         <= '1';              -- enable pc
      pc_i_doJump(0)        <= '0';              --
      ram_i_writeEnable(0)  <= '0';              --
      reg_i_en_reg_wb(0)    <= '1';              -- on
      reg_i_data_in         <= alu_o_result;     -- 
      reg_i_write_enable(0) <= '1';              -- on
      
      state_next <= fetch;
    
    -- uJALR Instruction
    when itype_jalr_1 =>
      alu_i_input1          <= reg_o_r1_out;     -- 
      alu_i_input2          <= imm_o_immediate;  -- output immediate
      pc_i_en_pc(0)         <= '1';              -- pc enable
      pc_i_doJump(0)        <= '0';              --
      ram_i_writeEnable(0)  <= '0';              --
      reg_i_en_reg_wb(0)    <= '0';              --
      reg_i_data_in         <= alu_o_result;     -- 
      reg_i_write_enable(0) <= '0';              --
      
      state_next <= itype_jalr_2;
      
     
     when itype_jalr_2 =>
      alu_i_input1                  <= reg_o_r1_out;     -- 
      alu_i_input2                  <= imm_o_immediate;  -- output immediate
      pc_i_en_pc(0)                 <= '0';              -- 
      pc_i_doJump(0)                <= '1';              -- pc jump enable
      ram_i_writeEnable(0)          <= '0';              --
      reg_i_en_reg_wb(0)            <= '1';              -- ?? enable 1
      reg_i_data_in(13 downto 0)    <= pc_o_addr;        -- pc addr in
      reg_i_write_enable(0)         <= '1';              -- ?? enable 2
      
      state_next <= fetch;
      
      -- Load Befehle
      when itype_load_1 =>
        alu_i_input1          <= reg_o_r1_out;      -- 
        alu_i_input2          <= imm_o_immediate;   -- output immediate
        pc_i_en_pc(0)         <= '0';               --
        pc_i_doJump(0)        <= '0';               -- 
        ram_i_writeEnable(0)  <= '0';               -- 
        reg_i_en_reg_wb(0)    <= '0';               -- 
        reg_i_data_in         <= alu_o_result;      -- 
        reg_i_write_enable(0) <= '0';               -- 
      
        state_next <= itype_load_2;
        
      when itype_load_2 =>
        alu_i_input1          <= reg_o_r1_out;      -- 
        alu_i_input2          <= imm_o_immediate;   -- output immediate
        pc_i_en_pc(0)         <= '1';               --
        pc_i_doJump(0)        <= '0';               -- 
        ram_i_writeEnable(0)  <= '0';               -- 
        reg_i_en_reg_wb(0)    <= '1';               -- ?? enable 1
        
        reg_i_write_enable(0) <= '1';               -- ?? enable 2
       
       -- zwischen den unterschiedlichen Load instructions unterscheiden
        case decode_o_op_code is
          when uLB  => reg_i_data_in <= std_logic_vector(resize(signed(ram_o_dataOut(31 downto 24)), 32));
          when uLH  => reg_i_data_in <= std_logic_vector(resize(signed(ram_o_dataOut(31 downto 16)), 32));
          when uLW  => reg_i_data_in <= ram_o_dataOut;
          when uLBU => reg_i_data_in <= "000000000000000000000000" & ram_o_dataOut(31 downto 24);
          when uLHU => reg_i_data_in <= "0000000000000000" & ram_o_dataOut(31 downto 16);
          when others => reg_i_data_in <= ram_o_dataOut;
        end case;
      
        state_next <= fetch;
    
    
      when others =>
        alu_i_input1          <= reg_o_r1_out;      -- alu 1 input
        alu_i_input2          <= reg_o_r2_out;      -- alu 2 input
        pc_i_en_pc(0)         <= '0';               -- pc enable
        pc_i_doJump(0)        <= '0';               -- pc jump enable
        ram_i_writeEnable(0)  <= '0';               -- ram write enable
        reg_i_en_reg_wb(0)    <= '0';               -- ?? enable 1
        reg_i_data_in         <= alu_o_result;      -- register data in
        reg_i_write_enable(0) <= '0';               -- ?? enable 2
      
        state_next <= fetch;
    
    end case;
  end process;
  
  
  alu : entity work.alu(behavioral)
    port map(
      alu_opc => decode_o_op_code,
      input1 => alu_i_input1,
      input2 => alu_i_input2,
      result => alu_o_result
    );
  
  
  decode : entity work.decode(behavioral)
    port map(
      inst_in => ram_o_instruction,
      reg_1 => decode_o_reg_1,
      reg_2 => decode_o_reg_2,
      reg_w => decode_o_reg_w,
      op_code => decode_o_op_code
    );
    
  imm : entity work.imm(behavioral)
    port map(
      instruction => ram_o_instruction,
      immediate => imm_o_immediate
    );
  
  pc : entity work.pc(behavioral)
    port map(
      clk => clk,
      en_pc => pc_i_en_pc,
      addr_calc => alu_o_result(13 downto 0), -- addresse ist deutlich kleiner als output von alu
      doJump => pc_i_doJump,
      addr => pc_o_addr
    );
    
  ram : entity work.ram(behavioral)
    port map(
      clk => clk,
      instructionAdr => pc_o_addr,
      dataAdr => alu_o_result(13 downto 0),
      
      writeEnable => ram_i_writeEnable,
      
      dataIn => reg_o_r2_out,
      instruction => ram_o_instruction,
      dataOut => ram_o_dataOut
    );
    
    registers : entity work.registers(behavioral)
      port map(
          clk => clk,
          en_reg_wb => reg_i_en_reg_wb,
          data_in => reg_i_data_in,
          wr_idx => decode_o_reg_w,
          r1_idx => decode_o_reg_1,
          r2_idx => decode_o_reg_2,
          write_enable => reg_i_write_enable,
          r1_out => reg_o_r1_out,
          r2_out => reg_o_r2_out
      );
  

end architecture;











