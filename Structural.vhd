library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity cpu is
	port( 
	clock : in std_logic;
	instruction_in : in std_logic_vector(23 downto 0)
	--data_out: out std_logic_vector (63 downto 0);
	--we_out: out std_logic
	
	);
end cpu;

architecture structural of cpu is

component instruction_buffer
	port(
	clock : in std_logic;
	instruction_in : in std_logic_vector (23 downto 0);
	instruction_out : out std_logic_vector (23 downto 0)
	);
end component;

component instruction_decoder
	port (clock: in std_logic;
	--enable: in std_logic;		 --if the decoder needs to be frozen, uncomment this an add an if statement surronding the case that relies on enable
	instruction_in: in std_logic_vector(23 downto 0);
	alu_op: out std_logic_vector (4 downto 0);
	immediate: out std_logic_vector (15 downto 0);
	imm_op : out std_logic_vector(1 downto 0);
	--write_enable: out std_logic;
	rs1, rs2, rs3, rd: out std_logic_vector (4 downto 0)
	);
end component;
	
component register_file
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
end component;

component alu
	port(
	clock : in std_logic;
	--enable : in std_logic;
	rs1, rs2, rs3 : in std_logic_vector (63 downto 0);
	alu_op : in std_logic_vector (4 downto 0);
	reg_dst_in : in std_logic_vector(4 downto 0);  
	immediate : in std_logic_vector (15 downto 0);
	li_op : in std_logic_vector(1 downto 0);
	--write_data_in : in std_logic;
	data_out : out std_logic_vector (63 downto 0);
	write_data_out : out std_logic;
	reg_dst : out std_logic_vector(4 downto 0)
	);
end component;

component if_id_register
	port(
		 clk : in STD_LOGIC;
		 instruction_in : in STD_LOGIC_VECTOR(23 downto 0);
		 instruction_out : out STD_LOGIC_VECTOR(23 downto 0)
	     );
end component; 

component id_ex_register
	 port(
		 clk : in STD_LOGIC;
		 reg1_data_in : in STD_LOGIC_VECTOR(63 downto 0);
		 reg2_data_in : in STD_LOGIC_VECTOR(63 downto 0);
		 reg3_data_in : in STD_LOGIC_VECTOR(63 downto 0);
		 reg_dst_in : in STD_LOGIC_VECTOR(4 downto 0);
		 imm_in : in STD_LOGIC_VECTOR(15 downto 0);
		 immop : in STD_LOGIC_VECTOR(1 downto 0);
		 opcode_in : in STD_LOGIC_VECTOR(4 downto 0);
		 imm_out : out STD_LOGIC_VECTOR(15 downto 0);
		 immop_out : out STD_LOGIC_VECTOR(1 downto 0);
		 opcode_out : out STD_LOGIC_VECTOR(4 downto 0);
		 reg_dst_out : out STD_LOGIC_VECTOR(4 downto 0);
		 reg1_data_out : out STD_LOGIC_VECTOR(63 downto 0);
		 reg2_data_out : out STD_LOGIC_VECTOR(63 downto 0);
		 reg3_data_out : out STD_LOGIC_VECTOR(63 downto 0)
	     );
end component;

signal alu2rf_we: std_logic;
signal ib2if_id, if_id2id : std_logic_vector(23 downto 0);	
signal id2id_ex_imm, id_ex2alu_imm : std_logic_vector(15 downto 0);
signal id2rf_rs1, id2rf_rs2, id2rf_rs3, id2id_ex_rd, id2id_ex_op, id_ex2alu_rd, id_ex2alu_op, alu2rf_rd: std_logic_vector(4 downto 0);
signal id2id_ex_immop, id_ex2alu_immop : std_logic_vector(1 downto 0);
signal rf2id_ex_rs1, rf2id_ex_rs2, rf2id_ex_rs3, id_ex2alu_rs1, id_ex2alu_rs2, id_ex2alu_rs3, alu2rf_alu_out: std_logic_vector(63 downto 0);

begin
	u1: instruction_buffer
	port map(
	clock => clock,	 
	instruction_in => instruction_in,
	instruction_out => ib2if_id
	);	
	
	u2: instruction_decoder
	port map(
	clock => clock,
	instruction_in => if_id2id,
	alu_op => id2id_ex_op,
	immediate => id2id_ex_imm,
	imm_op => id2id_ex_immop,
	--write_enable => id2id_ex_we,
	rs1 => id2rf_rs1,
	rs2 => id2rf_rs2,
	rs3 => id2rf_rs3,
	rd => id2id_ex_rd
	); 
	
	u3: register_file
	port map(
	clk => clock,
	write_en => alu2rf_we,
	read_addr1 => id2rf_rs1,
	read_addr2 => id2rf_rs2,
	read_addr3 => id2rf_rs3,
	write_reg_addr => alu2rf_rd,
	write_data => alu2rf_alu_out,
	out_reg1 => rf2id_ex_rs1,
	out_reg2 => rf2id_ex_rs2,
	out_reg3 => rf2id_ex_rs3
	); 
	
	u4: alu
	port map(
	clock => clock,
	rs1 => id_ex2alu_rs1,
	rs2 => id_ex2alu_rs2,
	rs3 => id_ex2alu_rs3,
	alu_op => id_ex2alu_op,
	reg_dst_in => id_ex2alu_rd,
	immediate => id_ex2alu_imm,
	li_op => id_ex2alu_immop,
	
	data_out => alu2rf_alu_out,
	write_data_out => alu2rf_we,
	reg_dst => alu2rf_rd
	);
	
	u5: if_id_register
	port map(
	clk => clock, 
	instruction_in => ib2if_id,
	instruction_out => if_id2id
	);
	
	u6: id_ex_register
	port map(
	clk => clock,
	reg1_data_in => rf2id_ex_rs1,
	reg2_data_in => rf2id_ex_rs2,
	reg3_data_in => rf2id_ex_rs3,
	reg_dst_in => id2id_ex_rd,
	opcode_in => id2id_ex_op,
	imm_in => id2id_ex_imm,
	immop => id2id_ex_immop,
	imm_out => id_ex2alu_imm,
	immop_out =>  id_ex2alu_immop,
	opcode_out => id_ex2alu_op,
	reg_dst_out => id_ex2alu_rd,
	reg1_data_out => id_ex2alu_rs1,
	reg2_data_out => id_ex2alu_rs2,
	reg3_data_out => id_ex2alu_rs3
	);
	
	
	
end	structural;
