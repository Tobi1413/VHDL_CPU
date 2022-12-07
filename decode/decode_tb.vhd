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
  
  variable counter : integer := 0;
  
  begin
  
  
  -- R-Type Tests
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
  
  
  
  
  -- invalid opcode Test
  var_op_code := "0000001";
  
  for I in 0 to 7 loop
    
    inst_in <= "0000000" & var_reg_2 & var_reg_1 & std_logic_vector(TO_UNSIGNED(I, 3)) & var_reg_w & var_op_code;
--    report "number is: " & integer'image(to_integer(unsigned(std_logic_vector(TO_UNSIGNED(I, 3)))));
    
    wait for 1 ns;
    
    assert reg_1 = var_reg_1 report "register 1 inkorrekt";
    assert reg_2 = var_reg_2 report "register 2 inkorrekt";
    assert reg_w = var_reg_w report "register w inkorrekt";
    assert op_code = uNOP report "falscher opcode. Muss uNOP sein";

    wait for 1 ns;
  end loop;
  
  wait;
  end process;
end Behavioral;
