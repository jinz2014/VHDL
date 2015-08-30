--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.mc_package.all;

--------------------------------------------------------------

entity execute is
port(	
	clk:		in std_logic;	
	d_command: 	in command_type;
	d_dst :		in std_logic_vector(addr_width-1 downto 0);
	d_src1 :	in std_logic_vector(addr_width-1 downto 0);
	d_src2 :	in std_logic_vector(addr_width-1 downto 0);
	d_data:		in std_logic_vector(data_width-1 downto 0);

  -- rf outputs, valid for ADD/SUB/MUL/CJE
	d_src1_data:	in std_logic_vector(data_width-1 downto 0);  
	d_src2_data:	in std_logic_vector(data_width-1 downto 0);

  -- asserted when a branch
	flush:		out std_logic;
  -- asserted when a branch
	jump:		out std_logic;  
  -- arithemtic results to rf
	ex_data: 	out std_logic_vector(data_width-1 downto 0); 
  -- arithemtic results write enable to rf
	ex_wr: 		out std_logic; 
	ex_dst :	out std_logic_vector(addr_width-1 downto 0);

	-- driven by the content of <dst> for READ <dst>
	output :	out std_logic_vector(data_width-1 downto 0)
);
end execute;

architecture behav of execute is
	signal int_d_src1_data :	std_logic_vector(data_width-1 downto 0);
	signal int_d_src2_data :	std_logic_vector(data_width-1 downto 0);
	signal int_ex_data :		std_logic_vector(data_width-1 downto 0);
	signal int_ex_dst :		std_logic_vector(addr_width-1 downto 0);

begin
	process(d_command, d_src1, d_src2, d_src1_data, d_src2_data, int_ex_dst, int_ex_data) begin
		if (d_command = LOAD or d_command = NOP) then
			int_d_src1_data <= d_src1_data;
			int_d_src2_data <= d_src2_data;
		else
      -- bypass paths
			if (int_ex_dst = d_src1) then 
				int_d_src1_data <= int_ex_data;
			else
				int_d_src1_data <= d_src1_data;
			end if;

			if (int_ex_dst = d_src2) then
				int_d_src2_data <= int_ex_data;
			else
				int_d_src2_data <= d_src2_data;
			end if;
		end if;
	end process;

	process(clk) begin
		if rising_edge(clk) then
			case d_command is
				when MOVE =>
					int_ex_data <= int_d_src1_data;
					int_ex_dst  <= d_dst;
					ex_wr    <= '1';
					jump        <= '0';
					flush       <= '0';
					output      <= zero;
				when ADD =>
					int_ex_data <= int_d_src1_data + int_d_src2_data;
					int_ex_dst  <= d_dst;
					ex_wr    <= '1';
					jump        <= '0';
					flush       <= '0';
					output      <= zero;
				when SUB =>
					int_ex_data <= int_d_src1_data - int_d_src2_data;
					int_ex_dst  <= d_dst;
					ex_wr    <= '1';
					jump        <= '0';
					flush       <= '0';
					output      <= zero;
				when MUL =>
					int_ex_data <= int_d_src1_data(15 downto 0) * int_d_src2_data(15 downto 0);
					int_ex_dst  <= d_dst;
					ex_wr    <= '1';
					jump        <= '0';
					flush       <= '0';
					output      <= zero;
				when CJE =>
					if (int_d_src1_data = int_d_src2_data) then
						jump        <= '1';
						flush       <= '1';
					else
						jump        <= '0';
						flush       <= '0';
					end if;
					ex_wr    <= '0';
					output      <= zero;
				when LOAD =>
					int_ex_data <= d_data;
					int_ex_dst  <= d_dst;
					ex_wr    <= '1';
					jump        <= '0';
					flush       <= '0';
					output      <= zero;
				when READ =>
					ex_wr    <= '0';
					jump        <= '0';
					flush       <= '0';
					output      <= int_d_src1_data;
				when others =>
					ex_wr    <= '0';
					jump        <= '0';
					flush       <= '0';
					output      <= zero;
			end case;
		end if;
	end process;

	ex_data <= int_ex_data;
	ex_dst  <= int_ex_dst;

end behav;
