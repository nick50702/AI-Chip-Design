`define cycle 10
module rca16_test;

reg clk=0;

always #(`cycle) clk = ~clk;

reg [15:0] a, b;
reg c_in;

wire [15:0] sum;
wire c_out;
rca16 dut(.sum(sum), .c_out(c_out), .a(a), .b(b), .c_in(c_in));

integer err_cnt;
initial err_cnt = 0;

initial
begin
	a = 0;	b = 0;	c_in = 0;
	$display("=== Testing Start ===");
	
	@(posedge clk);
		a = 0;	b = 0;	c_in = 0;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=0, c_out=0 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==0 || c_out!==0)	begin $display($time,,"Testing failed!!");  err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 0;	b = 0;	c_in = 1;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=1, c_out=0 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==1 || c_out!==0)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 0;	b = 16'hffff;	c_in = 0;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=16'hffff, c_out=0 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==16'hffff || c_out!==0)	 begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 0;	b = 16'hffff;	c_in = 1;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=0, c_out=1 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==0 || c_out!==1)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 16'hffff;	b = 0;	c_in = 0;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=16'hffff, c_out=0 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==16'hffff || c_out!==0)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 16'hffff;	b = 0;	c_in = 1;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=0, c_out=1 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==0 || c_out!==1)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 16'hffff;	b = 16'hffff;	c_in = 0;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=16'hfffe, c_out=1 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==16'hfffe || c_out!==1)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 16'hffff;	b = 16'hffff;	c_in = 1;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=16'hffff, c_out=1 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==16'hffff || c_out!==1)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 11;	b = 9;	c_in = 0;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=20, c_out=0 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==20 || c_out!==0)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");
	@(posedge clk);
		a = 63;	b = 88;	c_in = 1;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=152, c_out=0 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==152 || c_out!==0)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");	
	@(posedge clk);
		a = 1536;	b = 2857;	c_in = 1;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=4394, c_out=0 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==4394 || c_out!==0)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");	
	@(posedge clk);
		a = 17289;	b = 40398;	c_in = 0;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=57687, c_out=0 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==57687 || c_out!==0)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");	
	@(posedge clk);
		a = 29289;	b = 50398;	c_in = 1;
	@(posedge clk);
		$display($time,,"a=%b, b=%b, c_in=%b", a, b, c_in );
		$display($time,,"Expected Result : sum=14152, c_out=1 ");
		$display($time,,"Real Result : sum=%b, c_out=%b ", sum, c_out);
		if(sum!==14152 || c_out!==1)	begin $display($time,,"Testing failed!!"); err_cnt = err_cnt + 1; end
		$display($time,,"================================= ");	
	@(posedge clk);
	if ( err_cnt == 0) 
		$display($time,,"Testing finished!! The test result is PASS ^_____^ ");
	else  $display($time,,"Testing finished!! The test result is FAIL ! Please check your code ...");
	$finish;
	
end


endmodule
