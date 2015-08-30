--------------------------------------------------------------------------
-- Decode the command to produce register file src and dest addr_widthess.
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.mc_package.all;

--------------------------------------------------------------

entity decode is
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
end decode;

architecture behav of decode is
begin
	process(clk) begin
		if rising_edge(clk) then
			if flush = '0' then
				d_command <= pd_command;
				case pd_command is
					-- MOVE <src1>, <dst>
					when MOVE => 
						d_src1 <= pd_src1;
						d_src2 <= "000";
						d_dst  <= pd_dst;
						d_data <= zero;
					-- ADD <src1>, <src2>, <dst>
					when ADD => 
						d_src1 <= pd_src1;
						d_src2 <= pd_src2;
						d_dst  <= pd_dst;
						d_data <= zero;
					-- SUB <src1>, <src2>, <dst>
					when SUB => 
						d_src1 <= pd_src1;
						d_src2 <= pd_src2;
						d_dst  <= pd_dst;
						d_data <= zero;
					-- MUL <src1>, <src2>, <dst>
					when MUL =>
						d_src1 <= pd_src1;
						d_src2 <= pd_src2;
						d_dst  <= pd_dst;
						d_data <= zero;
					-- CJE <src1>, <src2>, <dst>
					when CJE => 
						d_src1 <= pd_src1;
						d_src2 <= pd_src2;
						d_dst  <= pd_dst;
						d_data <= zero;
					-- LOAD data, <dst>
					when LOAD => 
						d_src1 <= "000";
						d_src2 <= "000";
						d_dst  <= pd_dst;
						d_data <= pd_data;
					-- READ <dst>
					when READ => 
						d_src1 <= "000";
						d_src2 <= "000";
						d_dst  <= pd_dst;
						d_data <= zero;
					when others =>
						d_src1 <= "000";
						d_src2 <= "000";
						d_dst  <= "000";
						d_data <= zero;
				end case;

			else
				d_command <= NOP;
				d_src1 <= "000";
				d_src2 <= "000";
				d_dst  <= "000";
				d_data <= zero;
			end if;
		end if;
	end process;
end behav;
