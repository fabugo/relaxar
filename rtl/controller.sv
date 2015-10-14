module controller
(
    clock,
    level,
    mode,
    mode,
    start,
    BTDLS,
    equal,
    inputed,
    generat,
    selDIn,
    addrOut,
    addrIn,
    edisplay
);
    input clock;            //entrada do clock
    input [2:0] level;      //indica nivel do jogo
    input   mode,           //indica modo do jogo
            start,          //sinaliza o inicio do jogo
            BTDLS,          //sinaliza o inicio da exibicao da ultima sequencia
            equal,          //indica se os valores da memoria é igual ao entrado
            inputed;        //indica se foi pressionado algum botao de cores
    output  generat,        //sinaliza para o GNR que deve gerar um valor
            selDIn,         //seleciona oq entra na memoria
            edisplay;       //habilita a exibicao do LED
    output [3:0] addrIn,    //endereco da memoria de onde sera inscrito o dado
                 addrOut;   //endereco da memoria que armazena oq saira
    logic [3:0] state,      //indicador do estado atual
                nextState;  //indicador do proximo estado

/*
Estados
    4'b0000: IDLE_INI
    4'b0001: GNR
    4'b0010: IDLE_INPUT
    4'b0011: DLS
    4'b0100: MEM_OUT
    4'b0101: DS
    4'b0110: IDLE_PLAY
    4'b0111: MEM_IN
    4'b1000: COMPARE
Memoria
    0: valor correto
    1: valor tentado
    3: ultima sequencia
*/
    always @(posedge clock or start or BTDLS)begin
        case(state)
            4'b0000:begin
                if(BTDLS)
                    nextState <= 4'b0011;
                else
                    if(mode && start)
                        nextState <= 4'b0010;
                        else
                        nextState <= 4'b0001;
            end
            4'b0001:begin
                nextState <= 4'b0100;
                generat = 1;
                selDIn = 1;
                addrIn = 0;
                ewrite = 1;
                addrOut = 0;//n importa
                edisplay = 0;
            end
            4'b0010:begin
                if(inputed)
                    nextState <= 4'b0100;
                else
                    nextState <= 4'b0010;
                generat = 0;
                selDIn = 0;
                addrIn = 0;
                ewrite = 1;
                edisplay = 0;
            end
            4'b0011:begin
                generat = 0;//n importa
                selDIn = 0;//n importa
                addrIn = 0;//n importa
                ewrite = 0;
                addrOut = 0;
                edisplay = 1;
            end
            4'b0100:begin

            end
            4'b0101:begin

            end
            4'b0110:begin

            end
            4'b0111:begin

            end
            4'b1000:begin

            end
            default:begin

            end
        endcase
    end
endmodule
