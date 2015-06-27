
module fifo_64_32_1024(
	input wr_clk,
	input wr_en,
	input [63:0]din,
	output full,	
	input rd_clk,
	input rd_en,
	output [31:0]dout,
	output empty
	);
endmodule

module fsl_bsw 
	(
		// ADD USER PORTS BELOW THIS LINE 
		// -- USER ports added here
		bsw_clk,
		bsw_rst,
		s1,s2,
		v1,v2,
		ack1,ack2,
		// ADD USER PORTS ABOVE THIS LINE 

		// DO NOT EDIT BELOW THIS LINE ////////////////////
		// Bus protocol ports, do not add or delete. 
		FSL_Clk,
		FSL_Rst,
		FSL_S_Clk,
		FSL_S_Read,
		FSL_S_Data,
		FSL_S_Control,
		FSL_S_Exists,
		FSL_M_Clk,
		FSL_M_Write,
		FSL_M_Data,
		FSL_M_Control,
		FSL_M_Full
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);

// ADD USER PORTS BELOW THIS LINE 
// -- USER ports added here 
input bsw_clk;
input bsw_rst;
input [2:0]s1,s2;
input v1,v2;
output ack1,ack2;
// ADD USER PORTS ABOVE THIS LINE 

input                                     FSL_Clk;
input                                     FSL_Rst;
input                                     FSL_S_Clk;
output                                    FSL_S_Read;
input      [0 : 31]                       FSL_S_Data;
input                                     FSL_S_Control;
input                                     FSL_S_Exists;

input                                     FSL_M_Clk;
output                                    FSL_M_Write;
output     [0 : 31]                       FSL_M_Data;
output                                    FSL_M_Control;
input                                     FSL_M_Full;

wire [47:0] s3;
wire wr3;
wire empty;

bsw #(.width(16), .type(3), .band(47), .a(1), .b(-3), .r(-2), .q(-5)) lrm(
	.clk(bsw_clk), .rst(bsw_rst),
	.s1(s1), .v1(~v1), .ack1(ack1),
	.s2(s2), .v2(~v2), .ack2(ack2),
	.s3(s3), .v3(), .ack3(wr3)
	);

fifo_64_32_1024 fifo(
	.wr_clk(bsw_clk),
	.wr_en(wr3),
	.din({16'h00,s3}),
	.full(),
	
	.rd_clk(FSL_Clk),
	.rd_en(FSL_M_Write),
	.dout(FSL_M_Data),
	.empty(empty)
	);

assign FSL_M_Write = ~FSL_M_Full & ~empty;

endmodule
