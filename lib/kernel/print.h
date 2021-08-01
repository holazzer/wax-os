#ifndef __LIB_KERNEL_PRINT_H
#define __LIB_KERNEL_PRINT_H
#include "stdint.h"
void put_char(uint8_t char_asci);
void my_set_cursor(uint32_t location); /* location range: [0, 1999] */
#endif
