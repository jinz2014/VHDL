library ieee;
use ieee.std_logic_1164.all;

package p_cpu is
  type t_instr is (jump, 
                   load, store, 
                   addd, subb, 
                   test, 
                   noop);
  function convertstring( s : string) return t_instr;
end p_cpu;

package body p_cpu is
  function convertstring(s : string(1 to 5)) return t_instr is
  begin
    assert false report "opcode is " & s severity note;
    case s is
      -- string length must be 5
      when "jump " =>
        return jump;
      when "load " =>
        return load;
      when "store" =>
        return store;
      when "addd " =>
        return addd;
      when "subb " =>
        return subb;
      when "test " =>
        return test;
      when "noop " =>
        return noop;
      when others =>
        return noop;
    end case;
  end convertstring;
end p_cpu;

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use work.p_cpu.all;

entity cpu_driver is
  port( --next_instr : in boolean;
        instr : out t_instr;
        src : out integer;
        dst : out integer);
end cpu_driver;

architecture a_cpu_driver of cpu_driver is
  file instr_file : text open read_mode is "instfile.txt";
begin
  read_instr : process --(next_instr)
    variable aline : line;
    variable a_instr : string(1 to 5);
    variable asrc, adst : integer;
    variable v_instr : t_instr;
  begin
    while not endfile(instr_file) loop
      readline( instr_file, aline);

      -- assume no leading spaces in the instfile.txt
      if (aline'length < a_instr'length) then
        read(aline, a_instr(1 to aline'length));
      else
        read(aline, a_instr);
      end if;

      if (aline'length > 0) then
        read( aline, asrc);
      end if;

      if (aline'length > 0) then
        read( aline, adst);
      end if;

      -- read multiple values on a line
      v_instr := convertstring(a_instr);
      assert false
      report "check instructions type: " & to_string(v_instr)
      severity note;

      -- clear the a_instr
      a_instr(5) := ' ';
      instr <= v_instr;

      --src <= asrc;
      --dst <= adst;



    end loop;
    wait;
  end process read_instr;
end a_cpu_driver;
