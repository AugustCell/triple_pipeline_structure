library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity instruction_decoder is
	port (clock: in std_logic;
	--enable: in std_logic;		 --if the decoder needs to be frozen, uncomment this an add an if statement surronding the case that relies on enable
	instruction_in: in std_logic_vector(23 downto 0);
	alu_op: out std_logic_vector (4 downto 0);
	immediate: out std_logic_vector (15 downto 0);
	imm_op : out std_logic_vector(1 downto 0);
	--write_enable: out std_logic;
	rs1, rs2, rs3, rd: out std_logic_vector (4 downto 0)
	);
end instruction_decoder; 

architecture behavioral of instruction_decoder is
	signal local_instruction : std_logic_vector(1 downto 0);
begin 
	process (clock, instruction_in)
	begin
		 
		--local_instruction <= instruction_in(23 downto 22);
			case instruction_in(23 downto 22) is
				when "10" | "11" =>	--load immediate
				alu_op <= "11111";
				immediate <= instruction_in(20 downto 5);
				imm_op <= instruction_in(22 downto 21);
				rs1 <= instruction_in(4 downto 0);
				rs2 <= "XXXXX";
				rs3 <= "XXXXX";
				rd <= instruction_in(4 downto 0); 
				
				when "01" => --multiply add/ sub
				alu_op(4) <= '1';	    
				alu_op(3) <= '0';
				alu_op(2) <= '0';
				alu_op(1 downto 0) <= instruction_in(21 downto 20);
				immediate <= "XXXXXXXXXXXXXXXX";
				
				rs3 <= instruction_in(19 downto 15);
				rs2 <= instruction_in(14 downto 10);
				rs1 <= instruction_in(9 downto 5);
				rd <= instruction_in(4 downto 0); 
				
				when "00"	=> --R-type
				if instruction_in = "000000000000000000000000" then
					alu_op <= "00000";
					immediate <= "0000000000000000";
					
					rs3 <= "00000";
					rs2 <= "00000";
					rs1 <= "00000";
					rd <= "00000";
					imm_op <= "00";
				else
					alu_op(4) <= '0';	    
					alu_op(3 downto 0) <= instruction_in(18 downto 15);
					immediate <= "XXXXXXXXXXXXXXXX";
				
					rs3 <= "XXXXX";
					rs2 <= instruction_in(14 downto 10);
					rs1 <= instruction_in(9 downto 5);
					rd <= instruction_in(4 downto 0);
					imm_op <= instruction_in(22 downto 21);
				end if;
				when others =>
			end case;
		
	end process;
end behavioral;

