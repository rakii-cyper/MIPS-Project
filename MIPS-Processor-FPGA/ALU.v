module alu 
	#(parameter width) 
	(opcode, data_in_a, data_in_b, data_out, zero_flag);
	
	input				[3:0]		opcode;
	input 	wire signed	[width-1:0]	data_in_a, data_in_b;
	output	reg	 signed	[width-1:0]	data_out;
	output	wire					zero_flag;
	
	always @(opcode, data_in_a, data_in_b) begin
		case (opcode) 
			4'b0000:	data_out <= data_in_a + data_in_b;					//ADD
			4'b0001:	data_out <= data_in_a - data_in_b;					//SUB
			4'b0010:	data_out <= data_in_a +	{{width - 1{1'b0}}, 1'b1};	
			4'b0011:	data_out <= data_in_a - {{width - 1{1'b0}}, 1'b1};
			4'b0100:	data_out <= data_in_a & data_in_b;					//AND
			4'b0101:	data_out <= data_in_a | data_in_b;					//OR
			4'b0110:	data_out <= ~data_in_a;
			4'b0111:	data_out <= data_in_a ^ data_in_b;					//XOR
			4'b1000:	data_out <= data_in_a >> data_in_b[2:0];					//SR
			4'b1001:	data_out <= data_in_a << data_in_b[2:0];					//SL
			4'b1010:	data_out <= data_in_a >>> data_in_b[2:0];				//SRA
			default:	data_out <= {width-1{1'bx}};
		endcase	
	end
	assign zero_flag = |data_out;
endmodule
