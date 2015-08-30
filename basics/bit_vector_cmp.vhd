entity test_average is
end  test_average; 

architecture behv of test_average is
  type int_array is array(natural range<>) of integer;
  constant samples : int_array := (0, 1, 2, 3, 4);
begin
  process 
  begin
    average_samples;
    v := average(samples); -- must specify the return value
    assert(v = 2.0) report "Error: average value is not 2" severity error;
    wait;
  end process;
end behv;
