

module bsw(clk, rst,
		s1, v1, ack1,
		s2, v2, ack2,
		s3, v3, ack3
		);

parameter width = 16;
parameter type = 3;

parameter band = 47;
parameter a = 1;
parameter b = -3;
parameter r = -2;
parameter q = -5;

parameter l1 = (band>>2) + (band != (band>>2<<2));
parameter l2 = (l1>>2) + (l1 != (l1>>2<<2));

input clk, rst;
input [type-1:0] s1, s2;
input v1, v2, v3;
output ack1, ack2, ack3;
output [47:0]s3;

wire signed [width-1:0] gnd = {width{1'b0}};
wire signed [width-1:0] I [0:band-1];
wire signed [width-1:0] D [0:band-1];
wire signed [width-1:0] oM[0:band-1];
wire signed [width-1:0] M [0:band-1];

wire [type-2:0] seq1[0:band-1];
wire [type-2:0] seq2[0:band-1];
wire new1[0:band-1];
wire new2[0:band-1];


///////////////////////////////////////////////////////////////////////
reg running = 0;
reg dir = 0;
reg [1:0]over = 2'b00;
reg exit = 0;
reg [5:0] ape;

wire freeze;
wire [1:0]mov;
wire load;
wire last;
wire finish;
wire norun = ~running;

wire [1:0]valid = {v2 & ~s2[type-1], v1 & ~s1[type-1]};

wire start = valid[1] & valid[0];

always @(posedge clk) if(rst) running <= 1'b0; else if(norun) running <= start; else if(finish) running <= 1'b0; else running <= 1'b1;

always @(posedge clk) if(norun) ape <= 6'd0; else if(load == 1'b0 || start == 1'b0) ape <= ape; else ape <= ape + 6'd1;

assign load = ape < (band>>1);

always @(posedge clk) if(load) over[0] <= 1'b0; else over[0] <= over[0]? 1'b1: s1[type-1];
always @(posedge clk) if(load) over[1] <= 1'b0; else over[1] <= over[1]? 1'b1: s2[type-1];

always @(posedge clk) if(load) dir <= 1'b1; else if(freeze) dir <= dir; else dir <= ~dir;

assign freeze = dir ? ~(over[0]|v1): ~(over[1]|v2);

assign mov = norun ? 2'b00: load ? {2{start}}: {~freeze & ~dir, ~freeze & dir};

always @(posedge clk) if(load) exit <= 1'b0; else exit <= exit ? 1'b1 : last;

assign ack1 = norun ? v1 & s1[type-1]: (mov[0]|exit) & ~over[0];
assign ack2 = norun ? v2 & s2[type-1]: (mov[1]|exit) & ~over[1];

assign last = (new1[band-1] & ~ new1[band-2]) | (new2[band-1] & ~ new2[band-2]);
assign finish = exit & over[0] & over[1];

//////////////////////////////////////////////////////////////////////////////////////////////////

genvar i;
generate
for(i=0; i<band; i=i+1)
begin: sw
	if(i == 0)
		core #(.width(width), .type(type-1), .a(a), .b(b), .r(r), .q(q))
		uut(.clk(clk), .rst(norun), .mov(mov),
			.I_l(gnd), .M_l(gnd), .oM_l(gnd),
			.D_r(D[i+1]), .M_r(M[i+1]),
			.I(I[i]), .D(D[i]), .M(M[i]), .oM(oM[i]),
			.seql(s1[type-2:0]), .seqr(seq2[band-2]), .seq1(seq1[0]), .seq2(seq2[band-1]),
			.newl(valid[0] & ~over[0]),  .newr(new2[band-2]), .new1(new1[0]), .new2(new2[band-1])
		);
			
	else if(i == band - 1)
		core #(.width(width), .type(type-1), .a(a), .b(b), .r(r), .q(q))
		uut(.clk(clk), .rst(norun), .mov(mov),
			.I_l(I[i-1]), .M_l(M[i-1]), .oM_l(oM[i-1]),
			.D_r(gnd), .M_r(gnd),
			.I(I[i]), .D(D[i]), .M(M[i]), .oM(oM[i]),
			.seql(seq1[band-2]), .seqr(s2[type-2:0]), .seq1(seq1[band-1]), .seq2(seq2[0]),
			.newl(new1[band-2]), .newr(valid[1] & ~over[1]),  .new1(new1[band-1]), .new2(new2[0])
		);
			
	else
		core #(.width(width), .type(type-1), .a(a), .b(b), .r(r), .q(q))
		uut(.clk(clk), .rst(norun), .mov(mov),
			.I_l(I[i-1]), .M_l(M[i-1]), .oM_l(oM[i-1]),
			.D_r(D[i+1]), .M_r(M[i+1]),
			.I(I[i]), .D(D[i]), .M(M[i]), .oM(oM[i]),
			.seql(seq1[i-1]), .seqr(seq2[band-2-i]), .seq1(seq1[i]), .seq2(seq2[band-1-i]),
			.newl(new1[i-1]), .newr(new2[band-2-i]), .new1(new1[i]), .new2(new2[band-1-i])
		);
			
end
endgenerate


wire signed [width-1:0] sc[0:l1+l2];
wire [5:0] index[0:l1+l2];
wire [0:383] th;

assign th= {6'd00, 6'd01, 6'd02, 6'd03, 6'd04, 6'd05, 6'd06, 6'd07, 6'd08, 6'd09, 6'd10, 6'd11, 6'd12, 6'd13, 6'd14, 6'd15,
			6'd16, 6'd17, 6'd18, 6'd19, 6'd20, 6'd21, 6'd22, 6'd23, 6'd24, 6'd25, 6'd26, 6'd27, 6'd28, 6'd29, 6'd30, 6'd31,
			6'd32, 6'd33, 6'd34, 6'd35, 6'd36, 6'd37, 6'd38, 6'd39, 6'd40, 6'd41, 6'd42, 6'd43, 6'd44, 6'd45, 6'd46, 6'd47,
			6'd48, 6'd49, 6'd50, 6'd51, 6'd52, 6'd53, 6'd54, 6'd55, 6'd56, 6'd57, 6'd58, 6'd59, 6'd60, 6'd61, 6'd62, 6'd63};

generate
for(i=0; i<band; i=i+4) 
begin: maxl1
	if((band-i) == 3)
		max4th #(.width(width)) maxl13(clk, M[i], M[i+1], M[i+2], gnd,
		th[i*6:i*6+5], th[i*6+6:i*6+11], th[i*6+12:i*6+17], 6'd63, sc[i/4], index[i/4]);
	else if((band-i) == 2)
		max2th #(.width(width)) maxl12(clk, M[i], M[i+1], th[i*6:i*6+5], th[i*6+6:i*6+11], sc[i/4], index[i/4]);
	else if((band-i) == 1)
		max0th #(.width(width)) maxl11(clk, M[i], th[i*6:i*6+5], sc[i/4], index[i/4]);
	else
		max4th #(.width(width)) maxl10(clk, M[i], M[i+1], M[i+2], M[i+3],
		th[i*6:i*6+5], th[i*6+6:i*6+11], th[i*6+12:i*6+17], th[i*6+18:i*6+23], sc[i/4], index[i/4]);
end

for(i=0; i<l1; i=i+4) 
begin: maxl2
	if((l1-i) == 3)
		max4th #(.width(width)) maxl23(clk, sc[i], sc[i+1], sc[i+2], gnd,
		index[i], index[i+1], index[i+2], 6'd63, sc[i/4+l1], index[i/4+l1]);
	else if((l1-i) == 2)
		max2th #(.width(width)) maxl22(clk, sc[i], sc[i+1],	index[i], index[i+1], sc[i/4+l1], index[i/4+l1]);
	else if((l1-i) == 1)
		max0th #(.width(width)) maxl21(clk, sc[i], index[i], sc[i/4+l1], index[i/4+l1]);
	else
		max4th #(.width(width)) maxl20(clk, sc[i], sc[i+1], sc[i+2], sc[i+3],
		index[i], index[i+1], index[i+2], index[i+3], sc[i/4+l1], index[i/4+l1]);
