library ieee;
use ieee.std_logic_1164.all;

--
-- Quartus synthesis shows that explict alu_func encoding uses more resources
-- (588 vs. 653)
--
package alu_type is

  subtype data_size is std_logic_vector(31 downto 0);

--  subtype alu_func is std_logic_vector(3 downto 0);
--  constant alu_add:       alu_func := "0000";
--  constant alu_addu:      alu_func := "0001";
--  constant alu_sub:       alu_func := "0010";
--  constant alu_subu:      alu_func := "0011";
--  constant alu_and:       alu_func := "0100";
--  constant alu_or:        alu_func := "0101";
--  constant alu_xor:       alu_func := "0110";
--  constant alu_sll:       alu_func := "0111";
--  constant alu_srl:       alu_func := "1000";
--  constant alu_sra:       alu_func := "1001";
--  constant alu_pass1:     alu_func := "1010";
--  constant alu_pass2:     alu_func := "1011";

  type alu_func is  ( alu_add,
                      alu_addu,
                      alu_sub, 
                      alu_subu,
                      alu_and, 
                      alu_or,  
                      alu_xor, 
                      alu_sll, 
                      alu_srl, 
                      alu_sra, 
                      alu_pass1,
                      alu_pass2 );
end package alu_type;
