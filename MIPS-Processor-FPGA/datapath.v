module my_register #(parameter width) (
	input wire				clk,
	input wire [width-1:0]	d,
	output reg [width-1:0]	q
	);
	
	initial begin
		q <= {width{1'b0}};
	end
	
	always @(posedge clk) begin
		q <= d;
	end
endmodule
	
module datapath #(parameter width = 16) (
	input	wire		clk,
	input	wire		PCSrc,
	input	wire 		RegSrc,
	input	wire 		RegEn,
	input	wire		ALUSrc,
	input	wire [3:0]	ALUOp,
	input	wire		DmemWr,
	input	wire		WrSrc,
	output	wire [4:0]	Inst,
	output	wire		IsZero
	);
		
	wire	[5:0]	current_pc_addr, pc_addr, next_pc_addr;
	wire	[15:0]	instruction, data_a, data_b, alu_data_out, data_mem, Inst_4_0_SE, data_wr, alu_data_b, jump_pc_addr, jump_pc_addr_temp;
	wire	[2:0]	addr_rdb;
	
	//block
	my_register #(.width(6)) pc (
		.clk(clk), 
		.d(pc_addr), 
		.q(current_pc_addr)
	);
	
	IMEM inst_mem (.addr(current_pc_addr[5:1]), .q(instruction));
	
	register_file #(.width(width)) rf (
		.reset(1'b0),
		.clk(clk),
		.write_en(RegEn), 
		.read_en_a(1'b1), 
		.read_en_b(1'b1),
		.write_addr(instruction[10:8]), 
		.read_addr_a(instruction[7:5]), 
		.read_addr_b(addr_rdb),
		.data_in(data_wr),
		.data_out_a(data_a), 
		.data_out_b(data_b)
	);
	
	alu #(.width(width)) alu_b( 
		.opcode(ALUOp), 
		.data_in_a(data_a), 
		.data_in_b(alu_data_b), 
		.data_out(alu_data_out), 
		.zero_flag(IsZero)
	);
	
	RAM #(.WIDTH(width)) dmem (
		.CLK(clk), 
		.Reset(1'b0), 
		.DataInput(data_b), 
		.Address(alu_data_out[2:0]), 
		.RWS(DmemWr), 
		.CS(1'b1), 
		.DataOutput(data_mem)
	);
	//**************************************************************
	
	//pc block
	assign pc_addr = (PCSrc == 1'b1) ? jump_pc_addr[5:0] : next_pc_addr; 
	assign next_pc_addr = current_pc_addr + 6'd2;
	
	assign jump_pc_addr_temp = Inst_4_0_SE << 1;
	assign jump_pc_addr = jump_pc_addr_temp + current_pc_addr;
	//**************************************************************
	
		
	//register file block
	assign addr_rdb = (RegSrc == 1'b0) ? instruction[10:8] : instruction[4:2];
	//**************************************************************
		
		
	//sign extend block
	assign Inst_4_0_SE = {{11{instruction[4]}}, {instruction[4:0]}};
	//**************************************************************
		
		
	//alu block
	assign alu_data_b = (ALUSrc == 1'b0) ? data_b : Inst_4_0_SE;
	//**************************************************************
		
		
	//dmem block
	assign data_wr = (WrSrc == 1'b0) ? data_mem : alu_data_out;
	//**************************************************************
		
	assign Inst = instruction[15:11];
endmodule