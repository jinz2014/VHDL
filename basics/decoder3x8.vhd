library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity decoder3x8 is
-- error: Array type case expression must be of a locally static subtype
--generic (N: natural := 2);
port(
      I:  in  std_logic_vector(2 downto 0);
      O:  out std_logic_vector(7 downto 0)
);
end decoder3x8;

-------------------------------------------------

architecture behv of decoder3x8 is
begin
  process (I) begin
    case_label:
    case I is
      when "000" => O <= B"0000_0001";
      when "001" => O <= B"0000_0010";
      when "010" => O <= B"0000_0100";
      when "011" => O <= B"0001_1000";
      when "100" => O <= B"0001_0000";
      when "101" => O <= B"0010_0000";
      when "110" => O <= B"0100_0000";
      when "111" => O <= B"1000_0000";
      when others => O <="XXXXXXXX";
    end case case_label;
  end process;
end behv;

