-------------------------------------------------------------------------------
--
-- Title       : register_file
-- Design      : MultimediaALU
-- Author      : Michael Anderson
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\themi\Documents\My_Designs\finalproject\MultimediaALU\src\register_file.vhd
-- Generated   : Sun Dec  3 14:00:24 2017
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
--{entity {register_file} architecture {register_file}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity register_file is
	 port(
		 clk : in STD_LOGIC;
		 write_en : in STD_LOGIC;
		 read_addr1 : in STD_LOGIC_VECTOR(4 downto 0);
		 read_addr2 : in STD_LOGIC_VECTOR(4 downto 0);
		 read_addr3 : in STD_LOGIC_VECTOR(4 downto 0);
		 write_reg_addr : in STD_LOGIC_VECTOR(4 downto 0);
		 write_data : in STD_LOGIC_VECTOR(63 downto 0);
		 out_reg1 : out STD_LOGIC_VECTOR(63 downto 0);
		 out_reg2 : out STD_LOGIC_VECTOR(63 downto 0);
		 out_reg3 : out STD_LOGIC_VECTOR(63 downto 0)
	     );
end register_file;

--}} End of automatically maintained section

architecture register_file of register_file is
type registers is array(31 downto 0) of std_logic_vector(63 downto 0);
signal reg_file : registers;
begin
	process(read_addr1, read_addr2, read_addr3, write_reg_addr, write_data, write_en, clk)
	begin
		if falling_edge(clk) then
			out_reg1 <= reg_file(to_integer(unsigned(read_addr1)));
			out_reg2 <= reg_file(to_integer(unsigned(read_addr2)));
			out_reg3 <= reg_file(to_integer(unsigned(read_addr3)));
			if write_en = '1' then
				if read_addr1 = write_reg_addr then
					out_reg1 <= write_data;
				end if;
				if read_addr2 = write_reg_addr then
					out_reg2 <= write_data;
				end if;
				if read_addr3 = write_reg_addr then
					out_reg3 <= write_data;
				end if;
			end if;
		end if;
		if rising_edge(clk) then	
			if write_en = '1' then
				reg_file(to_integer(unsigned(write_reg_addr))) <= write_data;
				if read_addr1 = write_reg_addr then
					out_reg1 <= write_data;
				end if;
				if read_addr2 = write_reg_addr then
					out_reg2 <= write_data;
				end if;
				if read_addr3 = write_reg_addr then
					out_reg3 <= write_data;
				end if;
			end if;
		end if;
	end process;
	 -- enter your statements here --

end register_file;
