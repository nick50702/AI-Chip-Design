module LBP ( clk, reset, gray_addr, gray_req, gray_data, lbp_addr, lbp_write, lbp_data, finish);
input   	clk;
input   	reset;
output  [5:0] 	gray_addr;
output         	gray_req;
input   [7:0] 	gray_data;
output  [5:0] 	lbp_addr;
output  	lbp_write;
output  [7:0] 	lbp_data;
output  	finish;




endmodule
