library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library work;
use work.riscv_types.all;

entity ram_TB is
end ram_TB;

architecture Behavioral of ram_TB is

  -- Clock
  signal clk : std_logic;
  constant clk_period : time := 10 ns;


  signal testCorrect : std_logic;


  -- all inputs and outputs of the ram entity
  signal instructionAdr : ram_addr_t;
  signal dataAdr : ram_addr_t;

  signal writeEnable : one_bit;

  signal dataIn : word;
  signal instruction : word;
  signal dataOut : word; 

begin
  
  uut : entity work.ram(behavioral)
    port map(
      clk => clk,
      instructionAdr => instructionAdr,
      dataAdr => dataAdr,

      writeEnable => writeEnable,

      dataIn => dataIn,
      instruction => instruction,
      dataOut => dataOut
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

    -- Text I/O
    variable lineBuffer : line;

  begin

    -- Wait for the first rising edge
    wait until rising_edge(clk);

    -- Print the top element
    write(lineBuffer, string'("Start simulation: "));
    writeline(output, lineBuffer);


    -- formel zum hochzählen:
    -- J + ram_addr_size * I

    -- formel für pseudo random zahlen:
    -- ((J * I * 123456789) mod 2**31) - 1

    wait for 5 ns;

    -- 
    for I in 0 to 83 loop
      
      -- loop for filling the ram
      writeEnable(0) <= '1';
      for J in 0 to ram_addr_size - 1 loop
        dataAdr <= std_logic_vector(to_unsigned(J, ram_addr_size));
        dataIn <= std_logic_vector(to_unsigned(J + ram_addr_size * I, wordWidth));
        wait for 10 ns;
      end loop;
    
      writeEnable(0) <= '0';

      -- loop for reading the ram and checking for equality to expected values
      for J in 0 to ram_addr_size - 1 loop
        dataAdr <= std_logic_vector(to_unsigned(J, ram_addr_size));

        wait for 8 ns; -- some time is needed before the dataout is accurate

        -- test for equality
        if dataOut = std_logic_vector(to_unsigned(J + ram_addr_size * I, wordWidth)) then
          testCorrect <= '1';
        else
          testCorrect <= '0';
          write(lineBuffer, string'("Fehler aufgetreten"));
          writeline(output, lineBuffer);
        end if;

        wait for 2 ns;
      end loop;


    end loop;


    wait;
  end process;

end architecture;