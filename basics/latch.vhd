---------------------------------------------------
-- n-bit Register (ESD book figure 2.6)
-- by Weijun Zhang, 04/2001
--
-- KEY WORD: concurrent, generic and range
---------------------------------------------------
	
library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

---------------------------------------------------

entity latch is

generic(n: natural :=2);

port(	D:	    in  std_logic_vector(n-1 downto 0);
	    clock:	in  std_logic;
	    Q:	    out std_logic_vector(n-1 downto 0);
	    Qb:	    out std_logic_vector(n-1 downto 0)
);
end latch;

----------------------------------------------------
-- is a common style 
----------------------------------------------------

architecture latch_behv of latch is 
begin
  process(D, clock)
  begin 
    if (clock='1') then
		  Q  <= D;
		  Qb <= not(D) ;
	  end if;
  end process;
end latch_behv;

----------------------------------------------------
-- is it a common style ?
----------------------------------------------------

architecture latch_guard of latch is 
begin
  G1: block(clock='1')
  begin
		Q  <= guarded D;
		Qb <= guarded not(D) ;
  end block G1;
end latch_guard;

