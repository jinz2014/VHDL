entity test_average is
end  test_average; 

architecture behv of test_average is
  type int_array is array(natural range<>) of integer;
  constant samples : int_array := (0, 1, 2, 3, 4);
begin
  process 

    variable v : real;

    procedure average_samples is
      variable average : real;
      variable total: integer := 0;
    begin
      assert samples'length > 0 severity failure;
      for i in samples'range loop
        total := total + samples(i);
      end loop;
      average := real(total) / real(samples'length);
    end; 

    function average(values : int_array) return real is
      variable total: integer := 0;
    begin
      assert values'length > 0 severity failure;
      for i in values'range loop
        total := total + values(i);
      end loop;
      return real(total) / real(values'length);
    end; 

  begin
    average_samples;
    v := average(samples); -- must specify the return value
    assert(v = 1.0) report "Error: average value is not 1" severity error;
    wait;
  end process;
end behv;
