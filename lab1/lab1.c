//Christopher Gerbino
//Oct 2, 2019
//convert.c

#include <stdint.h>

uint32_t Bits2Unsigned(int8_t bits[8]){ //convert an array of bits to unsigned integer
    uint32_t num = 0;
    int i = 8;
    
    for(i = 8; i>0; i--){
        num = ((2*num) + bits[i-1]);
    }
    
    return num;

}

int32_t Bits2Signed(int8_t bits[8]){ //convert an array of bits to signed integers
    uint32_t num = Bits2Unsigned(bits); //uint bc value is assigned by uint function
    
    if(num > 127){ //here num is an unsigned int -- we only want to convert it if it is bigger than 127 which half of 255
        num = num - 256;
    }

    return num;
}

void Increment(int8_t bits[8]){ //add 1 to the # --- (# will be in bits)
    int i = 0;
    int cIn = 1;

    for(i = 0; i < 9; i++){ //for will traverse the whole array of bits
        if(cIn && bits[i]){ //for each bit there will be 2 cases we need to check for
            bits[i] = 0; 		//1. Carryin = 1 and the bit[i] = 1 --> this will lead to the outputted bit being 0
            //cIn stays 1 here
        }else if(!bits[i] && cIn){ //2. carryin = 1 and the bit[i] = 0 --> this will lead to the outputted bit being 1 and the carryIn to be flipped to 0;
            bits[i] = 1;
            cIn = 0;
        }							
    }


}

void Unsigned2Bits(uint32_t n, int8_t bits[8]){ //convert unsigned integers to an array of bits
    int i = 0;
    for(i = 0; i < 8; i++){
        bits[i] = n%2; //here i am using mod to find whether the bit[i] should be a 1 or 0
    	n=n/2; 
     }
  
}