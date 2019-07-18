-------------------------------------------------------------------------------
--
-- Title       : TestBench
-- Design      : MultumediaALU
-- Author      : Michael
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\themi\Documents\My_Designs\finalproject\MultumediaALU\src\TestBench.vhd
-- Generated   : Mon Dec  4 11:11:33 2017
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {TestBench} architecture {TestBench}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity TestBench is
end TestBench;

--}} End of automatically maintained section

architecture TestBench of TestBench is
signal end_of_file : bit := '0';
signal data_read : real;
signal data_sig : string(1 to 25);
signal instruction_in : std_logic_vector(23 downto 0);
signal instruction_out : std_logic_vector(23 downto 0);
signal clock : std_logic := '0';
begin
	
	uut : entity cpu port map(instruction_in => instruction_in, clock => clock);--, instruction_out => instruction_out);
	
	reading: process  
	
		file in_file : text is in "instructions.txt";
		variable in_line : line;
		variable instruction : std_logic_vector(23 downto 0);
		variable imm : std_logic_vector(15 downto 0);					  
		variable data_in : std_logic_vector(23 downto 0);
		variable instruction_string : string(1 to 8);
		variable count : integer := 0;
	begin				   
		while not endfile(in_file) loop
			readline(in_file, in_line);
			read(in_line, data_in);
			report "a line";
			instruction_in <= data_in;
			wait for 0.01ns;
		end loop;
		
		
		wait for 10ns;
		clock <= not clock;
	end process reading;
	-- enter your statements here --

end TestBench;
