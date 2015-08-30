-- unconstrained type declaration

-- TYPE BIT_VECTOR IS ARRAY(NATURAL RANGE <>) OF BIT;

library ieee;
use ieee.std_logic_1164.all;

package utility_package is
  subtype eightbit is bit_vector(0 to 7);
  subtype fourbit is bit_vector(0 to 3);
  type st16 is array (0 to 15) of std_logic;

  function shift_right(val : bit_vector)
  return bit_vector;

  function vec2int(v : in st16) 
  return integer;

  function add(a : in st16; 
               b : in st16) return integer;

  function bv_to_natural(bv : in bit_vector) return natural;

  procedure vec2int_p (z      : in    std_logic_vector;
                       x_flag : out   boolean; 
                       q      : inout integer);

  -- specify the type of clk as signal 
  procedure clock_gen (signal clk    : out std_logic;
                       constant period, pulse, phase : in time);

end utility_package;

package body utility_package is

  -- convert a bit vector to a natural number
  function bv_to_natural(bv : in bit_vector) return natural is
    variable r : natural := 0;
  begin
    for i in bv'range loop
      -- position of '0' or '1' in bit type
      r := 2 * r + bit'pos(bv(i));
    end loop;
    return r;
  end function bv_to_natural;

  -- generate a flexbile clock signal
  procedure clock_gen (signal clk    : out std_logic;
                       constant period, pulse, phase : in time) is
  begin
    assert(period > pulse) 
    report "clock period must be larger than pulse width"
    severity failure;

    wait for phase;
    loop
      clk <= '1', '0' after pulse;
      wait for period;
    end loop;
  end clock_gen;


  -- convert a std_logic_vector to an integer
  -- x_flag is set when any bit contains a value other than 
  -- '0' or '1'
  procedure vec2int_p (z      : in    std_logic_vector;
                       x_flag : out   boolean; 
                       q      : inout integer) is
  begin
    q := 0;
    x_flag := false;

    for i in z'range loop
      q := q * 2;
      if z(i) = '1' then
        q := q + 1;
      elsif z(i) /= '0' then
        x_flag := true;
      end if;
    end loop;
  end vec2int_p;

  -- 16-bit std_logic_vector add
  function add(a : in st16; b : in st16) return integer is
    variable aint : integer;
    variable bint : integer;
  begin
    aint := vec2int(a);
    bint := vec2int(b);
    return aint + bint;
  end add;

  function vec2int(v : st16) return integer is
    variable result : integer := 0;
    variable prod : integer := 1;
  begin
    for i in 0 to 15 loop
      if '1' = v(i) then
        result := result + prod;
      end if;
      prod := prod * 2;
    end loop;

    return result;
  end vec2int;

  -- logical shift right by 1 bit
  function shift_right(val : bit_vector) return bit_vector is 
    variable result : bit_vector(0 to (val'length -1));
  begin
    result := val;
    if (val'length > 1) then
      for i in 0 to (val'length - 2) loop
        result(i) := result(i+1);
      end loop;
      result(val'length -1) := '0';
    else
      result(0) := '0';
    end if;
    return result;
  end shift_right;

end utility_package;
