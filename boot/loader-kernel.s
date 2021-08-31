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

    jmp SELECTOR_CODE: enter_kernel
enter_kernel: 
    call kernel_init

    mov byte [gs:164], 'K'

    mov esp, 0xc009f000
    jmp KERNEL_ENTRY_POINT


;=== 内核
kernel_init:
    xor eax, eax 
    xor ebx, ebx ; ebx记录程序头表地址
    xor ecx, ecx ; cx记录程序头表的program header数量
    xor edx, edx ; dx记录program header尺寸，即e_phentsize [???]

    mov dx,  [KERNEL_BIN_BASE_ADDR + 42]    ; 偏移42位置是 e_phentsize
    mov ebx, [KERNEL_BIN_BASE_ADDR + 28]    ; 偏移28位置是 e_phoff 也就是第一个program header的偏移量 
                                            ; 这个值应该是 0x34
    add ebx, KERNEL_BIN_BASE_ADDR
    mov cx,  [KERNEL_BIN_BASE_ADDR + 44]    ; 偏移44是 e_phnum 表示 program header的数量

.each_segment:
    cmp byte [ebx+0], PT_NULL   ; 等于PT_NULL说明此program header未使用
    je .PT_NULL                 ; 跳过下面的拷贝

    push dword [ebx+16]             ; +16是p_filesz 压入size参数
    mov eax, [ebx+4]                ; +4是 p_offset 在文件中的起始偏移字节
    add eax, KERNEL_BIN_BASE_ADDR   ; 加上基址
    push eax                        ; 压入目标的偏移地址 src
    push dword [ebx+8]              ; +8是p_vaddr 在内存中的起始虚拟地址
    call mem_cpy
    add esp, 12

.PT_NULL:
    add ebx, edx    ; 基地址++，移动到下一个program header

    loop .each_segment
    ret

; 逐字节拷贝函数 mem_cpy 
; 输入：压入栈中的三个参数dst, src, size
mem_cpy:
    cld     ; CLD 清方向标志位. 将标志寄存器Flag的方向标志位DF清零。
                            ; df=0时movs系列指令是正向传送，传送后esi和edi的值增大
    push ebp                ; 保护ebp。现在[esp+4]是ebp的值
    mov ebp, esp            ; ebp装入esp，用来取参数。ebp=现在的esp
    push ecx                ; 保护ecx。rep指令需要使用ecx。ebp的值不受push影响。esp=esp-4
    mov edi, [ebp + 8]      ; dst  
    mov esi, [ebp + 12]     ; src  
    mov ecx, [ebp + 16]     ; size 
    rep movsb               ; movsb: 从源地址向目的地址传送数据，传送之后会自动更改esi和edi的值
                            ; 原地址 ds:esi 目的地址 ds:edi
                            ; movs系列：movsb字节 movsw字 movsd双字
                            ; rep的作用：执行这个语句并让ecx减一，直到ecx等于0为止

    pop ecx ; 恢复ecx
    pop ebp ; 恢复ebp
    ret



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


; 注: 经过我比较，这里rd_disk_m_32和前面mbr中使用的rd_disk_m_16代码一模一样。

;-------------------------------------------------------------------------------
			   ;功能:读取硬盘n个扇区
rd_disk_m_32:	   
;-------------------------------------------------------------------------------
							 ; eax=LBA扇区号
							 ; ebx=将数据写入的内存地址
							 ; ecx=读入的扇区数
      mov esi,eax	   ; 备份eax
      mov di,cx		   ; 备份扇区数到di
;读写硬盘:
;第1步：设置要读取的扇区数
      mov dx,0x1f2
      mov al,cl
      out dx,al            ;读取的扇区数

      mov eax,esi	   ;恢复ax

;第2步：将LBA地址存入0x1f3 ~ 0x1f6

      ;LBA地址7~0位写入端口0x1f3
      mov dx,0x1f3                       
      out dx,al                          

      ;LBA地址15~8位写入端口0x1f4
      mov cl,8
      shr eax,cl
      mov dx,0x1f4
      out dx,al

      ;LBA地址23~16位写入端口0x1f5
      shr eax,cl
      mov dx,0x1f5
      out dx,al

      shr eax,cl
      and al,0x0f	   ;lba第24~27位
      or al,0xe0	   ; 设置7～4位为1110,表示lba模式
      mov dx,0x1f6
      out dx,al

;第3步：向0x1f7端口写入读命令，0x20 
      mov dx,0x1f7
      mov al,0x20                        
      out dx,al

;;;;;;; 至此,硬盘控制器便从指定的lba地址(eax)处,读出连续的cx个扇区,下面检查硬盘状态,不忙就能把这cx个扇区的数据读出来

;第4步：检测硬盘状态
  .not_ready:		   ;测试0x1f7端口(status寄存器)的的BSY位
      ;同一端口,写时表示写入命令字,读时表示读入硬盘状态
      nop
      in al,dx
      and al,0x88	   ;第4位为1表示硬盘控制器已准备好数据传输,第7位为1表示硬盘忙
      cmp al,0x08
      jnz .not_ready	   ;若未准备好,继续等。

;第5步：从0x1f0端口读数据
      mov ax, di	   ;以下从硬盘端口读数据用insw指令更快捷,不过尽可能多的演示命令使用,
			   ;在此先用这种方法,在后面内容会用到insw和outsw等

      mov dx, 256	   ;di为要读取的扇区数,一个扇区有512字节,每次读入一个字,共需di*512/2次,所以di*256
      mul dx
      mov cx, ax	   
      mov dx, 0x1f0
  .go_on_read:
      in ax,dx		
      mov [ebx], ax
      add ebx, 2
			  ; 由于在实模式下偏移地址为16位,所以用bx只会访问到0~FFFFh的偏移。
			  ; loader的栈指针为0x900,bx为指向的数据输出缓冲区,且为16位，
			  ; 超过0xffff后,bx部分会从0开始,所以当要读取的扇区数过大,待写入的地址超过bx的范围时，
			  ; 从硬盘上读出的数据会把0x0000~0xffff的覆盖，
			  ; 造成栈被破坏,所以ret返回时,返回地址被破坏了,已经不是之前正确的地址,
			  ; 故程序出会错,不知道会跑到哪里去。
			  ; 所以改为ebx代替bx指向缓冲区,这样生成的机器码前面会有0x66和0x67来反转。
			  ; 0X66用于反转默认的操作数大小! 0X67用于反转默认的寻址方式.
			  ; cpu处于16位模式时,会理所当然的认为操作数和寻址都是16位,处于32位模式时,
			  ; 也会认为要执行的指令是32位.
			  ; 当我们在其中任意模式下用了另外模式的寻址方式或操作数大小(姑且认为16位模式用16位字节操作数，
			  ; 32位模式下用32字节的操作数)时,编译器会在指令前帮我们加上0x66或0x67，
			  ; 临时改变当前cpu模式到另外的模式下.
			  ; 假设当前运行在16位模式,遇到0X66时,操作数大小变为32位.
			  ; 假设当前运行在32位模式,遇到0X66时,操作数大小变为16位.
			  ; 假设当前运行在16位模式,遇到0X67时,寻址方式变为32位寻址
			  ; 假设当前运行在32位模式,遇到0X67时,寻址方式变为16位寻址.

      loop .go_on_read
      ret
