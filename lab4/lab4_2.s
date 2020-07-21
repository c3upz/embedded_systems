.syntax unified
.cpu cortex-m4
.text


//float Root1(float a, float b, float c) ;
//                S0      S1      S2
//This func computes the (-b +) part of quadratic equation
.global Root1
.thumb_func
Root1: 
PUSH {LR, R4-R5}    
VMOV R4,S0          //R4 = S0 = A ... preserving A in R4 bc we call discriminate later
//VMOV R5,S1        //R5 = S1 = B ... preserving B in R5
BL Discriminant     //Calling Discriminant ... S0 = (B^2) - (4AC)
VSQRT.F32 S0,S0     //S0 = sqrt[(B^2) - (4AC)]
//VMOV S1, R4   
VNEG.F32 S1,S1      //S1 = -B ... calc neg version
VADD.F32 S1,S1,S0   //S1 = -B + sqrt[(B^2) - (4AC)]
VMOV S0,R4          //S0 = A ... restoring saved value
VMOV S2,2.0         //S2 = 2.0 ... this is a legal value to VMOV
VMUL.F32 S3,S0,S2   //S3 = 2 * A
VDIV.F32 S0,S1,S3   //S0 = (-B + sqrt[(B^2) - (4AC)]) / 2A
POP {PC, R4-R5}

//float Root2(float a, float b, float c) ;
//                S0      S1      S2
//This func computes the (-b -) part of quadratic equation
.global Root2
.thumb_func
Root2:
PUSH {LR, R4-R5} 
VMOV R4,S0 //R4 = S0 = A
//VMOV R5,S1 //R5 = S1 = B
BL Discriminant//S0 = (B^2) - (4AC)
VSQRT.F32 S0,S0 //S0 = sqrt[(B^2) - (4AC)]
//VMOV S1,R5 //S1 = B
VNEG.F32 S1,S1 //S1 = -B
VSUB.F32 S1,S1,S0 //S1 = -B - sqrt[(B^2) - (4AC)]
VMOV S0,R4 //S0 = A
VMOV S2,2.0 //S2 = 2.0 ... legal value for VMOV
VMUL.F32 S0,S0,S2 //S0 = 2 * A
VDIV.F32 S0,S1,S0 //S0 = (-b-sqrt(b*b-4ac))/2a
POP {PC, R4-R5}


//float Quadratic(float x, float a, float b, float c) ;
//                    S0      S1      S2       S3
//Computes the quadratic equation
.global Quadratic
.thumb_func
Quadratic:
VMUL.F32 S2,S2,S0   //S2 = B * X ... first part of equation
VMUL.F32 S0,S0,S0   //S4 = X^2 ... need to store in S4 bc we need to preserve the 
    //VMUL.F32 S1,S1,S0   //S1 = A * (X^2) ... second part of the equation !NOTE: Probably could use VMLA here to reduce clock cycles
    //VADD.F32 S0,S1,S2   //S0 = A(X^2) + (BX)
VMLA.F32 S1,S1,S0,S2 //!NOTE: this line should be able to replace the 2 above
VADD.F32 S0,S0,S3   //S0 = A(X^2) + BX + C ... final equation
BX LR

//float Discriminant(float a, float b, float c) ; done
//                      S0      S1      S2
//Computes the discriminant
.global Discriminant
.thumb_func
Discriminant:
VMOV S3,4.0         //S3 = 4 ... 4 is legal val to VMOV
VMUL.F32 S0,S3,S0   //S3 = 4 * A
VMUL.F32 S0,S0,S2   //S0 = (4A) * C ... second part of the equation
    //VMUL.F32 S1,S1,S1   //S1 = B^2 ... first part of equation
    //VSUB.F32 S0,S1,S0   //S0 = (B^2) - (4AC) ... final equation
VMLS.F32 S1,S1,S1,S0 //!NOTE: this should replace the 2 lines aboce
BX LR               //return