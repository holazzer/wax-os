#include "print.h"
void main(){
    my_set_cursor(80*5);  // test constant folding
    put_char('k');
    put_char('e');
    put_char('r');
    put_char('n');
    put_char('e');
    put_char('l');
    put_char('\n');
    put_char('Y');
    put_char('e');
    put_char('s');
    put_char('\n');
    put_char('H');
    put_char('a');
    put_char('n');
    while(1);
}
