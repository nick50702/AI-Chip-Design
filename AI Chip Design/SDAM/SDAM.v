module SDAM(reset_n, scl, sda, avalid, aout, dvalid, dout);
input	reset_n ;
input	scl ;
input	sda ;

output	reg 		avalid, dvalid ;
output	reg	[7:0]	aout ;
output	reg	[15:0]	dout ;
reg [7:0] Addr ;
reg [15:0] data ;
reg [1:0] current_state ;
parameter IDLE = 2'b00, START = 2'b01, WRA = 2'b10, WRD = 2'b11 ;
reg [2:0] wra_cnt ;
reg [3:0] wrd_cnt ;
reg out_flag ;


always@(posedge scl or negedge reset_n)
begin // CS
	if(~reset_n)begin
		current_state <= IDLE ;
	end
	else begin
		case(current_state)
		IDLE : if(sda == 0) current_state <= START ;
		START : begin
				if(sda == 1) begin
					current_state <= WRA ;
					avalid <= 0 ;
					dvalid <= 0 ;
					wra_cnt <= 0 ;
					wrd_cnt <= 0 ;
				end
			end
		WRA : begin
			if(wra_cnt >= 3'd7) begin
				current_state <= WRD ;
				Addr[wra_cnt] <= sda ;
				end
				else begin
					Addr[wra_cnt] <= sda ;
					wra_cnt <= wra_cnt + 1 ;
				end
			end
		WRD : begin
			if(wrd_cnt >= 4'd15) begin
				data[wrd_cnt] <= sda ;
				current_state <= IDLE ;
				out_flag <= 1 ;
				end
				else begin
					data[wrd_cnt] <= sda ;
					wrd_cnt <= wrd_cnt + 1 ;
				end
			end
		default : begin
				wra_cnt <= 0 ;
				wrd_cnt <= 0 ;
				current_state <= IDLE ;
				end
		endcase
	end
end

always@(*)
begin
	if(out_flag == 1)begin
		avalid <= 1 ;
		dvalid <= 1 ;
		aout <= Addr ;
		dout <= data ;
		out_flag <= 0 ;
	end
end

endmodule