//d flip flop
module D_Latch(D, CLK, Q);
	input  D;
	input  CLK;
	output Q;
	wire net0, net1, net2;
	
	nand inst0(net0, D, CLK);
	nand inst1(net1, ~D, CLK);
	nand inst2(Q, net0, net2);
	nand inst3(net2, net1, Q);
	
endmodule

module DFF(D, CLK, Q);
	input  D;
	input  CLK;
	output Q;
	wire net0;
	
	D_Latch inst0(.D(D), .CLK(~CLK), .Q(net0));
	D_Latch inst1(.D(net0), .CLK(CLK), .Q(Q));
	
endmodule

module DFF_RST(CLK, D, Q, RST);
    output Q;
    input CLK, D, RST;
    wire D_IN, RST_BAR;

    DFF inst0(.D(D_IN), .CLK(CLK), .Q(Q));

    not(RST_BAR, RST);
    and(D_IN, RST_BAR, D);

endmodule
//******************************************************************

//register file
module register_file_cell (
	input		reset,
	input		write_select, 
	input 		data_in, 
	input		clk, 
	input		read_select_a, 
	input		read_select_b,
	output tri	data_out_a, 
	output tri 	data_out_b,
	output		data
	);
	
	wire net0, net1, d_net, q_net;
	
	DFF_RST dff_0(.D(d_net), .Q(q_net), .CLK(clk), .RST(reset));
	
	and inst0(net0, q_net, ~write_select);
	and inst1(net1, data_in, write_select);
	or  inst2(d_net, net0, net1);
	
	assign data = q_net;
	bufif1 inst3(data_out_a, q_net, read_select_a);
	bufif1 inst4(data_out_b, q_net, read_select_b);
endmodule

module row_of_cell #(parameter width) (
	input	reset,
	input	write_row_select, 
	input	clk, 
	input	read_row_a, 
	input	read_row_b,
	input	[width-1:0]	data_in,
	output	tri [width-1:0] data_out_a, 
	output	tri [width-1:0] data_out_b,
	output [width-1:0] data
	);
	
	register_file_cell inst0 [width-1:0](.reset(reset),
										 .write_select(write_row_select),
										 .clk(clk),
										 .read_select_a(read_row_a),
										 .read_select_b(read_row_b),
										 .data_in(data_in),
										 .data_out_a(data_out_a),
										 .data_out_b(data_out_b),
										 .data(data)
										 );
endmodule

module register_file #(parameter width) (
	input				reset,
	input				clk,
	input				write_en, 
	input				read_en_a, 
	input				read_en_b,
	input	[2:0]		write_addr, 
	input	[2:0]		read_addr_a, 
	input	[2:0]		read_addr_b,
	input	[width-1:0]	data_in,
	output	tri [width-1:0]	data_out_a, 
	output	tri [width-1:0]	data_out_b
	);

	wire 	[7:0]		addr_net, addr_a_net, addr_b_net;
	wire	[width-1:0]	first_row;
	Decoder3to8 decoder_in 		(.I(write_addr), 	.E(write_en), 	.Y(addr_net));
	Decoder3to8 decoder_out_a 	(.I(read_addr_a),	.E(read_en_a), 	.Y(addr_a_net));
	Decoder3to8 decoder_out_b 	(.I(read_addr_b),	.E(read_en_b), 	.Y(addr_b_net));
	
	//row 0
	assign first_row = {width{1'b0}};
	bufif1 first_row_out_a [width-1:0] (data_out_a, first_row, addr_a_net[0]);
	bufif1 first_row_out_b [width-1:0] (data_out_b, first_row, addr_b_net[0]);
	
	//row 1->7
	row_of_cell #(.width(width)) inst0 [6:0] (.reset(reset),
											  .write_row_select(addr_net[7:1]),
											  .clk(clk),
											  .read_row_a(addr_a_net[7:1]),
											  .read_row_b(addr_b_net[7:1]),
											  .data_in(data_in),
											  .data_out_a(data_out_a),
											  .data_out_b(data_out_b),
											  .data()
											  );
endmodule