`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2025 06:55:31 AM
// Design Name: 
// Module Name: calculator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module mux(input a, b, c , output o);
assign o = (c) ? b : a ;
endmodule

module adder(input [63:0] A,B , input c ,output [63:0] O);
wire [63:0] B_b ;
assign B_b = ~ B ; 
assign O = (c) ? A+B : A+B_b+1 ; 
endmodule

module comparator(input [63:0] z1 , output o);
assign o = ~z1[63] ;
endmodule ; 

module barrel_shifter(input [63:0] A,
input [5:0] B ,
input s ,
output [63:0] C);
wire z ;
assign z = s ; 
wire [63:0] int [6:0];
assign int[0] = A ;
assign C = int[6];
genvar i ; 
genvar j ;
generate
for (i=0;i<6;i=i+1) begin

for (j=0;j<64;j=j+1) begin
if((j-2**i)>=0) begin
mux m_i_j (int[i][63-j],int[i][63-j+2**i],B[i],int[i+1][63-j]) ;
end
else begin 
mux m_i_j (int[i][63-j],z,B[i],int[i+1][63-j]) ;
end
end

end
endgenerate
endmodule

module calculator( input [63:0] Z,XX,YY,input [5:0] dur ,input [2:0] mode ,
input clk ,startr ,
output reg [63:0] Xo,Yo,Zo,
output reg done);
wire del , inv ;
assign inv = mode[2] ;
reg m ;
wire del_n ;
reg start ;
reg [5:0] cycles ;
wire [5:0] shift ;
wire delz,dely;
reg [63:0] epo [63:0];
reg [63:0] epoh [63:0];
assign shift = cycles ;
assign del_n=~del ;
reg [63:0] X,Y,Zr ;
wire [63:0] xi,xo,yi,yo,xl,yl,zi,zo,ep,xini,xinih;
wire xlm , ylm ;
reg [63:0] epp ;
assign ep = epp ;
assign xi = X ;
assign yi = Y ;
assign zi = Zr ;
assign xini=64'b0010011011011101001110110110101000010000110101111001101000000000 ;
assign xinih=64'b0000000001001101001000001111010000111111101011111110000010011000 ;
//assign xlm = inv&xi[63]|xl[63] ;
//assign ylm = inv&yi[63]|yl[63] ;
adder a1 (xi,yl,del_n^m,xo);
adder a2 (yi,xl,del,yo);
adder a3 (zi,ep,del_n,zo);
barrel_shifter bs1 (xi,shift,xi[63],xl);
barrel_shifter bs2 (yi,shift,yi[63],yl);
comparator comz (zi,delz);
comparator comy (yi,dely);
assign del = (inv&(~dely)) | (~inv)&delz ;
always @(posedge clk)begin
start<=startr ;
if (start&~done) begin
if((mode[1:0]==2'b01)&(cycles==3'b0) )begin 
X<=xi ;
Y<=yi ;
Zr<=zi ;
end else begin
X<=xo ;
Y<=yo ;
Zr<=zo ;
end
case (mode[1:0]) 
  2'b0 : epp<=epo[cycles+1] ;
  2'b01 :  epp<=epoh[cycles+1] ;
  default : epp<=epo[cycles+1] ;
  endcase

cycles <= cycles+1 ;
done<= (cycles==dur) ? 1'b1 : 1'b0 ;
if (cycles==dur) begin 
Xo<= X ;
Yo<=Y ;
Zo<=Zr ;
end
end
else if(~start) begin 
case (mode) 
  3'b0 : X<=xini ;
  3'b001 :  X<=xinih ;
  3'b100 : X<=XX ;
  3'b101 : X<=XX ;
  default : X<=xini ;
endcase
case (mode) 
  3'b0 : Y<=64'b0 ;
  3'b001 :  Y<=64'b0  ;
  3'b100 : Y<=YY ;
  3'b101 : Y<=YY ;
  default : Y<=64'b0 ;
endcase
case (mode) 
  3'b0 : Zr<=Z ;
  3'b001 :  Zr<=Z ;
  3'b100 : Zr<=64'b0 ;
  3'b101 : Zr<=64'b0 ;
  default : Zr<=Z ;
endcase
done<=0 ;
cycles<=0 ;
case (mode[1:0]) 
  2'b0 : epp<=epo[0] ;
  2'b01 :  epp<=epoh[0] ;
  default : epp<=epo[0] ;
  endcase
  case (mode[1:0]) 
  2'b0 : m<=0 ;
  2'b01 : m<=1 ;
  default : m<=0 ;
endcase
end 
end
initial begin 
X<=xinih ;
Y<=64'b0;
Zr<=Z ;
done<=0 ;
cycles<=0 ;
epp<=epoh[0] ;
$readmemb("values.dat",epo,0,63);
$readmemb("valuesh.dat",epoh,0,63);
end
endmodule