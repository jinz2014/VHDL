package p_qual_2 is
  type vector8 is array( 0 to 7) of bit;
end p_qual_2;

use work.p_qual_2.all;
entity latch is
  port( reset    : in bit; 
        clock    : in bit;
        data_in  : in vector8;
        data_out : out vector8);
end latch;
architecture behave of latch is
begin
  process(clock)
  begin
    if (clock = '1') then
      if (reset = '1') then
        --data_out <= vector8'(others => '0');
        --data_out <= ('0', '0', '0', '0','0', '0', '0', '0');
        data_out <= (others => '0');
      else
        data_out <= data_in;
      end if;
    end if;
  end process;
eND behave;
