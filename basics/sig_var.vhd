--------------------------------------------------------
-- Signal vs. Variable (sig_var.vhd)
-- we get the same simulation results 
--------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity sig_var is
port(	d1, d2, d3:	in std_logic;
	res1, res2, res3:	out std_logic);
end sig_var;

architecture behv of sig_var is

  signal sig_s1: std_logic;

begin
	
  proc1: 
  process(d1,d2,d3)
    variable var_s1: std_logic;
  begin
    var_s1 := d1 and d2;
    res1   <= var_s1 xor d3;
  end process;
		
	sig_s1 <= d1 and d2;
	res2   <= sig_s1 xor d3;

  proc2:
  process(sig_s1, d3)
  begin
    if sig_s1 = '1' then
      res3 <= not d3;
    else
      res3 <= d3;
    end if;
  end process;

end behv;

-- PRAGMA translate_off
	
	
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity sig_var_TB is				-- entity declaration
end sig_var_TB;

architecture TB of sig_var_TB is

    component sig_var is
    port(	
    d1:	in std_logic;
		d2:	in std_logic;	 		
		d3:	in std_logic;	 
		res1:	out std_logic;				  
		res2:	out std_logic;
		res3:	out std_logic
    );
    end component;

    signal d1,d2,d3:	std_logic;
    
    begin

        U_sig_var: sig_var port map (d1,d2,d3,open, open);
          
	  process begin
	d1 <= '0';			-- clock cycle is 10 ns
	wait for 5 ns;
	d1 <= '1';
	wait for 5 ns;
    end process;
									  
	  process begin
	d2 <= '0';			-- clock cycle is 10 ns
	wait for 10 ns;
	d2 <= '1';
	wait for 10 ns;
    end process;		

	  process begin
	d3 <= '0';			-- clock cycle is 10 ns
	wait for 15 ns;
	d3 <= '1';
	wait for 15 ns;
    end process;		
    
    process begin
      wait for 100 ns;
      wait;
    end process;
    
end TB;
--------------------------------------------------------------------
configuration CFG_TB of sig_var_TB is
	for TB
	end for;
end CFG_TB;
--------------------------------------------------------------------
-- PRAGMA translate_on
