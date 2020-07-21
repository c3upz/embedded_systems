
		//@ChrisGerbino
		//COEN20 lab 8
		//Nov 19, 2019
		
		.syntax		unified
		.cpu		cortex-m4
		.text

		//	k = day of the month
		//	m = month number, Feb = 12 therefore march = 1
		//	D = last 2 digits of year
		//	C = century or the first 2 digits in the year

		//	Result: 0 = sunday, 1 = monday, etc...

		//uint32_t Zeller1(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;
		//can contain anything
		.global		Zeller1
		.thumb_func
		Zeller1:
		PUSH	{R4,R5}		
		MOV		R4,13 		//eq const
		MUL		R1,R4,R1	//R1 = 13m
		SUB		R1,R1,1		//R1 = 13m - 1
		MOV		R4,5		//eq const 
		UDIV	R1,R1,R4	//unsigned division... R1 = (13m-1)/5
		ADD		R0,R0,R1	//R0 = [(13m-1)/5] + k
		ADD		R0,R0,R2	//R0 = [(13m-1)/5] + k + D
		MOV		R4,4		//eq const
		UDIV	R2,R2,R4	//R2 = D/4
		ADD		R0,R0,R2	//R0 = [(13m-1)/5] + k + D + D/4
		UDIV	R5,R3,R4	//R5 = C/4
		ADD		R0,R0,R5	//R0 = [(13m-1)/5] + k + D + D/4 + C/4
		MOV		R4,2		//eq const
		MUL		R3,R3,R4	//R3 = 2*C
		SUB		R0,R0,R3	//R0 = [(13m-1)/5] + k + D + D/4 + C/4 - 2C ... !NOTE: the full eq result of 'f' is now in R0
		MOV 	R4,7		//need to div by 7 to find day of the week
		SDIV	R1,R0,R4	//signed division... R1 = f / 7 !NOW working on remainder
		MUL 	R2,R1,R4	//R2 = 7 * f/7, this is basically equal to 'f - remainder'
		SUB		R0,R0,R2	//R0 = f - (7 * f/7) !NOTE: this is our remainder ... i think i could combine this with  the instruction above and use something like MULS
		MOV		R4,0		
		CMP		R0,R4		//is f - (7 * f/7) < 0? Is the remainder neg? If yes then add 7
		IT		LT			
		ADDLT	R0,R0,7		//yes: R0 = R0 + 7
		POP		{R4,R5}		//else don't do anything
		BX		LR
		
		//uint32_t Zeller2(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;
		//cannot contain SDIV or UDIV
		.global		Zeller2
		.thumb_func
		Zeller2:
		PUSH	{R4,R5}		
		MOV		R4,13			//eq const
		MUL		R1,R4,R1		//R1 = 13m
		SUB		R1,R1,1			//R1 = 13m - 1
		LDR		R4,=0x33333333	//2^32 / 5 ... this number preps for division by 5
		UMULL	R5,R4,R1,R4 	//unsigned mult... 64 bit product stored in R4.R5... R4.R5 = (13m-1)/5
		ADD		R0,R4,R0		//adding MSH and k
		ADD		R0,R2,R0		//R0 = 	k + (13m-1)/5
		ASR		R2,R2,2			//R2 = D/4
		ADD		R0,R0,R2		//R0 = k + (13m-1)/5 + D/4 
		ASR		R5,R3,2			//R5 = C / 4 ... storing in R5 bc I need C later
		ADD		R0,R0,R5		//R0 = k + (13m-1)/5 + D/4 + C/4
		MOV		R4,2			//eq const
		MUL		R3,R3,R4		//R3 = 2c
		SUB		R0,R0,R3		//R0 = k + (13m-1)/5 + D/4 + C/4 - 2C ... this is final result of f
		LDR		R5,=0x24924925  //2^32 / 7 ... this number preps for division by 7 
		SMULL	R1,R5,R0,R5		//signed mult... R5.R1 storing result of f * 
		MOV 	R4,7			//const
		MUL 	R2,R5,R4		//R2 = 7 * MSH of result
		SUB		R0,R0,R2		//R0 = remainder
		MOV		R4,0			//moving for comparison	
		CMP		R0,R4			//is remainder < 0? 
		IT		LT				
		ADDLT	R0,R0,7			//yes: add 7
		POP		{R4,R5}			//no: do nothing 
		BX		LR

		//uint32_t Zeller3(uint32_t k, uint32_t m, uint32_t D, uint32_t C) ;
		//cannot contain MUL, MLS, etc...
		//try to use shifts to multiply.. may have to use a combination of multiple shifts to get desired effects
		.global		Zeller3
		.thumb_func
		Zeller3:
		PUSH	{R4,R5}		
		LSLS	R4,R1,4			//R4 = 'm' shifted left 4 bits... R4 = 16m //may need .n
		RSB 	R1,R1,R1,LSL 2  //R1 = 4m - m = 3m
		SUB 	R1,R4,R1 		//R1 = 16m - 3m = 13m
		SUB		R1,R1,1			//R1 = 13m - 1
		MOV		R4,5			//eq const
		UDIV	R1,R1,R4		//unsigned division... R1 = (13m - 1) / 5
		ADD		R0,R0,R1		//R0 = k + (13m - 1) / 5
		ADD		R0,R0,R2		//R0 =  + (13m - 1) / 5 + D 
		MOV		R4,4			//eq const
		UDIV	R2,R2,R4		//unsigned division... D / 4
		ADD		R0,R0,R2		//R0 = k + (13m - 1) / 5 + D + D/4
		UDIV	R5,R3,R4		//unsigned division... R5 = C /4
		ADD		R0,R0,R5		//R0 = k + (13m - 1) / 5 + D + D/4 + C/4
		LSL		R3,R3,1			//R3 = 2C
		SUB		R0,R0,R3		//R0 = k + (13m - 1) / 5 + D + D/4 + C/4 - 2C !NOTE: this is final result of f
		MOV		R4,7			//const
		SDIV	R1,R0,R4		//signed division... R1 = f / 7
		LSLS	R4,R1,3			//R4 = (f / 7) * 8  //may need .n	
		SUB		R2,R4,R1		//R2 = [(f / 7) * 8] - (f / 7)
		SUB		R0,R0,R2		//R0 = f - [(f / 7) * 8] - (f / 7) !NOTE: this is number for the remainder
		MOV		R4,0			//need for comparison
		CMP		R0,R4			//Is the result < 0? 
		IT		LT			
		ADDLT	R0,R0,7			//YES: remainder is negative
		POP		{R4,R5}			//NO: do nothing
		BX		LR