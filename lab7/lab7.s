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
		LSRS	R1,R1,1 //right shift 'which' 1 bit (which / 2), set carry
		LDRB	R3,[R0,R1] //loading 'nibbles' w/ offset 'which' into R3, !R3 is used as a way to test storing location
		ITTE	CS 			//if - then - then - else
		ANDCS	R3,R3,0x0F //if carry set: [R3(address) = 01111 & R3(address) == 0bbbb] !This filters 4 bit value of R3 through (only #'s 0-15 allowed')
		LSLCS	R2,R2,4	//if carry set: [R2 = 16R2] !clears R2 of its 4 bit  value... now R2 = 0000
		ANDCC	R3,R3,0xF0 //else (carry clear): [R3 = 11110000 & R3 == bbbb0000] !This essentially clears and sets all  bits to 0 (R3)
		ORR		R2,R2,R3 //R2 = R2 OR address
		STRB	R2,[R0,R1]  //R0(w/ offset R1) = contents of 'value'
		BX		LR //can return bc value is now stored in 'nibbles'
		//not sure if I need this return



		.global		GetNibble
		.thumb_func
	//uint32_t GetNibble(void *nibbles, uint32_t which) ;
	//							R0,				R1
	GetNibble: 
		LSRS	R1,R1,1 //right shift 'which' 1 bit (which / 2), set carry
		LDRB 	R3,[R0,R1] 	//R3 = 'nibbles' w/ offset 'which' = address !memory address we want to access is loaded into R2, !NOTE: we can use R2 bc no value parameter
		ITE		CS 			//if - then - else
		LSRCS	R3,R3,4 	//if carry is set: shift right !This just fills R3 with 0s
		ANDCC	R3,R3,0x0F 	//else carry is clear, R3 = address & 01111 ==	  0bbbb
		MOV		R0,R3 	//move the contents of R3 into R0 before branching 
		BX		LR	//return contents of R0