--------------------------------------------------------------------
-- Test Bench for memory module (ESD book Chapter 5)
--
-- use loop statement to test module completely
-------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
 
entity tb_ROM is 		        -- entity declaration
end tb_ROM; 

--------------------------------------------------------------------
 
architecture TB of tb_ROM is 

component ROM is	
port(	
	addr      : in  integer;
  cs        : in  std_logic;
	data      : out integer
);	
end component;

signal T_Data_out:  integer;
signal T_Read_Addr: integer;
signal T_cs:        std_logic;

begin 
    u_rom: ROM
    port map (T_Read_Addr, T_cs, T_Data_out);
							
    process 
      variable err_cnt: integer := 0;
    begin
      T_cs        <= '0';   
      T_Read_Addr <= 0;
      wait for 20 ns;
      for i in 2 to 64 loop
        -- cs = 0
        assert (T_Data_out = -1) 
        report "ROM read data!" severity Error;
        T_Read_Addr <= T_Read_Addr + 1;
        wait for 10 ns;	
      end loop;

      T_cs        <= '1';   
      T_Read_Addr <= 0;
      wait for 20 ns;
      for i in 2 to 64 loop
        -- cs = 1
        assert (T_Data_out = T_Read_Addr mod 10 + 1)
        report "ROM read data!" severity Error;
        T_Read_Addr <= T_Read_Addr + 1;
        wait for 10 ns;	
      end loop;
        
      assert false 
      report "Testbench of ROM completed successfully!" 
      severity failure; 
end process;

end TB;

--------------------------------------------------------------------------
configuration CFG_TB of TB_ROM is 
        for TB 
        end for; 
end CFG_TB; 
--------------------------------------------------------------------------



