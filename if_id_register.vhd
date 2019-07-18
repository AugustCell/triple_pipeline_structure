-------------------------------------------------------------------------------
--
-- Title       : if_id_register
-- Design      : MultimediaALU
-- Author      : Michael Anderson
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\themi\Documents\My_Designs\finalproject\MultimediaALU\src\if_id_register.vhd
-- Generated   : Sun Dec  3 14:22:40 2017
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
--{entity {if_id_register} architecture {if_id_register}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity if_id_register is
	port(
		 clk : in STD_LOGIC;
		 instruction_in : in STD_LOGIC_VECTOR(23 downto 0);
		 instruction_out : out STD_LOGIC_VECTOR(23 downto 0)
	     );
end if_id_register;

--}} End of automatically maintained section

architecture if_id_register of if_id_register is
signal last_inst : std_logic_vector(23 downto 0) := "000000000000000000000000";
begin
	process(instruction_in)
	begin
		--if rising_edge(clk) then
			instruction_out <= last_inst;
			last_inst <= instruction_in;
		--end if;
	end process;
	 -- enter your statements here --

end if_id_register;
