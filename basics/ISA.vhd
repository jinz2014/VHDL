------------------------------------------------------------------
-- ISA bus interface design (ISA.vhd)
-- by Weijun Zhang, 05/2001
------------------------------------------------------------------

-- 8-bit adder --------------------------------------------------- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity adder is
port(   num1:	in std_logic_vector(7 downto 0);
        num2:	in std_logic_vector(7 downto 0);
        sum:    out std_logic_vector(7 downto 0)
);
end adder;

architecture behv of adder is
begin                                     
 
    sum <= num1 + num2;
    
end behv;

-- Comparator ------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity comparator is
port(	addr_ld:	in std_logic;
	addr_in:	in std_logic_vector(15 downto 0);
	w_match:  	out std_logic;
	r_match:	out std_logic
);
end comparator;

architecture behv of comparator is
begin				   
  
    process(addr_ld, addr_in)
    begin
        if(addr_ld='1') then 
	    if (addr_in="1010000000000000") then
		w_match <= '1';
		r_match <= '0';
	    elsif (addr_in="1010000000000001") then
		w_match <= '0';
		r_match <= '1';	   
	    else
		w_match <= '0';
		r_match <= '0';
	    end if;		  
	else
	    w_match <= '0';
	    r_match <= '0';
	end if;
    end process;

end behv;

-- Data Register -----------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity data_reg is
port(	clock:		in std_logic;
	reset:		in std_logic;
	load:		in std_logic;
	data_in: 	in std_logic_vector(7 downto 0);
        data_out:	out std_logic_vector(7 downto 0)
);
end data_reg;

