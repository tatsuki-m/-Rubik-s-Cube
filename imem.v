module imem(pc, op);
	input wire [7:0] pc;
	output reg [15:0] op;

`include "def.h"
`include "rotation.h"
`include "register.h"
`include "order_digit_title.h"

parameter INIT_ROTATION_FLAG = 1'b1,
		// separate function in ADD
		  ORDER_DIGIT_INC_FLAG	 = 1'b1,
		  SEQUENCE_INC_FLAG		 = 1'b0;

parameter [2:0]	INC_NUM = 3'b001;

// mem addr
parameter [3:0]	BLUE_MEM_ADDR	= 4'b0000,
				WHITE_MEM_ADDR	= 4'b0001,
				RED_MEM_ADDR	= 4'b0010,
				ORDER1_MEM_ADDR = 4'b0011,
				ORDER2_MEM_ADDR = 4'b0100;

// define order num
parameter [7:0] TO_INIT 		  = 0,
				TO_READING_ORDER  = 4,
				TO_MAKE_SEQUENCE  = 9,
				TO_CHECK_ROTATION = 12,
				TO_RX90			  = 28,
				TO_RX180		  = 32,
				TO_RX270		  = 36,
				TO_RY90			  = 40,
				TO_RY180		  = 44,
				TO_RY270		  = 48,
				TO_RZ90			  = 52,
				TO_RZ180		  = 56,
				TO_BLUE_CHECK	  = 60,
				TO_WHITE_CHECK	  = 63,
				TO_RED_CHECK	  = 66,
				TO_OVERWRITE_STATE = 69,
				TO_FIN			   = 77,
				TO_INIT_2		  = 78,
				TO_SWITCH_BY_ORDER2 = 82,
				TO_GO_STAGE_2	  = 89,
				TO_RETURN_STAGE_1 = 94;
				

always @(pc) begin
	case (pc)
// copy i.c state to tmp register
	0: begin
		op[15:12]	<= COPY;
		op[11:8]	<= TMP_BLUE_ADDR;
		op[7:4]		<= BLUE_ADDR;
		op[3:0]		<= 4'bx;
	end

	1: begin
		op[15:12]	<= COPY;
		op[11:8]	<= TMP_WHITE_ADDR;
		op[7:4]		<= WHITE_ADDR;
		op[3:0]		<= 4'bx;
	end

	2: begin
		op[15:12]	<= COPY;
		op[11:8]	<= TMP_RED_ADDR;
		op[7:4]		<= RED_ADDR;
		op[3:0]		<= 4'bx;
	end

// check all the surface
	3: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_BLUE_CHECK;
	end

// ===================================
// ========== Reading order ==========
// ===================================

