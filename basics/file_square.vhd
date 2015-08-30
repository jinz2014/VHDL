library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

----------------------------------------
-- read (L : inout line, out integer);
--  integer (e.g. 10)
--  16   (e.g. 16#F) 
--  1_2_3 (ignore underscores in between)
--  10  20 (ignore 20)
----------------------------------------

entity file_square is
  port( go : in std_logic);
end file_square;

architecture square of file_square is
begin
  process(go)
    -- vhdl87 
    --file infile  : text is in  "text_io_din.txt";
    --file outfile : text is out "text_io_dout.txt";
    file infile  : text open read_mode is  "text_io_din.txt";
    file outfile : text open write_mode is "text_io_dout.txt";
    variable out_line, in_line : line;
    variable my_line : line;
    variable int_val : integer;
  begin
    while not( endfile(infile)) loop
      -- read a line from the input file
      readline(infile, in_line);
      -- read a value from the line
      read(in_line, int_val);

      -- square the value
      int_val := int_val **2;

      -------------------------------------------
      -- in_line is not always empty after a read
      -------------------------------------------

      -- write the squared value to the line
      write(out_line, int_val);
      -- write the line to the output file and flush out_line
      writeline(outfile, out_line);
    end loop;
  end process;
end square;
