/* *	[15:12] alu_op *	[11:8]  dst
*	[7:4]   src1
*	[3:0]  	src0
*/


module decoder(op, zf, pc_in, pc_we, src0, src1, dst, reg_we, sel1, sel2, data, alu_op, mem_we);
	input wire [15:0] op;
	input wire zf;
	output reg [7:0] pc_in;
	output reg pc_we;
	output reg [3:0] src0, src1, dst;
	output reg reg_we;
	output reg sel1, sel2;
	output reg [23:0] data;
	output reg [3:0] alu_op;
	output reg mem_we;

`include "def.h"

always @(*) begin
// synopsys parallel_case full_case
	case (op[15:12])
	RX90 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 1;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end

	RX180 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 0;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end

	RX270 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 0;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end

	RY90 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 1;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end

	RY180 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 1;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end

	RY270 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 1;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end

	RZ90 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 1;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end
	
	RZ180 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 1;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end

/*
	RZ270 : begin
		alu_op  <= op[15:12];
		dst	    <= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 1;
		sel2	<= 0;
		data	<= 0;
		mem_we	<= 0;
	end
*/

	REFERENCE : begin
		alu_op <= op[15:12];
		dst    <= op[11:8];
		src1   <= op[7:4];
		src0   <= 0;
		pc_in  <= 0;
		pc_we  <= 0;
		reg_we <= 1;
		sel1   <= 0;
		sel2   <= 0;
		data   <= 0;
		mem_we <= 0;
	end

	ADD: begin
		alu_op  <= op[15:12];
		dst		<= op[11:8];
		src1    <= op[7:4];
		src0    <= 0;
		pc_in   <= 0;
		pc_we   <= 0;
		reg_we  <= 1;
		sel1 	<= 0;
		sel2   	<= 0;
		data    <= {op[3:0], 20'b0000_0000_0000_0000_0000}; mem_we  <= 0;
	end

	CHECK : begin
		alu_op  <= op[15:12];
		dst		<= 0;
		src1    <= op[11:8];
		src0    <= 0;
		pc_in   <= 0;
		pc_we   <= zf;
		reg_we  <= 0;
		sel1 	<= 0;
		sel2   	<= 0;
		data    <= {op[7:0], 16'b0000_0000_0000_0000};
		mem_we  <= 0;
	end

	COMP : begin
		alu_op  <= op[15:12];
		dst		<= 0;
		src1    <= op[7:4];
		src0    <= op[3:0];
		pc_in   <= 0;
		pc_we   <= zf;
		reg_we  <= 0;
		sel1 	<= 1;
		sel2   	<= 0;
		data    <= 0;
		mem_we  <= 0;
	end

	COPY : begin
		alu_op	<= op[15:12];
		dst 	<= op[11:8];
		src1	<= op[7:4];
		src0	<= 0;
		pc_in	<= 0;
		pc_we	<= 0;
		reg_we	<= 1;
		sel1	<= 0;
		sel2	<= 0;
		data	<= op[3:0];
		mem_we	<= 0;
	end 

	JMP: begin
		alu_op  <= 0;
		dst		<= 0;
		src1    <= 0;
		src0    <= 0;
		pc_in   <= op[7:0];
		pc_we   <= 1;
		reg_we  <= 0;
		sel1 	<= 0;
		sel2   	<= 0;
		data    <= 0;
		mem_we  <= 0;
	end

	JNZ : begin
		alu_op  <= 0;
		dst		<= 0;
		src1    <= 0;
		src0    <= 0;
		pc_in   <= op[7:0];
		pc_we   <= zf;
		reg_we  <= 0;
		sel1 	<= 0;
		sel2   	<= 0;
		data    <= 0;
		mem_we 	<= 0;
	end

	 STORE : begin
		alu_op  <= op[15:12];
		dst		<= 0;
		src1    <= op[11:8];
		src0    <= op[7:4];
		pc_in   <= 0;
		pc_we   <= 0;
		reg_we  <= 0;
		sel1 	<= 1;
		sel2   	<= 0;
		data    <= 0;
		mem_we  <= 1;
	end

	default : begin
		pc_we <= 0;
	end
	endcase
end

endmodule



