.syntax unified
.cpu cortex-m4
.text

.global MatrixMultiply
.thumb_func



MatrixMultiply:

    PUSH {LR, R4-R12}
    MOV R8,R0 //moving A... A = R8 (preserving)
    MOV R9,R1  //moving B... A = R9 (preserving)
    MOV R10,R2 //moving C... A = R10 (preserving)

    LDR R4,=0 // first loop 
    LDR R5,=0 // second loop 
    LDR R6,=0 // third loop 
    LDR R7,=3 //constant... need this to find offset 

    LDR R11, =0 //temp reg
    LDR R12,=0 //temp reg
    
    B ROW//Calling first for loop


    IncrementFirstLoop: //increment then run row again
        ADD R4,R4,1 //incrementing row count
        LDR R5,=0
        B ROW

        ROW: //Row
        CMP R4,3 //running 3 times
        BGE done //if row isnt between 0 and 2 then we are done
        B COL //if we arnt done, then row is between 0 and 2

    IncrementSecondLoop: //increment then run col again
        ADD R5,1 //incrementing column count
        LDR R6,=0
        B COL

        COL: //Column
        CMP R5,3 //running 3 times
        BGE IncrementFirstLoop //go back up in for loop heirarchy if COL isnt between 0 and 2
        MUL R0,R7,R5 // R0 = (# of rows) * 3
        ADD R0,R0,R5 // adding col offset
        LSL R0,R0,2  //shifting
        ADD R0,R8,R0 //(address of A) + offset
        STR R12,[R0] // storing 0 into the (address of A + offset)
        MOV R11,R0 //saving R0 to R11 to preserve
        B K //now need to call K func


    K: //K
        CMP R6,3 //iterating 3 times 
        BGE IncrementSecondLoop //go back up in for loop heirarchy if K isnt between 0 and 2

        LDR R0,[R11] //address of R11 into R0
        MUL R1,R7,R5 //R1 = 3 * #ofRows
        ADD R1,R1,R6//R1 = R1 + k value
        LSL R1,R1,2 
        ADD R1,R9,R1 //(address of B) + R1
        LDR R1,[R1] //Loading address of R1 into R1
        MUL R2,R7,R6 //3 * k ... k value will vary depending on the amount of iterations
        ADD R2,R2,R5 //R2 + #ofCol
        LSL R2,R2,2 
        ADD R2,R10,R2 //(address of C) + offset
        LDR R2,[R2] //(address of R2) = R2
        BL MultAndAdd //caling function... result will be stored in R0
        STR R0,[R11] //store val of R0 into address in R11
        ADD R6,1 //incrementing k
        B K

done:   POP {PC, R4-R12}

