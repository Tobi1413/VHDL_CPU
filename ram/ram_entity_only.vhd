-------------------------------------------------------------------------------------------------------------
-- Project: VHDL_CPU
-- Author: Maher Popal & Tobias Blumers 
-- Description: 
-- Additional Comments: kann man mit "for generate" statements machen, war mir aber noch etwas zu schwer
-------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;
use work.program.all;

entity ram is

  generic (width : integer := 4);

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

signal instructionAdr_sig_0 : ram_addr_phys_t;
signal instructionAdr_sig_1 : ram_addr_phys_t;
signal instructionAdr_sig_2 : ram_addr_phys_t;
signal instructionAdr_sig_3 : ram_addr_phys_t;

signal dataAdr_sig_0 : ram_addr_phys_t;
signal dataAdr_sig_1 : ram_addr_phys_t;
signal dataAdr_sig_2 : ram_addr_phys_t;
signal dataAdr_sig_3 : ram_addr_phys_t;

signal instruction_sig_0 : byte;
signal instruction_sig_1 : byte;
signal instruction_sig_2 : byte;
signal instruction_sig_3 : byte;

signal dataOut_sig_0 : byte;
signal dataOut_sig_1 : byte;
signal dataOut_sig_2 : byte;
signal dataOut_sig_3 : byte;

signal dataIn_sig_0 : byte;
signal dataIn_sig_1 : byte;
signal dataIn_sig_2 : byte;
signal dataIn_sig_3 : byte;

constant init_data_0 : ram_t := (X"02", X"02", X"ff", X"00", X"40",  others => (others => '0'));
constant init_data_1 : ram_t := (X"07", X"b7", X"d7", X"24", X"87", others => (others => '0'));
constant init_data_2 : ram_t := (X"87", X"87", X"87", X"04", X"d4", others => (others => '0'));
constant init_data_3 : ram_t := (X"93", X"93", X"13", X"13", X"b3", others => (others => '0'));



begin
--  init_data_1 <= (others => (others => '0'));

--  init_data_1(0)(7 downto 0) <= "01010100";
--  init_data_1(1)(7 downto 0) <= "01110100";
--  init_data_1(2)(7 downto 0) <= "10010100";
  
--  init_data_2(0)(7 downto 0) <= "00000100";
--  init_data_2(1)(7 downto 0) <= "10000100";
--  init_data_2(2)(7 downto 0) <= "00000101";
  
--  init_data_3(0)(7 downto 0) <= "00010011";
--  init_data_3(1)(7 downto 0) <= "10010011";
--  init_data_3(2)(7 downto 0) <= "00110011";
  
  
-- Erstellen der 4 RAM Bloecke
  ram0 : entity work.ram_block(behavioral)
      generic map(initMem => init_data_0)
      port map( clk => clk,
                addr_a => instructionAdr_sig_0,
                data_read_a => instruction_sig_0,
                write_b => writeEnable(0),
                addr_b => dataAdr_sig_0,
                data_read_b => dataOut_sig_0,
                data_write_b => dataIn_sig_0);
                
  ram1 : entity work.ram_block(behavioral)
      generic map(initMem => init_data_1)
      port map( clk => clk,
                addr_a => instructionAdr_sig_1,
                data_read_a => instruction_sig_1,
                write_b => writeEnable(0),
                addr_b => dataAdr_sig_1,
                data_read_b => dataOut_sig_1,
                data_write_b => dataIn_sig_1);
 
  ram2 : entity work.ram_block(behavioral)
      generic map(initMem => init_data_2)
      port map( clk => clk,
                addr_a => instructionAdr_sig_2,
                data_read_a => instruction_sig_2,
                write_b => writeEnable(0),
                addr_b => dataAdr_sig_2,
                data_read_b => dataOut_sig_2,
                data_write_b => dataIn_sig_2); 
                
  ram3 : entity work.ram_block(behavioral)
      generic map(initMem => init_data_3)
      port map( clk => clk,
                addr_a => instructionAdr_sig_3,
                data_read_a => instruction_sig_3,
                write_b => writeEnable(0),
                addr_b => dataAdr_sig_3,
                data_read_b => dataOut_sig_3,
                data_write_b => dataIn_sig_3); 


-- Multiplexer zum Uebergeben der einzelnen Instruktions Adressen an die RAM Bloecke
    with instructionAdr(1 downto 0) select
      instructionAdr_sig_0 <= std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "01",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "10",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

    with instructionAdr(1 downto 0) select
      instructionAdr_sig_1 <= std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "10",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

    with instructionAdr(1 downto 0) select
      instructionAdr_sig_2 <= std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "10",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

    with instructionAdr(1 downto 0) select
      instructionAdr_sig_3 <= std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "10",
                              std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when others;


-- Multiplexer zum Uebergeben der einzelnen Daten Adressen an die RAM Bloecke
    with dataAdr(1 downto 0) select
      dataAdr_sig_0 <= std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "01",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "10",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

    with dataAdr(1 downto 0) select
      dataAdr_sig_1 <= std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "10",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

    with dataAdr(1 downto 0) select
      dataAdr_sig_2 <= std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "10",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

    with dataAdr(1 downto 0) select
      dataAdr_sig_3 <= std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "10",
                       std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when others;


-- Multiplexer zum Uebergeben der einzelnen Daten Bytes an die RAM Bloecke
    with dataAdr(1 downto 0) select
      dataIn_sig_0 <= dataIn(31 downto 24) when "00",
                      dataIn(7  downto 0)  when "01",
                      dataIn(15 downto 8)  when "10",
                      dataIn(23 downto 16) when others;

    with dataAdr(1 downto 0) select
      dataIn_sig_1 <= dataIn(23 downto 16) when "00",
                      dataIn(31 downto 24) when "01",
                      dataIn(7  downto 0)  when "10",
                      dataIn(15 downto 8)  when others;

    with dataAdr(1 downto 0) select
      dataIn_sig_2 <= dataIn(15 downto 8)  when "00",
                      dataIn(23 downto 16) when "01",
                      dataIn(31 downto 24) when "10",
                      dataIn(7  downto 0)  when others;

    with dataAdr(1 downto 0) select
      dataIn_sig_3 <= dataIn(7  downto 0)  when "00",
                      dataIn(15 downto 8)  when "01",
                      dataIn(23 downto 16) when "10",
                      dataIn(31 downto 24) when others;


-- Multiplexer zum richtigen zusammensetzen der Bytes zu einem Instruktions Wort
    with instructionAdr(1 downto 0) select
      instruction <= instruction_sig_0 & instruction_sig_1 & instruction_sig_2 & instruction_sig_3 when "00",
                     instruction_sig_1 & instruction_sig_2 & instruction_sig_3 & instruction_sig_0 when "01",
                     instruction_sig_2 & instruction_sig_3 & instruction_sig_0 & instruction_sig_1 when "10",
                     instruction_sig_3 & instruction_sig_0 & instruction_sig_1 & instruction_sig_2 when others;

-- Multiplexer zum richtigen zusammensetzen der Bytes zu einem Daten Wort
    with dataAdr(1 downto 0) select
      dataOut <= dataOut_sig_0 & dataOut_sig_1 & dataOut_sig_2 & dataOut_sig_3 when "00",
                 dataOut_sig_1 & dataOut_sig_2 & dataOut_sig_3 & dataOut_sig_0 when "01",
                 dataOut_sig_2 & dataOut_sig_3 & dataOut_sig_0 & dataOut_sig_1 when "10",
                 dataOut_sig_3 & dataOut_sig_0 & dataOut_sig_1 & dataOut_sig_2 when others;

end behavioral;