architecture behv of data_reg is
begin
    process(clock, reset)
	begin
        if(reset = '1') then 
            data_out <= (others => '0');
        elsif(clock'event and clock = '1') then
            if(load = '1') then
                data_out <= data_in;
            end if;
        end if;
    end process;
end behv;

----------------------------------------------------------------------
-- Data Path of ISA bus interface
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity datapath is
port(	dp_clk: 	in std_logic;
	dp_rst: 	in std_logic;
	A_ld:		in std_logic;					
	D_ld:		in std_logic;
	D_st:		in std_logic;
	ADDR_P:		in std_logic_vector(15 downto 0);
	DIN:		in std_logic_vector(7 downto 0);
	Write_match:	out std_logic;
	Read_match:	out std_logic;
	DOUT:		out std_logic_vector(7 downto 0)
);
end datapath;

architecture struct of datapath is

component data_reg is
port(	clock:		in std_logic;
	reset:		in std_logic;
	load:		in std_logic;
	data_in: 	in std_logic_vector(7 downto 0);
        data_out:	out std_logic_vector(7 downto 0)
);
end component;

component comparator is 
port(	addr_ld:	in std_logic;
	addr_in:	in std_logic_vector(15 downto 0);
	w_match:  	out std_logic;
	r_match:	out std_logic
);
end component;

component adder is
port(   num1:	in std_logic_vector(7 downto 0);
        num2:	in std_logic_vector(7 downto 0);
        sum:    out std_logic_vector(7 downto 0)
);
end component;

signal reg2adder, adder2reg, one: std_logic_vector(7 downto 0);

begin  
	
    one <= "00000001";
	
    U1: comparator port map (A_ld, ADDR_P, Write_match, Read_match);
    U2: data_reg port map (dp_clk, dp_rst, D_ld, DIN, reg2adder);
    U3: adder port map (reg2adder, one, adder2reg);
    U4: data_reg port map (dp_clk, dp_rst, D_st, adder2reg, DOUT);   
	
end struct;

--------------------------------------------------------------------
-- FSM controller for ISA bus interfacing
--------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity controller is
port(	ctrl_clk:	in std_logic;
	ctrl_rst:	in std_logic;
	IOR:		in std_logic;
	IOW:		in std_logic;
	ALE:		in std_logic;
	WE_m:		in std_logic;
	RE_m:		in std_logic;
	Ald:		out std_logic;
	Dld:		out std_logic;
	Dst:		out std_logic
);
end controller;

architecture fsm of controller is

    type states is (S0, S1, S2, S3, S3a, S4, S4a, S5);
    signal nState, cState: states;

begin	  
	
    state_reg: process(ctrl_clk, ctrl_rst)
    begin
        if (ctrl_rst = '1') then 
            cState <= S0;
        elsif (ctrl_clk'event and ctrl_clk = '1') then 
            cState <= nState;
        end if;
    end process;

    comb_logic: process(cState, IOR, IOW, ALE, WE_m, RE_m)	  
    begin

      case cState is 
                
        when S0 =>	Ald <= '0';	    -- waiting for ALE signal
			Dld <= '0';
			Dst <= '0';
			if (ALE='1') then
				nState <= S1;
			else
				nState <= S0;
			end if;
		
	when S1 =>	Ald <= '1';	    -- waiting for Address		   
			Dld <= '0';
			Dst <= '0';
			nState <= S2;
        
	when S2 =>  	Ald <= '1';	    -- decide operation
			Dld <= '0';	    -- Read or Write
			Dst <= '0';		 
			if (WE_m='1') then
				nState <= S3;
			elsif (RE_m='1') then
			 	nState <= S4;
			else
				nState <= S2;
			end if;

	when S3 =>  	Ald <= '0';	    -- ready to Write
			Dld <= '0';
			Dst <= '0';
			if (IOW='0') then
				nState <= S3a;
			else
				nState <= S3;
			end if;
		
	when S3a => 	Ald <= '0';	    -- do Write operation
			Dld <= '1';	    -- then go back
			Dst <= '0';
			nState <= S0;
					
        when S4 =>  	Ald <= '0';	    -- ready to Read
			Dld <= '0';
			Dst <= '0';
			if (IOR='0') then
				nState <= S4a;
			else
				nState <= S4;
			end if;
		
	when S4a =>	Ald <= '0';	    -- do Read operation
			Dld <= '0';	    -- then go back
			Dst <= '1';
			nState <= S0;
		
        when others =>  Ald <= '0';	    -- go back to initial
			Dld <= '0';
			Dst <= '0';
			nState <= S0;
                        
      end case;
        
    end process;
        
end fsm;

------------------------------------------------------------------
-- ISA bus interface ( FSM + Datapath )
-- VHDL structural modeling
------------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all;   
use ieee.std_logic_arith.all; 
use work.all;

entity ISA is
port(	CLK_P:		in std_logic;
	RESET_P:	in std_logic;
	IOR_P:		in std_logic;
	IOW_P:		in std_logic;
	ALE_P:		in std_logic;
	ADDRESS_P:	in std_logic_vector(15 downto 0);
	DIN_P:		in std_logic_vector(7 downto 0);
	DOUT_P:		out std_logic_vector(7 downto 0)
);
end ISA;
 
architecture struct of ISA is 
 
component controller is	   
port(	ctrl_clk:	in std_logic;
	ctrl_rst:	in std_logic;
	IOR:		in std_logic;
	IOW:		in std_logic;
	ALE:		in std_logic;
	WE_m:		in std_logic;
	RE_m:		in std_logic;
	Ald:		out std_logic;
	Dld:		out std_logic;
	Dst:		out std_logic
);
end component; 
 
component datapath is   
port(	dp_clk: 	in std_logic;
	dp_rst: 	in std_logic;
	A_ld:		in std_logic;					
	D_ld:		in std_logic;
	D_st:		in std_logic;
	ADDR_P:		in std_logic_vector(15 downto 0);
	DIN:		in std_logic_vector(7 downto 0);
	Write_match:	out std_logic;
	Read_match:	out std_logic;
	DOUT:		out std_logic_vector(7 downto 0)
);
end component; 
 
 
signal WE_sig, RE_sig: std_logic;										 
signal Ald_sig, Dld_sig, Dst_sig: std_logic;

begin  
	
    U0: controller port map(CLK_P,RESET_P,IOR_P,IOW_P,ALE_P,
			    WE_sig,RE_sig,Ald_sig,Dld_sig,Dst_sig);
    U1: datapath port map(CLK_P,RESET_P,Ald_sig,Dld_sig,Dst_sig,
			    ADDRESS_P,DIN_P,WE_sig,RE_sig,DOUT_P);
	
end struct;
