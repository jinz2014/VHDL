--------------------------------------------------------------
-- Test Bench for 3-bit shift register (ESD figure 2.6)
-- by Weijun Zhang, 04/2001
--
-- please note usually the processes within testbench do
-- not have sesitive list.
-------------------------------------------------------------- 

library ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity shifter_TB is   -- entity declaration
end shifter_TB;

architecture TB of shifter_TB is

    component shift_reg
    port(   I: in std_logic;
     clock: in std_logic;
     shift: in std_logic;
     Q: out std_logic
    );
    end component;

    signal T_I:  std_logic;
    signal T_clock: std_logic;
    signal T_shift: std_logic;
    signal T_Q:  std_logic;

begin

    U_shifter: entity work.shift_reg(behv) 
    generic map (N => 2)
    port map (T_I, T_clock, T_shift, T_Q);
 
    clock:
    process
    begin
      T_clock <= '0';
      wait for 5 ns;
      T_clock <= '1';
      wait for 5 ns;
    end process;

    test:
    process
    begin        
      T_shift <= '1';   -- start shifting  
      T_I <= '0';
      wait for 20 ns;
      T_I <= '1';    -- 1st/2nd bit input
      wait for 20 ns;
      T_I <= '0';   -- 3rd bit input
      wait for 10 ns;
      T_I <= '1';   -- 4th bit input
      wait for 30 ns;

      assert false 
      report "Testbench of Shifter completed successfully!"
      severity failure;
    end process; 


    mon:
    process(T_Q) begin
      if T_Q = '1' then
        assert false 
        report "T_Q is high at " & to_string(now) 
        severity note;
      end if;

      if T_Q = '0' then
        assert false 
        report "T_Q is low at " & to_string(now) 
        severity note;
      end if;
    end process;

end TB;

----------------------------------------------------------------
configuration CFG_TB of shifter_TB is
 for TB
 end for;
end CFG_TB;
-----------------------------------------------------------------
