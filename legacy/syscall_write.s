section .data
str_syscall: db "syscall: hello", 0xa
str_syscall_len equ $ - str_syscall

section .text
global _start

_start:
    ; syscall style
    mov eax, 4          ; #define __NR_write 4
    mov ebx, 1
    mov ecx, str_syscall
    mov edx, str_syscall_len
    int 0x80

    ; exit
    mov eax, 1          ; #define __NR_exit 1
    int 0x80        

; compile: 
; $ nasm syscall_write.s -f elf -o syscall_write.o
; link: 
; ld -o syscall_write.bin syscall_write.o -m elf_i386
; run:
; 