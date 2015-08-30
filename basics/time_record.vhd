library ieee;
use ieee.std_logic_1164.all;

entity time_record is
  port ( a : in std_logic;
         b : out std_logic);
end time_record;

architecture test of time_record is
  type timestamp is
    record
      sec:  integer range 0 to 59;
      min:  integer range 0 to 59;
      hour: integer range 0 to 23;
    end record;

begin
  process is
    variable event : timestamp := (others=>0);
  begin
  end process;
end test;

