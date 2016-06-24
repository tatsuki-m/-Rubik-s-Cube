module pc(pc_in, pc_out, rst_n, clk, we);
	input rst_n, clk, we; // we =  write enable, rst_n => negative high
	input[7:0] pc_in;
	output[7:0] pc_out;
	reg[7:0] pc_out;

	always @(posedge clk or posedge rst_n) begin
		if (!rst_n) begin
		// reset
			pc_out <= 0;
		end else begin
			if (we) begin
				pc_out <= pc_in;
			end else begin
				pc_out <= pc_out + 1;
			end
		end
	end
endmodule