end

if(l2 == 3)
	max4th #(.width(width)) maxl3(clk, sc[l1], sc[l1+1], sc[l1+2], load?gnd:sc[l1+l2],
	index[l1], index[l1+1], index[l1+2], load?6'd63:index[l1+l2], sc[l1+l2], index[l1+l2]);
else if(l2 == 2)
	max4th #(.width(width)) maxl3(clk, sc[l1], sc[l1+1], load? gnd:sc[l1+l2], gnd,
	index[l1], index[l1+1], load?6'd63:index[l1+l2], 6'd63, sc[l1+l2], index[l1+l2]);
else if(l2 == 1)
	max4th #(.width(width)) maxl3(clk, sc[l1], load?gnd:sc[l1+l2], gnd, gnd,
	index[l1], load?6'd63:index[l1+l2], 6'd63, 6'd63, sc[l1+l2], index[l1+l2]);

endgenerate

reg [15:0] phase;
always @(posedge clk) if(load) phase <= 16'd0; else if(freeze) phase <= phase; else phase <= phase + 16'd1;

reg [width-1:0] score;
reg [15:0] pos;
always @(posedge clk) score <= sc[l1+l2];
always @(posedge clk) if(score < sc[l1+l2]) pos <= phase; else pos <= pos;

assign s3 = {sc[l1+l2], pos, {10'h00, index[l1+l2]}};
assign ack3 = finish & running;

/*
integer k;
reg signed [width-1:0] scm = 0;
always @(posedge clk)
begin
	for(k=0; k<=band; k=k+1) if(scm < M[k]) scm = M[k];
	if(ack3) $display("sc:%d",scm);
end
*/

endmodule

module core(clk, rst, mov,
			I_l, M_l, oM_l,
		   	D_r, M_r,
			I, D, M, oM,
		   	seql, seqr, seq1, seq2,
			newl, newr, new1, new2);

parameter width = 16;
parameter type = 2;

parameter a = 1;
parameter b = -3;
parameter r = -2;
parameter q = -5;
parameter rq = r + q;

input clk, rst;
input [1:0]mov;
input [type-1:0] seql, seqr;
input newl, newr;
input [width-1:0] I_l, M_l, oM_l, D_r, M_r;

output reg signed [width-1:0] I, M, oM, D;
output reg [type-1:0] seq1, seq2;
output reg new1, new2;

wire signed [width-1:0] lI = mov[1] ? I_l : I;
wire signed [width-1:0] lM = mov[1] ? M_l : M;
wire signed [width-1:0] uD = mov[1] ? D : D_r;
wire signed [width-1:0] uM = mov[1] ? M : M_r;

wire signed [width-1:0] I_tmp = (lI > lM + q) ? lI + r : lM + rq;
wire signed [width-1:0] D_tmp = (uD > uM + q) ? uD + r : uM + rq;
wire signed [width-1:0] cM = oM + (seql == seqr ? a : b);

wire signed [width-1:0] M_tmp1 = I_tmp > D_tmp ? I_tmp : D_tmp;
wire signed [width-1:0] M_tmp2 = cM > 0 ? cM : 0;
wire signed [width-1:0] M_tmp = M_tmp1 > M_tmp2 ? M_tmp1: M_tmp2;

always @(posedge clk)
begin
	if(rst) begin new1 <= 1'b0; new2 <= 1'b0; seq1 <= 0; seq2 <= 0; end
	else
	case(mov)
		2'b00: begin new1 <= new1; new2 <= new2; seq1 <= seq1; seq2 <= seq2; end
		2'b01: begin new1 <= newl; new2 <= new2; seq1 <= seql; seq2 <= seq2; end
		2'b10: begin new1 <= new1; new2 <= newr; seq1 <= seq1; seq2 <= seqr; end
		2'b11: begin new1 <= newl; new2 <= newr; seq1 <= seql; seq2 <= seqr; end
	endcase
end

always @(posedge clk)
begin
	if(mov == 2'b00) begin I<= I; D <= D; M <= M; oM <= oM; end
	else if(newl & newr) begin I<= I_tmp; D <= D_tmp; M <= M_tmp; oM <= M; end
	else begin I <= 0; D <= 0; M <= 0; oM <= 0; end
end

endmodule


