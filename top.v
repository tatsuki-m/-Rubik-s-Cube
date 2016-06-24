module top(clk, rst_n);
	input wire clk, rst_n;
	// write enable
	input wire pc_we, reg_we, mem_we;

	// pc & imem
	input wire [7:0] pc_in, pc_out;
	input wire [15:0] op;

	// decoder
	input wire [3:0] dst;
	input wire [3:0] src0, src1;
	input wire [23:0] dec_data;

	// alu
	input wire [3:0] alu_op;
	input wire [23:0] alu_out;

	// zf
	input wire zf, zf_out;

	// selector
	input wire sel1, sel2;
	input wire [23:0] sel1_out, sel2_out;

	// register
	input wire [23:0] reg_data0, reg_data1;

	// memory
	input wire [23:0] mem_data;

// sel
sel s1(.in0(dec_data), .in1(reg_data0), .sel(sel1), .out(sel1_out));
sel s2(.in0(alu_out), .in1(mem_data), .sel(sel2), .out(sel2_out));

// register
register r0(.src0(src0), .src1(src1), .dst(dst), .we(reg_we), .data(sel2_out), .clk(clk), .rst_n(rst_n), .data0(reg_data0), .data1(reg_data1));

// alu
alu a0(.ina(sel1_out), .inb(reg_data1), .op(alu_op), .zf(zf), .out(alu_out));

// memory
memory mem0(.in(alu_out), .out(mem_data), .addr(reg_data1), .rst_n(rst_n),.clk(clk), .we(mem_we));

// pc
pc pc0(.pc_in(pc_in), .pc_out(pc_out), .rst_n(rst_n), .clk(clk), .we(pc_we));

//imem
imem imem0(.pc(pc_out), .op(op));

// zf
zf zf0(.clk(clk), .rst_n(rst_n), .zf_in(zf), .zf_out(zf_out));

// decoder
decoder dec1(.op(op), .zf(zf_out), .pc_in(pc_in), .pc_we(pc_we), .src0(src0), .src1(src1), .dst(dst), .reg_we(reg_we), .sel1(sel1), .sel2(sel2), .data(dec_data), .alu_op(alu_op), .mem_we(mem_we));

endmodule
