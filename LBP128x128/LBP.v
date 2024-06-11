module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   		clk;
input   		reset;
output  reg 	[13:0] 	gray_addr;
output  reg       	gray_req;
input   		gray_ready;
input   	[7:0] 	gray_data;
output  reg 	[13:0] 	lbp_addr;
output  reg		lbp_valid;
output  reg 	[7:0] 	lbp_data;
output  reg		finish;



reg [1:0] cnt_read ;
reg [7:0] gray_data_temp1, gray_data_temp2, gray_data_temp3, gray_data_temp4,
 gray_data_temp5, gray_data_temp6, gray_data_temp7, gray_data_temp8, gray_data_temp9 ;
wire [7:0] lbp_data_temp ;
reg [13:0] center ;
reg special_case ;

wire [13:0] address2, address5, address8 ;


assign address2 = center - 128 ;
assign address5 = center ;
assign address8 = center + 128 ;



always@(posedge clk or posedge reset)
begin
	if(reset)
	begin
		gray_req <= 1 ;
		lbp_data <= 0 ;
		finish <= 0 ;
		cnt_read <= 0 ;
		center <= 128 ;
		special_case <= 0 ;
	end
	else
	begin
		if(cnt_read == 2)
		begin
			center <= center + 1 ;
			lbp_valid <= 0 ;
			if(center[6:0] == 7'b0000000 || center[6:0] == 7'b0000001) special_case <= 0 ;
			else special_case <= 1 ;
			if(center == 16256) finish <= 1 ;
		end
		if(cnt_read == 1)
		begin
			if(special_case)
			begin
				lbp_valid <= 1 ;
				lbp_addr <= center - 2 ;
				lbp_data <= lbp_data_temp ;
			end
		end
		if(cnt_read == 2) cnt_read <= 0 ;
		else cnt_read <= cnt_read + 1 ;
	end
end

assign lbp_data_temp[0] = (gray_data_temp1 >= gray_data_temp5) ? 1 : 0 ;
assign lbp_data_temp[1] = (gray_data_temp2 >= gray_data_temp5) ? 1 : 0 ;
assign lbp_data_temp[2] = (gray_data_temp3 >= gray_data_temp5) ? 1 : 0 ;
assign lbp_data_temp[3] = (gray_data_temp4 >= gray_data_temp5) ? 1 : 0 ;
assign lbp_data_temp[4] = (gray_data_temp6 >= gray_data_temp5) ? 1 : 0 ;
assign lbp_data_temp[5] = (gray_data_temp7 >= gray_data_temp5) ? 1 : 0 ;
assign lbp_data_temp[6] = (gray_data_temp8 >= gray_data_temp5) ? 1 : 0 ;
assign lbp_data_temp[7] = (gray_data_temp9 >= gray_data_temp5) ? 1 : 0 ;

always@(posedge clk)
begin
	if(~reset)
	begin
		case(cnt_read)
			2'd0 : begin 	gray_addr <= address2 ; gray_data_temp9 <= gray_data ;
					gray_data_temp7 <= gray_data_temp8 ;
					gray_data_temp8 <= gray_data_temp9 ;	end
			2'd1 : begin 	gray_addr <= address5 ; gray_data_temp3 <= gray_data ;
					gray_data_temp1 <= gray_data_temp2 ;
					gray_data_temp2 <= gray_data_temp3 ;	end
			2'd2 : begin 	gray_addr <= address8 ; gray_data_temp6 <= gray_data ;
					gray_data_temp4 <= gray_data_temp5 ;
					gray_data_temp5 <= gray_data_temp6 ;	end
		endcase
	end
end


endmodule

