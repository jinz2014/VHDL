--------------------------------------------------
-- AND gate (ESD book figure 2.3)		
-- two descriptions provided
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------

entity AND_ent is
port(	x: in std_logic;
	y: in std_logic;
	z: out std_logic
);
end AND_ent;  


architecture beh of AND_ent is
begin

    process(x, y) begin -- process is required
        -- compare to truth table
        if (x='1' and y='1') then
	    z <= '1';
	else
	    z <= '0';
	end if;
    end process;

end beh;

architecture beh2008 of AND_ent is
begin

    process(all) begin 
        if (x and y) then -- e.g. (x and not z and y)
	    z <= '1';
	else
	    z <= '0';
	end if;
    end process;

end beh2008;

architecture rtl of AND_ent is
begin
  process(x,y)  begin -- process is optional
    z <= x and y;
  end process;

end rtl;

--------------------------------------------------
