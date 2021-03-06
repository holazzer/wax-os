; ====== MBR (VRAM) ======
; book reference: p110

SECTION MBRV vstart=0x7c00
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov sp, 0x7c00

    ; gs作为显存的基地址
    mov ax, 0xb800
    mov gs, ax


    ; ===== clear screen =====
    mov ax, 0x600
    mov bx, 0x700
    mov cx, 0
    mov dx, 0x184f
    int 0x10

    ; ===== write to v-ram =====
    mov byte [gs:0x00], '1'
    mov byte [gs:0x01], 0xA4

    mov byte [gs:0x02], ' '
    mov byte [gs:0x03], 0xA4

    mov byte [gs:0x04], 'M'
    mov byte [gs:0x05], 0xA4

    mov byte [gs:0x06], 'B'
    mov byte [gs:0x07], 0xA4

    mov byte [gs:0x08], 'R'
    mov byte [gs:0x09], 0xA4

    jmp $

    times 510-($-$$) db 0
    db 0x55, 0xaa

