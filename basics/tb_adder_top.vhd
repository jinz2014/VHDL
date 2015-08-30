
entity tb_adder_top is
end;


architecture tb of tb_adder_top is
  component ADDER_TB is
  end component;

begin

  ADDER_TB_U : ADDER_TB;

end;

--------------------------------------------------------------------
configuration cfg of tb_adder_top is
	for tb 
    for ADDER_TB_U : ADDER_TB
      use entity work.ADDER_TB(FILE_TB);
    end for;
	end for;
end cfg;
--------------------------------------------------------------------
