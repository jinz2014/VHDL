----------------------------------------------------------------------
-- Test Bench for 2-bit Adder (ESD figure 2.5)
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity ADDER_TB is				-- entity declaration
end ADDER_TB;

architecture FILE_TB of ADDER_TB is
    component ADDER is
    port(	
          A:	  in std_logic_vector(1 downto 0);
          B:	  in std_logic_vector(1 downto 0);	 
          cin:	in std_logic;				  
          cout:	out std_logic;				  
          sum:	out std_logic_vector(1 downto 0)
    );
    end component;

    signal A, B:	std_logic_vector(1 downto 0);
    signal cin:	  std_logic;
    signal cout:	std_logic;
    signal sum:		std_logic_vector(1 downto 0);


    begin
      U_ADDER: ADDER port map (A, B, cin, cout, sum);

      process
        file infile : text is in "adder_tv.txt";
        variable A_t, B_t:	integer;
        variable cin_t:	    std_logic;
        variable my_line : line;
        variable space : character;
        variable good_number : boolean;
      begin
        while not (endfile(infile)) loop
          readline(infile, my_line);
          read(my_line, A_t, good_number);
          next when not good_number;
          read(my_line, space); -- skip a space
          read(my_line, B_t);
          read(my_line, space); -- skip a space
          read(my_line, cin_t);

          A <= conv_std_logic_vector(A_t, 2);
          B <= conv_std_logic_vector(B_t, 2);
          cin <= cin_t;

          wait for 10 ns;

          assert (conv_integer(sum)=(A_t+B_t+conv_integer(cin_t)) mod 4) 
          report "Sum Error!" severity error;

          if (A_t+B_t+conv_integer(cin_t) >= 4) then
            assert (cout='1') 
            report "Carry = 0 Error!" severity error;
          else
            assert (cout='0') 
            report "Carry = 1 Error!" severity error;
          end if;
        end loop;
        assert false 
        report "Testbench of Adder completed!" severity failure;
      end process;
end FILE_TB;

architecture LOOP_TB of ADDER_TB is

    component ADDER is
    port(	
          A:	  in std_logic_vector(1 downto 0);
          B:	  in std_logic_vector(1 downto 0);	 
          cin:	in std_logic;				  
          cout:	out std_logic;				  
          sum:	out std_logic_vector(1 downto 0)
    );
    end component;

    signal A, B:	std_logic_vector(1 downto 0);
    signal cin:	  std_logic;
    signal cout:	std_logic;
    signal sum:		std_logic_vector(1 downto 0);

    begin
        U_ADDER: ADDER port map (A, B, cin, cout, sum);

    process
    begin
      l1: for i in 0 to 3 loop
        l2: for j in 0 to 3 loop
          l3: for k in 0 to 1 loop
            A   <= conv_std_logic_vector(i,2);
            B   <= conv_std_logic_vector(j,2);
            if k = 0 then
              cin <= '0' ;
            else 
             cin <= '1' ;
            end if;

            wait for 10 ns;
            assert (conv_integer(sum)=(i+j+k) mod 4) report "Sum Error!" severity error;

            if (i+j+k >= 4) then
              assert (cout='1') report "Carry = 0 Error!" severity error;
            else
              assert (cout='0') report "Carry = 1 Error!" severity error;
            end if;
          -- exit l1 [when (err_cnt > 10)];  -- exit the nested loop
          end loop;
        end loop;
      end loop;
	    assert false 
	    report "Testbench of Adder completed!" severity failure;
    end process;
  end LOOP_TB;


architecture TB of ADDER_TB is
    component ADDER is
    port(	A:	in std_logic_vector(1 downto 0);
		B:	in std_logic_vector(1 downto 0);	 
		cin:	in std_logic;				  
		cout:	out std_logic;				  
		sum:	out std_logic_vector(1 downto 0)
    );
    end component;

    signal A, B:	std_logic_vector(1 downto 0);
    signal cin:	        std_logic := '0';
    signal cout:	std_logic;
    signal sum:		std_logic_vector(1 downto 0);


    begin

        U_ADDER: ADDER port map (A, B, cin, cout, sum);
	
    process			
	
	variable err_cnt: integer :=0;
    
    begin												  
		
	-- case 1
	A <= "00";							
	B <= "00";
	wait for 10 ns;
	assert (sum="00") report "Sum Error!" severity error;
	assert (cout='0') report "Carry Error!" severity error;
	if (sum/="00" or cout/='0') then
	    err_cnt:=err_cnt+1;
	end if;
		
 	-- case 2 		
	A <= "11";
	B <= "11";
	wait for 10 ns;												  
	assert (sum="10") report "Sum Error!" severity error;	 
	assert (cout='1') report "Carry Error!" severity error;
	if (sum/="10" or cout/='1') then
	    err_cnt:=err_cnt+1;
	end if;
		
	-- case 3
	A <= "01";
	B <= "10";
	wait for 10 ns;												  
	assert (sum="11") report "Sum Error!" severity error;	 
	assert (cout='0') report "Carry Error!" severity error;
	if (sum/="11" or cout/='0') then
	    err_cnt:=err_cnt+1;
	end if;
		
	-- case 4
	A <= "10";
	B <= "01";
	wait for 10 ns;												  
	assert (sum="11") report "Sum Error!" severity error;	 
	assert (cout='0') report "Carry Error!" severity error;
	if (sum/="11" or cout/='0') then
	    err_cnt:=err_cnt+1;
	end if;
		
	-- case 5
	A <= "01";
	B <= "01";
	wait for 10 ns;
	assert (sum="10") report "Sum Error!" severity error;
	assert (cout='0') report "Carry Error!" severity error;
	if (sum/="10" or cout/='0') then
	    err_cnt:=err_cnt+1;
	end if;
		
	-- summary of testbench
	if (err_cnt=0) then
	    assert false  -- (false) optional
	    report "Testbench of Adder completed successfully!" severity note;
	else
	    assert false
	    report "Adder contains errors." severity error;
	end if;
			
	wait;
		
    end process;

end TB;

