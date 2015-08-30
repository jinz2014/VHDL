library ieee;
use ieee.std_logic_1164.all;

package mc_package is

type command_type is (MOVE, ADD, SUB, MUL, CJE, LOAD, READ, NOP);
type ram_type is array (0 to 15) of std_logic_vector(31 downto 0);
constant zero : std_logic_vector(31 downto 0) := (others => '0');
constant inst_width:  integer  := 3;  -- inst width
constant data_width:  integer  := 32;  -- data width
constant addr_width:  integer  := 4;  -- rf addr_width width

end mc_package;

