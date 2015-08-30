-------------------------------------------------
-- 2:4 Decoder (ESD figure 2.5)
--
-- decoder is a kind of inverse process
-- of multiplexor
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- to_integer

-------------------------------------------------

entity DECODER2x4 is
-- error: Array type case expression must be of a locally static subtype
--generic (N: natural := 2);
port(
      I:  in  std_logic_vector(1 downto 0);
      O:  out std_logic_vector(3 downto 0)
);
end DECODER2x4;

-------------------------------------------------

architecture behv of DECODER2x4 is
begin

    -- process statement

    process (I) begin
    -- use case statement 
    case_label:
    case I is
      when "00" => O <= "0001";
      when "01" => O <= "0010";
      when "10" => O <= "0100";
      when "11" => O <= "1000";
      when others => O <= "XXXX";
    end case case_label;

    end process;

end behv;

architecture when_else of DECODER2x4 is
begin

    -- use when..else statement

    O <= "0001" when I = "00" else
         "0010" when I = "01" else
         "0100" when I = "10" else
         "1000" when I = "11" else
         "XXXX";

end when_else;

architecture shift of DECODER2x4 is
begin
   --- sll(unsigned, integer)
   -- vcom -2008
   O <= B"0001" sll to_integer(unsigned(I));

end shift;
--------------------------------------------------
