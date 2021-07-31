; ====== loader: load kernel ======
; book reference: p223

%include "boot.inc"
SECTION loader vstart=LOADER_BASE_ADDR
LOADER_STACK_TOP equ LOADER_BASE_ADDR
jmp loader_start

    GDT_BASE:           dd 0x00000000 
                        dd 0x00000000
    CODE_DESC:          dd 0x0000FFFF
                        dd DESC_CODE_HIGH4
    DATA_STACK_DESC:    dd 0x0000FFFF
                        dd DESC_DATA_HIGH4
    VIDEO_DESC:         dd 0x80000007; limit=(0xbffff-0xb8000)/4k=0x7 
                        dd DESC_VIDEO_HIGH4
                                ; GDT用了8个双字, 【32字节】    

    GDT_SIZE equ $ - GDT_BASE
    GDT_LIMIT equ GDT_SIZE-1
    times 60 dq 0    ; 预留60个描述符的空位 dq   60个4字,  【480字节】
    SELECTOR_CODE  equ (0x0001 << 3) + TI_GDT + RPL0
    SELECTOR_DATA  equ (0x0002 << 3) + TI_GDT + RPL0
    SELECTOR_VIDEO equ (0x0003 << 3) + TI_GDT + RPL0

    total_mem_bytes dd 0        ; 【480+32=512字节】位置：偏移文件头0x200 【4字节】 地址：0xb03

    gdt_ptr dw GDT_LIMIT        ; 【2字节】
            dd GDT_BASE         ; 【4字节】

    ards_buf times 244 db 0     ; 【244字节】 地址 0x0b0d
    ards_nr dw 0                ; ards结构的数量【2字节】对齐。 4+2+4+244+2 = 256字节
                                ; ards_nr 地址 0xc01

    loader_message db '2 loader in real.'

loader_start:
    xor ebx, ebx                 ; ebx置0
    mov edx, 0x534d4150     ; [chr(i) for i in (0x53,0x4d,0x41,0x50)] => ['S','M','A','P']
                            ; 用来比较。如果0x15调用成功，eax的值会变成0x534d4150
    mov di, ards_buf        ; di存ARDS缓冲区地址，把拿到的ARDS都放进去

.e820_mem_get_loop:
    mov eax, 0x0000e820     ; 调用0xe820子功能
    mov ecx, 20             ; ARDS地址描述符结构大小20字节
    int 0x15                ; call
    jc .e820_failed_so_try_e801 ; 有错误发生，cf位为1
    add di, cx              ; 保存地址加20字节
    inc word [ards_nr]      ; 保存数量+1
    cmp ebx, 0              ; ebx为0说明全部返回了
    jnz .e820_mem_get_loop  ; 不是0，跳回去继续


                            ; 全部获取，开始寻找最大的
    mov cx, [ards_nr]       ; 循环的次数cx=ards数量  cx=6
    mov ebx, ards_buf       ; ebx存放开始地址
    xor edx, edx            ; edx 清零，保存最大的那一项

.find_max_mem_area:
    mov eax, [ebx]          ; 取基地址低32位 
    add eax, [ebx+8]        ; 加上内存长度低32位，
    add ebx, 20             ; 移动到下一个ARDS项
    cmp edx, eax            ; 比较edx和eax

    jge .next_ards          ; edx大于等于eax，直接跳转
    mov edx, eax            ; edx小于eax，将eax的值赋给edx

.next_ards:
    loop .find_max_mem_area ; 直到cx用完 
    jmp .mem_get_ok         ; cx用完跳转到ok

.e820_failed_so_try_e801:
    mov ax, 0xe801          ; call 0xe801
    int 0x15
    jc .e801_failed_so_try88

    mov cx, 0x400           
    mul cx                  ; ax <- ax * 0x400， 从KB转成B
    shl edx, 16             ; 乘积的高16位在dx中，把这16位左移
    and eax, 0x0000FFFF     ; ax中乘积低16位
                            ; 把eax的高16位置0，因为要与edx中高16位合并
    or edx, eax             ; edx <- edx + eax 合起来 
    add edx, 0x100000       ; 加上15MB-16MB的空洞 1MB 
    mov esi, edx            ; esi <- edx 暂时保存16M以内的大小

    xor eax, eax            ; eax <- 0
    mov ax, bx              ; ax <- bx 以64KB为单位，16MB-4GB中连续单位的数量
    mov ecx, 0x10000        ; 64K
    mul ecx                 ; 把16M-4GB中的空间大小化成字节数
                            ; 低32位在eax，高32位在edx。
                            ; 但是最多4GB，不可能超过32位。所以不用管edx

    add esi, eax            ; esi 现在是全部的字节数
    mov edx, esi            ; 结果放到edx （3种方法都是这样）
    jmp .mem_get_ok