// ===== check 1st order =====
	4: begin
		op[15:12]	<= CHECK;
		op[11:8]    <= ORDER1_ADDR;
		op[7:0]		<= {SEVENTH, 5'b00000};
	end

	5: begin
		op[15:12]	<= JNZ;
		op[11:8] 	<= 4'bx;
		op[7:0]		<= TO_SWITCH_BY_ORDER2; 
	end

// save an order(3bit)
	6: begin
		op[15:12] <= REFERENCE;
		op[11:8]  <= TMP_ORDER_ADDR;
		op[7:4]   <= ORDER1_ADDR;
		op[3:0]   <= 4'bx;
	end

	7: begin
		op[15:12] <= ADD;
		op[11:8]  <= ORDER1_ADDR;
		op[7:4]   <= ORDER1_ADDR;
		op[3:0]   <= {INC_NUM, ORDER_DIGIT_INC_FLAG};
	end

	8: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_CHECK_ROTATION;
	end

/*
// ===== ckeck 2nd order =====
	9: begin
		op[15:12]	<= CHECK;
		op[11:8]	<= ORDER2_ADDR;
		op[7:0]		<= 8'b0101_0000;
	end

	10: begin
		op[15:12]	<= JNZ;
		op[11:8]	<= 0;  // DC
		op[7:0]		<= // To make sequence
	end

// save an order(4bit)
	8: begin
		op[15:12]	<= REFERENCE;
		op[11:8]	<= ORDER2_ADDR;
		op[7:4]		<= TMP_ORDER_ADDR;
		op[3:0]		<= 0;	// DC
	end

	9: begin
		op[15:12] <= ADD;
		op[11:8]  <= ORDER2_ADDR;
		op[7:4]	  <= ORDER2_ADDR;
		op[3:0]	  <= 4'b0001;	// incremental num 
	end

	10: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 0;	// DC
		op[7:0]		<= // TO check rotation
	end
*/

// ===================================
// ========== Make sequence ==========
// ===================================
// increment order
	9: begin
		op[15:12]	<= ADD;
		op[11:8]	<= ORDER1_ADDR;
		op[7:4]		<= ORDER1_ADDR;
		op[3:0]		<= {INC_NUM, SEQUENCE_INC_FLAG};
	end

// initialize ROTATION_FLAG
	10 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= ORDER1_ADDR;
		op[7:4]		<= ORDER1_ADDR;
		op[3:0]		<= {INIT_ROTATION_FLAG, 3'b000};
	end

	11	: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_INIT;
	end

// =====================================
// ========== Check rotation ===========
// =====================================

// X90
	12: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {X90, 5'b00000};
	end

	13: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 4'bx;
		op[7:0]    <= TO_RX90;
	end

// X180
	14: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {X180, 5'b00000};
	end

	15: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 4'bx; 
		op[7:0]    <= TO_RX180;
	end


// X270
	16: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {X270, 5'b00000};
	end

	17: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 4'bx;
		op[7:0]    <= TO_RX270;
	end

// Y90
	18: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {Y90, 5'b00000};
	end

	19: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 4'bx;
		op[7:0]    <= TO_RY90;
	end

// Y180
	20: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {Y180, 5'b00000};
	end

	21: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 4'bx;
		op[7:0]    <= TO_RY180;
	end

// Y270
	22: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {Y270, 5'b00000};
	end

	23: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 4'bx;
		op[7:0]    <= TO_RY270;
	end

// Z90
	24: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {Z90, 5'b00000};
	end

	25: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 4'bx;
		op[7:0]    <= TO_RZ90;
	end

// Z180
	26: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {Z180, 5'b00000};
	end

	27: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 4'bx;
		op[7:0]    <= TO_RZ180;
	end

/*
// Z270
	27: begin
		op[15:12]  <= CHECK;
		op[11:8]   <= TMP_ORDER_ADDR;
		op[7:0]    <= {Z270, 4'b0000};
	end

	28: begin
		op[15:12]  <= JNZ;
		op[11:8]   <= 0; //DC
		op[7:0]    <= // T0 Z270
	end
*/


// ==============================
// ========== Rotation ==========
// ==============================

// X90
	28: begin
		op[15:12] <= RX90;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx;
	end

	29 : begin
		op[15:12] <= RX90;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx;
	end

	30 : begin
		op[15:12] <= RX90;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
		op[3:0]	  <= 4'bx;
	end

	31 : begin
		op[15:12] <= JMP;
		op[11:8]  <= 4'bx;
		op[7:0]   <= TO_BLUE_CHECK;
	end


// X180
	32: begin
		op[15:12] <= RX180;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx;
	end

	33 : begin
		op[15:12] <= RX180;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx;
	end

	34 : begin
		op[15:12] <= RX180;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
		op[3:0]	  <= 4'bx;
	end

	35 : begin
		op[15:12] <= JMP;
		op[11:8]  <= 4'bx;
		op[7:0]   <= TO_BLUE_CHECK;
	end

// X270
	36: begin
		op[15:12] <= RX270;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx;
	end

	37 : begin
		op[15:12] <= RX270;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx;
	end

	38 : begin
		op[15:12] <= RX270;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
		op[3:0]	  <= 4'bx;
	end

	39 : begin
		op[15:12] <= JMP;
		op[11:8]  <= 4'bx;
		op[7:0]   <= TO_BLUE_CHECK;
	end

// Y90
	40: begin
		op[15:12] <= RY90;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx;
	end

	41 : begin
		op[15:12] <= RY90;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx;
	end

	42 : begin
		op[15:12] <= RY90;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
		op[3:0]	  <= 4'bx;
	end

	43 : begin
		op[15:12] <= JMP;
		op[11:8]  <= 4'bx;
		op[7:0]   <= TO_BLUE_CHECK;
	end

// Y180
	44: begin
		op[15:12] <= RY180;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx;
	end

	45 : begin
		op[15:12] <= RY180;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx;
	end

	46 : begin
		op[15:12] <= RY180;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
		op[3:0]	  <= 4'bx;
	end

	47 : begin
		op[15:12] <= JMP;
		op[11:8]  <= 4'bx;
		op[7:0]   <= TO_BLUE_CHECK;
	end

// Y270
	48: begin
		op[15:12] <= RY270;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx;
	end

	49 : begin
		op[15:12] <= RY270;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx;
	end

	50 : begin
		op[15:12] <= RY270;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
		op[3:0]	  <= 4'bx;
	end

	51 : begin
		op[15:12] <= JMP;
		op[11:8]  <= 4'bx;
		op[7:0]   <= TO_BLUE_CHECK;
	end

// Z90
	52: begin
		op[15:12] <= RZ90;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx;
	end

	53 : begin
		op[15:12] <= RZ90;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx;
	end

	54 : begin
		op[15:12] <= RZ90;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
		op[3:0]	  <= 4'bx;
	end

	55: begin
		op[15:12] <= JMP;
		op[11:8]  <= 4'bx;
		op[7:0]   <= TO_BLUE_CHECK;
	end

// Z180
	56: begin
		op[15:12] <= RZ180;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx;
	end

	57 : begin
		op[15:12] <= RZ180;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx;
	end

	58 : begin
		op[15:12] <= RZ180;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
		op[3:0]	  <= 4'bx;
	end

	59 : begin
		op[15:12] <= JMP;
		op[11:8]  <= 4'bx;
		op[7:0]   <= TO_BLUE_CHECK;
	end

/*
// Z270
	0: begin
		op[15:12] <= RZ270;
		op[11:8]  <= TMP_BLUE_ADDR;
		op[7:4]   <= TMP_BLUE_ADDR;
		op[3:0]   <= 4'bx  //DC
	end

	1 : begin
		op[15:12] <= RZ270;
		op[11:8]  <= TMP_WHITE_ADDR;
		op[7:4]   <= TMP_WHITE_ADDR;
		op[3:0]	  <= 4'bx  // DC
	end

	2 : begin
		op[15:12] <= RZ270;
		op[11:8]  <= TMP_RED_ADDR;
		op[7:4]   <= TMP_RED_ADDR;
r	op[3:0]	  <= 4'bx  // DC
	end

	3 : begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx // DC
		op[3:0]		<= // TO checker
	end
*/ 

// ==============================
// ========== Checker ===========
// ==============================
// blue
	60 : begin
		op[15:12]	<= COMP;
		op[11:8]	<= 4'bx;
		op[7:4]		<= TMP_BLUE_ADDR;
		op[3:0]		<= IDEAL_BLUE_ADDR;
	end

	61 : begin
		op[15:12]	<= JNZ;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_WHITE_CHECK;
	end

	62: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_READING_ORDER;
	end

// white
	63 : begin
		op[15:12]	<= COMP;
		op[11:8]	<= 4'bx;
		op[7:4]		<= TMP_WHITE_ADDR;
		op[3:0]		<= IDEAL_WHITE_ADDR;
	end

	64 : begin
		op[15:12]	<= JNZ;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_RED_CHECK;
	end

	65 : begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_READING_ORDER;
	end

// red
	66 : begin
		op[15:12]	<= COMP;
		op[11:8]	<= 4'bx;
		op[7:4]		<= TMP_RED_ADDR;
		op[3:0]		<= IDEAL_RED_ADDR;
	end

	67 : begin
		op[15:12]	<= JNZ;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_OVERWRITE_STATE;
	end

	68 : begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_READING_ORDER;
	end

// ============================================
// ========== orverwrite color regis ==========
// ============================================
	69 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= BLUE_ADDR;
		op[7:4]		<= TMP_BLUE_ADDR;
		op[3:0]		<= 4'bx;
	end

	70 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= WHITE_ADDR;
		op[7:4]		<= TMP_WHITE_ADDR;
		op[3:0]		<= 4'bx;
	end

	71 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= RED_ADDR;
		op[7:4]		<= TMP_RED_ADDR;
		op[3:0]		<= 4'bx;
	end

// ===========================
// ========== Store ==========
// ===========================
	72 : begin
		op[15:12]	<= STORE;
		op[11:8]	<= BLUE_ADDR;
		op[7:4]		<= BLUE_MEM_ADDR;
		op[3:0]		<= 4'bx;
	end

	73 : begin
		op[15:12]	<= STORE;
		op[11:8]	<= WHITE_ADDR;
		op[7:4]		<= WHITE_MEM_ADDR;
		op[3:0]		<= 4'bx;
	end

	74 : begin
		op[15:12]	<= STORE;
		op[11:8]	<= RED_ADDR;
		op[7:4]		<= RED_MEM_ADDR;
		op[3:0]		<= 4'bx;
	end 

	75 : begin
		op[15:12]	<= STORE;
		op[11:8]	<= ORDER1_ADDR;
		op[7:4]		<= ORDER1_MEM_ADDR;
		op[3:0]		<= 4'bx;
	end 

	76 : begin
		op[15:12]	<= STORE;
		op[11:8]	<= ORDER2_ADDR;
		op[7:4]		<= ORDER2_MEM_ADDR;
		op[3:0]		<= 4'bx;
	end 

	77: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_FIN;
	end

// ============================
// ========== Init 2 ==========
// ============================
	
	78: begin
		op[15:12]	<= COPY;
		op[11:8]	<= TMP_BLUE_ADDR;
		op[7:4]		<= BLUE_ADDR_2;
		op[3:0]		<= 4'bx;
	end

	79: begin
		op[15:12]	<= COPY;
		op[11:8]	<= TMP_WHITE_ADDR;
		op[7:4]		<= WHITE_ADDR_2;
		op[3:0]		<= 4'bx;
	end

	80: begin
		op[15:12]	<= COPY;
		op[11:8]	<= TMP_RED_ADDR;
		op[7:4]		<= RED_ADDR_2;
		op[3:0]		<= 4'bx;
	end

	81: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_READING_ORDER;
	end

// ===========================
// ==== Switch by order2 =====
// ===========================

	82: begin
		op[15:12]	<= CHECK;
		op[11:8]	<= ORDER2_ADDR;
		op[7:0]		<= {8'b0000_0000};
	end

	83: begin
		op[15:12]	<= JNZ;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_GO_STAGE_2;
	end

// =====================================
// ========== Make Sequence 2 ==========
// =====================================

	84: begin
		op[15:12]	<= ADD;
		op[11:8]	<= ORDER1_ADDR;
		op[7:4]		<= ORDER1_ADDR;
		op[3:0]		<= {INC_NUM, SEQUENCE_INC_FLAG};
	end

	85: begin
		op[15:12]	<= CHECK;
		op[11:8]	<= ORDER1_ADDR;
		op[7:0]		<= {8'b0000_0000};
	end

	86: begin
		op[15:12]	<= JNZ;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_RETURN_STAGE_1;
	end
	
	87 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= ORDER1_ADDR;
		op[7:4]		<= ORDER1_ADDR;
		op[3:0]		<= {INIT_ROTATION_FLAG, 3'b000};
	end

	88	: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_INIT_2;
	end

// ================================
// ========== Go Stage 2 ==========
// ================================

	89 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= ORDER2_ADDR;
		op[7:4]		<= ORDER1_ADDR;
		op[3:0]		<= 4'bx;
	end

	90 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= BLUE_ADDR_2;
		op[7:4]		<= TMP_BLUE_ADDR;
		op[3:0]		<= 4'bx;
	end

	91 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= WHITE_ADDR_2;
		op[7:4]		<= TMP_WHITE_ADDR;
		op[3:0]		<= 4'bx;
	end

	92 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= RED_ADDR_2;
		op[7:4]		<= TMP_RED_ADDR;
		op[3:0]		<= 4'bx;
	end

	93	: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_INIT_2;
	end

// ====================================
// ========== Return Stage 1 ==========
// ====================================

	94: begin
		op[15:12]	<= ADD;
		op[11:8]	<= ORDER2_ADDR;
		op[7:4]		<= ORDER2_ADDR;
		op[3:0]		<= {INC_NUM, SEQUENCE_INC_FLAG};
	end

	95 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= ORDER1_ADDR;
		op[7:4]		<= ORDER2_ADDR;
		op[3:0]		<= 4'bx;
	end

	96 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= ORDER1_ADDR;
		op[7:4]		<= ORDER1_ADDR;
		op[3:0]		<= {INIT_ROTATION_FLAG, 3'b000};
	end

	97 : begin
		op[15:12]	<= COPY;
		op[11:8]	<= ORDER2_ADDR;
		op[7:4]		<= ORDER2_ADDR;
		op[3:0]		<= {INIT_ROTATION_FLAG, 3'b000};
	end

	98	: begin
		op[15:12]	<= JMP;
		op[11:8]	<= 4'bx;
		op[7:0]		<= TO_INIT;
	end

	endcase
end 

endmodule

