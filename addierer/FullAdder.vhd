library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is

  port (a    : in  std_logic;
        b    : in  std_logic;
        cin  : in  std_logic;
        s    : out std_logic;
        cout : out std_logic);

end FullAdder;

architecture Structural of FullAdder is

  signal sum1   : std_logic;
  signal carry1 : std_logic;
  signal carry2 : std_logic;

begin

  adder1 : entity work.HalfAdder(Behavioral)
    port map (a    => a,
              b    => b,
              s    => sum1,
              cout => carry1);

-- Missing HalfAdder adder2 (similar to adder1)
  adder2 : entity work.HalfAdder(Behavioral)
    port map (a   => cin,
              b   => sum1,
              s   => s,
              cout => carry2);


  
  -- Generate full-adder carry
  cout <= carry1 or carry2;

end architecture;
