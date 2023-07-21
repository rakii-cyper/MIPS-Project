module controller(
	input wire	[4:0]	inst_op,
	input wire			zero,
	output reg			PCSrc,
	output reg			RegSrc,
	output reg			RegEn,
	output reg			ALUSrc,
	output reg 	[3:0]	ALUOp,
	output reg			DmemWr,
	output reg			WrSrc
	);
	
	parameter add 	= 5'b00010;
	parameter sub 	= 5'b00011;
	parameter iand	= 5'b00100;
	parameter ior 	= 5'b00101;
	parameter ixor 	= 5'b00110;
	parameter sr 	= 5'b01000;
	parameter sra 	= 5'b01001;
	parameter sl 	= 5'b01010;
	parameter addi 	= 5'b10010;
	parameter andi 	= 5'b10100;
	parameter ori 	= 5'b10101;
	parameter xori 	= 5'b10110;
	parameter lw 	= 5'b11100;
	parameter sw 	= 5'b11101;
	parameter beq 	= 5'b11110;
	parameter bne 	= 5'b11111;
	
	parameter alu_add 	= 4'b0000;
	parameter alu_sub 	= 4'b0001;
	parameter alu_and 	= 4'b0100;
	parameter alu_or	= 4'b0101;
	parameter alu_xor 	= 4'b0111;
	parameter alu_sr 	= 4'b1000;
	parameter alu_sl 	= 4'b1001;
	parameter alu_sra 	= 4'b1010;
	
	always @(inst_op, zero) begin
		case (inst_op)
			add: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b1;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_add;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			sub: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b1;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_sub;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			iand: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b1;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_and;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			ior: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b1;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_or;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			ixor: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b1;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_xor;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			sr: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b1;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_sr;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			sra: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b1;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_sra;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			sl: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b1;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_sl;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			addi: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'bx;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b1;
				ALUOp	<= alu_add;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			andi: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'bx;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b1;
				ALUOp	<= alu_and;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			ori: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'bx;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b1;
				ALUOp	<= alu_or;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			xori: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'bx;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b1;
				ALUOp	<= alu_xor;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b1;
			end
			
			lw: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b0;
				RegEn	<= 1'b1;
				ALUSrc	<= 1'b1;
				ALUOp	<= alu_add;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'b0;
			end
			
			sw: begin
				PCSrc 	<= 1'b0;
				RegSrc	<= 1'b0;
				RegEn	<= 1'b0;
				ALUSrc	<= 1'b1;
				ALUOp	<= alu_add;
				DmemWr	<= 1'b1;
				WrSrc	<= 1'bx;
			end
			
			bne: begin
				PCSrc 	<= (zero == 1'b1) ? 1'b1 : 1'b0;
				RegSrc	<= 1'b0;
				RegEn	<= 1'b0;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_sub;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'bx;
			end
			
			beq: begin
				PCSrc 	<= (zero == 1'b0) ? 1'b1 : 1'b0;
				RegSrc	<= 1'b0;
				RegEn	<= 1'b0;
				ALUSrc	<= 1'b0;
				ALUOp	<= alu_sub;
				DmemWr	<= 1'b0;
				WrSrc	<= 1'bx;
			end
		endcase
	end
endmodule
