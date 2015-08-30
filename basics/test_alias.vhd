
entity test_alias is
end ;

architecture behv of test_alias is
  signal instruction : BIT_VECTOR(31 DOWNTO 0);
  alias opcode : bit_vector(3 downto 0) is instruction(31 downto 28);
  alias src_reg : bit_vector(4 downto 0) is instruction(27 downto 23);
  alias dst_reg : bit_vector(4 downto 0) is instruction(22 downto 18);
begin

end;
