----------------------------------------------------------------
-- Test Bench for D flip-flop
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tb_latch is		-- entity declaration
end tb_latch;

----------------------------------------------------------------

architecture TB of tb_latch is

    signal T_data_in: 	std_logic_vector(1 downto 0);
    signal T_data_in_s: std_logic_vector(1 downto 0);
    signal T_clock:	    std_logic;
    signal T_data_out:	std_logic_vector(1 downto 0);
    signal T_datab_out:	std_logic_vector(1 downto 0);
	
    component latch
      generic(n: natural :=2);
      port(	D:	   in std_logic_vector(1 downto 0);
            clock: in std_logic;
            Q:	   out std_logic_vector(1 downto 0);
            Qb:	   out std_logic_vector(1 downto 0)
      );
    end component;
		
begin
  -- instantiate DUT
  U_latch: latch 
  port map (T_data_in, T_clock, T_data_out, T_datab_out);

  -- clock generator
  process
  begin
    T_clock <= '0';
    wait for 5 ns;
    T_clock <= '1';
    wait for 5 ns;
  end process;

	-- test cases
  process
  begin
    T_data_in   <= "01";
    wait for 7 ns;		 -- latch enable
    T_data_in_s <= T_data_in;
    assert (T_data_out=T_data_in) report "Error1!" severity error;
    assert (T_datab_out=not T_data_in) report "Error1!" severity error;

    wait for 5 ns;     -- latch disable
    assert (T_data_out=T_data_in) report "Error1!" severity error;
    assert (T_datab_out=not T_data_in) report "Error1!" severity error;

    T_data_in <= "10"; -- latch still disable
    wait for 1 ns;
    T_data_in_s <= T_data_in;
    -- T_data_in_s is not the updated value in assert
    assert (T_data_out=T_data_in_s) report "Error1!" severity error;
    assert (T_datab_out=not T_data_in_s) report "Error1!" severity error;

    wait for 5 ns;		 -- latch enable
    assert (T_data_out=T_data_in) report "Error1!" severity error;
    assert (T_datab_out=not T_data_in) report "Error1!" severity error;

    wait for 100 ns;		 

    assert false 
    report "Testbench of Latched completed!" 
    severity failure; 

	wait;
  end process;

end TB;

-----------------------------------------------------------------
-- cfg_name of entity_name
--   for arch_name 
--   end for;
-- end cfg_name;
configuration CFG_TB of tb_latch is
	for TB
    for U_latch: latch 
      --use entity work.latch(latch_behv);
      use entity work.latch(latch_guard);
    end for;

    -- for others: latch
    -- use entity work.latch(...);
    -- end for;

    -- for all: latch
    -- use entity work.latch(...);
    -- end for;
    
	end for;
end CFG_TB;
-----------------------------------------------------------------
