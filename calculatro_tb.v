`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2025 07:36:35 AM
// Design Name: 
// Module Name: calculatro_tb
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


module calculatro_tb;
wire [63:0] toch ;
assign toch = test[3];
integer file1 ;
integer file2 ;
integer file3 ;
integer file4 ;
integer file5 ;
integer file6 ;
integer file8 ;
reg [63:0] A ;
reg [2:0] mode ;
reg clk ;
reg start ;
reg [5:0] dur ;
wire [63:0] X,Y ;
wire done ;
wire [5:0]cyc;
wire [63:0] xl,yl,xo,yo,zcal,zz,ep ;
reg [63:0] test [2499:0] ;
reg [63:0] tests [1570:0] ;
reg [63:0] testc [1570:0] ;
assign zz = cal.zi ;
wire del,m,inv,delz ;
assign delz= cal.delz ;
assign inv= cal.inv ;
assign m=cal.m ;
assign ep=cal.ep ;
assign del=cal.del ; 
assign xl=cal.xl ;
assign yl=cal.yl ;
assign xo=cal.xo ;
assign yo=cal.yo ; 
assign cyc = cal.cycles ;
always #1 clk = ~clk ;
reg [11:0] turn; 
reg [63:0] Xin,Yin ; 
calculator cal (A,Xin,Yin,dur,mode,clk,start,X,Y,zcal,done);
always @(posedge clk)begin 
if(done&start) begin
//$fwrite(file1, "%b\n",X);
//$fwrite(file2, "%b\n",Y);
//$fwrite(file3, "%b\n",X);
//$fwrite(file4, "%b\n",Y);
//$fwrite(file5, "%b\n",zcal);
//$fwrite(file6, "%b\n",zcal);
$fwrite(file8, "%b\n",zcal);
end
end
always @(posedge clk) begin
if((done==1)&(start==1)) begin 
turn = turn +1 ;
A= test[turn] ;
Xin = testc[turn] ;
Yin = tests[turn] ; 
start = 0 ;
end
if((done==0)&(start==0)) begin 
start = 1;
end
end
initial begin
cal.start = 0 ;
start=0 ;
//$readmemb("test_tri.dat",test,0,1570);
//$readmemb("test_hyp.dat",test,0,2499);
//$readmemb("test_cos.dat",testc,0,1570);
//$readmemb("test_sin.dat",tests,0,1570);
//$readmemb("test_sinh.dat",tests,0,999);
//$readmemb("test_cosh.dat",testc,0,999);
$readmemb("test_sinl.dat",tests,0,899);
$readmemb("test_cosl.dat",testc,0,899);
mode = 3'b101 ;
dur = 6'b111111 ;
turn=12'b0 ;
A=64'b0000000000000000000000000000000000000000000000000000000000000000;
clk=0;
//file1 = $fopen("outputcos.txt", "w");
//file2 = $fopen("outputsin.txt", "w");
file3 = $fopen("outputcosh.txt", "w");
file4 = $fopen("outputsinh.txt", "w");
file5 = $fopen("outputatan.txt", "w");
file6 = $fopen("outputatanh.txt", "w");
file8 = $fopen("outputlnx.txt", "w");
#2 start=1 ;
//wait((turn==12'b011000100011)&(~start)&(done)) 
//wait((turn==12'b001111100111)&(~start)&(done))
wait((turn==12'b001110000011)&(~start)&(done))
//wait((turn==12'b100111000100)&(~start)&(done)) 
$finish ;


end
endmodule
