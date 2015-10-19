//'include "rng.v"

module rng_teste;

logic clock, reset, loadseed_i;
reg [63:0] seed_i, number_o;

rng rng(.clk(clock),.reset(reset),.loadseed_i(loadseed_i),.seed_i(seed_i),.number_o(number_o));

initial begin
	    clock = 1;
	end
	
	always #5 clock = ~clock;

initial begin
	reset = 1'b1;//reset inativo
	loadseed_i = 1'b1; // sinal para carregar a semente e começar a gerar os números a partir dela
	seed_i = 64'b1001110000111100111100011010010110011100001111001111000110100101; // semente
	end

	always @(posedge clock) begin
		
		reset = 1'b1; //reset inativo
		loadseed_i = 1'b0;
		
		end


endmodule