---------------------------------------------
-- D Flip-Flop (ESD book Chapter 2.3.1)
-- Flip-flop is the basic component in 
-- sequential logic design
-- we assign input signal to the output 
-- at the clock rising edge 
---------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;
use work.all;

---------------------------------------------

entity dff is
  generic(tpd, tsu, th : delay_length);
  port(	
        clock:		in  std_logic;
        data_in:	in  std_logic;
        data_out:	out std_logic
  );

begin
  setup_check:
  process begin
    wait until clock = '1';
    assert (data_in'last_event >= tsu)
    report ("setup violation")
    severity error;
  end process;

  hold_check:
  process begin
    wait until clock'delayed(th) = '1';
    assert (data_in'delayed'last_event >= th)
    report ("hold violation")
    severity error;
  end process;
end dff;

----------------------------------------------

architecture behv of dff is
begin
  process(clock)
  begin 
	  if (clock='1' and clock'event) then
	    data_out <= data_in after tpd;
	  end if;
  end process;	

end behv;

----------------------------------------------

architecture wait_struct of dff is
begin
  process
  begin -- clock rising edge
	  wait until (clock='1' and clock'event);
	  data_out <= data_in after tpd;
  end process;	
end wait_struct;

architecture concurrent_struct of dff is
begin
    data_out <= data_in after tpd when 
                clock='1' and clock'event;

end concurrent_struct;
