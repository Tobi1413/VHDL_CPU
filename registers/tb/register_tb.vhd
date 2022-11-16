--author: Maher Popal & Tobias Blumers
--date:12.11.2022 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_types.all;

entity register_tb is
end register_tb;

library std;
use std.textio.all;


architecture Behavioral of register_tb is

	--clk signal/clk period
	signal clk : std_logic;
	constant clk_period : time := 10 ns;
	
	--input
	signal en_reg_wb 	: one_bit;
	signal data_in		: word;
	signal wr_idx		: reg_idx;
	signal r1_idx 		: reg_idx;
	signal r2_idx		: reg_idx;
	signal write_enable : one_bit;
	
	--output
	signal r1_out 		: word;
	signal r2_out		: word;
	
	begin
	--Instance of the Unit Under Test
		uut : entity work.registers(Behavioral)
			port map(clk			=> clk,
					 en_reg_wb		=> en_reg_wb,
					 data_in		=> data_in,
					 wr_idx			=> wr_idx,
					 r1_idx			=> r1_idx,
					 r2_idx			=> r2_idx,
					 write_enable	=> write_enable,
					 r1_out			=> r1_out,
					 r2_out			=> r2_out);
					 
	-- clock process 
	clk_process : process
		begin
			clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	 -- Stimulus process
  stim_proc : process
	begin
		wait until rising_edge(clk);
		
		report "Start simulation:";
		
		wait for 7 ns;
		
		
		--First test: loop to test what happens when r1_idx is set to zero and r2 isnt
		for I in 0 to reg_size - 1 loop
			en_reg_wb <= "1";
			write_enable <= "1";
			data_in <= std_logic_vector(to_unsigned(I+I, wordWidth));
			wr_idx <= std_logic_vector(to_unsigned(I, reg_adr_size));
			r1_idx <= "00000";
			r2_idx <= std_logic_vector(to_unsigned(I, reg_adr_size));
		
			wait for 20 ns;
		
			if r1_out /= X"00000000" then
				report "Test from r1 set to zero failed.";
			else
				report "r1_idx to zero: Test sucecessful!";
			end if;
		
			if r2_out /= std_logic_vector(to_unsigned(I+I, wordWidth)) then
				report "Test to write to R2" & integer'image(I) & " failed!";
			else
				report "Write to r2 test succesful!";
			end if;
		end loop;
		
		wait for 10 ns;
		
		--second test: dont write to R0
		
		en_reg_wb <= "1";
		data_in <= std_logic_vector(to_unsigned(42, wordWidth));
		wr_idx <= std_logic_vector(to_unsigned(0, reg_adr_size));
		r1_idx <= std_logic_vector(to_unsigned(7, reg_adr_size));
		r2_idx <= std_logic_vector(to_unsigned(0, reg_adr_size));
		write_enable <= "1";

		wait for 10 ns;
    
		if r1_out /= std_logic_vector(to_unsigned(14, wordWidth)) then
			report "Test dont write to R0 failed!";
		else 
			report "Test dont write to R0 successful!";
		end if;
    
		if r2_out /= std_logic_vector(to_unsigned(0, wordWidth)) then
			report "Read from R7 failed!";
		else 
			report "Read from R7 succesful!";
		end if;
		
		
	---third : dont write to r0
	
	en_reg_wb <= std_logic_vector(to_unsigned(1, 1));
    data_in <= std_logic_vector(to_unsigned(42, wordWidth));
    wr_idx <= std_logic_vector(to_unsigned(7, reg_adr_size));
    r1_idx <= std_logic_vector(to_unsigned(0, reg_adr_size));
    r2_idx <= std_logic_vector(to_unsigned(25, reg_adr_size));
    write_enable <= std_logic_vector(to_unsigned(0, 1));
    
    wait for 10 ns;
    
    if r1_out = std_logic_vector(to_unsigned(0, wordWidth)) then
      report "Test dont write to R0 successful!";
    else
      report "Test dont write to R0 failed!";
    end if;
    
    if r2_out = std_logic_vector(to_unsigned(50, wordWidth)) then
      report "Test read from R25 successful!";
    else 
      report "Test read from R25 failed!";
    end if;
    
	---fourth test: write enable
    en_reg_wb <= std_logic_vector(to_unsigned(1, 1));
    data_in <= std_logic_vector(to_unsigned(42, wordWidth));
    wr_idx <= std_logic_vector(to_unsigned(7, reg_adr_size));
    r1_idx <= std_logic_vector(to_unsigned(7, reg_adr_size));
    r2_idx <= std_logic_vector(to_unsigned(7, reg_adr_size));
    write_enable <= std_logic_vector(to_unsigned(0, 1));
    
    wait for 10 ns;
    
    if r1_out = std_logic_vector(to_unsigned(14, wordWidth)) then
      report "Test write_enable successful!";
    else
      report "Test write_enable failed!";
    end if;
    
    if r2_out = std_logic_vector(to_unsigned(14, wordWidth)) then
      report "Test write_enable successful!";
    else
      report "Test write_enable failed!";
    end if;
	
	
    ---fifth test: write enable
    en_reg_wb <= std_logic_vector(to_unsigned(0, 1));
    data_in <= std_logic_vector(to_unsigned(42, wordWidth));
    wr_idx <= std_logic_vector(to_unsigned(9, reg_adr_size));
    r1_idx <= std_logic_vector(to_unsigned(9, reg_adr_size));
    r2_idx <= std_logic_vector(to_unsigned(9, reg_adr_size));
    write_enable <= std_logic_vector(to_unsigned(1, 1));
    
    wait for 10 ns;
    
    if r1_out = std_logic_vector(to_unsigned(18, wordWidth)) then
      report "Test write_enable successful!";
    else
      report "Test write_enable failed!";
    end if;
    
    if r2_out = std_logic_vector(to_unsigned(18, wordWidth)) then
      report "Test write_enable successful!";
    else
      report "Test write_enable failed!";
    end if;
		
		
		
		
	
		report "End of simulation!";
		
		--simply wait forever
		wait;
	
	
	end process;
  
  
end architecture;
