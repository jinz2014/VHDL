library ieee ;
use ieee.std_logic_1164.all;

entity timing_check is
  port(	din:	in  std_logic;
        clk:	in  std_logic
      );
end timing_check;

architecture behav of timing_check is
begin
  process(clk, din)
    variable last_din : std_logic := 'X';
    variable last_time : TIME := 0 ns;
  begin
    if (last_din /= din) then
      last_din  := din;
      last_time := NOW;
    end if;

    if (clk = '1') then
      assert (NOW - last_time >= 20 ns) 
      report "setup violation" severity WARNING;
    end if;
  end process;

  process(clk, din)
    variable last_din : std_logic := 'X';
    variable last_time : TIME := 0 ns;
  begin
    if (last_din /= din) then
      assert (NOW - last_time >= 20 ns) 
      report "hold violation" severity WARNING;
    end if;

    if (clk = '1') then
      last_din  := din;
      last_time := NOW;
    end if;
  end process;
end behav;

