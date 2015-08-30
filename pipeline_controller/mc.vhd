library ieee;
use ieee.std_logic_1164.all;
use work.mc_package.all;

entity mc is
port (
clk   : in std_logic;
inst  : in std_logic_vector(inst_width-1 downto 0);
src1  :	in std_logic_vector(addr_width-1 downto 0);
src2  :	in std_logic_vector(addr_width-1 downto 0);
dst   : in std_logic_vector(addr_width-1 downto 0); 
data  : in std_logic_vector(data_width-1 downto 0);
jump  :	out std_logic;  -- asserted when a branch
output:	out std_logic_vector(data_width-1 downto 0)
);
end mc;

architecture mc_arch of mc is

component decode -- is optional
port(	
	clk:		in std_logic;	
	pd_command: 	in command_type;
	pd_src1:	in std_logic_vector(addr_width-1 downto 0);
	pd_src2:	in std_logic_vector(addr_width-1 downto 0);
	pd_dst: 	in std_logic_vector(addr_width-1 downto 0); 
	pd_data: 	in std_logic_vector(data_width-1 downto 0);
	flush:		in std_logic;
	-- to execute block
	d_command: 	out command_type;
	d_dst :		out std_logic_vector(addr_width-1 downto 0);
	d_src1:		out std_logic_vector(addr_width-1 downto 0);
	d_src2:		out std_logic_vector(addr_width-1 downto 0);
	d_data:		out std_logic_vector(data_width-1 downto 0)
);
end component;

component regfile 
port(	
	clk:		in std_logic;	
	flush:		in std_logic;
	rd:		in std_logic;
	wr:		in std_logic;
	raddr1:	in std_logic_vector(addr_width-1 downto 0);
	raddr2:	in std_logic_vector(addr_width-1 downto 0);
	waddr: 	in std_logic_vector(addr_width-1 downto 0); 
	din: 	in std_logic_vector(data_width-1 downto 0);
	dout1: 	out std_logic_vector(data_width-1 downto 0);
	dout2: 	out std_logic_vector(data_width-1 downto 0)
);
end component;

component pd 
port(	
	clk:		in std_logic;	
	flush:		in std_logic;
	src1:		in std_logic_vector(addr_width-1 downto 0);
	src2:		in std_logic_vector(addr_width-1 downto 0);
	dst :		in std_logic_vector(addr_width-1 downto 0);
	inst:		in std_logic_vector(2 downto 0);
	data:		in std_logic_vector(data_width-1 downto 0);
	pd_rd:		out std_logic;
	pd_src1:	out std_logic_vector(addr_width-1 downto 0);
	pd_src2:	out std_logic_vector(addr_width-1 downto 0);
	pd_dst: 	out std_logic_vector(addr_width-1 downto 0); 
	pd_data: 	out std_logic_vector(data_width-1 downto 0);
	pd_command: 	out command_type
);
end component;

component execute
port(	
	clk:		in std_logic;	
	d_command: 	in command_type;
	d_dst :		in std_logic_vector(addr_width-1 downto 0);
	d_src1 :	in std_logic_vector(addr_width-1 downto 0);
	d_src2 :	in std_logic_vector(addr_width-1 downto 0);
	d_data:		in std_logic_vector(data_width-1 downto 0);
	d_src1_data:	in std_logic_vector(data_width-1 downto 0);  -- rf output, valid for ADD/SUB/MUL/CJE
	d_src2_data:	in std_logic_vector(data_width-1 downto 0);  -- rf output, valid for ADD/SUB/MUL/CJE

	flush:		out std_logic;  -- asserted when a branch
	jump:		out std_logic;  -- asserted when a branch
	ex_data: 	out std_logic_vector(data_width-1 downto 0); -- arithemtic results to rf
	ex_wr: 		out std_logic; -- arithemtic results to rf
	ex_dst :	out std_logic_vector(addr_width-1 downto 0);
	-- driven by the content of <dst> for READ <dst>
	output :	out std_logic_vector(data_width-1 downto 0)
);
end component ;


signal sig_clk   : std_logic;
signal sig_inst  : std_logic_vector(2 downto 0);
signal sig_src1  : std_logic_vector(addr_width-1 downto 0);
signal sig_src2  : std_logic_vector(addr_width-1 downto 0);
signal sig_dst   : std_logic_vector(addr_width-1 downto 0);
signal sig_data  : std_logic_vector(data_width-1 downto 0);
--signal sig_jump  : std_logic;
signal sig_flush  : std_logic;

signal sig_pd_command  : command_type;
signal sig_pd_src1  : std_logic_vector(addr_width-1 downto 0);
signal sig_pd_src2  : std_logic_vector(addr_width-1 downto 0);
signal sig_pd_dst   : std_logic_vector(addr_width-1 downto 0);
signal sig_pd_data  : std_logic_vector(data_width-1 downto 0);
signal sig_pd_rd    : std_logic;

signal sig_d_command  : command_type;
signal sig_d_src1  : std_logic_vector(addr_width-1 downto 0);
signal sig_d_src2  : std_logic_vector(addr_width-1 downto 0);
signal sig_d_dst   : std_logic_vector(addr_width-1 downto 0);
signal sig_d_src1_data  : std_logic_vector(data_width-1 downto 0);
signal sig_d_src2_data : std_logic_vector(data_width-1 downto 0);
signal sig_d_data  : std_logic_vector(data_width-1 downto 0);

signal sig_ex_data  : std_logic_vector(data_width-1 downto 0);
signal sig_ex_dst   : std_logic_vector(addr_width-1 downto 0);
signal sig_ex_wr    : std_logic;

begin
dut_pd : pd port map (
	clk => sig_clk,
	inst => sig_inst,
	src1 => sig_src1,
	src2 => sig_src2,
	dst  => sig_dst ,
	data  => sig_data,
	flush  => sig_flush,
	pd_command  => sig_pd_command,
	pd_src1 => sig_pd_src1,
	pd_src2 => sig_pd_src2,
	pd_dst => sig_pd_dst,
	pd_data => sig_pd_data,
	pd_rd => sig_pd_rd
);

dut_decode : decode port map(	
	clk        => sig_clk,
	pd_command => sig_pd_command,
	pd_src1    => sig_pd_src1,
	pd_src2    => sig_pd_src2,
	pd_dst     => sig_pd_dst,
	pd_data    => sig_pd_data,
	flush      => sig_flush,
	d_command  => sig_d_command,
	d_dst      => sig_d_dst,
	d_src1     => sig_d_src1,
	d_src2     => sig_d_src2,
	d_data     => sig_d_data
);

dut_execute : execute port map(	
	clk        => sig_clk,
	d_command  => sig_d_command,
	d_dst      => sig_d_dst,
	d_src1     => sig_d_src1,
	d_src2     => sig_d_src2,
	d_data     => sig_d_data,
	d_src1_data=> sig_d_src1_data, -- from rf
	d_src2_data=> sig_d_src2_data, -- from rf
	flush      => sig_flush,
	ex_data    => sig_ex_data,
	ex_wr      => sig_ex_wr,
	ex_dst     => sig_ex_dst,
	jump       => jump,
	output     => output
);

dut_regfile : regfile port map (
	clk        => sig_clk,
	flush      => sig_flush,
	rd         => sig_pd_rd,
	raddr1     => sig_pd_src1,
	raddr2     => sig_pd_src2,
	dout1      => sig_d_src1_data,
	dout2      => sig_d_src2_data,
	din        => sig_ex_data,
	wr         => sig_ex_wr,
	waddr      => sig_ex_dst
);

end mc_arch;


