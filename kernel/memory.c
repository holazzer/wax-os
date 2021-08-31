#include "memory.h"
#include "stdint.h"
#include "print.h"

#define PG_SIZE 4096

#define MEM_BITMAP_BASE 0xc009a000
/*  0xc009f000 内核主线程栈顶
    0xc000e000 内核主线程pcb
    0xc000a000 -> e000 有16KB空间
    一个页框表示 128MB 的地址空间，需要 128MB / 4KB = 32Kb = 4 KB 的数组
    16KB 空间可以放4个页框，有512MB的空间。  */

#define K_HEAP_START 0xc0100000
/*  内核空间从3GB开始，即0xc0000000
    [?] 0x100000 指 跨过低端 1MB，是虚拟地址在逻辑上连续 [???]  */

struct pool {
    struct bitmap pool_bitmap;
    uint32_t phy_addr_start;
    uint32_t pool_size;
};

struct pool kernel_pool, user_pool;
struct virtual_addr kernel_addr;

static void mem_pool_init(uint32_t all_mem){
    put_str("  mem_pool_init start\n");
    uint32_t page_table_size = PG_SIZE * 256;
    
}







