module TesteLCD 
#(
	parameter ADDR_WIDTH = 12,
	parameter DATA_WIDTH = 32,
	parameter dados_ = 255
)(
	input clk_50,    // Clock
	input rst_n,     // Asynchronous reset active low
	// Input key
	input read_in,	 // Read trigger key[3]
	input botao,
	input reset,
	
	// Debug
	output data_mem_rd_en_out,  // Red0 LED

	// LCD signals
	output [7:0] lcd_data_out, 	// LCD data
	output lcd_on_out,			// LCD power on/off
	output lcd_blon_out,		// LCD back light on/off
	output lcd_rw_out,			// LCD read/write select, 0 = write, 1 = read
	output lcd_en_out,			// LCD enable
	output lcd_rs_out			// LCD command/data select, 0 = command, 1 = data

);

wire [DATA_WIDTH-1:0] mem_data;
wire [ADDR_WIDTH-1:0] mem_addr;
wire [15:0] resultado, instrucao;
wire habilitaEscritaDisplay;
reg[31:0] A, inst;
reg habEscrita;
 

  reg [21:0] contador;
  reg hab_count;
  reg aux_botao;
  
lcd_mem_read 
#(
	.ADDR_WIDTH(ADDR_WIDTH),
	.DATA_WIDTH(DATA_WIDTH)
) lcd_mem_read_u0 (
	.clk_50(clk_50),    			// Board clock 50Mhz
	.rst_n(~rst_n),  				// Asynchronous reset active low key[0]
	.read_in(~read_in),				// Read trigger key[3]
	.instrucao(inst),
	
	// Data memory
	.mem_data_in(mem_data), 							// Data memory output -> Esses dados ser�o convertidos para hexa
	.addr_out(mem_addr),	    						// Data memory address -> Endere�o de mem�ria (este � o contador)
	.data_mem_rd_en_out(data_mem_rd_en_out),			// Data memory read enable

	// LCD signals
	.lcd_data_out(lcd_data_out), 		// LCD data
	.lcd_on_out(lcd_on_out),			// LCD power on/off
	.lcd_blon_out(lcd_blon_out),		// LCD back light on/off
	.lcd_rw_out(lcd_rw_out),			// LCD read/write select, 0 = write, 1 = read
	.lcd_en_out(lcd_en_out),			// LCD enable
	.lcd_rs_out(lcd_rs_out)			    // LCD command/data select, 0 = command, 1 = data
);

sp_ram_with_init
#(
	.DATA_WIDTH(DATA_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH)
) sp_ram_with_init_u0 (
	.data(A), // Dado a ser escrito 32'b10000000000000000000000000000000
	.addr(mem_addr),
	.we(1'b1),                
	.clk(clk_50),
	.q(mem_data) // Dados sai da ram para serem convertidos
);


always begin

	if(reset)begin
		contador = 0;
		resultado = 0;
	end

	if(hab_count & contador <= 22'b1111111111111111111000111)
		contador = contador+1;

	if(botao)begin
		hab_count = 1'b1;

		if(contador > 22'b1111111111111111000000)begin  // Pula de 2 em 2 b1111111111111111000000
			aux_botao = 1'b1;
			resultado = 1 + resultado;
			hab_count = 0;
		end else 
			aux_botao = 1'b0;
			
   	
	end else begin
		aux_botao = 1'b0;
   end
		
	A=resultado;
   inst = 888;
	habEscrita = habilitaEscritaDisplay;
 
end

endmodule
