#include "print.h"
#include "init.h"
#include "debug.h"
#include "memory.h"


int main() {
   my_set_cursor(240);
   put_str("I am kernel\n");
   init_all();
   void* addr = get_kernel_pages(3);
   put_str("\nget_kernel_pages start vaddr: 0x");
   put_int((uint32_t)addr);
   put_str("\n");

   addr = get_kernel_pages(4);
   put_str("get_kernel_pages start vaddr: 0x");
   put_int((uint32_t)addr);
   put_str("\n");

   addr = get_kernel_pages(5);
   put_str("get_kernel_pages start vaddr: 0x");
   put_int((uint32_t)addr);
   put_str("\n");

   while(1);
}
