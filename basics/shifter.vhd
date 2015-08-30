---------------------------------------------------
-- (N+1)-bit Shift-Register/Shifter
-- ech register is initialized to 1
---------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

---------------------------------------------------

entity shift_reg is
generic(N: natural :=2);
port(I:    in std_logic;
     clock:in std_logic;
     shift:in std_logic;
     Q:    out std_logic
);
end shift_reg;

---------------------------------------------------

architecture behv of shift_reg is

  -- initialize the declared signal
  signal S: std_logic_vector(N downto 0) := (others => '1');

begin
    
  process(I, clock, shift, S)
    begin

    -- everything happens upon the clock changing
    if clock'event and clock='1' then
      if shift = '1' then
        S <= I & S(N downto 1);
       end if;
    end if;
  end process;

  -- concurrent assignment
  Q <= S(0);

end behv;

----------------------------------------------------
