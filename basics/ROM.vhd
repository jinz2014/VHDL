library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity ROM is
  port(addr : in integer;
       cs   : in std_logic;
       data : out integer);
end ROM;

architecture rom_init of ROM is
begin
  process(addr, cs)

    type dtype is array(0 to 63) of integer;
    variable rom_data : dtype;
    variable i : integer := 0;
    ---------------------------------------------
    -- ROM initialization using a file
    ---------------------------------------------
    variable rom_init : boolean := false; 

    -- file object
    variable file_line : line;
    file file_handle : text is in "test.dat";

  begin
    if (rom_init = false) then
      -- predefined function endfile
      while not endfile(file_handle) and  (i < 64) loop
        readline(file_handle, file_line);
        read(file_line, rom_data(i));
        i := i + 1;
      end loop;
      rom_init := true; --line 10
    end if;

    if (cs = '1') then --line 11
      data <= rom_data(addr); --line 12
    else
      data <= -1; --line 13
    end if;
 end process;
end rom_init;
