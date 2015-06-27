

module fifo_12_3_65536(
	input wr_clk,
	input wr_en,
	input [11:0]din,
	output full,
	
	input rd_clk,
	input rd_en,
	output [2:0]dout,
	output empty
	);
endmodule


module fsl_fifo 
	(
		// ADD USER PORTS BELOW THIS LINE 
		rd_clk,
		rd_en,
		dout,
		empty,
		// ADD USER PORTS ABOVE THIS LINE 

		// DO NOT EDIT BELOW THIS LINE ////////////////////
		// Bus protocol ports, do not add or delete. 
		FSL_Clk,
		FSL_Rst,
		FSL_S_Clk,
		FSL_S_Read,
		FSL_S_Data,
		FSL_S_Control,
		FSL_S_Exists
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);

// ADD USER PORTS BELOW THIS LINE 
// -- USER ports added here 
input rd_clk;
input rd_en;
output [2:0]dout;
output empty;

// ADD USER PORTS ABOVE THIS LINE 

input                                     FSL_Clk;
input                                     FSL_Rst;
input                                     FSL_S_Clk;
output                                    FSL_S_Read;
input      [31 : 0]                       FSL_S_Data;
input                                     FSL_S_Control;
input                                     FSL_S_Exists;


wire [11:0] value;
wire [31:0] data = FSL_S_Data;

assign value[11:9] = data[31:24] == 8'd48 ? 3'b000: data[31:24] == 8'd49 ? 3'b001:
							data[31:24] == 8'd50 ? 3'b010: data[31:24] == 8'd51 ? 3'b011: 3'b100;
assign value[08:6] = data[23:16] == 8'd48 ? 3'b000: data[23:16] == 8'd49 ? 3'b001:
							data[23:16] == 8'd50 ? 3'b010: data[23:16] == 8'd51 ? 3'b011: 3'b100;
assign value[05:3] = data[15:08] == 8'd48 ? 3'b000: data[15:08] == 8'd49 ? 3'b001:
							data[15:08] == 8'd50 ? 3'b010: data[15:08] == 8'd51 ? 3'b011: 3'b100;
assign value[02:0] = data[07:00] == 8'd48 ? 3'b000: data[07:00] == 8'd49 ? 3'b001:
							data[07:00] == 8'd50 ? 3'b010: data[07:00] == 8'd51 ? 3'b011: 3'b100;

wire full;
assign FSL_S_Read = FSL_S_Exists & ~full;

fifo_12_3_65536 fifo(
	.wr_clk(FSL_Clk),
	.wr_en(FSL_S_Read),
	.din(value),
	.full(full),
	
	.rd_clk(rd_clk),
	.rd_en(rd_en),
	.dout(dout),
	.empty(empty)
	);


endmodule

