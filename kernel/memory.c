#include "memory.h"
#include "stdint.h"
#include "print.h"

#define PG_SIZE 4096  // 每页 4KB 

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
struct virtual_addr kernel_vaddr;

static void mem_pool_init(uint32_t all_mem){
    put_str("  mem_pool_init start\n");
    uint32_t page_table_size = PG_SIZE * 256;  // 一共256页 [???]
    uint32_t used_mem = page_table_size + 0x100000;
    uint32_t free_mem = all_mem - used_mem;
    uint16_t all_free_pages = free_mem / PG_SIZE;

    uint16_t kernel_free_pages = all_free_pages / 2;
    uint16_t user_free_pages = all_free_pages - kernel_free_pages;

    uint32_t kbm_length = kernel_free_pages / 8;
    uint32_t ubm_length = user_free_pages   / 8;

    uint32_t kp_start = used_mem;
    uint32_t up_start = kp_start + kernel_free_pages * PG_SIZE;

    kernel_pool.phy_addr_start = kp_start;
    user_pool.phy_addr_start = up_start; 

    kernel_pool.pool_size = kernel_free_pages * PG_SIZE;
    user_pool.pool_size = user_free_pages * PG_SIZE;

    kernel_pool.pool_bitmap.bitmap_bytes_len = kbm_length;
    user_pool.pool_bitmap.bitmap_bytes_len = ubm_length;

    kernel_pool.pool_bitmap.bits = (void*)MEM_BITMAP_BASE;
    user_pool.pool_bitmap.bits = (void*)(MEM_BITMAP_BASE + kbm_length);

    put_str("    krnl_pool_bitmap_start: 0x"); put_int((int)kernel_pool.pool_bitmap.bits); 
    put_str("    krnl_pool_phy_addr_start: 0x"); put_int((int)kernel_pool.phy_addr_start);
    put_str("\n");
    put_str("    user_pool_bitmap_start: 0x"); put_int((int)user_pool.pool_bitmap.bits); 
    put_str("    user_pool_phy_addr_start: 0x"); put_int((int)user_pool.phy_addr_start);
    put_str("\n");

    bitmap_init(&kernel_pool.pool_bitmap);
    bitmap_init(&user_pool.pool_bitmap);

    kernel_vaddr.vaddr_bitmap.bitmap_bytes_len = kbm_length;
    kernel_vaddr.vaddr_bitmap.bits = (void*) (MEM_BITMAP_BASE + kbm_length + ubm_length);

    kernel_vaddr.vaddr_start = K_HEAP_START;
    bitmap_init(&kernel_vaddr.vaddr_bitmap);
    put_str("  mem_pool_init done\n");
}

void mem_init(){
    put_str("mem_init start\n");
    uint32_t mem_bytes_total = (*(uint32_t*)(0xb03));  // 在loader中获取的内存大小，实际上保存在0xb03的位置，因为我在loader开头加了jmp
    mem_pool_init(mem_bytes_total);
    put_str("mem_init done\n");
}







