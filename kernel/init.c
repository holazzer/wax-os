#include "init.h"
#include "print.h"
#include "interrupt.h"

void init_all(){
    put_str("init_all\n");  // call .-16
    idt_init();             // call .+1572 (0xc0001b8d)
}
