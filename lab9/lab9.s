.syntax unified
.cpu cortex-m4
.text

.global Discriminant
.thumb_func
Discriminant:
VMUL.F32 S1,S1,S1 //S1 = b*b
VMOV S3,4.0 //R2 = 4.0
VMUL.F32 S3,S3,S0 //4a
VMUL.F32 S3,S3,S2    //S1 = 4ac
VSUB.F32 S0,S1,S3 //b^2-4ac
BX LR

.global Root2
.thumb_func
Root2: //minus
PUSH {R4-R5,LR} //Preserve R4,R5,L4
VMOV R4,S0 //Save S0 = a
VMOV R5,S1 //Save S1 = b
BL Discriminant//S0 = b*b-4ac
VSQRT.F32 S0,S0 //S0 = sqrt(b*b-4ac)
VMOV S1,R5 //S1 = b
VNEG.F32 S1,S1 //S1 = -b
VSUB.F32 S1,S1,S0 //S1 = -b-sqrt(b*b-4ac)
VMOV S0,R4 //S0 = a
VMOV S2,2.0 //S2 = 2.0
VMUL.F32 S0,S0,S2 //S0 = 2a
VDIV.F32 S0,S1,S0 //S0 = (-b-sqrt(b*b-4ac))/2a
POP {R4-R5,PC}

.global Root1
.thumb_func
Root1: //plus
PUSH {R4-R5,LR} //Preserve R4,R5,L4
VMOV R4,S0 //Save S0 = a
VMOV R5,S1 //Save S1 = b
BL Discriminant//S0 = b*b-4ac
VSQRT.F32 S0,S0 //S0 = sqrt(b*b-4ac)
VMOV S1,R5 //S1 = b
VNEG.F32 S1,S1 //S1 = -b
VADD.F32 S1,S1,S0 //S1 = -b+sqrt(b*b-4ac)
VMOV S0,R4 //S0 = a
VMOV S2,2.0 //S2 = 2.0
VMUL.F32 S0,S0,S2 //S0 = 2a
VDIV.F32 S0,S1,S0 //S0 = (-b+sqrt(b*b-4ac))/2a
POP {R4-R5,PC}

.global Quadratic
.thumb_func
Quadratic:
VMUL.F32 S4,S0,S0 //S4 = x^2
VMUL.F32 S1,S1,S4 //S1 = ax^2
VMUL.F32 S2,S2,S0 //S2 = bx
VADD.F32 S0,S1,S2 //S0 = ax^2+bx
VADD.F32 S0,S0,S3 //S0 = ax^2+bx+c
BX LR