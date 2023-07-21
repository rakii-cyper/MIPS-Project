module mips #(parameter width) (
	input wire clk
	);
	wire 		PCSrc, RegSrc, RegEn, ALUSrc, DmemWr, WrSrc, IsZero;
	wire [3:0]	ALUOp;	
	wire [4:0]	Inst;
	datapath #(.width(width)) dtp(
		.clk(clk),
		.PCSrc(PCSrc),
		.RegSrc(RegSrc),
		.RegEn(RegEn),
		.ALUSrc(ALUSrc),
		.ALUOp(ALUOp),
		.DmemWr(DmemWr),
		.WrSrc(WrSrc),
		.Inst(Inst),
		.IsZero(IsZero)
	);
	
	controller ctl(
		.PCSrc(PCSrc),
		.RegSrc(RegSrc),
		.RegEn(RegEn),
		.ALUSrc(ALUSrc),
		.ALUOp(ALUOp),
		.DmemWr(DmemWr),
		.WrSrc(WrSrc),
		.inst_op(Inst),
		.zero(IsZero)
	);
endmodule
