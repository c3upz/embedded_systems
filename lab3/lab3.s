#@Chris-Gerbino
#Oct.16 2019
#lab3funcs.s
    #lab is mostly focused on copying data. We will copy diff sizes of data each time

    .syntax unified
    .cpu cortex-m4
    .text

    .global UseLDRB
    .thumb_func
    #void UseLDRB(void *dst, void *src);
    UseLDRB:
        .REPT 512
            LDRB R2, [R1],1 //incrementing R1 by 1 
            STRB R2, [R0],1 //incrementing R0 by 1
        .ENDR
        BX  LR
    .global UseLDRH
    .thumb_func
    #void UseLDRH(void *dst, void *src);
    UseLDRH:
        .REPT 256 // 512/2
            LDRH R2, [R1],2 //incrementing R1 by 2 
            STRH R2, [R0],2 //incrementing R0 by 2
        .ENDR
        BX  LR

    .global UseLDR
    .thumb_func
    #void UseLDR(void *dst, void *src);
    UseLDR:
        .REPT 128 // 512/4
            LDR R2, [R1],4 //incrementing R1 by 4 
            STR R2, [R0],4 //incrementing R0 by 4
        .ENDR
        BX  LR

    .global UseLDRD
    .thumb_func
    #void UseLDRD(void *dst, void *src);
    UseLDRD:
        .REPT 64 // 512/8
            LDRD R3,R2, [R1],8 //incrementing R1 by 8 
            STRD R3,R2, [R0],8 //incrementing R0 by 8
        .ENDR
        BX  LR


    .global UseLDM
    .thumb_func
    #void UseLDM(void *dst, void *src);
    UseLDM:
        PUSH {R4-R9}
        .REPT 16 // 4byte(word) * 8 registers * 16 repeats = 512 bytes
            LDMIA R1!, {R2-R9} // loading to 8 reg
            STMIA R0!, {R2-R9} // loading from reg to mem
        .ENDR
        POP {R4-R9}
        BX  LR

    .end
