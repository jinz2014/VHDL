--------------------------------------------------------------
-- decode the instruction to produce one-hot command output, and 
-- register file read signal
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.mc_package.all;

--------------------------------------------------------------

entity pd is
  port(  
    clk:          in std_logic;  
    flush:        in std_logic;
    src1:         in std_logic_vector(addr_width-1 downto 0);
    src2:         in std_logic_vector(addr_width-1 downto 0);
    dst :         in std_logic_vector(addr_width-1 downto 0);
    inst:         in std_logic_vector(inst_width-1 downto 0);
    data:         in std_logic_vector(data_width-1 downto 0);
    pd_rd:        out std_logic;
    pd_src1:      out std_logic_vector(addr_width-1 downto 0);
    pd_src2:      out std_logic_vector(addr_width-1 downto 0);
    pd_dst:       out std_logic_vector(addr_width-1 downto 0); 
    pd_data:      out std_logic_vector(data_width-1 downto 0);
    pd_command:   out command_type
  );
end pd;



architecture behav of pd is
begin
  process(clk) 
  begin
    if rising_edge(clk) then
      pd_src1  <= src1;
      pd_src2  <= src2;
      pd_dst   <= dst;

      if flush = '0' then
        case inst is
          when "000" => 
            pd_command <= MOVE;
            pd_rd <= '1';
          when "001" => 
            pd_command <= ADD;
            pd_rd <= '1';
          when "010" => 
            pd_command <= SUB;
            pd_rd <= '1';
          when "011" => 
            pd_command <= MUL;
            pd_rd <= '1';
          when "100" => 
            pd_command <= CJE;
            pd_rd <= '1';
          when "101" => 
            pd_command <= LOAD;
            pd_rd <= '0';
          when "110" => 
            pd_command <= READ;
            pd_rd <= '1';
          when others =>
            pd_command <= NOP;
            pd_rd <= '0';
        end case;

        -- avoid setting pd_data for every case
        if inst = "101" then
          pd_data  <= data;
        else
          pd_data  <= (others => '0');
        end if;
      else
        pd_command <= NOP;
        pd_rd      <= '0';
        pd_data    <= (others => '0');
      end if;
      
    end if;
  end process;
end behav;
