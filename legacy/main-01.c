#include "print.h"
void main(){
    my_set_cursor(80*5);
    put_char('H');
    put_char('i');
    put_char('.');
    put_char(0x20);
    put_str("I am inside the kernel.\n");
    put_int(0xcafebabe);
    while(1);
}

