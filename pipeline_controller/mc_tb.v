module mc_tb;

parameter CYCLE = 50;
reg         mc_clk;
reg [2:0]   mc_inst;
reg [3:0]   mc_src1, mc_src2, mc_dst;
reg [31:0]  mc_data;
wire [31:0] mc_read_output;
integer i;

always #(CYCLE/2) mc_clk = ~mc_clk;

mc #(3, 32, 4) dut (
	mc_clk,
	mc_inst,
	mc_src1,
	mc_src2,
	mc_dst,
	mc_data,
	mc_jump,
	mc_read_output
);

initial begin
	mc_clk = 0;
	// r0 = #51
	driver("load", 0, 0, 0, 51);
	// r1 = #2
	driver("load", 0, 0, 1, 2);
	// r2 = r0+r1
	driver(" add", 0, 1, 2, 0);
	// r3 = r0-r1
	driver(" sub", 0, 1, 3, 0);
	// r4 = r0*r1
	driver(" mul", 0, 1, 4, 0);
	// r5 = r1
	driver(" mov", 1, 0, 5, 0);
	// r6 = r1
	driver(" mov", 1, 0, 6, 0);
	// r0 == r5, jump
	driver(" cje", 0, 5, 0, 0);
	// r6 == r5, jump
	driver(" cje", 5, 6, 0, 0);
	#CYCLE;
	#CYCLE;
	for (i = 0; i <= 6; i=i+1)
		// read ri
		driver("read", i, 0, 0, 0);
	$stop;
end

task driver;
	input [4*8-1:0] inst;
	input [3:0] src1;
	input [3:0] src2;
	input [3:0] dst;
	input [31:0] data;
	begin
	case (inst) 
		" mov" :  mc_inst = 3'b000;
		" add" :  mc_inst = 3'b001;
		" sub" :  mc_inst = 3'b010;
		" mul" :  mc_inst = 3'b011;
		" cmj" :  mc_inst = 3'b100;
		"load" :  mc_inst = 3'b101;
		"read" :  mc_inst = 3'b110;
		" nop" :  mc_inst = 3'b111;
	endcase
	mc_src1 = src1;
	mc_src2 = src2;
	mc_dst  = dst ;
	mc_data = data;
	#CYCLE;
	end
endtask

endmodule
