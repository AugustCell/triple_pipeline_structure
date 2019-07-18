library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity alu is
port(clock : in std_logic;
	--enable : in std_logic;
	rs1, rs2, rs3 : in std_logic_vector (63 downto 0);
	alu_op : in std_logic_vector (4 downto 0);
	reg_dst_in : in std_logic_vector(4 downto 0);  
	immediate : in std_logic_vector (15 downto 0);
	li_op : in std_logic_vector(1 downto 0);
	
	data_out : out std_logic_vector (63 downto 0);
	write_data_out : out std_logic;
	reg_dst : out std_logic_vector(4 downto 0)
	);
end alu;

architecture behavioral of alu is

begin 
	process (clock)
	variable local_bit : std_logic;
	variable local_data, temp1, temp2, temp3, temp4 : std_logic_vector (63 downto 0);
	variable count, flag1 : integer := 0;
	begin
		if rising_edge(clock) then
			--write_data_out <= '0';
			--data_out <= "0000000000000000000000000000000000000000000000000000000000000000";
			case alu_op is
				when "00000" =>  --nop 
				write_data_out <= '0';
				
				when "00001" =>  --bcw
				data_out(63 downto 32) <= rs1(31 downto 0);
				data_out(31 downto 0) <= rs1(31 downto 0);
				write_data_out <= '1'; 
				
				when "00010" =>  --and
				data_out <= rs1 and rs2;
				write_data_out <= '1';
				
				when "00011" =>	 --or
				data_out <= rs1 or rs2;
				write_data_out <= '1';  
				
				when "00100" =>  --popcnth
				--count ones using a loop and an integer counter. Save count to halfword in data out
				for i in 0 to 15 loop 
					if (rs1(i) = '1') then
						count := count + 1;
					end if;
				end loop;
				data_out(15 downto 0) <= std_logic_vector(to_unsigned(count, 16)); --count 1's 
				count := 0;
				
				for i in 16 to 31 loop 
					if (rs1(i) = '1') then
						count := count + 1;
					end if;
				end loop;
				data_out(31 downto 16) <= std_logic_vector(to_unsigned(count, 16));
				count := 0;
				
				for i in 32 to 47 loop 
					if (rs1(i) = '1') then
						count := count + 1;
					end if;
				end loop;
				data_out(47 downto 32) <= std_logic_vector(to_unsigned(count, 16));
				count := 0;
				
				for i in 48 to 63 loop 
					if (rs1(i) = '1') then
						count := count + 1;
					end if;
				end loop;
				data_out(63 downto 48) <= std_logic_vector(to_unsigned(count, 16));
				count := 0;
				write_data_out <= '1';
				
				when "00101" =>  --clz 	count leading zeros	 
				
				for i in 0 to 31 loop
					if (rs1(i) = '1') then
						flag1 := 1;
					end if;
					if (flag1 = 1) and (rs1(i) = '0') then
						count := count + 1;
					end if;
				end loop; 
				
				if (rs1(31 downto 0) = "00000000000000000000000000000000") then
					data_out(31 downto 0) <= "00000000000000000000000000100000";   --if word = 0, give 32
				else
					data_out(31 downto 0) <= std_logic_vector(to_unsigned(count, 32));
				end if;	 
				count := 0;
				flag1 := 0;
				
				for i in 32 to 63 loop
					if (rs1(i) = '1') then
						flag1 := 1;
					end if;
					if (flag1 = 1) and (rs1(i) = '0') then
						count := count + 1;
					end if;
				end loop; 
				
				if (rs1(63 downto 32) = "00000000000000000000000000000000") then
					data_out(63 downto 32) <= "00000000000000000000000000100000";   --if word = 0, give 32
				else
					data_out(63 downto 32) <= std_logic_vector(to_unsigned(count, 32));
				end if;
				count := 0;
				flag1 := 0;
				write_data_out <= '1';
				
				when "00110" =>  --rot 
				count := to_integer(unsigned(rs2(5 downto 0)));
				data_out <= rs1 ror	count;
				count := 0;	   
				write_data_out <= '1';
				
				when "00111" =>  --shlhi
				count := to_integer(unsigned(rs2(3 downto 0)));
				data_out(15 downto 0) <= rs1(15 downto 0) sll count;
				data_out(31 downto 16) <= rs1(31 downto 16) sll count;
				data_out(47 downto 32) <= rs1(47 downto 32) sll count;
				data_out(63 downto 48) <= rs1(63 downto 48) sll count; 
				count := 0;		 
				write_data_out <= '1';
				
				when "01000" =>  --a	   not sure what packed means and not sure what to do with overflow
				count := to_integer(unsigned(rs1(31 downto 0))) + to_integer(unsigned(rs2(31 downto 0)));
				data_out(31 downto 0) <= std_logic_vector(to_unsigned(count, 32));
				count := to_integer(unsigned(rs1(63 downto 32))) + to_integer(unsigned(rs2(63 downto 32)));
				data_out(63 downto 32) <= std_logic_vector(to_unsigned(count, 32));		
				count := 0;		 
				write_data_out <= '1';
				
				when "01001" =>  --sfw     
				count := to_integer(unsigned(rs1(31 downto 0))) - to_integer(unsigned(rs2(31 downto 0)));
				data_out(31 downto 0) <= std_logic_vector(to_unsigned(count, 32));
				count := to_integer(unsigned(rs1(63 downto 32))) - to_integer(unsigned(rs2(63 downto 32)));
				data_out(63 downto 32) <= std_logic_vector(to_unsigned(count, 32));		
				count := 0;		 
				write_data_out <= '1';
				
				when "01010" =>  --ah
				count := to_integer(unsigned(rs1(15 downto 0))) + to_integer(unsigned(rs2(15 downto 0)));
				data_out(15 downto 0) <= std_logic_vector(to_unsigned(count, 16));
				
				count := to_integer(unsigned(rs1(31 downto 16))) + to_integer(unsigned(rs2(31 downto 16)));
				data_out(31 downto 16) <= std_logic_vector(to_unsigned(count, 16));	
				
				count := to_integer(unsigned(rs1(47 downto 32))) + to_integer(unsigned(rs2(47 downto 32)));
				data_out(47 downto 32) <= std_logic_vector(to_unsigned(count, 16)); 
				
				count := to_integer(unsigned(rs1(63 downto 48))) + to_integer(unsigned(rs2(63 downto 48)));
				data_out(63 downto 48) <= std_logic_vector(to_unsigned(count, 16));		
				count := 0;		 
				write_data_out <= '1';
				
				when "01011" =>  --sfh
				count := to_integer(unsigned(rs1(15 downto 0))) - to_integer(unsigned(rs2(15 downto 0)));
				data_out(15 downto 0) <= std_logic_vector(to_unsigned(count, 16));
				
				count := to_integer(unsigned(rs1(31 downto 16))) - to_integer(unsigned(rs2(31 downto 16)));
				data_out(31 downto 16) <= std_logic_vector(to_unsigned(count, 16));	
				
				count := to_integer(unsigned(rs1(47 downto 32))) - to_integer(unsigned(rs2(47 downto 32)));
				data_out(47 downto 32) <= std_logic_vector(to_unsigned(count, 16)); 
				
				count := to_integer(unsigned(rs1(63 downto 48))) - to_integer(unsigned(rs2(63 downto 48)));
				data_out(63 downto 48) <= std_logic_vector(to_unsigned(count, 16));		
				count := 0;		 
				write_data_out <= '1';
				
				when "01100" =>  --ahs
				count := to_integer(signed(rs1(15 downto 0))) + to_integer(signed(rs2(15 downto 0)));
				if (count > 32767) then  --is 2^16 -1 the right value for saturation? -32,768 to 32,767 with sign?
					count := 32767;
				elsif (count < -32768) then
					count := -32768;
				end if;
				data_out(15 downto 0) <= std_logic_vector(to_signed(count, 16));
				
				count := to_integer(signed(rs1(31 downto 16))) + to_integer(signed(rs2(31 downto 16)));
				if (count > 32767) then
					count := 32767;
				elsif (count < -32768) then
					count := -32768;
				end if;
				data_out(31 downto 16) <= std_logic_vector(to_signed(count, 16));	
				
				count := to_integer(signed(rs1(47 downto 32))) + to_integer(signed(rs2(47 downto 32)));
				if (count > 32767) then
					count := 32767;
				elsif (count < -32768) then
					count := -32768;
				end if;
				data_out(47 downto 32) <= std_logic_vector(to_signed(count, 16)); 
				
				count := to_integer(signed(rs1(63 downto 48))) + to_integer(signed(rs2(63 downto 48)));
				if (count > 32767) then
					count := 32767;
				elsif (count < -32768) then
					count := -32768;
				end if;
				data_out(63 downto 48) <= std_logic_vector(to_signed(count, 16));		
				count := 0;		 
				write_data_out <= '1';
				
				when "01101" =>  --sfhs
				count := to_integer(signed(rs1(15 downto 0))) - to_integer(signed(rs2(15 downto 0)));
				if (count > 32767) then  --is 2^16 -1 the right value for saturation? -32,768 to 32,767 with sign?
					count := 32767;
				elsif (count < -32768) then
					count := -32768;
				end if;
				data_out(15 downto 0) <= std_logic_vector(to_signed(count, 16));
				
				count := to_integer(signed(rs1(31 downto 16))) - to_integer(signed(rs2(31 downto 16)));
				if (count > 32767) then
					count := 32767;
				elsif (count < -32768) then
					count := -32768;
				end if;
				data_out(31 downto 16) <= std_logic_vector(to_signed(count, 16));	
				
				count := to_integer(signed(rs1(47 downto 32))) - to_integer(signed(rs2(47 downto 32)));
				if (count > 32767) then
					count := 32767;
				elsif (count < -32768) then
					count := -32768;
				end if;
				data_out(47 downto 32) <= std_logic_vector(to_signed(count, 16)); 
				
				count := to_integer(signed(rs1(63 downto 48))) - to_integer(signed(rs2(63 downto 48)));
				if (count > 32767) then
					count := 32767;
				elsif (count < -32768) then
					count := -32768;
				end if;
				data_out(63 downto 48) <= std_logic_vector(to_signed(count, 16));		
				count := 0;		 
				write_data_out <= '1'; 
				
				when "01110" =>  --mpyu
				temp1(15 downto 0) := rs1(15 downto 0);
				temp2(15 downto 0) := rs2(15 downto 0);
				count := to_integer(unsigned(temp1))* to_integer(unsigned(temp2));
				data_out(31 downto 0) <= std_logic_vector(to_unsigned(count, 32)); 
				
				temp1(15 downto 0) := rs1(47 downto 32);
				temp2(15 downto 0) := rs2(47 downto 32);
				count := to_integer(unsigned(temp1))* to_integer(unsigned(temp2));
				data_out(63 downto 32) <= std_logic_vector(to_unsigned(count, 32));
				
				count := 0;
				write_data_out <= '1';  
				
				when "01111" =>  --absdb 
				temp2(7 downto 0) := rs2(7 downto 0);
				temp1(7 downto 0) := rs1 (7 downto 0);
				count := to_integer(unsigned(temp2))- to_integer(unsigned(temp1));
				data_out(7 downto 0) <= std_logic_vector(to_unsigned(count, 8));
				
				temp2(7 downto 0) := rs2(15 downto 8);
				temp1(7 downto 0) := rs1 (15 downto 8);
				count := to_integer(unsigned(temp2))- to_integer(unsigned(temp1));
				data_out(15 downto 8) <= std_logic_vector(to_unsigned(count, 8));
				
				temp2(7 downto 0) := rs2(23 downto 16);
				temp1(7 downto 0) := rs1 (23 downto 16);
				count := to_integer(unsigned(temp2))- to_integer(unsigned(temp1));
				data_out(23 downto 16) <= std_logic_vector(to_unsigned(count, 8));
				
				temp2(7 downto 0) := rs2(31 downto 24);
				temp1(7 downto 0) := rs1 (31 downto 24);
				count := to_integer(unsigned(temp2))- to_integer(unsigned(temp1));
				data_out(31 downto 24) <= std_logic_vector(to_unsigned(count, 8));
				
				temp2(7 downto 0) := rs2(39 downto 32);
				temp1(7 downto 0) := rs1 (39 downto 32);
				count := to_integer(unsigned(temp2))- to_integer(unsigned(temp1));
				data_out(39 downto 32) <= std_logic_vector(to_unsigned(count, 8));
				
				temp2(7 downto 0) := rs2(47 downto 40);
				temp1(7 downto 0) := rs1 (47 downto 40);
				count := to_integer(unsigned(temp2))- to_integer(unsigned(temp1));
				data_out(47 downto 40) <= std_logic_vector(to_unsigned(count, 8));
				
				temp2(7 downto 0) := rs2(55 downto 48);
				temp1(7 downto 0) := rs1 (55 downto 48);
				count := to_integer(unsigned(temp2))- to_integer(unsigned(temp1));
				data_out(55 downto 48) <= std_logic_vector(to_unsigned(count, 8));
				
				temp2(7 downto 0) := rs2(63 downto 56);
				temp1(7 downto 0) := rs1 (63 downto 56);
				count := to_integer(unsigned(temp2))- to_integer(unsigned(temp1));
				data_out(63 downto 56) <= std_logic_vector(to_unsigned(count, 8));
				
				count := 0;
				write_data_out <= '1';
				
				when "10000" =>  --mal
				temp1(15 downto 0) := rs2(15 downto 0);
				temp2(15 downto 0) := rs3(15 downto 0);
				
				local_data(31 downto 0) := std_logic_vector(to_unsigned((to_integer(unsigned(temp1(15 downto 0))) * to_integer(unsigned(temp2(15 downto 0)))), 32));
				data_out(31 downto 0) <= std_logic_vector(to_unsigned((to_integer(unsigned(rs1(31 downto 0))) + to_integer(unsigned(local_data(31 downto 0)))), 32));
				
				temp1(47 downto 32) := rs2(47 downto 32);
				temp2(47 downto 32) := rs3(47 downto 32);
				
				local_data(63 downto 32) := std_logic_vector(to_unsigned((to_integer(unsigned(temp1(47 downto 32))) * to_integer(unsigned(temp2(47 downto 32)))), 32));
				data_out(63 downto 32) <= std_logic_vector(to_unsigned((to_integer(unsigned(rs1(63 downto 32))) + to_integer(unsigned(local_data(63 downto 32)))), 32));				
																																								   
				write_data_out <= '1';
				
				when "10001" =>  --mah
				temp1(31 downto 16) := rs2(31 downto 16);
				temp2(31 downto 16) := rs3(31 downto 16);
				
				local_data(31 downto 0) := std_logic_vector(to_unsigned((to_integer(unsigned(temp1(31 downto 16))) * to_integer(unsigned(temp2(31 downto 16)))), 32));
				temp3(31 downto 0) := std_logic_vector(to_unsigned((to_integer(unsigned(rs1(31 downto 0))) + to_integer(unsigned(local_data(31 downto 0)))), 32));
				
				temp1(63 downto 48) := rs2(63 downto 48);
				temp2(63 downto 48) := rs3(63 downto 48);
				
				local_data(63 downto 32) := std_logic_vector(to_unsigned((to_integer(unsigned(temp1(63 downto 48))) * to_integer(unsigned(temp2(63 downto 48)))), 32));
				temp3(63 downto 32) := std_logic_vector(to_unsigned((to_integer(unsigned(rs1(63 downto 32))) + to_integer(unsigned(local_data(63 downto 32)))), 32));				
				
				data_out <= temp3;
				write_data_out <= '1';
				
				when "10010" =>  --msl
				temp1(15 downto 0) := rs2(15 downto 0);
				temp2(15 downto 0) := rs3(15 downto 0);	  
				
				local_data(31 downto 0) := std_logic_vector(to_unsigned((to_integer(unsigned(temp1(15 downto 0))) * to_integer(unsigned(temp2(15 downto 0)))), 32));
				temp3(31 downto 0) := std_logic_vector(to_unsigned((to_integer(unsigned(rs1(31 downto 0))) + to_integer(unsigned(local_data(31 downto 0)))), 32));
				
				temp1(47 downto 32) := rs2(47 downto 32);
				temp2(47 downto 32) := rs3(47 downto 32);
				
				local_data(63 downto 32) := std_logic_vector(to_unsigned((to_integer(unsigned(temp1(47 downto 32))) * to_integer(unsigned(temp2(47 downto 32)))), 32));
				temp3(63 downto 32) := std_logic_vector(to_unsigned((to_integer(unsigned(rs1(63 downto 32))) - to_integer(unsigned(local_data(63 downto 32)))), 32));
				
				data_out <= temp3;
				write_data_out <= '1';
				
				when "10011" =>  --msh
				temp1(31 downto 16) := rs2(31 downto 16);
				temp2(31 downto 16) := rs3(31 downto 16);			  
				
				local_data(31 downto 0) := std_logic_vector(to_unsigned((to_integer(unsigned(temp1(31 downto 16))) * to_integer(unsigned(temp2(31 downto 16)))), 32));
				temp3(31 downto 0) := std_logic_vector(to_unsigned((to_integer(unsigned(rs1(31 downto 0))) + to_integer(unsigned(local_data(31 downto 0)))), 32));
				
				temp1(63 downto 48) := rs2(63 downto 48);
				temp2(63 downto 48) := rs3(63 downto 48);
				
				local_data(63 downto 32) := std_logic_vector(to_unsigned((to_integer(unsigned(temp1(63 downto 48))) * to_integer(unsigned(temp2(63 downto 48)))), 32));
				temp3(63 downto 32) := std_logic_vector(to_unsigned((to_integer(unsigned(rs1(63 downto 32))) - to_integer(unsigned(local_data(63 downto 32)))), 32));
				
				data_out <= temp3;
				write_data_out <= '1';
				
				when "11111" => --li
				if li_op = "00" then
					--data_out(63 downto 16) <= rs1(63 downto 16);
					data_out(15 downto 0) <= immediate;
				elsif li_op = "01" then
					--data_out(63 downto 32) <= rs1(63 downto 32);
					data_out(31 downto 16) <= immediate; 
					--data_out(15 downto 0) <= rs1(15 downto 0);
				elsif li_op = "10" then
					--data_out(63 downto 48) <= rs1(63 downto 48);
					data_out(47 downto 32) <= immediate;		
					--data_out(31 downto 0) <= rs1(31 downto 0);
				elsif li_op = "11" then						  
					data_out(63 downto 48) <= immediate;	  
					--data_out(47 downto 0) <= rs1(47 downto 0);
				end if;
				reg_dst <= reg_dst_in;
				write_data_out <= '1';
				
				when others =>
				
			end case;
			reg_dst <= reg_dst_in;
		end if;
	end process;
	
end behavioral;

				
				
				
				
				