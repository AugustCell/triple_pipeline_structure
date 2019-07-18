library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity instruction_buffer is
	port (clock : in std_logic;
	--pc : in std_logic_vector(15 downto 0);
	instruction_out : out std_logic_vector (23 downto 0)
	--new_pc : out std_logic_vector(15 downto 0)
	);
end instruction_buffer;

architecture behavioral of instruction_buffer is
type inst_buffer is array (31 downto 0) of std_logic_vector(23 downto 0);
signal inst : inst_buffer;
signal end_of_file : bit := '0';
signal data_read : real;
signal data_sig : string(1 to 25);
signal pc : integer := 0;
signal instruction_sig : std_logic_vector(23 downto 0) := "000000000000000000000000"; 

begin
	
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
			inst(count) <= data_in;
			count := (count + 1);
		end loop;
		wait;
	end process reading;
	
	get_instruction: process (clock)
	begin
		if rising_edge(clock) then
			instruction_out <= inst(pc);
			pc <= pc + 1;
		end if;
	end process get_instruction;
end behavioral;
	
		