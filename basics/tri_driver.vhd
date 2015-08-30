---------------------------------------------------------
-- VHDL model for tri state driver				  
-- by Weijun Zhang, 05/2001
--
-- this friver often used to control system outputs	
---------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tristate_dr is
  generic (N : natural := 8);
port(	d_in:	in std_logic_vector(N-1 downto 0);
	en: 	in std_logic;
	d_out:	out std_logic_vector(N-1 downto 0)
);			  
end tristate_dr;

architecture behavior of tristate_dr is
begin

  process(d_in, en)
  begin
	if en='1' then
	  d_out <= d_in;
	else				   
	  -- array can be created simply by using vector
	  d_out <= (d_out'range => 'Z') ;--"ZZZZZZZZ";
	end if;
  end process;

end behavior;

	
