library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity instruction_buffer is
	port (clock : in std_logic;
	instruction_in : in std_logic_vector(23 downto 0);
	instruction_out : out std_logic_vector (23 downto 0)
	--new_pc : out std_logic_vector(15 downto 0)
	);
end instruction_buffer;

architecture behavioral of instruction_buffer is
type inst_buffer is array (32 downto 0) of std_logic_vector(23 downto 0);
signal inst : inst_buffer;
signal pc : integer := 0;
--signal counter : integer := 0;

begin
	
	load_instruction : process(instruction_in)
	variable count : integer := 0;
	begin	 
		inst(0) <= "000000000000000000000000";
		inst(count) <= instruction_in;
		if count < 32 then
			count := count + 1;	
		end if;
	end process;
	
	get_instruction: process (clock)
	begin
		if rising_edge(clock) then
			instruction_out <= inst(pc);
			pc <= pc + 1;
		end if;
	end process get_instruction;
	
end behavioral;
	
		