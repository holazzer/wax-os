#include "bitmap.h"
#include "stdint.h"
#include "string.h"
#include "print.h"
#include "interrupt.h"
#include "debug.h"

void bitmap_init(struct bitmap* btmp){
    memset(btmp->bits, 0, btmp->bitmap_bytes_len);
}

// returns btmp[bit_idx] == 1
bool bitmap_scan_test(struct bitmap* btmp, uint32_t bit_idx){
    uint32_t byte_idx = bit_idx / 8;
    uint32_t bit_odd = bit_idx % 8;
    return btmp->bits[byte_idx] & (BIT_MASK << bit_odd);
}

// allocate bits of amount 'cnt' and return index, or -1 if failed 
int bitmap_scan(struct bitmap* btmp, uint32_t cnt){
    uint32_t idx_byte = 0;
    while( (0xff == btmp->bits[idx_byte]) && (idx_byte < btmp->bitmap_bytes_len) ) { ++idx_byte;} // 找到第一个不满的字节
    ASSERT(idx_byte < btmp->bitmap_bytes_len);
    if(idx_byte == btmp->bitmap_bytes_len){ return -1; } // 全部都满了

    uint32_t idx_bit = 0;
    while( (uint8_t)(BIT_MASK << idx_bit ) & btmp->bits[idx_byte] ){ ++idx_bit; } // 找到第一个空的bit
    
    uint32_t bit_idx_start = idx_byte * 8 + idx_bit;
    if(cnt == 1){ return bit_idx_start; }   // 如果只需要一个bit，直接返回此位

    uint32_t bit_left = btmp->bitmap_bytes_len * 8 - bit_idx_start;
    uint32_t next_bit = bit_idx_start + 1;
    uint32_t count = 0; // 找到的连续空位数
    bit_idx_start = -1;
    while(bit_left-->0){
        if(!bitmap_scan_test(btmp, next_bit)){ ++count; } else{ count = 0; }
        if(count == cnt){ bit_idx_start = next_bit - cnt + 1; break; }  // 找到第一个连续的空位，分配此连续空间
        ++next_bit;
    }
    return bit_idx_start;
}

void bitmap_set(struct bitmap* btmp, uint32_t bit_idx, int8_t value){
    ASSERT( (value == 0) || (value == 1));
    uint32_t byte_idx = bit_idx / 8;
    uint32_t bit_odd = bit_idx % 8;
    if(value){ btmp->bits[byte_idx] |= (BIT_MASK << bit_odd); }  // 此位置1
    else { btmp->bits[byte_idx] &= ~(BIT_MASK << bit_odd); }     // 取反后其他位是1，这一位是0，做与操作后，1的位不变，0的位变0
}



