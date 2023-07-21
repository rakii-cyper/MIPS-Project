//fixed dff
module MY_DFF(input CLK, input D, input PRE, input CLR, output Q);
		wire NQ, x, y, z, t;
		
		nand N1(x, PRE, t, y);
		nand N2(y, x, CLK, CLR);
		nand N3(z, y, CLK, t);
		nand N4(t, z, D, CLR);
		
		nand N5(Q, PRE, y, NQ);
		nand N6(NQ, Q, z, CLR);
endmodule
//****************************************************************************
module MemoryCell (CLK, Reset, DataInput, RowSelect, WriteEnable, DataOutput);
	input 		CLK, Reset, DataInput, RowSelect, WriteEnable;
	output tri	DataOutput;
	
	wire		Enable, QOut, Temp;
	
	and	and_0(Enable, RowSelect, WriteEnable);
	
	MYMUX2 mymux(.OPCODE(Enable), 
				 .DATA_IN0(QOut),
				 .DATA_IN1(DataInput), 
				 .DATA_OUT(Temp)
				);
	
	MY_DFF	dff_0 (	.CLK(CLK),
					.D(Temp), 
					.PRE(1'b1), 
					.CLR(~Reset),
					.Q(QOut)
					);	
	
	bufif1  tristate0(DataOutput, QOut, RowSelect);
endmodule

module RowOfMemoryCell #(parameter WIDTH)
	(CLK, Reset, DataInput, RowSelect, WriteEnable, DataOutput);
	input				CLK, Reset, RowSelect, WriteEnable;
	input 	[WIDTH-1:0]	DataInput;
	output 	[WIDTH-1:0]	DataOutput;
	
	MemoryCell memcell [WIDTH-1:0] (.CLK(CLK),
									.Reset(Reset), 
									.DataInput(DataInput),
									.RowSelect(RowSelect),
									.WriteEnable(WriteEnable),
									.DataOutput(DataOutput)
									);
endmodule

module RAM #(parameter WIDTH)
	(CLK, Reset, DataInput, Address, RWS, CS, DataOutput);
	input					CLK, Reset, RWS, CS;
	input		[2:0]		Address;
	input 		[WIDTH-1:0]	DataInput;
	output tri 	[WIDTH-1:0]	DataOutput;
	
	wire					WriteEnable, ReadEnable, RWSBar;
	wire		[WIDTH-1:0]	InputBus, OutputBus;
	wire		[7:0]		AddressDecoder;
		
	and 	and2_0(WriteEnable, RWS, CS);
	not		not0(RWSBar, RWS);
	and		and2_1(ReadEnable, RWSBar, CS);
	
	buf 	buf0 [WIDTH-1:0]	(InputBus, DataInput);
	bufif1	stri [WIDTH-1:0]	(DataOutput, OutputBus, ReadEnable);
	
	Decoder3to8 decoder_in (.I(Address), .E(CS), .Y(AddressDecoder));
	
	RowOfMemoryCell #(.WIDTH(WIDTH)) rowmemcell [7:0] (.CLK(CLK),
														.Reset(Reset), 
														.DataInput(InputBus), 
														.RowSelect(AddressDecoder), 
														.WriteEnable(RWS), 
														.DataOutput(OutputBus)
														);
endmodule