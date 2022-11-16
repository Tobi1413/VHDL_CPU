library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;

entity ram is

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

signal instructionAdr_sig : ram_addr_t;
signal dataAdr_sig : ram_addr_t;
signal instruction_sig : byte;
signal dataOut_sig : byte;
signal dataIn_sig : byte;

begin
  ram : for I in 0 to width - 1 generate
  begin
    ram : entity work.ram_block(behavioral)
      port map( addr_a => instructionAdr_sig(I),
                data_read_a => instruction_sig(I),
                write_b => writeEnable(I),
                addr_b => dataAdr(I),
                data_read_b => dataOut(I),
                data_write_b => dataIn_sig(I));
  end generate;
  
  process(clk)
  begin

-- Multiplexer zum Übergeben der einzelnen Instruktions Adressen an die RAM Blöcke
    with instructionAdr(ram_addr_size -1 downto ram_addr_size -2) select
      instructionAdr_sig(0) <= instructionAdr(ram_addr_size -3 downto 0) + 0 when "00",
                               instructionAdr(ram_addr_size -3 downto 0) + 3 when "01",
                               instructionAdr(ram_addr_size -3 downto 0) + 2 when "10",
                               instructionAdr(ram_addr_size -3 downto 0) + 1 when others;

    with instructionAdr(ram_addr_size -1 downto ram_addr_size -2) select
      instructionAdr_sig(1) <= instructionAdr(ram_addr_size -3 downto 0) + 1 when "00",
                               instructionAdr(ram_addr_size -3 downto 0) + 0 when "01",
                               instructionAdr(ram_addr_size -3 downto 0) + 3 when "10",
                               instructionAdr(ram_addr_size -3 downto 0) + 2 when others;

    with instructionAdr(ram_addr_size -1 downto ram_addr_size -2) select
      instructionAdr_sig(2) <= instructionAdr(ram_addr_size -3 downto 0) + 2 when "00",
                               instructionAdr(ram_addr_size -3 downto 0) + 1 when "01",
                               instructionAdr(ram_addr_size -3 downto 0) + 0 when "10",
                               instructionAdr(ram_addr_size -3 downto 0) + 3 when others;

    with instructionAdr(ram_addr_size -1 downto ram_addr_size -2) select
      instructionAdr_sig(3) <= instructionAdr(ram_addr_size -3 downto 0) + 3 when "00",
                               instructionAdr(ram_addr_size -3 downto 0) + 2 when "01",
                               instructionAdr(ram_addr_size -3 downto 0) + 1 when "10",
                               instructionAdr(ram_addr_size -3 downto 0) + 0 when others;


-- Multiplexer zum Übergeben der einzelnen Daten Adressen an die RAM Blöcke
    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataAdr_sig(0) <= dataAdr(ram_addr_size -3 downto 0) + 0 when "00",
                        dataAdr(ram_addr_size -3 downto 0) + 3 when "01",
                        dataAdr(ram_addr_size -3 downto 0) + 2 when "10",
                        dataAdr(ram_addr_size -3 downto 0) + 1 when others;

    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataAdr_sig(1) <= dataAdr(ram_addr_size -3 downto 0) + 1 when "00",
                        dataAdr(ram_addr_size -3 downto 0) + 0 when "01",
                        dataAdr(ram_addr_size -3 downto 0) + 3 when "10",
                        dataAdr(ram_addr_size -3 downto 0) + 2 when others;

    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataAdr_sig(2) <= dataAdr(ram_addr_size -3 downto 0) + 2 when "00",
                        dataAdr(ram_addr_size -3 downto 0) + 1 when "01",
                        dataAdr(ram_addr_size -3 downto 0) + 0 when "10",
                        dataAdr(ram_addr_size -3 downto 0) + 3 when others;

    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataAdr_sig(3) <= dataAdr(ram_addr_size -3 downto 0) + 3 when "00",
                        dataAdr(ram_addr_size -3 downto 0) + 2 when "01",
                        dataAdr(ram_addr_size -3 downto 0) + 1 when "10",
                        dataAdr(ram_addr_size -3 downto 0) + 0 when others;

-- Multiplexer zum Übergeben der einzelnen Daten Bytes an die RAM Blöcke
    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataIn_sig(0) <= dataIn(31 downto 24) when "00",
                       dataIn(7  downto 0)  when "01",
                       dataIn(15 downto 8)  when "10",
                       dataIn(23 downto 16) when others;

    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataIn_sig(1) <= dataIn(23 downto 16) when "00",
                       dataIn(31 downto 24) when "01",
                       dataIn(7  downto 0)  when "10",
                       dataIn(15 downto 8)  when others;

    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataIn_sig(2) <= dataIn(15 downto 8)  when "00",
                       dataIn(23 downto 16) when "01",
                       dataIn(31 downto 24) when "10",
                       dataIn(7  downto 0)  when others;

    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataIn_sig(3) <= dataIn(7  downto 0)  when "00",
                       dataIn(15 downto 8)  when "01",
                       dataIn(23 downto 16) when "10",
                       dataIn(31 downto 24) when others;


-- Multiplexer zum richtigen zusammensetzen der Bytes zu einem Instruktions Wort
    with instructionAdr(ram_addr_size -1 downto ram_addr_size -2) select
      instruction <= instruction_sig(0) & instruction_sig(1) & instruction_sig(2) & instruction_sig(3) when "00",
                     instruction_sig(1) & instruction_sig(2) & instruction_sig(3) & instruction_sig(0) when "01",
                     instruction_sig(2) & instruction_sig(3) & instruction_sig(0) & instruction_sig(1) when "10",
                     instruction_sig(3) & instruction_sig(0) & instruction_sig(1) & instruction_sig(2) when others,

-- Multiplexer zum richtigen zusammensetzen der Bytes zu einem Daten Wort
    with dataAdr(ram_addr_size -1 downto ram_addr_size -2) select
      dataOut <= dataOut_sig(0) & dataOut_sig(1) & dataOut_sig(2) & dataOut_sig(3) when "00",
                 dataOut_sig(1) & dataOut_sig(2) & dataOut_sig(3) & dataOut_sig(0) when "01",
                 dataOut_sig(2) & dataOut_sig(3) & dataOut_sig(0) & dataOut_sig(1) when "10",
                 dataOut_sig(3) & dataOut_sig(0) & dataOut_sig(1) & dataOut_sig(2) when others,



            

  end process;
end behavioral;