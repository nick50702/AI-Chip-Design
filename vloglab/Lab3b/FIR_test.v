
`timescale 10ps/10fs
module FIR_test;

integer k;
reg reset;
reg [7:0] Din;
reg clk;

real cycle = 5;

initial clk = 0;
always #((cycle)/2) clk = ~clk;




wire [17:0] Dout;

FIR dut(.Dout(Dout), .Din(Din), .clk(clk), .reset(reset));

initial begin
clk = 0;
reset = 0;
Din = 0;
#1 reset = 1;
@(posedge clk); @(posedge clk); 
#1 reset = 0;
#1 Din = 0;
@(posedge clk);
#1 Din = 8'b1;
@(posedge clk);
#1 Din = 0;
for (k = 0; k<=15; k=k+1) @(posedge clk);

#1 Din = 1;
@(posedge clk);
#1 Din = 0;
@(posedge clk); @(posedge clk); @(posedge clk);
#1 reset = 1;
for (k = 0; k<=15; k=k+1) @(posedge clk);
#1 reset = 0;

@(posedge clk);
 #1 Din=0;
@(posedge clk);
 #1 Din=8'b00011001;
@(posedge clk);
 #1 Din=8'b11111001;
@(posedge clk);
 #1 Din=8'b00111010;  
 @(posedge clk);
 #1 Din=8'b00000001;  
 @(posedge clk);
 #1 Din=8'b00110011;  
 @(posedge clk);
 #1 Din=8'b00011000;  
 @(posedge clk);
 #1 Din=8'b00001100;  
 @(posedge clk);
 #1 Din=8'b00100110;  
 @(posedge clk);
 #1 Din=8'b11100110;  
 @(posedge clk);
 #1 Din=8'b00011001;  
 @(posedge clk);
 #1 Din=8'b11011001;  
 @(posedge clk);
 #1 Din=8'b11110011;  
 @(posedge clk);
 #1 Din=8'b11101000;  
 @(posedge clk);
 #1 Din=8'b11001011;  
 @(posedge clk);
 #1 Din=8'b11111110;  
 @(posedge clk);
 #1 Din=8'b11101100;  
 @(posedge clk);
 #1 Din=8'b00000110;  
 @(posedge clk);
 #1 Din=8'b11100110;  
 @(posedge clk);
 #1 Din=8'b00000001;  
 @(posedge clk); 
#1 Din = 0;
for (k = 0; k<=25; k=k+1) @(posedge clk);

$display("Simulation finished !! Please check the waveform !!");
$finish;

end

initial begin
$fsdbDumpfile("FIR.fsdb");
$fsdbDumpvars;
end




endmodule
