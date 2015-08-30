
library ieee;
use ieee.std_logic_1164.all;

entity array_and_bit is
port(	
	x: in std_logic_vector(3 downto 0);
	s: in std_logic;
	z: out std_logic_vector(3 downto 0)
);
end array_and_bit;  

architecture rtl of array_and_bit is
begin
    z <= x when s = '1' else (others => '0');
end rtl;

architecture rtl2008 of array_and_bit is
begin
    z <= x and s;
end rtl2008;
