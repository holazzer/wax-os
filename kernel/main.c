int main(){
    while(1);
    return 0;
}


/*****************
Disassembly of section .text:

c0001500 <main>:
c0001500:       55                      push   %ebp
c0001501:       89 e5                   mov    %esp,%ebp
c0001503:       e8 07 00 00 00          call   c000150f <__x86.get_pc_thunk.ax>
c0001508:       05 f8 1a 00 00          add    $0x1af8,%eax
c000150d:       eb fe                   jmp    c000150d <main+0xd>  
                                                    //  <main+0xd>就是这一行 
                                                    // 这里就是while(1);  
                                                    // 所谓的jmp $
c000150f <__x86.get_pc_thunk.ax>:
c000150f:       8b 04 24                mov    (%esp),%eax
c0001512:       c3                      ret

*****************
bochs:

(0) [0x000000000000150d] 0008:00000000c000150d (unk. ctxt): jmp .-2 (0xc000150d)      ; ebfe


***/

