-- Study the differences of using var/sig for a sequential logic

library ieee ;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;

---------------------------------------------------

entity sreset_register is
  generic(n: natural :=2);
  port( 
        clock:  in std_logic;
        clear:  in std_logic;
        load:   in std_logic;
        I:      in std_logic_vector(n-1 downto 0);
        Q:      out std_logic_vector(n-1 downto 0)
  );
end sreset_register;
---------------------------------------------------
architecture behv_sig of sreset_register is
  signal Q_tmp: std_logic_vector(n-1 downto 0);
begin 
  process(clock) begin
    if rising_edge(clock) then
     if clear = '1' then
      Q_tmp <= (Q_tmp'range => '0');
     elsif load = '1' then
      Q_tmp <= I;
     end if;
    end if;
  end process;
  -- concurrent statement
  Q <= Q_tmp;
end behv_sig;



-- variable Q_tmp is not visiable in the simulation wave

architecture behv_var of sreset_register is
begin

process(clock) 
  variable Q_tmp: std_logic_vector(n-1 downto 0);
begin
  if rising_edge(clock) then
    if clear = '1' then
      Q_tmp := (Q_tmp'range => '0');
    elsif load = '1' then
      Q_tmp := I;
    end if;
  end if;
  Q <= Q_tmp;
end process;

end behv_var;
