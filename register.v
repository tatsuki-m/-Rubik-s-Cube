module register(src0, src1, dst, we, data, clk, rst_n, data0, data1);
	input wire clk, rst_n, we;
	input wire [3:0] src0, src1;
	input wire [3:0] dst;
	input wire [23:0] data;
	output wire [23:0] data0, data1;
	wire [23:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11;
	reg [23:0] regis [15:0]; // depend on algorism

	parameter [23:0] BLUE = 24'b1000_0000_0000_0000_1100_0001,
					WHITE = 24'b0000_1000_0001_0100_0000_1000,
					RED   = 24'b0001_0011_0010_0000_0000_0000,
					ORDER1 = 24'b0000_0000_0000_0000_0000_0000,
					ORDER2 = 24'b0000_0000_0000_0000_0000_0000,
					IDEAL_BLUE = 24'b1111_0000_0000_0000_0000_0000,
					IDEAL_WHITE = 24'b0000_1111_0000_0000_0000_0000,
					IDEAL_RED = 24'b0000_0000_1111_0000_0000_0000;

always @(posedge clk) begin
	// rst_n 1 => はいらない
if (!rst_n) begin
// initial state
		regis[0] <= BLUE;
		regis[1] <= WHITE;
		regis[2] <= RED;
// temp state
		regis[3] <= 0;
		regis[4] <= 0;
		regis[5] <= 0;
// order 4bit
		regis[6] <= ORDER1;
		regis[7] <= ORDER2;
// tmp order saving 4 digit
		regis[8] <= 0;
// ideal state
		regis[9]  <= IDEAL_BLUE;
		regis[10] <= IDEAL_WHITE;
		regis[11] <= IDEAL_RED;
// ignore
		regis[12] <= 0;
		regis[13] <= 0;
		regis[14] <= 0;
		regis[15] <= 0;
	end else begin
		if (we) begin
			regis[dst] <= data;
		end else begin
			regis[dst] <= regis[dst];
		end
	end
end

assign data0 = regis[src0];
assign data1 = regis[src1];

// watch register
assign reg0 = regis[0];
assign reg1 = regis[1];
assign reg2 = regis[2];
assign reg3 = regis[3]; assign reg4 = regis[4]; assign reg5 = regis[5]; assign reg6 = regis[6];
assign reg7 = regis[7];
assign reg8 = regis[8];
assign reg9 = regis[9];
assign reg10 = regis[10];
assign reg11 = regis[11];

endmodule


