--------------------------------------------------------------
-- KEYWORD: array, concurrent processes, generic, conv_integer 
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.mc_package.all;

--------------------------------------------------------------

entity regfile is
  generic (  width:  integer:=32;
             --depth:  integer:=4;
             addr:  integer:=4);
port(  
  clk:    in std_logic;  
  flush:  in std_logic;
  rd:     in std_logic;
  wr:     in std_logic;
  raddr1: in std_logic_vector(addr-1 downto 0);
  raddr2: in std_logic_vector(addr-1 downto 0);
  waddr:  in std_logic_vector(addr-1 downto 0); 
  din:    in std_logic_vector(width-1 downto 0);
  dout1:  out std_logic_vector(width-1 downto 0);
  dout2:  out std_logic_vector(width-1 downto 0)
);
end regfile;

--------------------------------------------------------------

architecture behav of regfile is

  -- 16-entry memory
  signal mem: ram_type;

begin  
         
-- rd Functional Section
process(clk) begin
  if rising_edge(clk) then
    if flush='0' then
      if rd='1' then
        if raddr1 /= waddr then
          dout1 <= mem(conv_integer(raddr1)); 
        else
           dout1 <= din;
        end if;

        if raddr2 /= waddr then
          dout2 <= mem(conv_integer(raddr2)); 
        else
          dout2 <= din;
        end if;
      end if;
    else 
      dout1 <= (others => '0');
      dout2 <= (others => '0'); 
    end if;
  end if;
end process;
  
-- wr 
process(clk) begin
  if rising_edge(clk) then
    if flush='0' then 
      if wr = '1' then 
        mem(conv_integer(waddr)) <= din;
      end if;
    end if; 
  end if;
end process;

end behav;
----------------------------------------------------------------
