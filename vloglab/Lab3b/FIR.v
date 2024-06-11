module FIR(Dout, Din, clk, reset);

parameter b0=7;
parameter b1=17;
parameter b2=32;
parameter b3=46;
parameter b4=52;
parameter b5=46;
parameter b6=32;
parameter b7=17;
parameter b8=7;

output	[17:0]	Dout;
input 	[7:0] 	Din;
input 		clk, reset;



endmodule
