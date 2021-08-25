#include "print.h"
#include "init.h"

// void main() __attribute__((section(".text.__at_0x0")));

void main(){
    my_set_cursor(80*5);        // call .+1668 (0xc0001bab)
    put_str("I am kernel\n");   // call .+1620 (0xc0001b8d)
    init_all();                 // call .+7    (0xc0001548)
    asm volatile ("sti");       // 开中断
    while(1);
}

