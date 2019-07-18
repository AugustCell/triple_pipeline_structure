-------------------------------------------------------------------------------
--
-- Title       : id_ex_register
-- Design      : MultimediaALU
-- Author      : Michael Anderson
-- Company     : Stony Brook University
--
-------------------------------------------------------------------------------
--
-- File        : c:\Users\themi\Documents\My_Designs\finalproject\MultimediaALU\src\id_ex_register.vhd
-- Generated   : Sun Dec  3 14:49:34 2017
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : ID/EX Register that holds the data needed for the ALU from the
--		Decoder and the Register Files from the last cycle and sends it out
--		at the next.
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {id_ex_register} architecture {id_ex_register}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity id_ex_register is
	 port(
		 clk : in STD_LOGIC;
		 reg1_data_in : in STD_LOGIC_VECTOR(63 downto 0);
		 reg2_data_in : in STD_LOGIC_VECTOR(63 downto 0);
		 reg3_data_in : in STD_LOGIC_VECTOR(63 downto 0);
		 reg_dst_in : in STD_LOGIC_VECTOR(4 downto 0);
		 opcode_in : in STD_LOGIC_VECTOR(4 downto 0);
		 imm_in : in std_logic_vector(15 downto 0);
		 immop : in std_logic_vector(1 downto 0);
		 immop_out : out std_logic_vector(1 downto 0);
		 imm_out : out std_logic_vector(15 downto 0);
		 opcode_out : out STD_LOGIC_VECTOR(4 downto 0);
		 reg_dst_out : out STD_LOGIC_VECTOR(4 downto 0);
		 reg1_data_out : out STD_LOGIC_VECTOR(63 downto 0);
		 reg2_data_out : out STD_LOGIC_VECTOR(63 downto 0);
		 reg3_data_out : out STD_LOGIC_VECTOR(63 downto 0)
	     );
end id_ex_register;

--}} End of automatically maintained section

architecture id_ex_register of id_ex_register is
signal reg1_data, reg2_data, reg3_data : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
signal opcode, reg_dst : std_logic_vector(4 downto 0) := "00000";
signal imm_sig : std_logic_vector(15 downto 0);
signal imm_op_sig : std_logic_vector(1 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
			reg1_data_out <= reg1_data;
			reg2_data_out <= reg2_data;
			reg3_data_out <= reg3_data;
			reg_dst_out <= reg_dst;
			opcode_out <= opcode;
			immop_out <= imm_op_sig;
			imm_out <= imm_sig;
			
			reg1_data <= reg1_data_in;
			reg2_data <= reg2_data_in;
			reg3_data <= reg3_data_in;
			reg_dst <= reg_dst_in;
			opcode <= opcode_in;
			imm_sig <= imm_in;
			imm_op_sig <= immop;
			
		end if;
	end process;
end id_ex_register;
