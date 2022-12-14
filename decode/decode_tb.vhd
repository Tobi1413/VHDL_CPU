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


entity decode_tb is
end decode_tb;

architecture Behavioral of decode_tb is

  signal inst_in : instruction;
  signal reg_1 : reg_idx;
  signal reg_2 : reg_idx;
  signal reg_w : reg_idx;
  signal op_code : uOP;
  
  
  --clk signal/clk period
	signal clk : std_logic;
	constant clk_period : time := 10 ns;
	
begin
  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  
  
  uut : entity work.decode(Behavioral)
    port map(inst_in => inst_in,
             reg_1 => reg_1,
             reg_2 => reg_2,
             reg_w => reg_w,
             op_code => op_code);
             
  
  -- Stimulus process
  stim_proc : process
  
  variable var_reg_1 : reg_idx := "10000";
  variable var_reg_2 : reg_idx := "10001";
  variable var_reg_w : reg_idx := "10010";
  variable var_op_code : opcode := "0110011";
  variable var_imm_12 : imm_12 := "000000000000";
  
  variable counter : integer := 0;
  
  begin
  
  
  -- R-Type Tests
  report "start: R-Type Tests";
  for I in 0 to 7 loop
    
    inst_in <= "0000000" & var_reg_2 & var_reg_1 & std_logic_vector(TO_UNSIGNED(I, 3)) & var_reg_w & var_op_code;
    
    wait for 1 ns;
    
    -- korrekte Register?
    assert reg_1 = var_reg_1 report "register 1 inkorrekt";
    assert reg_2 = var_reg_2 report "register 2 inkorrekt";
    assert reg_w = var_reg_w report "register w inkorrekt";
    
    -- korrekter opcode?
    if I = 0 then assert op_code = uADD  report "falscher op_code: uADD";  end if;
    if I = 1 then assert op_code = uSLL  report "falscher op_code: uSLL";  end if;
    if I = 2 then assert op_code = uSLT  report "falscher op_code: uSLT";  end if;
    if I = 3 then assert op_code = uSLTU report "falscher op_code: uSLTU"; end if;
    if I = 4 then assert op_code = uXOR  report "falscher op_code: uXOR";  end if;
    if I = 5 then assert op_code = uSRL  report "falscher op_code: uSRL";  end if;
    if I = 6 then assert op_code = uOR   report "falscher op_code: uOR";   end if;
    if I = 7 then assert op_code = uAND  report "falscher op_code: uAND";  end if;

    wait for 1 ns;
  end loop;
  
  -- Manuelle Tests für die flag in funct7
  report "start: Manuelle Tests für die flag in funct7";
  inst_in <= "0100000" & var_reg_2 & var_reg_1 & "000" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert op_code = uSUB report "falscher op_code: uSUB";
  
  inst_in <= "0100000" & var_reg_2 & var_reg_1 & "101" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert op_code = uSRA report "falscher op_code: uSRA";
  
  inst_in <= "0000000" & var_reg_2 & var_reg_1 & "000" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert op_code = uADD report "falscher op_code: uADD";
  
  inst_in <= "0000000" & var_reg_2 & var_reg_1 & "101" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert op_code = uSRL report "falscher op_code: uSRL";
  
  
  -- I-Type Tests
  -- jump and link register
  
  report "start: jump and link register";
  var_op_code := "1100111";
  
  inst_in <= var_imm_12 & var_reg_1 & "000" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uJALR report "falscher op_code: uJALR";
  
  
  -- load
  report "start: load";
  var_op_code := "0000011";
  
  inst_in <= var_imm_12 & var_reg_1 & "000" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uLB report "falscher op_code: uLB";
  
  inst_in <= var_imm_12 & var_reg_1 & "001" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uLH report "falscher op_code: uLH";
  
  inst_in <= var_imm_12 & var_reg_1 & "010" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uLW report "falscher op_code: uLW";
  
  inst_in <= var_imm_12 & var_reg_1 & "100" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uLBU report "falscher op_code: uLBU";
  
  inst_in <= var_imm_12 & var_reg_1 & "101" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uLHU report "falscher op_code: uLHU";
  
  
  -- alu immediate
  report "start: alu immediate";
  var_op_code := "0010011";
  
  inst_in <= var_imm_12 & var_reg_1 & "000" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uADDI report "falscher op_code: uADDI";
  
  inst_in <= var_imm_12 & var_reg_1 & "010" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uSLTI report "falscher op_code: uSLTI";
  
  inst_in <= var_imm_12 & var_reg_1 & "011" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uSLTIU report "falscher op_code: uSLTIU";
  
  inst_in <= var_imm_12 & var_reg_1 & "100" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uXORI report "falscher op_code: uADDI";
  
  inst_in <= var_imm_12 & var_reg_1 & "110" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uORI report "falscher op_code: uORI";
  
  inst_in <= var_imm_12 & var_reg_1 & "111" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uANDI report "falscher op_code: uANDI";
  
  inst_in <= var_imm_12 & var_reg_1 & "001" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uSLLI report "falscher op_code: uSLLI";
  
  inst_in <= var_imm_12 & var_reg_1 & "101" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uSRLI report "falscher op_code: uSRLI";
  
  var_imm_12 := "010000000000";
  inst_in <= var_imm_12 & var_reg_1 & "101" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = var_reg_1 report "register 1 inkorrekt";
  assert reg_w = var_reg_w report "register w inkorrekt";
  assert op_code = uSRAI report "falscher op_code: uSRAI";
  
  
  -- ecall
  var_op_code := "1110011";
  inst_in <= var_imm_12 & var_reg_1 & "000" & var_reg_w & var_op_code;
  wait for 1 ns;
  assert reg_1 = "00000" report "register 1 inkorrekt";
  assert reg_w = "00000" report "register w inkorrekt";
  assert op_code = uECALL report "falscher op_code: uECALL";
  
  
  
  -- invalid opcode Test
  report "start: invalid opcode Test";
  var_op_code := "0000001";
  
  for I in 0 to 7 loop
    
    inst_in <= "0000000" & var_reg_2 & var_reg_1 & std_logic_vector(TO_UNSIGNED(I, 3)) & var_reg_w & var_op_code;
--    report "number is: " & integer'image(to_integer(unsigned(std_logic_vector(TO_UNSIGNED(I, 3)))));
    
    wait for 1 ns;
    
    assert reg_1 = "00000" report "register 1 inkorrekt";
    assert reg_2 = "00000" report "register 2 inkorrekt";
    assert reg_w = "00000" report "register w inkorrekt";
    assert op_code = uNOP report "falscher opcode. Muss uNOP sein";

    wait for 1 ns;
  end loop;
  
  
  report "Ende der Tests!";
  wait;
  end process;
end Behavioral;
