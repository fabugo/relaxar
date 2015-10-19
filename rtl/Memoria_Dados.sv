
module Memoria_Dados (
  Hab_Escrita, 
  endereco,    
  Entrada, 
  Saida,  
  reset,        
  clock      
  );          
  
  parameter bits_palavra = 64;
  parameter end_registros = 10;//endereço de 10 bits, no caso, a memória guarda  as sequencias aleatorias geradas de 64 bits. (32 tipos de leds (2 bits pra cada)).
  parameter num_registros = 10; 
  
  input reset, clock;
  input reg Hab_Escrita;
  input [bits_palavra-1:0] Entrada;
  input reg [end_registros-1:0] endereco; 
  output reg [bits_palavra-1:0] Saida;

  reg [bits_palavra-1:0] dado_mem [0:(2**num_registros)-1] ;	
	
	
	always @(posedge clock, posedge reset) begin
		if(reset) begin 
			for(int i=0; i<((2**num_registros)-1); i++)
				dado_mem[i] = 1'd0;
		end 
		else if(Hab_Escrita) begin 
			dado_mem[endereco] = Entrada; 
			Saida = dado_mem[endereco];
		end else begin
		
		Saida = dado_mem[endereco]; 
		end
	end
	
endmodule
