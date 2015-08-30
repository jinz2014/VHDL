library IEEE;
use IEEE.std_logic_1164.all;

entity shifter_mode is
  generic ( n : integer := 4);
  port ( 
          clk      : in std_logic;
          ld       : in std_logic;
          en       : in std_logic;
          data_in  : in std_logic_vector(n-1 downto 0);
          mode     : in std_logic_vector(1 downto 0);
          data_out : out std_logic_vector(n-1 downto 0)
       );
end shifter_mode;

architecture behav of shifter_mode is
  signal data_out_int : std_logic_vector(n-1 downto 0);

begin
  process(clk) 
  begin
    if (clk = '1' and clk'event) then
      if (en = '1') then
        if (ld = '1') then
          data_out_int <= data_in;
        else
          case mode is
            -- shift left
            when "00" => 
              data_out_int <= data_out_int(n-2 downto 0) & '0';
            -- shift right
            when "01" => 
              data_out_int <= '0' & data_out_int(n-1 downto 1);
            -- rotate shift left
            when "10" => 
              data_out_int <= data_out_int(n-2 downto 0) & data_out_int(n-1);
            -- rotate shift right
            when "11" => 
              data_out_int <= data_out_int(0) & data_out_int(n-1 downto 1);
            when others =>
              data_out_int <= (data_out_int'range => '0');
          end case;
        end if;
      else -- en = 0
        data_out_int <= (data_out_int'range => '0');
      end if;
    end if;
  end process;
  data_out <= data_out_int;
end behav;



          

