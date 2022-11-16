library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;

entity ram is

  generic (initMem : ram_t := (others => (others => '0')));

  port (
    clk              : in  std_logic;

    instructionAdr : in  ram_addr_t; -- Address instruction
    dataAdr        : in  ram_addr_t; -- Address data

    writeEnable     : in  one_bit;

    dataIn          : in  word; -- Write data
    instruction     : out word; -- Get instruction
    dataOut         : out word -- Read data

    );
    
end ram;


architecture behavioral of ram is

  signal store    : ram_t := initMem;

begin
  process(clk)
  begin
    if rising_edge(clk) then

      -- only store data if writeEnable is high
      if writeEnable(0) = '1' then
        store(to_integer(unsigned(dataAdr))) <= dataIn;
      end if; -- spielt hier die Reinfolge eine Rolle und welchen Output bekommen wir wenn wir gleichzeitig schreiben?

      -- always output data from both address locations
      instruction <= store(to_integer(unsigned(instructionAdr)));
      dataOut <= store(to_integer(unsigned(dataAdr)));


    end if;
  end process;
end behavioral;