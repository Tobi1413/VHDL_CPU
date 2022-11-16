library ieee;
use ieee.std_logic_1164.all;

entity RCAdder is

  generic (width : integer := 6);

  port (a    : in  std_logic_vector(width - 1 downto 0);
        b    : in  std_logic_vector(width - 1 downto 0);
        cin  : in  std_logic;
        s    : out std_logic_vector(width - 1 downto 0);
        cout : out std_logic);

end RCAdder;

architecture Behavioral of RCAdder is

  signal carry : std_logic_vector(width downto 0);

begin

  -- Generate an array of full adders
  adders : for I in 0 to width - 1 generate
  begin
    -- Generate the Ith full adder
    adder : entity work.FullAdder(Structural)
      port map (a    => a(I),
                b    => b(I),
                cin  => carry(I),
                s    => s(I),
                cout => carry(I+1));

  end generate;

  -- Add carry in
  carry(0) <= cin;

  -- Generate the carry out
  cout <= carry(carry'high);

end architecture;
