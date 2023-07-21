module register #(parameter width) (
	input	wire				clk,
	input 	wire				pre,
	input	wire				clr,
	input	wire [width-1:0]	in,
	output	reg  [width-1:0]	out
);	wire	net_case0, net_case1, net_case2;
	
	and inst0(net_case0, pre, ~clr);
	and inst1(net_case1, ~pre, clr);
	and inst2(net_case2, pre, clr);	
	
	always @(posedge clk, negedge pre, negedge clr) begin
		if(net_case0)
			out <= {width{1'b0}};
		else if(net_case1)
			out <= {{width - 1{1'b0}}, 1'b1};
		else if(net_case2)
			out <= in;
	end
endmodule


