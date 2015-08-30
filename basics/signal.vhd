library ieee;
use ieee.std_logic_1164.all;

package sigdecl is
  type bus_type is array(0 to 7) of std_logic;
  signal vcc     : std_logic := '1';
  signal gnd     : std_logic := '0';

  function magic_function( a : in bus_type ) return bus_type;

end sigdecl;

use work.sigdecl.all;
use ieee.std_logic_1164.all;
entity board_design is
  port( data_in : in bus_type;
  port( data_out : out bus_type);
  -- signal global to entity and any arch of entity board_design
  signal sys_clk : std_logic := ‘1’;
end board_design;

architecture data_flow of board_design is
  -- local signals
  signal int_bus : bus_type;

  constant disconnect_value : bus_type
  := (‘x’, ‘x’, ‘x’, ‘x’, ‘x’, ‘x’, ‘x’, ‘x’);
begin
  int_bus <= data_in when sys_clk = ‘1’
             else int_bus;
  data_out <= magic_function(int_bus) when sys_clk = ‘0’
                else disconnect_value;
  sys_clk <= not(sys_clk) after 50 ns;
end data_flow;

