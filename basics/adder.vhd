--------------------------------------------------------
-- VHDL code for n-bit adder (ESD figure 2.5)	
--
-- function of adder:
-- A plus B to get n-bit sum and 1 bit carry	
-- we may use generic statement to set the parameter 
-- n of the adder.							
--------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--------------------------------------------------------

entity adder is

-- parameter
generic(n: natural :=2);

port(	A:    in std_logic_vector(n-1 downto 0);
      B:    in std_logic_vector(n-1 downto 0);
      cin:  in std_logic;
      cout:	out std_logic;
      sum:  out std_logic_vector(n-1 downto 0)
);

end adder;

--------------------------------------------------------

architecture behv of adder is

-- define a temparary signal of size n+1 to store the result
signal result: std_logic_vector(n downto 0);
 
begin					  
    result <= ('0' & A)+('0' & B) + cin;
    sum    <= result(n-1 downto 0);
    cout   <= result(n);

end behv;

---------------------------------------------------------
-- A'range: n-1 downto 0
---------------------------------------------------------
architecture ripple of adder is
begin					  
  process(A, B, cin) 
    variable carry : std_logic;
  begin
    carry := cin;
    for i in A'reverse_range loop
      sum(i) <= A(i) xor B(i) xor carry;
      carry  := (A(i) and B(i)) or (carry and (A(i) or B(i)));
    end loop;
    cout <= carry;
  end process;
end ripple;

-- VHDL 2008
--architecture behv2008 of adder is
--begin					  
--  (cout, sum) <= ('0' & A)+('0' & B) + cin;
--end behv2008;
--------------------------------------------------------
