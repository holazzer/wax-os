#ifndef __KERNEL_MEMORY_H
#define __KERNEL_MEMORY_H
#include "stdint.h"
#include "bitmap.h"

enum pool_flags { PF_KERNEL = 1, PF_USER = 2 } ;

#define PG_P_1 1   // page present 
#define PG_P_0 0  
#define PG_RW_R 0  // page read/execute 
#define PG_RW_W 2  // page read/write/execute
#define PG_US_S 0  // User 
#define PG_US_U 4  // System


struct virtual_addr {
    struct bitmap vaddr_bitmap;
    uint32_t vaddr_start;       // 虚拟地址起始地址 
};

extern struct pool kernel_pool, user_pool;

void mem_init();
void* get_kernel_pages(uint32_t pg_cnt);

#endif
