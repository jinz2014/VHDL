library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all; -- to_unsigned
use ieee.std_logic_arith.all; -- conv_std_logic_vector

------------------------------------------------------
-- Difference between signal and variable 
-- Specify the size of the signal cnt to reduce resources
------------------------------------------------------

entity mod_count is
  generic(N : natural := 4);
  port
  (
    clk    : in std_logic;
    reset  : in std_logic;
    enable   : in std_logic;
    q    : out std_logic_vector(N-1 downto 0) 
  );
  -- shared by multiple architecture blocks 
  constant Max : integer := 2**N - 1;
end entity;

--architecture use_var of mod_count is
--begin
--  process (clk)
--    variable cnt  : integer;
--  begin
--    if (rising_edge(clk)) then
--      if reset = '1' then
--        -- Reset the counter to 0
--        cnt := 0;
--      elsif enable = '1' then
--        if cnt = Max then
--          cnt := 0;
--        else
--              cnt := cnt + 1;
--            end if;
--      end if;
--    end if;
--    
--    -- Output the current count 
--    q <= conv_std_logic_vector(cnt, N);
--  end process;
--end use_var;

architecture use_sig of mod_count is
  subtype cnt_size is integer range 0 to Max;
  signal cnt : cnt_size;
begin
  process (clk)
  begin
    if (rising_edge(clk)) then
      if reset = '1' then
        -- Reset the counter to 0
        cnt <= 0;
      elsif enable = '1' then
        if cnt = Max then
          cnt <= 0;
        else
          cnt <= cnt + 1;
        end if;
      end if;
    end if;
  end process;

  -- Output the current count
  q <= conv_std_logic_vector(cnt, N);

end use_sig;
