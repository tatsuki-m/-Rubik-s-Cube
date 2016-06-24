module alu(ina, inb, op, zf, out);
	input wire [23:0] ina, inb;
	input wire [3:0] op;
	output reg zf;
	output reg [23:0] out;

`include "def.h"
`include "order_digit_title.h"

parameter ORDER_DIGIT_INC_FLAG = 1'b1,
		  INIT_ROTATION_FLAG = 1'b1;
always @(*) begin
	case (op)
/*
	AND : begin
		out <= ina & inb;
		zf <= 0;
	end

	OR  : begin
		out <= ina | inb;
		zf <= 0;
	end

	ADD : begin
		out <= ina + inb;
		zf <= 0;
	end

	SUB : begin
		out <= (ina > inb) ? ina - inb : inb - ina;
		zf <= 0;
	end


INC : begin
		out <= ina + 1'b1;
		zf <= 0;
	end


	DEC : begin
		out <= ina - 1;
		zf <= 0;
	end

	COMP : begin
		zf <= (ina == inb) ? 1 : 0;
	end

	CHECK : begin
		zf <= (ina == inb) ? 1 : 0;
	end

	LOAD: begin
		out <= ina;
		zf <= 0;
	end

	LI : begin
		out <= ina;
		zf <= 0;
	end
*/

// Rotation
	RX90 : begin
		out <= {inb[23:19], inb[6:5], inb[16:15], inb[18:17], inb[12:11], inb[14:13], inb[8:7], inb[10:9], inb[4], inb[2:0], inb[3]};
		zf <= 0;
	end

	RX180 : begin
		out <= {inb[23:19], inb[10:9], inb[16:15], inb[6:5], inb[12:11], inb[18:17], inb[8:7], inb[14:13], inb[4], inb[1:0], inb[3:2]};
		zf <= 0;
	end
	
	RX270 : begin
		out <= {inb[23:19], inb[14:13], inb[16:15], inb[10:9], inb[12:11], inb[6:5], inb[8:7], inb[18:17], inb[4], inb[0], inb[3:1]};
		zf <= 0;
	end

	RY90 : begin
		out <= {inb[23:22], inb[13:12], inb[19:14], inb[1:0], inb[10:8], inb[11], inb[21:20], inb[5:2], inb[7:6]};
		zf <= 0;
	end

	RY180 : begin
		out <= {inb[23:22], inb[1:0], inb[19:14], inb[7:6], inb[9:8], inb[11:10], inb[13:12], inb[5:2], inb[21:20]};
		zf <= 0;
	end

	RY270 : begin
		out <= {inb[23:22], inb[7:6], inb[19:14], inb[21:20], inb[8], inb[11:9], inb[1:0], inb[5:2], inb[13:12]};
		zf <= 0;
	end

	RZ90 : begin
		out <= {inb[23], inb[11:10], inb[20:18], inb[22:21], inb[12], inb[15:13], inb[0], inb[3], inb[9:4], inb[16], inb[2:1], inb[17]};
		zf <= 0;
	end

	RZ180 : begin
		out <= {inb[23], inb[0], inb[3], inb[20:18], inb[11:10], inb[13:12], inb[15:14], inb[17:16], inb[9:4], inb[21], inb[2:1], inb[22]};
		zf <= 0;
	end

/*
	RZ270: begin
		out <= {inb[23], inb[17:16], inb[20:18], inb[0], inb[3], inb[14:12], inb[15], inb[22:21], inb[9:4], inb[10], inb[2:1], inb[11]};
		zf <= 0;
	end
*/

// Reading order and save reister
	REFERENCE : begin
		case (inb[23:21])
			FIRST: out <= {inb[2:0], 21'b000_000_000_000_000_000_000};
			SECOND: out <= {inb[5:3], 21'b000_000_000_000_000_000_000};
			THIRD: out <= {inb[8:6], 21'b000_000_000_000_000_000_000};
			FOURTH: out <= {inb[11:9], 21'b000_000_000_000_000_000_000};
			FIFTH: out <= {inb[14:12], 21'b000_000_000_000_000_000_000};
			SIXTH: out <= {inb[17:15], 21'b000_000_000_000_000_000_000};
			SEVENTH: out <= {inb[20:18], 21'b000_000_000_000_000_000_000};
		endcase
		zf <= 0;
	end

	ADD : begin
	// increment order digit
		if (ina[20] == ORDER_DIGIT_INC_FLAG) begin
			out <= {ina[23:21], 21'b000_000_000_000_000_000_000}  + inb;
		end else begin
	// increment sequence
			out <= {3'b000, inb[20:0]} + { 21'b000_000_000_000_000_000_000, ina[23:21]};
		end
		zf <= 0;
	end

// check 3bit
	CHECK : begin
		zf <= (ina[23:21] == inb[23:21]) ? 1 : 0;
	end

	COMP : begin
		zf <= (ina == inb) ? 1 : 0;
	end

	COPY : begin
		if (ina[23] == INIT_ROTATION_FLAG) begin
			out <= {4'b0000, inb[20:0]};
		end else begin
			out <= inb;
		end
		zf <= 0;
	end

	STORE : begin
		out <= ina;
		zf <= 0;
	end

	

	endcase
end

endmodule



