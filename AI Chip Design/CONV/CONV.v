
`timescale 1ns/10ps

module  CONV(
	input		clk,
	input		reset,
	output	reg	busy,	
	input		ready,	
			
	output	reg 	[11:0]	iaddr,
	input	signed 	[19:0]	idata,	
	
	output	 reg		cwr,
	output	 reg	[11:0]	caddr_wr,
	output	 reg	[19:0]	cdata_wr,
	
	output	 reg		crd,
	output	 reg	[11:0]	caddr_rd,
	input	 	[19:0]	cdata_rd,
	
	output	 reg	[2:0]	csel
	);

wire signed [39:0] bias ;
parameter signed w1 = 20'h0A89E, 
	w2 = 20'h092D5,
	w3 = 20'h06D43,
	w4 = 20'h01004,
	w5 = 20'hF8F71,
	w6 = 20'hF6E54,
	w7 = 20'hFA6D7,
	w8 = 20'hFC834,
	w9 = 20'hFAC19;
wire signed [19:0] Kernel1, Kernel2, Kernel3, Kernel4, Kernel5, 
		Kernel6, Kernel7, Kernel8, Kernel9 ;
wire signed [39:0] conv_sum ;
wire signed [39:0] conv_sum_6 ;

reg signed [19:0] idata_temp1, idata_temp2, idata_temp3, idata_temp4,
idata_temp5, idata_temp6, idata_temp7, idata_temp8, idata_temp9 ; 

wire signed [39:0] conv1, conv2, conv3, conv4,
	conv5, conv6, conv7, conv8, conv9;
reg [1:0] cnt_read ;
wire [11:0] address2, address5, address8 ;
reg signed [19:0] conv_result ;
reg [11:0] center ;
reg signed [19:0] cdata_wr_temp ;
reg flag ;
reg [11:0] L0mem_addr ;
reg [11:0] L1mem_addr ;
parameter L0=1'b0, L1=1'b1 ;
reg mem_state ;
wire [11:0] L1addr1, L1addr2, L1addr3, L1addr4 ;
reg [2:0] cnt_L1 ;

// bias
assign bias = 40'h0013100000 ;

// kernel_weight
assign Kernel1 = w1 ; 
assign Kernel2 = w2 ;
assign Kernel3 = w3 ;
assign Kernel4 = w4 ;
assign Kernel5 = w5 ;
assign Kernel6 = w6 ;
assign Kernel7 = w7 ;
assign Kernel8 = w8 ;
assign Kernel9 = w9 ;

// conv_sum
assign conv1 = idata_temp1*Kernel1 ;
assign conv2 = idata_temp2*Kernel2 ;
assign conv3 = idata_temp3*Kernel3 ;
assign conv4 = idata_temp4*Kernel4 ;
assign conv5 = idata_temp5*Kernel5 ;
assign conv6 = idata_temp6*Kernel6 ;
assign conv7 = idata_temp7*Kernel7 ;
assign conv8 = idata_temp8*Kernel8 ;
assign conv9 = idata_temp9*Kernel9 ;
assign conv_sum = conv1 + conv2 + conv3 + conv4 + 
conv5 + conv6 + conv7 + conv8 + conv9 + bias ;


// read_data_counter
always@(posedge clk or posedge reset)begin
	if(reset) cnt_read <= 0 ;
	else if(busy) begin
		if(cnt_read==3) cnt_read <= 0 ;
		else cnt_read <= cnt_read + 1 ;
	end
end

// iaddr
assign address2 = center - 64 ;
assign address5 = center ;
assign address8 = center + 64 ;

// flag
always@(posedge clk or posedge reset)begin
	if(reset) flag <= 0 ;
	else if(cnt_read==3&&center[5:0]==6'd63&&flag==0) flag <= 1 ;
	else if(cnt_read==0&&center[5:0]==6'd0&&flag==1)  flag <= 0 ;
end

// iaddr
always@(posedge clk or posedge reset)begin
	if(reset) center <= 0 ;
	else begin
		case(cnt_read)
		2'd0 : iaddr <= address2 ;
		2'd1 : iaddr <= address5 ;
		2'd2 : iaddr <= address8 ;
		3'd3 : begin if(flag==0&&center[5:0]==6'd63) center <= center ; else center <= center + 1 ; end 
		endcase
	end
end

// data_shift
always@(posedge clk or posedge reset)begin
	if(reset)begin
		idata_temp1 <= 0 ;
		idata_temp2 <= 0 ;
		idata_temp3 <= 0 ;
		idata_temp4 <= 0 ;
		idata_temp5 <= 0 ;
		idata_temp6 <= 0 ;
		idata_temp7 <= 0 ;
		idata_temp8 <= 0 ;
		idata_temp9 <= 0 ;
	end
	else begin
		if(flag)begin
			case(cnt_read)
			2'd1 : begin idata_temp3 <= 0 ; idata_temp1 <= idata_temp2 ; idata_temp2 <= idata_temp3 ; end
			2'd2 : begin idata_temp6 <= 0 ; idata_temp4 <= idata_temp5 ; idata_temp5 <= idata_temp6 ; end
			2'd3 : begin idata_temp9 <= 0 ; idata_temp7 <= idata_temp8 ; idata_temp8 <= idata_temp9 ; end
			endcase		
		end
		else begin
			case(cnt_read)
			2'd1 : begin idata_temp3 <= (center[11:6]==6'd0) ? 0 : idata ; idata_temp1 <= idata_temp2 ; idata_temp2 <= idata_temp3 ; end
			2'd2 : begin idata_temp6 <= idata ; idata_temp4 <= idata_temp5 ; idata_temp5 <= idata_temp6 ; end
			2'd3 : begin idata_temp9 <= (center[11:6]==6'd63) ? 0 : idata ; idata_temp7 <= idata_temp8 ; idata_temp8 <= idata_temp9 ; end
			endcase
		end
	end
end

// round
// relu
always@(*)begin
	conv_result = (conv_sum[15]) ? ({conv_sum[35:16]} + 20'd1) : {conv_sum[35:16]} ;
	cdata_wr_temp = (conv_sum[39]) ? 20'd0 : conv_result ;
end



// mem_state
always@(posedge clk or posedge reset)begin
	if(reset) mem_state <= 1'd0 ;
	else if(caddr_wr==4095) mem_state <= 1'd1 ;
end

// L1mem_addr 
assign L1addr1 = L0mem_addr ;
assign L1addr2 = L1addr1 + 1 ;
assign L1addr3 = L1addr1 + 64 ;
assign L1addr4 = L1addr3 + 1 ;
always@(posedge clk or posedge reset)begin
	if(reset)begin
		L1mem_addr <= 0 ;
		L0mem_addr <= 0 ;
		caddr_rd <= 0 ;
	end
	else if(mem_state==1'd1)begin
		case(cnt_L1)
		3'd0 : caddr_rd <= L1addr1 ;
		3'd1 : caddr_rd <= L1addr2 ;
		3'd2 : caddr_rd <= L1addr3 ;
		3'd3 : caddr_rd <= L1addr4 ;
		endcase
		if(cnt_L1==5&&L0mem_addr[5:0]==6'd62) begin L0mem_addr <= L0mem_addr + 66 ; L1mem_addr <= L1mem_addr + 1 ; end
		else if(cnt_L1==5)begin L0mem_addr <= L0mem_addr + 2 ; L1mem_addr <= L1mem_addr + 1 ; end 
	end
end

always@(posedge clk or posedge reset)begin
	if(reset) cnt_L1 <= 0 ;
	else if(mem_state==1'd1)begin
		if(cnt_L1==5) cnt_L1 <= 0 ;
		else cnt_L1 <= cnt_L1 + 1 ;
	end
end

// write data L0_MEM0
always@(posedge clk or posedge reset)begin
	if(reset)begin
		cwr <= 0 ;
		crd <= 0 ;
		caddr_wr <= 0 ;
		cdata_wr <= 0 ;
	end
	else begin
		case(mem_state)
		1'd0 : begin
			if(caddr_wr==4095||center[5:0]==6'd1) cwr <= 0 ;	
			else if(cnt_read==0)begin
				if(flag)begin			
					cwr <= 1 ;
					csel <= 3'd1 ;
					caddr_wr <= center - 1 ;
					cdata_wr <= cdata_wr_temp ;
				end
				else begin
					cwr <= 1 ;
					csel <= 3'd1 ;
					caddr_wr <= center - 2 ;
					cdata_wr <= cdata_wr_temp ;
				end
			end
		end
		1'd1 : begin
			if(cnt_L1==5)begin
				crd <= 0 ;
				cwr <= 1 ;
				csel <= 3'd3 ;
				caddr_wr <= L1mem_addr ;
			end
			else if(cnt_L1==1)begin
				cdata_wr <= cdata_rd ;
				cwr <= 0 ;
				csel <= 3'd1 ;
				crd <= 1 ;
			end	
			else begin
				cdata_wr <= (cdata_rd > cdata_wr) ? cdata_rd : cdata_wr ;
				cwr <= 0 ;
				csel <= 3'd1 ;
				crd <= 1 ;			
			end
		end
		endcase
	end
end

// busy
always@(posedge clk or posedge reset)begin
	if(reset) busy <= 0 ;
	else if(ready) busy <= 1 ;
	else if(L1mem_addr==1024) busy <= 0 ; 
end

endmodule




