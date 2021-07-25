; ====== MBR ======
; book reference: p61 

SECTION MBR vstart=0x7c00
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov sp, 0x7c00

    ; ===== clear screen =====
    mov ax, 0x600
    mov bx, 0x700
    mov cx, 0
    mov dx, 0x184f
    int 0x10

    ; ===== get cursor location =====
    mov ah, 3
    mov bh, 0
    int 0x10

    ; out:
    ; ch, cl = (光标起始行, 光标结束行)
    ; dh, dl = (光标所在行号, 光标所在列号) 
    ; ===================================


    ; ===== print message ======
    mov ax, message
    mov bp, ax  ; es:bp <- 串首地址，现在es=cs
    mov cx, 5   ; 打印长度
    mov ax, 0x1301 
    mov bx, 0x2 ; 黑底绿字
    int 0x10

    ; ===== stop =====
    jmp $

    message db "1 MBR"

    times 510-($-$$) db 0
    db 0x55, 0xaa
