library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity decoder_tb is
  generic(N: natural := 3;
          M: natural := 2**N);
end decoder_tb;

architecture behv of decoder_tb is

    signal T_I: std_logic_vector(N-1 downto 0);
    signal T_O: std_logic_vector(M-1 downto 0);

    type test_vector is
      record
        test_in  : std_logic_vector(N-1 downto 0);
        gold_out : std_logic_vector(M-1 downto 0);
        delay    : delay_length;
      end record test_vector; 

    type test_suite is array(natural range<>) of test_vector;

    -- a variable ts is not allowed to have an unconstrained index
    constant ts : test_suite := (
      (test_in => "000", delay=>1 ns, gold_out => B"0000_0001"),
      (test_in => "001", delay=>1 ns, gold_out => B"0000_0010"),
      (test_in => "010", delay=>1 ns, gold_out => B"0000_0100"),
      (test_in => "011", delay=>1 ns, gold_out => B"0000_1000"), 
      (test_in => "100", delay=>1 ns, gold_out => B"0001_0000"),
      (test_in => "101", delay=>1 ns, gold_out => B"0010_0000"),
      (test_in => "110", delay=>1 ns, gold_out => B"0100_0000"),
      (test_in => "111", delay=>1 ns, gold_out => B"1000_0000"), 
      (test_in => "XXX", delay=>1 ns, gold_out => "XXXXXXXX")
    );

    -- declare the component
    component decoder3x8
    port(
          I:in std_logic_vector(N-1 downto 0);
          O:out std_logic_vector(M-1 downto 0)
    );
    end component;

begin

  U_decoder: entity work.decoder3x8(behv)
    port map (T_I, T_O);

  process

    -- variable should be declared within process
    --variable err_cnt : integer := 0;

  begin

    for i in ts'range loop
      wait for 10 ns;
      T_I <= ts(i).test_in;
      wait for ts(i).delay; 
      assert (T_O = ts(i).gold_out) 
      report "Error: " & to_string(T_O) & " != " & to_string(ts(i).gold_out)
      severity error;
    end loop;

    assert false report "Finished test" severity note;

    wait; -- comment it out will run the test forever

  end process;

end behv;

