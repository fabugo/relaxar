module DeBouncer
(
clock,
btin,
btout
);

input clock;
input logic btin;
output logic btout;
logic control;
logic [26:0] count = 0;

always @(posedge clock)begin
    if(count == 50000000)begin
        control = 1;
        count <= 0;
    end
count = count + 1;
end
always @(posedge clock)begin
    if(control && btin)begin
        btout = 1;
        control = 0;
    end
end
endmodule
