library ieee;
use ieee.std_logic_1164.all;

entity HalfAdder is

  port (a    : in  std_logic;
        b    : in  std_logic;
        s    : out std_logic;
        cout : out std_logic);

end HalfAdder;

architecture Behavioral of HalfAdder is

begin

  -- Calculate the sum
  s <= a xor b;

  -- Calculate the overflow
  cout <= a and b;
  
end architecture;
