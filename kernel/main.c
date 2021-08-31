#include "print.h"
#include "init.h"
#include "debug.h"

int main() {
   my_set_cursor(400);
   put_str("I am kernel\n");
   init_all();
   ASSERT(1==2);
   // asm volatile("sti");	     // 为演示中断处理,在此临时开中断
   while(1);
}
