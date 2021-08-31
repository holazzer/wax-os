; ====== MBR (hard disk) ======
; book reference: p132
%include "boot.inc"
SECTION MBR vstart=0x7c00
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


    ; ===== 

    mov eax, LOADER_START_SECTOR  ; LBA
    mov bx, LOADER_BASE_ADDR      ; 
    mov cx, 1
    call rd_disk_m_16

    jmp LOADER_BASE_ADDR


rd_disk_m_16:
    ; 读取硬盘n个扇区
    ; eax=LBA扇区号
    ; bx=将数据写入的内存地址
    ; cx=读入的扇区数量


    ; 备份保存
    mov esi, eax
    mov di, cx

    ; 1.设置要读取的扇区数
    mov dx, 0x1f2
    mov al, cl  ; al <- cl = 1
    out dx, al  ; dx <- 1 设置为一个
    
    mov eax, esi

    ; 2.将LBA地址写入0x1f3 ~ 0x1f6
    
    mov dx, 0x1f3
    out dx, al      ; 0-7位 写到 0x1f3

    mov cl, 8

    shr eax, cl     ; 右移8位，现在8-15位在al里
    mov dx, 0x1f4
    out dx, al      ; 8-15位 写到 0x1f4

    shr eax, cl
    mov dx, 0x1f5
    out dx, al      ; 16-24位 写到 0x1f5

    shr eax, cl     ; al现在有 24-31位
    and al, 0x0f    ; 去掉高4位
    or al, 0xe0     ; 高4位设置为 1110; [1-固定为1][1-LBA][1-固定为1][0-主盘]
    mov dx, 0x1f6
    out dx, al      ; 24-27位 写到 0x1f6

    ; 3.向0x1f7端口写入读命令0x20
    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

    ; 4.检测硬盘状态

.not_ready:
    nop
    in al, dx      ; 现在dx是0x1f7，正好是读操作时的status寄存器
    and al, 0x88   ; 0b10001000，保留3和7位。3-DRQ-准备好 7-BSY-忙 
    cmp al, 0x08   ; al 忙是0x80,准备好是0x08
    jnz .not_ready ; 不相等则跳转

    ; 5.从0x1f0端口读数据
    mov ax, di  ; 读入扇区的数量,在ax
    mov dx, 256
    mul dx      ; ax <- ax * 256
    mov cx, ax  ; 搬运次数：扇区数 * 字节数 / 2 （一次搬一个字，2字节）
    
    mov dx, 0x1f0

.go_on_read:
    in ax, dx
    mov [bx], ax ; bx是写入地址
    add bx, 2
    loop .go_on_read  ; cx记录跳出
    ret

    times 510-($-$$) db 0
    db 0x55, 0xaa



;LOADER_BASE_ADDR equ 0x900
;LOADER_START_SECTOR equ 0x2