.e801_failed_so_try88:
    mov ah, 0x88
    int 0x15
    jc .error_hlt
    and eax, 0x0000FFFF     ; ax中存1MB之上的连续内存单位数，单位1KB

    mov cx, 0x400           ; 1KB
    mul cx                  ; 低16位在ax，高16位在dx
    shl edx, 16             ; 高位部分左移
    or edx, eax             ; 低位移到dx，32位乘积拼到edx里
    add edx, 0x100000       ; 加上开始的1MB

.mem_get_ok:
    mov [total_mem_bytes], edx
    mov esi, edx

    mov sp, LOADER_BASE_ADDR
    mov bp, loader_message
    mov cx, 17
    mov ax, 0x1301
    mov bx, 0x001f
    mov dx, 0x1800
    int 0x10


    ;======= 打开A20 ======
    in al, 0x92
    or al, 0000_0010B
    out 0x92, al

    ;======= 加载GDT =====
    lgdt [gdt_ptr]

    ;======= cr0第0位置1 =======
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp dword SELECTOR_CODE:p_mode_start

.error_hlt:
    hlt


[bits 32]
p_mode_start:
    mov ax, SELECTOR_DATA
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, LOADER_STACK_TOP
    mov ax, SELECTOR_VIDEO
    mov gs, ax

    mov byte [gs:160], 'P'

    ; 把内核文件内容读入内存
    mov eax, KERNEL_START_SECTOR
    mov ebx, KERNEL_BIN_BASE_ADDR
    mov ecx, 200
    call rd_disk_m_32


    ; 开启分页
    call setup_page
    sgdt [gdt_ptr]

    mov ebx, [gdt_ptr + 2]
    or dword [ebx + 0x18 + 4], 0xc0000000

    add dword [gdt_ptr + 2], 0xc0000000

    add esp, 0xc0000000

    mov eax, PAGE_DIR_TABLE_POS
    mov cr3, eax

    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    lgdt [gdt_ptr]

    mov byte [gs:162], 'V'

    jmp $

; ===== 创建页目录和页表

; 页目录从 0x100000 开始，一共4KB, 即 4096字节，需要把这些地方都写0
setup_page: 
    mov ecx, 4096
    mov esi, 0
.clear_page_dir:
    mov byte [PAGE_DIR_TABLE_POS + esi], 0
    inc esi
    loop .clear_page_dir

; 创建页目录项 PDE
.create_pde:
    mov eax, PAGE_DIR_TABLE_POS
    add eax, 0x1000; 加上0x1000(4096)，获得第一个页表项的地址
    mov ebx, eax
    or eax, PG_US_U | PG_RW_W | PG_P
    mov [PAGE_DIR_TABLE_POS + 0x0], eax     ; 第1个页目录项
    mov [PAGE_DIR_TABLE_POS + 0xc00], eax   ; 0xc00是第768个目录项 0xc00以上的目录项用于内核空间
    sub eax, 0x1000                         ; 
    mov [PAGE_DIR_TABLE_POS + 4092], eax    ; 最后一个目录项指向自己

; 创建页表项 PTE
    mov ecx, 256  ; 1M低端内存 / 4K = 256页 
    mov esi, 0
    mov edx, PG_US_U |PG_RW_W | PG_P
.create_pte:
    mov [ebx + esi*4], edx  ; ebx=0x100000
    add edx, 4096           ; 一个页是4KB = 4096字节
    inc esi                 
    loop .create_pte        ; 把前256个页表项填完

; 创建内核其他页表的PDE
    mov eax, PAGE_DIR_TABLE_POS         ;
    add eax, 0x2000                     ;
    or eax, PG_US_U | PG_RW_W | PG_P    ;
    mov ebx, PAGE_DIR_TABLE_POS         ;
    mov ecx, 254                        ; 769-1022的所有目录项数量
    mov esi, 769                        ; 开始的偏移
.create_kernel_pde:
    mov [ebx+esi*4], eax                
    inc esi
    add eax, 0x1000
    loop .create_kernel_pde
    ret                                 ; 页表写完了


; ====== delete the following before you compile



;=== 内核                           
KERNEL_START_SECTOR equ 0x9         ; 将内核文件放到9号扇区（从0开始数）
KERNEL_BIN_BASE_ADDR equ 0x70000    ; 规定的位置而已，一个暂时存放数据的位置



