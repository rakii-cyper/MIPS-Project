module Decoder2to4 (I, E, Y);
	input	[1:0]	I;
	input		  	E;
	output	[3:0]	Y;
	
	and inst0 ({Y[0]}, ~{I[0]}, ~{I[1]}, E);
	and inst1 ({Y[1]}, {I[0]}, ~{I[1]}, E);
	and inst2 ({Y[2]}, ~{I[0]}, {I[1]}, E);
	and inst3 ({Y[3]}, {I[0]}, {I[1]}, E);

endmodule

module Decoder3to8 (I, E, Y);
	input	[2:0]	I;
	input			E;
	output	[7:0]	Y;

	wire en1, en2;
	
	and inst0 (en1, ~{I[2]}, E);
	and inst1 (en2, {I[2]}, E);
	
	Decoder2to4 inst2 (.I({I[1:0]}), .E(en1), .Y({Y[3:0]}));
	Decoder2to4 inst3 (.I({I[1:0]}), .E(en2), .Y({Y[7:4]}));

endmodule