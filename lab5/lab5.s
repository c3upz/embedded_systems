//COEN20 - Lab5 (week 6)
//ChrisGerbino
//Oct 30, 2019

.syntax unified
.cpu cortex-m4
.text
//void WritePixel(int x, int y, uint8_t colorIndex, uint8_t frameBuffer[256][240]) ;
.global WritePixel
.thumb_func
WritePixel:
    PUSH {R4}
    LDR R4,=240 //length of array
    MUL R1,R1,R4 // R1 = 240 * y , NOTE: this gets you to the correct row val in the array... now we need to find correct column
    ADD R1,R1,R0 // R1 = (R1) + x == (240 * y) + x , NOTE: this finds the correct column
    ADD R1,R3,R1 // R1 == (240 * y) + x + framerBuffer , NOTE: R1 now contains the address of frameBuffer[y][x]
                 // The line above adds the original address of the array and the increment we need to get to the storing address
    STRB R2,[R1] //store
    POP {R4}
	BX LR

//uint8_t *BitmapAddress(char ascii, uint8_t *fontTable, int height, int width) ;
.global BitmapAddress
.thumb_func
BitmapAddress:
    PUSH {R4}
    LDR R4,=8
    ADD R3,R3,7 
    UDIV R3,R3,R4 //n  (= # bytes per row) == R3
    MUL R2,R3,R2 //height * n (this gives the total # of bytes in Bitmap)
    SUB R0,R0,' '  //finding to displacement, NOTE: This is find the amount the fontTable pointer should move
    MLA R0,R2,R0,R1 //([displacement] x [total # of bytes in bit map]) + fontTable , NOTE: this will calculate the final address and put it in R0
    POP {R4}
	BX LR

//uint32_t GetBitmapRow(uint8_t *rowAdrs) ;
.global GetBitmapRow
.thumb_func
GetBitmapRow:
    LDR R1,[R0]
    REV R0,R1 //changing endianness
    BX LR
