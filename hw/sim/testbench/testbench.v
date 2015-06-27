
`timescale 1ns/1ns

module testbench();

parameter type = 3;
parameter width = 16;

reg clk, rst;
always # 10 clk <= ~ clk;

initial
begin
	clk = 0;
	rst = 1;
	# 200;
	rst = 0;
end

wire [type-1:0] s1, s2;
wire [47:0]s3;
wire v1, v2, v3, rd1, rd2, wr3;

//fifo #(.width(type), .depth(4096), .instants("lrm"), .cases("../../../data/seq1.fa")) seq1(
fifo #(.width(type), .depth(65536), .instants("lrm-fill"), .cases("../../../data/gene/seql1.txt")) seq1(
	.clk1(clk), .full(), .din(), .wr(),
	.clk2(clk), .empty(v1), .dout(s1), .rd(rd1)
	);

//fifo #(.width(type), .depth(4096), .instants("lrm"), .cases("../../../data/seq2.fa")) seq2(
fifo #(.width(type), .depth(65536), .instants("lrm-fill"), .cases("../../../data/gene/seql2.txt")) seq2(
	.clk1(clk), .full(), .din(), .wr(),
	.clk2(clk), .empty(v2), .dout(s2), .rd(rd2)
	);

fifo #(.width(48), .depth(4096), .instants("lrm-score"), .cases()) score(
	.clk1(~clk), .full(v3), .din(s3), .wr(wr3),
	.clk2(clk), .empty(), .dout(), .rd()
	);

bsw #(.width(width), .type(type), .band(47), .a(1), .b(-3), .r(-2), .q(-5)) lrm(
	.clk(clk), .rst(rst),
	.s1(s1), .v1(~v1), .ack1(rd1),
   	.s2(s2), .v2(~v2), .ack2(rd2),
	.s3(s3), .v3(~v3), .ack3(wr3)
	);

endmodule


