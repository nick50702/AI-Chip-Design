`timescale 1ns/10ps
`define CYCLE      10        	  // Modify your clock period here
`define End_CYCLE  100000              // Modify cycle times once your design need more cycle times!

  
`define EXP        "./golden1.dat"     


module testfixture;

parameter N_EXP   = 63; // 8 x 8 pixel
parameter N_PAT   = N_EXP;

reg   [7:0]   exp_mem    [0:N_EXP-1];

reg [7:0] LBP_dbg;
reg [7:0] exp_dbg;
wire [7:0] lbp_data;
reg   clk = 0;
reg   reset = 0;
reg   result_compare = 0;

integer err = 0;
integer times = 0;
reg over = 0;
integer exp_num = 0;
wire [5:0] gray_addr;
wire [5:0] lbp_addr;
wire [7:0] gray_data;
reg gray_ready = 0;
integer i;

   LBP LBP( .clk(clk), .reset(reset), 
            .gray_addr(gray_addr), .gray_req(gray_req), .gray_data(gray_data), 
	    .lbp_addr(lbp_addr), .lbp_write(lbp_write), .lbp_data(lbp_data), 
	    .finish(finish));
			
   lbp_mem u_lbp_mem(.lbp_write(lbp_write), .lbp_data(lbp_data), .lbp_addr(lbp_addr));
   gray_mem u_gray_mem(.gray_addr(gray_addr), .gray_req(gray_req), .gray_data(gray_data), .clk(clk));

initial	$readmemh (`EXP, exp_mem);

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	$fsdbDumpfile("LBP.fsdb");
	$fsdbDumpMDA;
	$fsdbDumpvars;
end


initial begin // result compare
	$display("-----------------------------------------------------\n");
 	$display("START!!! Simulation Start .....\n");
 	$display("-----------------------------------------------------\n");
	reset = 1'b0; 
   	@(negedge clk)  reset = 1'b1; 
   	#(`CYCLE*2);    reset = 1'b0; 
	#(`CYCLE*3); 
	wait( finish === 1 ) ;
	@(negedge clk); 
	for (i=0; i <N_PAT ; i=i+1) begin
			//@(posedge clk);  // TRY IT ! no comment this line for debugging !!
				exp_dbg = exp_mem[i]; LBP_dbg = u_lbp_mem.LBP_M[i];
				if (exp_mem[i] === u_lbp_mem.LBP_M[i]) begin
					$display("pixel %d is CORRECT !! expected result is %d", i, exp_dbg); 
				end
				else begin
					$display("");
					$display("pixel %d is WRONG !! expected result is %d, but real result is %d", i, exp_dbg, LBP_dbg); 
					$display("");
					err = err+1;
				end				
	end
	$display("-----------------------------------------------------\n");
         if (err == 0)  begin
            $display("Congratulations! All data have been generated successfully!\n");
            $display("-------------------------PASS------------------------\n");
         end
         else begin
            $display("There are %d errors!\n", err);
            $display("-----------------------------------------------------\n");
	    
         end
      #(`CYCLE/2); $finish;
end


initial  begin
 #`End_CYCLE ;
 	$display("-----------------------------------------------------\n");
 	$display("Error!!! Somethings' wrong with your code ...!\n");
 	$display("-------------------------FAIL------------------------\n");
 	$display("-----------------------------------------------------\n");
 	$finish;
end
   
endmodule


module lbp_mem (lbp_write, lbp_data, lbp_addr);
input		lbp_write;
input	[5:0] 	lbp_addr;
input	[7:0]	lbp_data;

reg [7:0] LBP_M [0:63];
integer i;

initial begin
	for (i=0; i<=63; i=i+1) LBP_M[i] = 0;
end

always@(posedge lbp_write) 
	LBP_M[ lbp_addr ] <= lbp_data;

endmodule



module gray_mem (gray_addr, gray_req, gray_data, clk);
input	[5:0]	gray_addr;
input		gray_req;
output	[7:0]	gray_data;
input		clk;
`define PAT        "./pattern1.dat"  
reg	[7:0]	gray_data;

reg [7:0] GRAY_M [0:63];

initial	$readmemh (`PAT, GRAY_M);

always@(negedge clk) 
	if (gray_req) gray_data <= GRAY_M[ gray_addr ] ;

endmodule


