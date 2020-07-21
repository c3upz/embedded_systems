//Chris Gerbino
//Oct 23 2019


.syntax unified
.cpu cortex-m4
.text

.global MxPlusB
.thumb_func

//int32_t MxPlusB(int32_t x, int32_t mtop, int32_t mbtm, int32_t b);


MxPlusB:
    //y = mx+b... compute and return the value of y
    //m = mtop/mbtm

    //Using the following 2 equations: 
    //1. rounding = (((( (dvnd*dvsr) >> 31) * dvsr) << 1) + dvsr) / 2 --(mtop = dvnd & mbtm = dvsr)
    //2. quotient = (dvnd + rounding) / dvsr
    
    SMMUL R0, R0, R1
    LDR R1, mbtm
    SMMUL R2, R0, R1 //new mtop
    ASR R2, R2, 31
    SMMUL R2, R1, R2 
    LSL R2, R2, 1
    ADD R2, R2, R1
    LDR R4, 2;
    SDIV R2, R2, R4;
    //Now doing quotient
    ADD R2, R2, R0
    SDIV R2, R2, R0
    ADD R3, R2, R3

    BX LR
    .end