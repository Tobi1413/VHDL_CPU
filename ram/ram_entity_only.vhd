-------------------------------------------------------------------------------------------------------------
-- Project: VHDL_CPU
-- Author: Maher Popal & Tobias Blumers 
-- Description: 
-- Additional Comments: todo: Muss eigentlich noch zwischen sb, sh, sw unterscheiden können
-- Arbeitet intern mit LSB first. gibt nach außen aber mit MSB first aus
-------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;
use work.program.all;

entity ram is

  generic(
    width : integer := 4;
    init_data_0 : ram_t := (others => (others => '0'));
    init_data_1 : ram_t := (others => (others => '0'));
    init_data_2 : ram_t := (others => (others => '0'));
    init_data_3 : ram_t := (others => (others => '0'))
  );

  port (
    clk              : in  std_logic;

    instructionAdr  : in  ram_addr_t; -- Address instruction
    dataAdr         : in  ram_addr_t; -- Address data
    
    op_code         : in uOP;
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

signal writeEnable_sig_0 : one_bit;
signal writeEnable_sig_1 : one_bit;
signal writeEnable_sig_2 : one_bit;
signal writeEnable_sig_3 : one_bit;

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

constant b01 : word := X"00300493";
constant b02 : word := X"05b00a93";
constant b03 : word := X"00ea9a93";
constant b04 : word := X"00300993";
constant b05 : word := X"00e99993";
constant b06 : word := X"00000913";
constant b07 : word := X"00100593";
constant b08 : word := X"00100693";
constant b09 : word := X"00f69693";
constant b10 : word := X"03f00413";
constant b11 : word := X"00941413";
constant b12 : word := X"0d0000e7";

constant b13 : word := X"00300893";
constant b14 : word := X"00189893";
constant b15 : word := X"0c0000e7";
constant b16 : word := X"01100933";
constant b17 : word := X"ff199ae3";
constant b18 : word := X"0018d893";
constant b19 : word := X"0c0000e7";
constant b20 : word := X"01100933";
constant b21 : word := X"ff149ae3";
constant b22 : word := X"0d0000e7";

constant b23 : word := X"0326c463";
constant b24 : word := X"00a58633";
constant b25 : word := X"00b00533";
constant b26 : word := X"00c005b3";
constant b27 : word := X"0c0000e7";
constant b28 : word := X"0c0000e7";
constant b29 : word := X"0c0000e7";
constant b30 : word := X"0c0000e7";
constant b31 : word := X"00c00933";
constant b32 : word := X"0d0000e7";

constant b33 : word := X"00000913";
constant b34 : word := X"00000513";
constant b35 : word := X"00100593";
constant b36 : word := X"05800067";

constant b37 : word := X"1f8ff393";
constant b38 : word := X"0033d393";
constant b39 : word := X"008ff333";
constant b40 : word := X"00935313";
constant b41 : word := X"00000293";
constant b42 : word := X"00000213";
constant b43 : word := X"00530863";
constant b44 : word := X"00720233";
constant b45 : word := X"00128293";
constant b46 : word := X"ff5ff06f";

constant b47 : word := X"00400933";
constant b48 : word := X"0d0000e7";

constant b49 : word := X"00000a13";
constant b50 : word := X"001a0a13";
constant b51 : word := X"ff4afee3";
constant b52 : word := X"00008067";

constant b53 : word := X"007fff13";
constant b54 : word := X"00000e93";
constant b55 : word := X"f5df0ce3";
constant b56 : word := X"00100e93";
constant b57 : word := X"f7df0ce3";
constant b58 : word := X"00200e93";
constant b59 : word := X"fbdf04e3";
constant b60 : word := X"0d000067";

 constant init_data_0_c : ram_t := (b01(31 downto 24), b02(31 downto 24), b03(31 downto 24), b04(31 downto 24), b05(31 downto 24), b06(31 downto 24), 
                                    b07(31 downto 24), b08(31 downto 24), b09(31 downto 24), b10(31 downto 24), b11(31 downto 24), b12(31 downto 24),
                                    b13(31 downto 24), b14(31 downto 24), b15(31 downto 24), b16(31 downto 24), b17(31 downto 24), b18(31 downto 24), 
                                    b19(31 downto 24), b20(31 downto 24), b21(31 downto 24), b22(31 downto 24), b23(31 downto 24), b24(31 downto 24),
                                    b25(31 downto 24), b26(31 downto 24), b27(31 downto 24), b28(31 downto 24), b29(31 downto 24), b30(31 downto 24),
                                    b31(31 downto 24), b32(31 downto 24), b33(31 downto 24), b34(31 downto 24), b35(31 downto 24), b36(31 downto 24),
                                    b37(31 downto 24), b38(31 downto 24), b39(31 downto 24), b40(31 downto 24), b41(31 downto 24), b42(31 downto 24),
                                    b43(31 downto 24), b44(31 downto 24), b45(31 downto 24), b46(31 downto 24), b47(31 downto 24), b48(31 downto 24),
                                    b49(31 downto 24), b50(31 downto 24), b51(31 downto 24), b52(31 downto 24), b53(31 downto 24), b54(31 downto 24),
                                    b55(31 downto 24), b56(31 downto 24), b57(31 downto 24), b58(31 downto 24), b59(31 downto 24), b60(31 downto 24),
                                    others => (others => '0'));
 constant init_data_1_c : ram_t := (b01(23 downto 16), b02(23 downto 16), b03(23 downto 16), b04(23 downto 16), b05(23 downto 16), b06(23 downto 16), 
                                    b07(23 downto 16), b08(23 downto 16), b09(23 downto 16), b10(23 downto 16), b11(23 downto 16), b12(23 downto 16),
                                    b13(23 downto 16), b14(23 downto 16), b15(23 downto 16), b16(23 downto 16), b17(23 downto 16), b18(23 downto 16), 
                                    b19(23 downto 16), b20(23 downto 16), b21(23 downto 16), b22(23 downto 16), b23(23 downto 16), b24(23 downto 16),
                                    b25(23 downto 16), b26(23 downto 16), b27(23 downto 16), b28(23 downto 16), b29(23 downto 16), b30(23 downto 16),
                                    b31(23 downto 16), b32(23 downto 16), b33(23 downto 16), b34(23 downto 16), b35(23 downto 16), b36(23 downto 16),
                                    b37(23 downto 16), b38(23 downto 16), b39(23 downto 16), b40(23 downto 16), b41(23 downto 16), b42(23 downto 16),
                                    b43(23 downto 16), b44(23 downto 16), b45(23 downto 16), b46(23 downto 16), b47(23 downto 16), b48(23 downto 16),
                                    b49(23 downto 16), b50(23 downto 16), b51(23 downto 16), b52(23 downto 16), b53(23 downto 16), b54(23 downto 16),
                                    b55(23 downto 16), b56(23 downto 16), b57(23 downto 16), b58(23 downto 16), b59(23 downto 16), b60(23 downto 16),
                                    others => (others => '0'));
 constant init_data_2_c : ram_t := (b01(15 downto  8), b02(15 downto  8), b03(15 downto  8), b04(15 downto  8), b05(15 downto  8), b06(15 downto  8), 
                                    b07(15 downto  8), b08(15 downto  8), b09(15 downto  8), b10(15 downto  8), b11(15 downto  8), b12(15 downto  8),
                                    b13(15 downto  8), b14(15 downto  8), b15(15 downto  8), b16(15 downto  8), b17(15 downto  8), b18(15 downto  8),
                                    b19(15 downto  8), b20(15 downto  8), b21(15 downto  8), b22(15 downto  8), b23(15 downto  8), b24(15 downto  8),
                                    b25(15 downto  8), b26(15 downto  8), b27(15 downto  8), b28(15 downto  8), b29(15 downto  8), b30(15 downto  8),
                                    b31(15 downto  8), b32(15 downto  8), b33(15 downto  8), b34(15 downto  8), b35(15 downto  8), b36(15 downto  8),
                                    b37(15 downto  8), b38(15 downto  8), b39(15 downto  8), b40(15 downto  8), b41(15 downto  8), b42(15 downto  8), 
                                    b43(15 downto  8), b44(15 downto  8), b45(15 downto  8), b46(15 downto  8), b47(15 downto  8), b48(15 downto  8),
                                    b49(15 downto  8), b50(15 downto  8), b51(15 downto  8), b52(15 downto  8), b53(15 downto  8), b54(15 downto  8),
                                    b55(15 downto  8), b56(15 downto  8), b57(15 downto  8), b58(15 downto  8), b59(15 downto  8), b60(15 downto  8),
                                    others => (others => '0'));
 constant init_data_3_c : ram_t := (b01( 7 downto  0), b02( 7 downto  0), b03( 7 downto  0), b04( 7 downto  0), b05( 7 downto  0), b06( 7 downto  0), 
                                    b07( 7 downto  0), b08( 7 downto  0), b09( 7 downto  0), b10( 7 downto  0), b11( 7 downto  0), b12( 7 downto  0),
                                    b13( 7 downto  0), b14( 7 downto  0), b15( 7 downto  0), b16( 7 downto  0), b17( 7 downto  0), b18( 7 downto  0), 
                                    b19( 7 downto  0), b20( 7 downto  0), b21( 7 downto  0), b22( 7 downto  0), b23( 7 downto  0), b24( 7 downto  0), 
                                    b25( 7 downto  0), b26( 7 downto  0), b27( 7 downto  0), b28( 7 downto  0), b29( 7 downto  0), b30( 7 downto  0), 
                                    b31( 7 downto  0), b32( 7 downto  0), b33( 7 downto  0), b34( 7 downto  0), b35( 7 downto  0), b36( 7 downto  0), 
                                    b37( 7 downto  0), b38( 7 downto  0), b39( 7 downto  0), b40( 7 downto  0), b41( 7 downto  0), b42( 7 downto  0), 
                                    b43( 7 downto  0), b44( 7 downto  0), b45( 7 downto  0), b46( 7 downto  0), b47( 7 downto  0), b48( 7 downto  0),
                                    b49( 7 downto  0), b50( 7 downto  0), b51( 7 downto  0), b52( 7 downto  0), b53( 7 downto  0), b54( 7 downto  0),
                                    b55( 7 downto  0), b56( 7 downto  0), b57( 7 downto  0), b58( 7 downto  0), b59( 7 downto  0), b60( 7 downto  0),
                                    others => (others => '0'));

-- constant init_data_0_c : ram_t := (d(31 downto 24), d(63 downto 56), d(95 downto 88), d(127 downto 120), d(159 downto 152), d(191 downto 184),
--                                    d(223 downto 216), d(255 downto 248), d(287 downto 280), d(319 downto 312), d(351 downto 344), d(383 downto 376),
--                                    d(415 downto 408), d(447 downto 440), d(479 downto 472), d(511 downto 504), d(543 downto 536), d(575 downto 568),
--                                    d(607 downto 600), d(639 downto 632), d(671 downto 664), d(703 downto 696), d(735 downto 728), d(767 downto 760),
--                                    d(799 downto 792), d(831 downto 824), d(863 downto 856), d(895 downto 888), d(927 downto 920), d(959 downto 952),
--                                    d(991 downto 984), d(1023 downto 1016), d(1055 downto 1048), d(1087 downto 1080), d(1119 downto 1112), d(1151 downto 1144),  
--                                    others => (others => '0'));
                                    
-- constant init_data_1_c : ram_t := (d(23 downto 16), 
--                                    d(55 downto 48), d(87 downto 80), d(119 downto 112), d(151 downto 144), d(183 downto 176), d(215 downto 208), 
--                                    d(247 downto 240), d(279 downto 272), d(311 downto 304), d(343 downto 336), d(375 downto 368), d(407 downto 400), 
--                                    d(439 downto 432), d(471 downto 464), d(503 downto 496), d(535 downto 528), d(567 downto 560), d(599 downto 592), 
--                                    d(631 downto 624), d(663 downto 656), d(695 downto 688), d(727 downto 720), d(759 downto 752), d(791 downto 784), 
--                                    d(823 downto 816), d(855 downto 848), d(887 downto 880), d(919 downto 912), d(951 downto 944), d(983 downto 976), 
--                                    d(1015 downto 1008), d(1047 downto 1040), d(1079 downto 1072), d(1111 downto 1104), d(1143 downto 1136), 
--                                    others => (others => '0'));
                                    
-- constant init_data_2_c : ram_t := (d(15 downto 8), 
--                                    d(47 downto 40), d(79 downto 72), d(111 downto 104), d(143 downto 136), d(175 downto 168), d(207 downto 200), 
--                                    d(239 downto 232), d(271 downto 264), d(303 downto 296), d(335 downto 328), d(367 downto 360), d(399 downto 392), 
--                                    d(431 downto 424), d(463 downto 456), d(495 downto 488), d(527 downto 520), d(559 downto 552), d(591 downto 584), 
--                                    d(623 downto 616), d(655 downto 648), d(687 downto 680), d(719 downto 712), d(751 downto 744), d(783 downto 776), 
--                                    d(815 downto 808), d(847 downto 840), d(879 downto 872), d(911 downto 904), d(943 downto 936), d(975 downto 968), 
--                                    d(1007 downto 1000), d(1039 downto 1032), d(1071 downto 1064), d(1103 downto 1096), d(1135 downto 1128), 
--                                    others => (others => '0'));
                                    
-- constant init_data_3_c : ram_t := (d(7 downto 0), 
--                                    d(39 downto 32), d(71 downto 64), d(103 downto 96), d(135 downto 128), d(167 downto 160), d(199 downto 192), 
--                                    d(231 downto 224), d(263 downto 256), d(295 downto 288), d(327 downto 320), d(359 downto 352), d(391 downto 384), 
--                                    d(423 downto 416), d(455 downto 448), d(487 downto 480), d(519 downto 512), d(551 downto 544), d(583 downto 576), 
--                                    d(615 downto 608), d(647 downto 640), d(679 downto 672), d(711 downto 704), d(743 downto 736), d(775 downto 768), 
--                                    d(807 downto 800), d(839 downto 832), d(871 downto 864), d(903 downto 896), d(935 downto 928), d(967 downto 960), 
--                                    d(999 downto 992), d(1031 downto 1024), d(1063 downto 1056), d(1095 downto 1088), d(1127 downto 1120), 
--                                    others => (others => '0'));

begin  
-- Erstellen der 4 RAM Bloecke
  ram0 : entity work.ram_block(behavioral)
      generic map(initMem => init_data_0_c)
      port map( clk => clk,
                addr_a => instructionAdr_sig_0,
                data_read_a => instruction_sig_0,
                write_b => writeEnable_sig_0(0),
                addr_b => dataAdr_sig_0,
                data_read_b => dataOut_sig_0,
                data_write_b => dataIn_sig_0);
                
  ram1 : entity work.ram_block(behavioral)
      generic map(initMem => init_data_1_c)
      port map( clk => clk,
                addr_a => instructionAdr_sig_1,
                data_read_a => instruction_sig_1,
                write_b => writeEnable_sig_1(0),
                addr_b => dataAdr_sig_1,
                data_read_b => dataOut_sig_1,
                data_write_b => dataIn_sig_1);
 
  ram2 : entity work.ram_block(behavioral)
      generic map(initMem => init_data_2_c)
      port map( clk => clk,
                addr_a => instructionAdr_sig_2,
                data_read_a => instruction_sig_2,
                write_b => writeEnable_sig_2(0),
                addr_b => dataAdr_sig_2,
                data_read_b => dataOut_sig_2,
                data_write_b => dataIn_sig_2); 
                
  ram3 : entity work.ram_block(behavioral)
      generic map(initMem => init_data_3_c)
      port map( clk => clk,
                addr_a => instructionAdr_sig_3,
                data_read_a => instruction_sig_3,
                write_b => writeEnable_sig_3(0),
                addr_b => dataAdr_sig_3,
                data_read_b => dataOut_sig_3,
                data_write_b => dataIn_sig_3); 


-- Multiplexer zum Uebergeben der einzelnen Instruktions Adressen an die RAM Bloecke
  with instructionAdr(1 downto 0) select
    instructionAdr_sig_0 <= std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "10",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when others;

  with instructionAdr(1 downto 0) select
    instructionAdr_sig_1 <= std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "10",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

  with instructionAdr(1 downto 0) select
    instructionAdr_sig_2 <= std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "10",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

  with instructionAdr(1 downto 0) select
    instructionAdr_sig_3 <= std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "01",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "10",
                            std_logic_vector(to_unsigned(to_integer(unsigned(instructionAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;


-- Multiplexer zum Uebergeben der einzelnen Daten Adressen an die RAM Bloecke
  with dataAdr(1 downto 0) select
    dataAdr_sig_0 <= std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "10",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when others;

  with dataAdr(1 downto 0) select
    dataAdr_sig_1 <= std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "10",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

  with dataAdr(1 downto 0) select
    dataAdr_sig_2 <= std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "01",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "10",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;

  with dataAdr(1 downto 0) select
    dataAdr_sig_3 <= std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 0, ram_addr_size - 2)) when "00",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "01",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when "10",
                     std_logic_vector(to_unsigned(to_integer(unsigned(dataAdr(ram_addr_size -1 downto 2))) + 1, ram_addr_size - 2)) when others;


-- Multiplexer zum Uebergeben der einzelnen Daten Bytes an die RAM Bloecke
  with dataAdr(1 downto 0) select
    dataIn_sig_0 <= dataIn(31 downto 24) when "00",
                    dataIn(23 downto 16) when "01",
                    dataIn(15 downto 8)  when "10",
                    dataIn(7  downto 0)  when others;

  with dataAdr(1 downto 0) select
    dataIn_sig_1 <= dataIn(23 downto 16) when "00",
                    dataIn(15 downto 8)  when "01",
                    dataIn(7  downto 0)  when "10",
                    dataIn(31 downto 24) when others;

  with dataAdr(1 downto 0) select
    dataIn_sig_2 <= dataIn(15 downto 8)  when "00",
                    dataIn(7  downto 0)  when "01",
                    dataIn(31 downto 24) when "10",
                    dataIn(23 downto 16) when others;

  with dataAdr(1 downto 0) select
    dataIn_sig_3 <= dataIn(7  downto 0)  when "00",
                    dataIn(31 downto 24) when "01",
                    dataIn(23 downto 16) when "10",
                    dataIn(15 downto 8)  when others;
                    
                    
-- Multiplexer um WriteEnable je nach opcode für einzelnen bloecke auszustellen
  writeEnable_sig_0(0) <= '1' when op_code = uSW else 
                          '1' when op_code = uSH and dataAdr(1 downto 0) = "10" else
                          '1' when op_code = uSH and dataAdr(1 downto 0) = "11" else
                          '1' when op_code = uSB and dataAdr(1 downto 0) = "11" else
                          '0';
  
  writeEnable_sig_1(0) <= '1' when op_code = uSW else 
                          '1' when op_code = uSH and dataAdr(1 downto 0) = "01" else
                          '1' when op_code = uSH and dataAdr(1 downto 0) = "10" else
                          '1' when op_code = uSB and dataAdr(1 downto 0) = "10" else
                          '0';
                          
  writeEnable_sig_2(0) <= '1' when op_code = uSW else 
                          '1' when op_code = uSH and dataAdr(1 downto 0) = "00" else
                          '1' when op_code = uSH and dataAdr(1 downto 0) = "01" else
                          '1' when op_code = uSB and dataAdr(1 downto 0) = "01" else
                          '0';
                          
  writeEnable_sig_3(0) <= '1' when op_code = uSW else 
                          '1' when op_code = uSH and dataAdr(1 downto 0) = "11" else
                          '1' when op_code = uSH and dataAdr(1 downto 0) = "00" else
                          '1' when op_code = uSB and dataAdr(1 downto 0) = "00" else
                          '0';
                    

-- Multiplexer zum richtigen zusammensetzen der Bytes zu einem Instruktions Wort
  with instructionAdr(1 downto 0) select
    instruction <= instruction_sig_0 & instruction_sig_1 & instruction_sig_2 & instruction_sig_3 when "00",
                   instruction_sig_3 & instruction_sig_0 & instruction_sig_1 & instruction_sig_2 when "01",
                   instruction_sig_2 & instruction_sig_3 & instruction_sig_0 & instruction_sig_1 when "10",
                   instruction_sig_1 & instruction_sig_2 & instruction_sig_3 & instruction_sig_0 when others;

-- Multiplexer zum richtigen zusammensetzen der Bytes zu einem Daten Wort
  with dataAdr(1 downto 0) select
    dataOut <= dataOut_sig_0 & dataOut_sig_1 & dataOut_sig_2 & dataOut_sig_3 when "00",
               dataOut_sig_3 & dataOut_sig_0 & dataOut_sig_1 & dataOut_sig_2 when "01",
               dataOut_sig_2 & dataOut_sig_3 & dataOut_sig_0 & dataOut_sig_1 when "10",
               dataOut_sig_1 & dataOut_sig_2 & dataOut_sig_3 & dataOut_sig_0 when others;

end behavioral;
