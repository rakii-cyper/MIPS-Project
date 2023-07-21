module IMEM (
	input [(5-1):0] addr,
	output reg [(16-1):0] q
);

	reg [16-1:0] rom[2**5-1:0];

	initial begin
		$readmemb("binary.txt", rom);
	end

	always @(addr) begin
		q = rom[addr];
	end

endmodule
