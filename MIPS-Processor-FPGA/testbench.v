module testbench();
	parameter width = 16;
	reg				clk;
	
	mips #(.width(width)) lab (
		.clk(clk)
	);
	
	initial begin
		clk = 1'b0;
	end

	always begin
		#5
		clk = ~clk;
	end
endmodule
