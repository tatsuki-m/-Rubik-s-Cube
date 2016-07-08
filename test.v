`timescale 1ps/1ps

module test;
	reg clk, rst_n;
	reg [23:0] all [0:2];
	reg [23:0] blue,white,red;
	top top0(clk, rst_n,blue,white,red);

	always #50 clk = ~clk;

	initial begin
		$dumpfile("top_test.vcd");
		$dumpvars(0, top0);
		$dumplimit(100000000000);
		$monitor($stime, "clk:%b rst:%b", clk, rst_n);
		rst_n = 0;
		clk = 0;
	# 149
		$readmemb("rubik.dat", all);
		blue <= all[0];
		white <= all[1];
		red <= all[2];
		//foreach (blue[i]) $display("readmemh : %02h", blue[i]);
		//foreach (white[i]) $display("readmemh : %02h", white[i]);
		//foreach (red[i]) $display("readmemh : %02h", red[i]);
	# 150
		rst_n = 1;
	# 100000000
	$finish;
	end
endmodule
