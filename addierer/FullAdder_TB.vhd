library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity FullAdder_TB is
end FullAdder_TB;

architecture Behavioral of FullAdder_TB is

  -- Width of adder
  constant adderWidth : natural := 8;

  -- Clock
  signal clk : std_logic;
  
  -- Inputs
  signal a   : std_logic;
  signal b   : std_logic;
  signal cin : std_logic := '0';

  -- Outputs
  signal s    : std_logic;
  signal cout : std_logic;

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : entity work.FullAdder(Structural)
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

    -- Print some message
    write(lineBuffer, string'("Start simulation: "));
    writeline(output, lineBuffer);

    -- Set a stimulus
    a <= '1';
    b <= '1';
      
    -- Wait 20ns
    wait for 20 ns;

    -- We need more stimuli to test the FullAdder
    cin <= '1';

    wait for 20 ns;

    b <= '0';
    cin <= '0';

    wait for 10 ns;

    a <= '0';
    cin <= '1';

    wait for 15 ns;

    b <= '1';
    cin <= '0';

    -- Tell that the simulation is over
    write(lineBuffer, string'("end of simulation: "));
    writeline(output, lineBuffer);

    -- Simply wait forever and terminate the simulation
    wait;
  end process;

end architecture;
