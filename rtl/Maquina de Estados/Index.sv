
module Index
#(
  parameter CincoSegundos = 500000, // Valor equivalente a 5 segundos
  parameter UmSegundo = 100,     // Valor equivalente a 1 segundos
  parameter MeioSegundo = 50     // Valor equivalente a 0,5 segundos
)
(
  input reset, clock,  
  input reg [1:0] Nivel_Jogo,                               // 2 Chaves
  input reg Modo_Jogo,                                      // Chave: Modo jogo
  input Iniciar_Jogo,                                   // Botao iniciar jogo
  input reg Bot_Ultima_Sequencia,                           // Botao mosta ultima sequencia
  input reg Bot_Vermelho, Bot_Azul, Bot_Amarelo, Bot_Verde, // Botoes que representam as cores
  output reg [2:0] Led_RGB                                  // Vermelho_Verde_Azul
);

  // 00 = Vermelho, 01 = Azul, 10 = Amarelo, 11 = Verde
  logic exibindo_sequencia;
  reg Copia_Modo_Jogo;
  reg [1:0] botao;
  reg [2:0] estado, prox_estado; 
  reg [63:0] Sequencia_Cores; // 32 cores - 64 bits 
  integer ContaSegundo, ContaMeioSegundo, ContaCincoSegundos,  
		  Sequencia_Maxima, AUXSequencia_Atual, Sequencia_Atual; 
 

  always @(posedge clock) 
	if(reset)
      estado=3'b000;
    else 
      estado=prox_estado;
	
  
  always @(estado) begin
  
	  case(estado)
	  3'b000: begin // Estado Ocioso: Permanece nesse estado enquanto o botao nao for precionado ¨ ------------	
		if(Iniciar_Jogo & exibindo_sequencia==0)
			prox_estado = 3'b001;

		else if(Bot_Ultima_Sequencia | exibindo_sequencia) 
			
			if((AUXSequencia_Atual/2) <= Sequencia_Atual) begin 
				botao[0] = Sequencia_Cores[AUXSequencia_Atual];
				botao[1] = Sequencia_Cores[AUXSequencia_Atual+1];
				case(botao)
					2'b00: Led_RGB = 3'b011; // Vermelho_Verde_Azul - VERMELHO
					2'b01: Led_RGB = 3'b110; // Vermelho_Verde_Azul - AZUL 
					2'b10: Led_RGB = 3'b001; // Vermelho_Verde_Azul COR AMARELO 
					2'b11: Led_RGB = 3'b101; // Vermelho_Verde_Azul COR VERDE 
				endcase
				
				if(ContaSegundo<UmSegundo) 
					ContaSegundo = ContaSegundo + 1;
				else begin // A cor ficou acesa por um segundo
					AUXSequencia_Atual = AUXSequencia_Atual+2;
					ContaSegundo = 0;
				end
				
				exibindo_sequencia = 1'b1;
				
			end else 
				exibindo_sequencia = 1'b0;
		
	  end
	  
	  3'b001: begin // Estado Configuracao: Configura o jogo de acordo com o modo e o nivel
		ContaSegundo = 0; 
		ContaMeioSegundo = 0;
		ContaCincoSegundos = 0;    
		AUXSequencia_Atual = 0;
		Sequencia_Atual = 0;
		
		// Desativa o RGB
		Led_RGB = 3'b111; // Vermelho_Verde_Azul
		
		Copia_Modo_Jogo = Modo_Jogo; 
		 
		if(Copia_Modo_Jogo == 0) begin // Modo Simon
			prox_estado = 3'b010;
			case(Nivel_Jogo)
				2'b00: Sequencia_Maxima = 8;
				2'b01: Sequencia_Maxima = 16;
				2'b10: Sequencia_Maxima = 20;
				2'b11: Sequencia_Maxima = 32;
				default: Sequencia_Maxima = 8;
			endcase 

            Sequencia_Cores = 64'b1110001001101000110010001011110110100011111000101110011110010111; 
			// Define a Sequencia_Cores do Jogo *********************************
			
		end else begin // Mando Eu
			prox_estado = 3'b011;
			Sequencia_Maxima = 32;
		end	
			
	  end
	  
	  3'b010: begin // Modo de Jogo Simon ¨--------------------------------------------------------------------
	  
	    if(ContaMeioSegundo<MeioSegundo) begin // Conta meio segundo
			// Gera sinal de acerto: COR CIANO (Verde+Azul)
			Led_RGB = 3'b100; // Vermelho_Verde_Azul
			ContaMeioSegundo = ContaMeioSegundo+1;
			//prox_estado = 3'b010;
		end

		else if((AUXSequencia_Atual/2) <= Sequencia_Atual) begin 
		// As cores já foram geradas 00 = Vermelho, 01 = Azul, 10 = Amarelo, 11 = Verde
            botao[0] = Sequencia_Cores[AUXSequencia_Atual];
            botao[1] = Sequencia_Cores[AUXSequencia_Atual+1];
			case(botao)
			2'b00: Led_RGB = 3'b011; // Vermelho_Verde_Azul - VERMELHO
			2'b01: Led_RGB = 3'b110; // Vermelho_Verde_Azul - AZUL 
			2'b10: Led_RGB = 3'b001; // Vermelho_Verde_Azul COR AMARELO 
			2'b11: Led_RGB = 3'b101; // Vermelho_Verde_Azul COR VERDE 
			endcase
			
			if(ContaSegundo<UmSegundo) 
				ContaSegundo = ContaSegundo + 1;
			else begin // A cor ficou acesa por um segundo
				AUXSequencia_Atual = AUXSequencia_Atual+2;
				ContaSegundo = 0;
			end
			
			prox_estado = 3'b010;
	    end
		
		else begin
		    ContaMeioSegundo = 0;
			ContaSegundo = 0;
			ContaCincoSegundos = 55; //**
            AUXSequencia_Atual = 0;			
			prox_estado = 3'b100;
		end
	  end
	  
	  3'b011: begin // Modo de Jogo Mando Eu
	    
	    if(ContaMeioSegundo<MeioSegundo) begin // Conta meio segundo
			// Gera sinal de acerto: COR CIANO (Verde+Azul)
			Led_RGB = 3'b100; // Vermelho_Verde_Azul
			ContaMeioSegundo = ContaMeioSegundo + 1;
			prox_estado = 3'b011;
		end
		else
		  prox_estado = 3'b100;
		  
		  // Desativa RGB
		  Led_RGB = 3'b111; // Vermelho_Verde_Azul
			
		  if(Bot_Vermelho) begin  
			ContaCincoSegundos = 0;
			Sequencia_Cores[AUXSequencia_Atual] = 0;
			Sequencia_Cores[AUXSequencia_Atual+1] = 0;
		    Led_RGB = 3'b011; // Vermelho_Verde_Azul
			
		  end else if(Bot_Azul) begin
			ContaCincoSegundos = 0;
			Sequencia_Cores[AUXSequencia_Atual] = 1;
			Sequencia_Cores[AUXSequencia_Atual+1] = 0;
		    Led_RGB = 3'b110; // Vermelho_Verde_Azul
			
		  end else if(Bot_Amarelo) begin
			ContaCincoSegundos = 0;
			Sequencia_Cores[AUXSequencia_Atual] = 0;
			Sequencia_Cores[AUXSequencia_Atual+1] = 1;
		    Led_RGB = 3'b001; // Vermelho_Verde_Azul
			
		  end else if(Bot_Verde) begin
			ContaCincoSegundos = 0;
			Sequencia_Cores[AUXSequencia_Atual] = 1;
			Sequencia_Cores[AUXSequencia_Atual+1] = 1;
		    Led_RGB = 3'b101; // Vermelho_Verde_Azul
			
		  end else
			if(ContaCincoSegundos<CincoSegundos) begin // Não ultrapassou os 5 segundos
				ContaCincoSegundos = ContaCincoSegundos+1;
				prox_estado = 3'b011; // Permanece no estado
			end else
				prox_estado = 3'b110; // 'Fim com erro' Ultrapassou os 5 segundos
		
		
	  end
	  
	  3'b100: begin // Estado Contador: Conta 5 segundos ----------------------------------------------------
	      prox_estado = 3'b101;
		  
		  if(Bot_Vermelho)  
			botao = 2'b00;
			
		  else if(Bot_Azul)
			botao = 2'b01;
			
		  else if(Bot_Amarelo)
			botao = 2'b10;
			
		  else if(Bot_Verde)
			botao = 2'b11;
		  else
			if(ContaCincoSegundos<CincoSegundos) begin // Não ultrapassou os 5 segundos
				ContaCincoSegundos = ContaCincoSegundos+1;
				prox_estado = 3'b100; // Permanece no estado
			end else
				prox_estado = 3'b110; // 'Fim com erro' Ultrapassou os 5 segundos
				
	  end
	  
	  3'b101: begin // Estado Verifica
	  ContaCincoSegundos = 0;
	  
		if((Sequencia_Cores[AUXSequencia_Atual] == botao[0]) && 
		  (Sequencia_Cores[AUXSequencia_Atual+1] == botao[1])) // Jogador precionou botao correto
			
			//if((AUXSequencia_Atual+1/2) == Sequencia_Maxima-1)
			if((AUXSequencia_Atual/2) == Sequencia_Maxima)
				prox_estado = 3'b111; // Fim Acerto
					
			else if((AUXSequencia_Atual/2) == Sequencia_Atual) begin
				Sequencia_Atual=Sequencia_Atual+1;
				
				if(Copia_Modo_Jogo == 0)  
					prox_estado = 3'b010; // Modo Simon
				else
					prox_estado = 3'b011; // Mando Eu
				
			end else begin
				AUXSequencia_Atual = AUXSequencia_Atual+2;
				prox_estado = 3'b100; // Espera do jogador Nova Cor
			end
			
		else // Jogador precionou botao errado
			prox_estado = 3'b110; // Fim ERRO
		
			
	  end
	  
	  3'b110: begin // Estado Fim Erro ¨ ----------------------------------------------------------------------
	    Led_RGB = 3'b010;     // Gera sinal de erro: COR MAGENTA (Vermelho+Azul)
		prox_estado = 3'b000; // Retorna ao estado Ocioso
	  end
	  
	  3'b111: begin // Estado Fim Acerto ¨ -------------------------------------------------------------------- 
	    Led_RGB = 3'b000;     // Gera sinal de acerto: COR BRANCO (Vermelho+Azul+Verde)
		prox_estado = 3'b000; // Retorna ao estado Ocioso
	  end
	  
	  default: prox_estado = 3'b000;
	  
	  endcase
	  
  end
  
endmodule 