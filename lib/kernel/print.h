#ifndef __LIB_KERNEL_PRINT_H
#define __LIB_KERNEL_PRINT_H
#include "stdint.h"
void put_char(uint8_t char_asci);
void my_set_cursor(uint32_t location); /* location range: [0, 1999] */
void put_str(char* str); /* str ends with '\0' */
void put_int(uint32_t num); /* print hex int */
#endif
