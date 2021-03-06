----------------------------------------------------
-- Behavior description of n-bit counter
----------------------------------------------------
	
library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- infix expresion '+'

----------------------------------------------------

entity counter is

generic(N: natural :=2);
port(
      clock:  in std_logic;
      clear:  in std_logic;
      count:  in std_logic;
      Q:      out std_logic_vector(N-1 downto 0)
    );
end counter;

----------------------------------------------------

architecture behv of counter is		 	  
  signal Pre_Q: std_logic_vector(N-1 downto 0);

begin
  process(clock, clear)
  begin
    if clear = '1' then
      Pre_Q <= (Pre_Q'range => '0');
    elsif (clock='1' and clock'event) then
      if count = '1' then
        Pre_Q <= Pre_Q + 1;
      end if;
    end if;
  end process;	

  -- concurrent assignment statement
  Q <= Pre_Q;

end behv;

-----------------------------------------------------
