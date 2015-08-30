library IEEE; 
use IEEE.STD_Logic_1164.all, IEEE.Numeric_STD.all; 

entity GCD is 
generic (Width: natural); 
port (Clock,Reset,Load: in std_logic; 
   A,B:   in unsigned(Width-1 downto 0); 
   Done:  out std_logic; 
   Y:     out unsigned(Width-1 downto 0)); 
end entity GCD;
 
architecture RTL of GCD is 
   signal A_New,A_Hold,B_Hold: unsigned(Width-1 downto 0); 
   signal A_lessthan_B: std_logic; 
begin 
---------------------------------------------------- 
-- Load 2 input registers and ensure B_Hold < A_Hold 
--------------------------------------------------- 
LOAD_SWAP: process (Clock) 
begin 
   if rising_edge(Clock) then 
     if (Reset = '0') then 
       A_Hold <= (others => '0'); 
       B_Hold <= (others => '0'); 
     elsif (Load = '1') then 
       A_Hold <= A; 
       B_Hold <= B; 
     elsif (A_lessthan_B = '1') then 
       A_Hold <= B_Hold; 
       B_Hold <= A_New; 
     else A_Hold <= A_New; 
     end if; 
   end if; 
end process LOAD_SWAP; 

SUBTRACT_TEST: process (A_Hold, B_Hold) 
begin 
   ------------------------------------------------------- 
   -- Subtract B_Hold from A_Hold if A_Hold >= B_Hold 
   ------------------------------------------------------ 
   if (A_Hold >= B_Hold) then 
      A_lessthan_B <= '0'; 
      A_New <= A_Hold - B_Hold; 
   else 
      A_lessthan_B <= '1'; 
      A_New <= A_Hold; 
   end if; 
   ------------------------------------------------- 
   -- Greatest common divisor found if B_Hold = 0 
   ------------------------------------------------- 
   if (B_Hold = 0) then 
      Done <= '1'; 
      Y <= A_Hold; 
   else 
      Done <= '0'; 
      Y <= (others => '0'); 
   end if; 
end process SUBTRACT_TEST; 

end architecture RTL; 
