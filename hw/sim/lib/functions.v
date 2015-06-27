
`timescale 1ns/1ns

module fifo(clk1, full, din, wr, clk2, empty, dout, rd);

parameter instants = "null";
parameter cases = "null";
parameter width = 8;
parameter depth = 256;

input clk1, clk2;
input wr, rd;
output full, empty;

input [width-1:0] din;
output [width-1:0] dout;

reg [width-1:0] buffer [0:depth-1];

integer head, tail;
integer endi, endj;

integer fp;
integer i, items;
reg [7:0] c, lc;

initial
begin
	tail = 0;
	head = 0;
	for(i=0; i<depth; i=i+1) buffer[i] = 0;

	$display("fifo instants: %s, cases: %s", instants, cases);

	if(instants == "lrm")
	begin
		fp = $fopen(cases, "r");
		if(fp != 0)
		begin
			while($feof(fp) == 0)
			begin
				c = $fgetc(fp);
				case(c)
					8'd65, 8'd097 : begin buffer[head%depth] = 3'b000; head = head + 1; end // A,a
					8'd67, 8'd099 : begin buffer[head%depth] = 3'b001; head = head + 1; end // C,c
					8'd71, 8'd103 : begin buffer[head%depth] = 3'b010; head = head + 1; end // G,g
					8'd84, 8'd116 : begin buffer[head%depth] = 3'b011; head = head + 1; end // T,t
					default: begin buffer[head%depth] = 3'b100; head = head + 1; end
				endcase
			end
		end
		$fclose(fp);
		$display("(total bytes:%d)", head);
	end
	
	if(instants == "lrm-extend")
	begin
		fp = $fopen(cases, "r");
		items = 0;
		lc = 0;
		if(fp != 0)
		begin
			while($feof(fp) == 0)
			begin
				c = $fgetc(fp);
				case(c)
					8'd48: begin buffer[head%depth] = 3'b000; head = head + 1; lc = 0; end // A,a
					8'd49: begin buffer[head%depth] = 3'b001; head = head + 1; lc = 0; end // C,c
					8'd50: begin buffer[head%depth] = 3'b010; head = head + 1; lc = 0; end // G,g
					8'd51: begin buffer[head%depth] = 3'b011; head = head + 1; lc = 0; end // T,t
					default: begin buffer[head%depth] = 3'b100; lc = lc + 1; end
				endcase
				if(lc == 1) begin items = items + 1; head = head + 1; end
			end
		end
		$fclose(fp);
		$display("items(bytes):%d(%d)", items, head);
	end
	
	if(instants == "lrm-fill")
	begin
		fp = $fopen(cases, "r");
		items = 0;
		lc = 0;
		//$fclose(fp);
		//$display("items(bytes):%d(%d)", items, head);
	end
	
	if(instants == "lrm-random")
	begin
		head = 1000;
		for(i=0; i<head; i=i+1) buffer[i] = {$random} % 4;
	end
	
	if(instants == "lrm-rate")
	begin
		head = 1;
		buffer[0] = 1;
		buffer[1] = 2;
		buffer[2] = 1;
	end

end


always @(posedge clk2)
begin
	if(instants == "lrm-score" && empty == 1'b0)
	begin
		endi = buffer[tail%depth][31:16] / 2 + 23 - buffer[tail%depth][15:00];
		endj = (buffer[tail%depth][31:16] - 1) / 2 + buffer[tail%depth][15:00] - 23;
		$display("%05d %05d %05d", buffer[tail%depth][47:32], endi, endj);
		$display("%05d %05d %05d", buffer[tail%depth][47:32], buffer[tail%depth][31:16], buffer[tail%depth][15:00]);
		tail =  tail + 1;
	end
end

always @ (posedge clk1)
begin
	if(instants == "lrm-fill" && $feof(fp) == 0 && full == 1'b0) begin
		c = $fgetc(fp);
		case(c)
			8'd48: begin buffer[head%depth] = 3'b000; head = head + 1; lc = 0; end // A,a
			8'd49: begin buffer[head%depth] = 3'b001; head = head + 1; lc = 0; end // C,c
			8'd50: begin buffer[head%depth] = 3'b010; head = head + 1; lc = 0; end // G,g
			8'd51: begin buffer[head%depth] = 3'b011; head = head + 1; lc = 0; end // T,t
			default: begin buffer[head%depth] = 3'b100; lc = lc + 1; end
		endcase
		if(lc == 1) begin items = items + 1; head = head + 1; end
	end
end


assign empty = tail == head;
assign full = head >= (tail + depth);
assign dout = buffer[tail%depth];

always@(posedge clk1) if(full == 1'b0 && wr == 1'b1) begin buffer[head%depth] <= din; head <= head + 1; end
always@(posedge clk2) if(empty == 1'b0 && rd == 1'b1) begin tail <= tail + 1; end

endmodule

module max0th(clk, a, ath, max, th);

parameter width = 16;
parameter index = 6;

input clk;
input [width-1:0] a;
input [index-1:0] ath;

output [width-1:0] max;
output [index-1:0] th;

reg [width-1:0] max;
reg [index-1:0] th;

always @(posedge clk) begin max <= a; th <= ath; end

endmodule

module max2th(clk, a, b, ath, bth, max, th);

parameter width = 16;
parameter index = 6;

input clk;
input [width-1:0] a, b;
input [index-1:0] ath, bth;

output [width-1:0] max;
output [index-1:0] th;

reg signed [width-1:0] max;
reg signed [index-1:0] th;

always @(posedge clk) if(a > b) begin max <= a; th <= ath; end else begin max <= b; th <= bth; end

endmodule


module max4th(clk, a, b, c, d, ath, bth, cth, dth, max, th);

parameter width = 16;
parameter index = 6;

input clk;
input [width-1:0] a, b, c, d;
input [index-1:0] ath, bth, cth, dth;

output [width-1:0] max;
output [index-1:0] th;

reg signed [width-1:0] max;
reg signed [index-1:0] th;

wire [width-1:0] max1 = a > b ? a : b;
wire [width-1:0] max2 = c > d ? c: d;
wire [index-1:0] th1 = a > b ? ath : bth;
wire [index-1:0] th2 = c > d ? cth : dth;

always @(posedge clk) if(max1 > max2) begin max <= max1; th <= th1; end else begin max <= max2; th <= th2; end

endmodule


