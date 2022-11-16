library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity RCAdder_TB is
end RCAdder_TB;

architecture Behavioral of RCAdder_TB is

  -- Width of adder
  constant adderWidth : natural := 8;

  -- Clock
  signal clk : std_logic;
  
  -- Inputs
  signal a   : std_logic_vector(adderWidth - 1 downto 0);
  signal b   : std_logic_vector(adderWidth - 1 downto 0);
  signal cin : std_logic := '0';

  -- Outputs
  signal s    : std_logic_vector(adderWidth - 1 downto 0);
  signal cout : std_logic;

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : entity work.RCAdder(Behavioral)
    generic map (width => adderWidth)
    port map (a    => a, 
              b    => b,
              cin  => cin,
              s    => s,
              cout => cout);

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

    -- Set a stimulus
    a <= std_logic_vector(to_unsigned(77, adderWidth));
    b <= std_logic_vector(to_unsigned(59, adderWidth));
      
    -- Wait 10ns
    wait for 10 ns;

   -- Set a stimulus
    a <= std_logic_vector(to_unsigned(11, adderWidth));
    b <= std_logic_vector(to_unsigned(9, adderWidth));


   -- More stimuli! Maybe we can test all possible inputs? 
    a <= std_logic_vector(to_unsigned(128, adderWidth));
    for I in 0 to 2**adderWidth - 1 loop
      b <= std_logic_vector(to_unsigned(I, adderWidth));

      for J in 0 to 2**adderWidth - 1 loop
        a <= std_logic_vector(to_unsigned(J, adderWidth));

        wait for 10 ns;
      end loop;

      wait for 10 ns;
   end loop;

    
    -- Simply wait forever
    wait;
    
  end process;

end architecture;
