
library ieee;
use ieee.std_logic_1164.all;

entity parity is
port(	
	d: in  std_logic_vector(7 downto 0);
	p: out std_logic
);
end parity;  

architecture rtl2008 of parity is
begin
    p <= xor d;
end rtl2008;
