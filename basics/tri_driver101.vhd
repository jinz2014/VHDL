---------------------------------------------------------
-- VHDL model for tri state driver  
--
-- Z when en = 0 or L
-- 0 when en = (1 or H) and din = (0 or L)
-- 1 when en = (1 or H) and din = (1 or H)
-- X otherwise
---------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tri_drv101 is
  port(
      d_in:  in  std_logic;
      en:    in  std_logic;
      d_out: out std_logic
);  
end tri_drv101;

architecture behavior of tri_drv101 is
begin
  process(d_in, en)
  begin
    if_label:
    if en='1' or en='H' then
      if d_in = '0' or d_in = 'L' then
        d_out <= '0';
      elsif d_in = '1' or d_in = 'H' then
        d_out <= '1';
      else
        d_out <= 'X';
      end if;
    elsif en = '0' or en = 'L' then
      d_out <= 'Z';
    else
      d_out <= 'X';
    end if if_label;
  end process;
end behavior;


