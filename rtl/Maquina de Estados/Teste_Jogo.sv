
// 1 segundo = 1000 millesegundo = 1000000 microssegundo = 1000000000 picossegundos

include "Chill_Out.sv";

module TesteJogo();

  logic reset, clock;  
  reg [1:0] Nivel_Jogo;                               
  reg Modo_Jogo, Iniciar_Jogo, Bot_Ultima_Sequencia, Bot_Vermelho, Bot_Azul, Bot_Amarelo, Bot_Verde;
  reg [2:0] Led_RGB;
  
  integer cont_stop = 0, estado_anterior = 0, file;
  
  Chill_Out Chill_Out(
    .reset(reset), 
	.clock(clock),  
	.Nivel_Jogo(Nivel_Jogo),                      
	.Modo_Jogo(Modo_Jogo),                                     
	.Iniciar_Jogo(Iniciar_Jogo),                                  
	.Bot_Ultima_Sequencia(Bot_Ultima_Sequencia),                           
	.Bot_Vermelho(Bot_Vermelho), 
	.Bot_Azul(Bot_Azul), 
	.Bot_Amarelo(Bot_Amarelo), 
	.Bot_Verde(Bot_Verde)
  );
  
  initial begin
    clock=1;
	file = $fopen("Teste1.txt");
  end
	
  always #5 clock = ~clock;
   
  always begin
  
    if(cont_stop==0) begin
	    $fdisplay(file,"Teste 1 - Modo Simon Perdendo por tempo na primeira rodada");
		reset = 1'b1;
	end else
		reset = 1'b0;
	
	// ---------------------------------------------------------------- Teste 1 - Modo Simon Perdendo por tempo
	if(cont_stop<10) begin
		Modo_Jogo = 1'b0;    // modo Simon
		Nivel_Jogo = 2'b10;  // 20 sequencia
		Iniciar_Jogo = 1'b1; // Iniciar Jogo
    end else
		Iniciar_Jogo = 1'b0; // Iniciar Jogo
		
	if(cont_stop!=0)	
		if(Chill_Out.estado==3'b000 & estado_anterior != 1) begin
			$fdisplay(file,"Inicio         %b - Tempo %d ps",Chill_Out.estado,cont_stop);
		    estado_anterior = 1;
			
		end else if(Chill_Out.estado==3'b001 & estado_anterior != 2) begin
			$fdisplay(file,"Configura      %b - Tempo %d ps",Chill_Out.estado,cont_stop);
		    estado_anterior = 2;
			
		end else if(Chill_Out.estado==3'b010 & estado_anterior != 3) begin
			$fdisplay(file,"Modo Simon     %b - Tempo %d ps",Chill_Out.estado,cont_stop);
		    estado_anterior = 3;
			
		end else if(Chill_Out.estado==3'b011 & estado_anterior != 4) begin
			$fdisplay(file,"Modo Mando Eu  %b - Tempo %d ps",Chill_Out.estado,cont_stop);
		    estado_anterior = 4;
			
		end else if(Chill_Out.estado==3'b100 & estado_anterior != 5) begin
			$fdisplay(file,"Contador       %b - Tempo %d ps",Chill_Out.estado,cont_stop);
		    estado_anterior = 5;
			
		end else if(Chill_Out.estado==3'b101 & estado_anterior != 6) begin
			$fdisplay(file,"Verifica       %b - Tempo %d ps",Chill_Out.estado,cont_stop);
		    estado_anterior = 6;
			
		end else if(Chill_Out.estado==3'b110 & estado_anterior != 7) begin
			$fdisplay(file,"Fim Erro       %b - Tempo %d ps",Chill_Out.estado,cont_stop);
		    estado_anterior = 7;
			
		end else if(Chill_Out.estado==3'b111 & estado_anterior != 8) begin
			$fdisplay(file,"Fim Acerto     %b - Tempo %d ps",Chill_Out.estado,cont_stop);
		    estado_anterior = 8;
        end
  
	#1
	if(cont_stop==1800000) begin// +/- 7 segundos  109996 500000
		$fclose(file);
		$stop;
	end	
	cont_stop = cont_stop+1;
  end
  
endmodule 