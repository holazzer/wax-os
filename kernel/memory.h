#ifndef __KERNEL_MEMORY_H
#define __KERNEL_MEMORY_H
#include "stdint.h"
#include "bitmap.h"

struct virtual_addr {
    struct bitmap vaddr_bitmap;
    uint32_t vaddr_start;       // 虚拟地址起始地址 
};

extern struct pool kernel_pool, user_pool;

void mem_init();

#endif
