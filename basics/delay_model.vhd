library ieee;
use ieee.std_logic_1164.all;
entity delay_model is
  port ( a : in std_logic;
         b : out std_logic);
end delay_model;

architecture inertia_delay of delay_model is
begin
  b <= a after 20 ns;
end inertia_delay;

architecture transport_delay of delay_model is
begin
  b <= transport a after 20 ns;
end transport_delay;

