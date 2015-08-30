---------------------------------------------------
-- srl, sll, and sra operators are not synthesizable
--A sll to_integer(unsigned(B));
--A srl to_integer(unsigned(B));	
--A sra to_integer(unsigned(B));
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.alu_type.all;

---------------------------------------------------

entity ALU is
  port(  
        A:    in data_size;
        B:    in data_size;
        func: in alu_func;
        res:  out data_size;
        z:    out std_logic;
        n:    out std_logic;
        v:    out std_logic
  );

end ALU;

---------------------------------------------------

architecture behv of ALU is

  component adder is
  generic(n: natural :=2);
  port( A:    in std_logic_vector(n-1 downto 0);
        B:    in std_logic_vector(n-1 downto 0);
        cin:  in std_logic;
        cout: out std_logic;
        sum:  out std_logic_vector(n-1 downto 0));
  end component;

  signal sum : std_logic_vector(31 downto 0);
  signal cin : std_logic;
  signal nB  : std_logic_vector(31 downto 0);

begin             
  u_adder: entity work.adder(behv) 
  generic map(n => 32)
  port map ( A    => A, 
             B    => nB, 
             cin  => cin, 
             cout => v, 
             sum  => sum);

  alu_datapath:
  process(A, B, func, sum) 
    variable tmp : std_logic_vector(31 downto 0);
  begin
    case func is
      --when alu_add | alu_addu | alu_sub | alu_subu => tmp := sum;
      when alu_and   =>  tmp := A and B;
      when alu_or    =>  tmp := A or B;
      when alu_xor   =>  tmp := A xor B;
      when alu_sll   =>  tmp := std_logic_vector(shift_left(unsigned(A), 
                                to_integer(unsigned(B))));
      when alu_srl   =>  tmp := std_logic_vector(shift_right(unsigned(A), 
                                to_integer(unsigned(B))));
      when alu_sra   =>  tmp := std_logic_vector(shift_right(signed(A), 
                                to_integer(unsigned(B))));
      when alu_pass1 =>  tmp := A;
      when alu_pass2 =>  tmp := B;
      when others    =>  tmp := sum;
    end case;

    res <= tmp; 
    if tmp = X"0000_0000" then
      z <= '1';
    else 
      z <= '0';
    end if;
    n <= tmp(31);
  end process;

  add_sub:
  process (B, func)
  begin
    if func = alu_sub or func = alu_subu then
      cin <= '1';
      nB  <= not B;
    else
      cin <= '0';
      nB  <= B;
    end if;
  end process;

end behv;

----------------------------------------------------
