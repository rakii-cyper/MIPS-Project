module MYMUX2 (OPCODE, DATA_IN0, DATA_IN1, DATA_OUT);
	input OPCODE;
	input DATA_IN0;
	input DATA_IN1;
	output DATA_OUT;
	
	wire NET0, NET1;
	
	and inst0(NET0,	DATA_IN1, OPCODE);
	and inst1(NET1, DATA_IN0, ~OPCODE);
	or  inst2(DATA_OUT, NET0, NET1);
	
endmodule
