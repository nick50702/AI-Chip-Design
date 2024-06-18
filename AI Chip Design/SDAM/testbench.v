`timescale 1ns/10ps
`define simulation_time 300000000
`define cycle_time      1000.0

`define pat "./Pattern_sti.dat"
`define exp "./Pattern_exp.dat"
module  testfixture;

reg     [15:0]  PAT     [0:255];
reg     [15:0]  EXP     [0:255];

reg     clk = 0;
reg     reset_n;

wire    SCL;
wire    SDAi;
reg     SDAoe; 
reg     SDAo;
pullup(SDA);
assign SCL = clk;
assign SDA = SDAoe ? SDAo : 1'bz;
assign SDAi = SDA;


always #(`cycle_time/2) clk = ~clk; 

initial $readmemh(`pat, PAT);
initial $readmemh(`exp, EXP);


reg     [15:0]  register_spaces_data;

reg     check_result_flag;
reg tws_rdout;

wire    [7:0] aout;
wire    [15:0]  dout;


SDAM u_SDAM( .reset_n(reset_n), .scl(SCL), .sda(SDA), .avalid(avalid), .aout(aout), .dvalid(dvalid), .dout(dout)  );



integer i, j;

reg     [15:0] rdata1 ;
reg     [15:0] rdata2 ;
reg     [15:0] wdata1 ;
reg     [15:0] wdata2 ;

reg     [15:0]  exp_pat;

integer err_cnt;

initial begin
reset_n = 1;
SDAoe = 0;
SDAo = 1;
err_cnt = 0;

#1;  reset_n = 0;
#(`cycle_time*3); #1; reset_n = 1;
$display(" ----------------------------------------------------------------------");
$display("TEST START !!!");
$display(" ----------------------------------------------------------------------");
#(`cycle_time*0.25);
        
//.................................................................................             

$display(" SDAM [ WRITE ] Test ..."); $display("  ");
        for (i=0; i <= 31; i=i+1) begin
                $display(" Address and Data %d write...", i);
                wdata2 = PAT[i];
                tws_write(i, wdata2);
                $display(" Result Check ..."); 
                wait(avalid&dvalid); 		$display("  ");
        end
#(`cycle_time*1);       

        
//.................................................................................
        
#(`cycle_time*3);

if (err_cnt===0)   begin
            $display("\n-----------------------------------------------------\n");
            $display("Congratulations! All data have been generated successfully!\n");
            $display("-------------------------PASS------------------------\n");
end
else begin
            $display("\n-----------------------------------------------------\n");
            $display("FAIL! Please Correct Your Code!\n");
            $display("-------------------------FAIL------------------------\n");

end

$finish;
        
end

initial begin
#(`simulation_time);
$display("\n-----------------------------------------------------\n");
$display("The simulation can't be terminated properly! Please correct your code !! \n") ;
$display("-------------------------------------------------------\n");
$finish;
end


always@(negedge SCL) begin
	if (avalid&dvalid) begin
		check_result;

	end
end

//==============================================================================================================
//================================= WF D U M P ====================================================================


        initial begin
                $fsdbDumpfile("SDAM.fsdb");
                $fsdbDumpvars("+all");
        end




//==============================================================================================================
//================================= T A S K ====================================================================

task check_result;
begin
                if (dout !== EXP[aout]) begin
                        $display(" Pattern address %d Fail!, expected result is %h, but the responsed result is %h", i, EXP[i], dout);
                        err_cnt = err_cnt + 1;                        
                        end

end
endtask


task tws_write; 
input   [7:0] addr;
input   [15:0] wdata;
integer i; 
begin
        SDAoe = 1;
        @(posedge SCL); #1;
                SDAo = 1;
        @(posedge SCL); #1;
                SDAo = 0;
        @(posedge SCL); #1;
                SDAo = 1;
        for (i=0; i<=7; i=i+1) begin
                @(posedge SCL); #1;
                        SDAo = addr[i];
        end
        for (i=0; i<=15; i=i+1) begin
                @(posedge SCL); #1;
                        SDAo = wdata[i];
        end
        @(posedge SCL); #1;
                SDAo = 1;
end
endtask



endmodule
