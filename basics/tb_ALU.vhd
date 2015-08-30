------------------------------------------------------------------------------
-- Test Bench for ALU design (ESD figure 2.5)
-- by Weijun Zhang, 04/2001
-- 
-- we illustrate how to use package and procedure in this example
-- it seems a kind of complex testbench for this simple module,
-- the method, however, makes huge circuit testing more complete, 
-- covenient and managable 
------------------------------------------------------------------------------	

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- define constant, signal and procedure within package for ALU

package ALU_package is
	
    constant INTERVAL: TIME := 8 ns;	
	
    signal sig_A, sig_B: std_logic_vector(1 downto 0);
    signal sig_Sel: std_logic_vector(1 downto 0);	  
    signal sig_Res: std_logic_vector(1 downto 0);
	
    procedure load_data(signal A, B: out std_logic_vector(1 downto 0);
    signal Sel: out std_logic_vector(1 downto 0));						 	 	
	
    procedure check_data(signal Sel: out std_logic_vector( 1 downto 0));
	
end ALU_package;  

-- put all the procedure descriptions within package body

package body ALU_package is
	
    procedure load_data (signal A, B: out std_logic_vector(1 downto 0);
			 signal Sel: out std_logic_vector(1 downto 0) ) is
    begin
	A <= sig_A;
	B <= sig_B;
	Sel <= sig_Sel;
    end load_data;
	
    procedure check_data (signal Sel: out std_logic_vector( 1 downto 0)) is 	
    begin
	Sel <= sig_Sel;
	if (sig_Sel="00") then
	    assert(sig_Res = (sig_A + sig_B)) 
	    report "Error detected in Addition!"	
	    severity warning;
	elsif (sig_Sel="01") then
	    assert(sig_Res = (sig_A - sig_B))
	    report "Error detected in Subtraction!"
	    severity warning;
	elsif (sig_Sel="10") then	 
	    assert(sig_Res = (sig_A and sig_B))
	    report "AND Operation Error!" 
	    severity warning;
	elsif (sig_Sel="11") then
	    assert(sig_Res = (sig_A or sig_B)) 
	    report "OR operation Error!"
	    severity warning;
	end if;
    end check_data;
	
end ALU_package;
	
-- Test Bench code for ALU
--------------------------------------------------------------------------
	
library IEEE;
use IEEE.std_logic_1164. all;	
use work.ALU_package.all;

entity ALU_TB is			-- entity declaration
end ALU_TB;

architecture TB of ALU_TB is

    component ALU
    port(	A:	in std_logic_vector(1 downto 0);
		B:	in std_logic_vector(1 downto 0);
		Sel:	in std_logic_vector(1 downto 0);
		Res:	out std_logic_vector(1 downto 0)   
    );
    end component;

    signal A, B, Res: std_logic_vector(1 downto 0):="00";
    signal Sel: std_logic_vector(1 downto 0);

begin

    U_ALU: ALU port map (A, B, Sel, Res);
	
    process
    begin
		
	sig_A <= "10";
	sig_B <= "01";		 
		
	sig_Sel <= "00";			-- case 1: Addition		   
	wait for 1 ns;
	load_data(A, B, Sel);	 
	wait for 1 ns;
	sig_Res <= Res;			  
	wait for INTERVAL;
	check_data(Sel);	   
		
	sig_Sel <= "01";			-- case 2: subtraction	   
	wait for 1 ns;
	load_data(A, B, Sel);	 
	wait for 1 ns;
	sig_Res <= Res;			  
	wait for INTERVAL;
	check_data(Sel);	   
		
	sig_Sel <= "10";			-- case 3: AND operation	   
	wait for 1 ns;
	load_data(A, B, Sel);	 
	wait for 1 ns;
	sig_Res <= Res;			  
	wait for INTERVAL;
	check_data(Sel);	   
		
	sig_Sel <= "11";			-- case 4: OR operation		   
	wait for 1 ns;
	load_data(A, B, Sel);	 
	wait for 1 ns;
	sig_Res <= Res;			  
	wait for INTERVAL;
	check_data(Sel);	   
	wait;		 
		
    end process;

end TB;

-------------------------------------------------------------------------
configuration CFG_TB of ALU_TB is
	for TB
	end for;
end CFG_TB;
-------------------------------------------------------------------------
