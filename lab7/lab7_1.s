//@ChrisGerbino
//COEN20
//Nov 13, 2019
//Lab 7 (week 8)

.syntax		unified
		.cpu		cortex-m4
		.text

	//functions

		.global		PutNibble
		.thumb_func

	//void PutNibble(void *nibbles, uint32_t which, uint32_t value) ;
	//						R0				R1,			R2 (4bit value, 0-15)
	PutNibble: 
		LSRS	R1,R1,1     //R1 = which / 2, carry set !NOTE: this is calculating correct offset
		LDRB	R3,[R0,R1]  //R3 = value @ (address of first cell + offset to specified cell)
		ITTE	CS 	        //IF - THEN - THEN - ELSE
		ANDCS	R3,R3,0x0F  //IF C = 1: R3 & 00001111 = bbbb, !NOTE C = 1 if we are working with and odd 'which', this means we are only allowing leastSig 4-bits
		LSLCS	R2,R2,4	    //shifting left 4, bc we need to move the number we just filtered into the mostSig 4 bits
		ANDCC	R3,R3,0xF0  //ELSE C = 0, R3 & 11110000, allows leastSeg 4-bits through, !NOTE C = 0 if we are working with a even number
		ORR		R2,R2,R3    // R2 |= R3,
		STRB	R2,[R0,R1]  //store value in 8-bits of memoryd
		BX		LR          //not sure if i need to return here
		



		.global		GetNibble
		.thumb_func
	//uint32_t GetNibble(void *nibbles, uint32_t which) ;
	//							R0,				R1
	GetNibble: 
		LSRS	R1,R1,1     //R1 = which / 2, carry set !NOTE: which / 2 finds the correct address
		LDRB 	R3,[R0,R1] 	//R3 = value @ (address of first cell + offset to specified cell)
		ITE		CS 			//IF - THEN - ELSE
		LSRCS	R3,R3,4 	//IF C = 1: R3 = R3/16, 
		ANDCC	R3,R3,0x0F 	//R3 &= 00001111, allows leastSig 4-bits through
		MOV		R0,R3       //Move contents of R3 into R0 before returning
        BX      LR