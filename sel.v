module sel(in0, in1, sel, out);
	input wire [23:0] in0, in1;
	input wire sel;
	output wire [23:0] out;

	assign out = (sel) ? in1:in0;
endmodule

