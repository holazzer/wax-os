TI_GDT equ 0
RPL0 equ 0
SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0

section .data
put_int_buffer dq 0     ; 8个字节的缓冲区 


[bits 32]
section .text
;======== put_char ===========
; 把栈中的一个字写到光标所在处
; ============================
global put_char
put_char:
    pushad  ; pushad 把通用寄存器全部压栈 push all double
            ; 寄存器的入栈顺序依次是：EAX,ECX,EDX,EBX,ESP(初始值),EBP,ESI,EDI.
    mov ax, SELECTOR_VIDEO      
    mov gs, ax

    ; 获取当前光标位置
    mov dx, 0x03d4  ; 指定端口号到 Address Register
    mov al, 0x0e    ; 送索引 0x0e: Cursor Location High Register 
    out dx, al      ; 送
    mov dx, 0x03d5  ; 指定端口号到 Data Register
    in al, dx       ; 取
    mov ah, al      ; 高8位移到ah

    mov dx, 0x03d4  ; 指定端口号到 Address Register
    mov al, 0x0f    ; 送索引 0x0f: Cursor Location Low Register 
    out dx, al      ; 送
    mov dx, 0x03d5  ; 指定端口号到 Data Register
    in al, dx       ; 取。现在ax里是完整的光标位置。(0-1999)

    mov bx, ax      ; 光标地址在bx

    mov ecx, [esp+36]   ; pushad压入8个寄存器占32字节，主调函数返回地址4字节
                        ; +36是最开始被压入的字符，也就是待打印的字符

    cmp cl, 0xd     ; 0xd即'\r' CR carriage return 回车符(光标退到行首)
    jz .is_carriage_return

    cmp cl, 0xa     ; 0xa即'\n' LF line feed 换行符
    jz .is_line_feed

    cmp cl, 0x8     ; 0x8即'\b' backsapce 退格
    jz .is_backspace

    jmp .put_other


.is_backspace:
    dec bx                  ; 光标地址回退一格
    shl bx, 1               ; 线性地址*2得到显存地址。因为显存中用两个字符，先写字符再写颜色
    mov byte [gs:bx], 0x20  ; 0x20即' ' 空格
    inc bx                  ; bx+1，设置空格的颜色
    mov byte [gs:bx], 0x07  ; 没颜色
    shr bx, 1               ; 右移，恢复地址，加1的自动没了
    jmp .set_cursor         

.put_other:
    shl bx, 1
    mov [gs:bx], cl
    inc bx
    mov byte [gs:bx], 0x07
    shr bx, 1
    inc bx
    cmp bx, 2000        
    jl .set_cursor      ; jl: 如果bx > 2000就跳 
                        ; 否则说明打印多了，需要翻页（换行

.is_line_feed:
.is_carriage_return:
    xor dx, dx          ; 做除法，被除数高位dx低位ax， 
    mov ax, bx          ; 商ax余数dx
    mov si, 80          ; 除数80放si里
    div si
    sub bx, dx          ; bx减去余数dx，在行首了

.is_carriage_return_end:
    add bx, 80          ; +80到下一行
    cmp bx, 2000        ; 看看有没有超，超2000需要滚动下
.is_line_feed_end:
    jl .set_cursor

.roll_screen:           ; 把1-24行搬到0-23行
    cld                 ; 正向拷贝
    mov ecx, 960        ; 拷贝字节数量：24行*80字*2字节=3840字节
                        ; 每次搬运4字节，需要搬960次
    mov esi, 0xc00b80a0 ; 第1行行首 ?
    mov edi, 0xc00b8000 ; 第0行行首 ?
    rep movsd

    mov ebx, 3840       ; 最后一行行首偏移
    mov ecx, 80         ; 一共写80次

.cls:                   ; 把最后一行全部写成空格
    mov word [gs:ebx], 0x0720
    add ebx, 2
    loop .cls
    mov bx, 1920        ; 最后一行的行首

.set_cursor:
    mov dx, 0x03d4
    mov al, 0x0e
    out dx, al
    mov dx, 0x03d5
    mov al, bh          ; 高8位
    out dx, al

    mov dx, 0x03d4
    mov al, 0x0f
    out dx, al
    mov dx, 0x03d5
    mov al, bl          ; 低8位
    out dx, al

.put_char_done:
    popad
    ret

; ==== 打印字符串
global put_str
put_str:
    push ebx
    push ecx
    xor ecx, ecx
    mov ebx, [esp+12]

.go_on:
    mov cl, [ebx]
    cmp cl, 0
    jz .str_over
    push ecx        ; 压入参数
    call put_char   ; 调用put_char
    add esp, 4      ; 回收栈空间
    inc ebx
    jmp .go_on

.str_over:
    pop ecx
    pop ebx
    ret


; ==== 把光标移动到第x个字的函数， x的值在0到2000
global my_set_cursor
my_set_cursor:
    pushad
    mov ebx, [esp+36]   ; 取位置
    cmp bx, 2000
    jge .done            ; 如果给的数字大于等于2000，那么什么也不做

    mov dx, 0x03d4
    mov al, 0x0e
    out dx, al
    mov dx, 0x03d5
    mov al, bh          ; 高8位
    out dx, al

    mov dx, 0x03d4
    mov al, 0x0f
    out dx, al
    mov dx, 0x03d5
    mov al, bl          ; 低8位
    out dx, al

.done:
    popad
    ret


; ====== put_int
; 在屏幕上打印十六进制数字，不打印前缀0x
global put_int
put_int:
    pushad                      ; 保存寄存器
    mov ebp, esp                ; 基址
    mov eax, [ebp + 4*9]        ; eax拿到待打印数字
    mov edx, eax                ; 装入edx
    mov edi, 7                  ; 在 put_int_buffer中的初始偏移量
    mov ecx, 8                  ; 32位数字，在十六进制下最多8位
    mov ebx, put_int_buffer     ; ebx装入基址

.16based_4bits:
    and edx, 0x0000000F         ; 取4bit，一位16进制数
    cmp edx, 9                  ; 和9比大小
    jg .isA2F                   ; 比9大，打印A-F
    add edx, '0'                ; 不比9大，打印0-9
    jmp .store                  ; 跳过.isA2F
.isA2F:
    sub edx, 10
    add edx, 'A'                ; A-F
.store:
    mov [ebx+edi], dl           ; edi是偏移量，从7降低到0
    dec edi                     ; edi--
    shr eax, 4                  ; eax右移4位，低4位是下一位数字
    mov edx, eax                ; edx是我们加'0'或者'A'用的，和eax的值保持同步
    loop .16based_4bits         

.ready_to_print:                ; 偏移量edi经过循环后，现在是-1
    inc edi                     ; edi = 0
.skip_prefix_0:
    cmp edi, 8                  ; 如果edi=8，即全部跳过了，说明8位都是0
    je .full0                   ; 
.go_on_skip:
    mov cl, [put_int_buffer + edi]  ; 待打印的字符放到cl
    inc edi                         ; 偏移量++
    cmp cl, '0'                     ; 和'0'比较，不打印多余的前缀0
    je .skip_prefix_0               ; 跳过前缀0
    dec edi                         ; 没跳过就不计数，偏移量恢复
    jmp .put_each_num               ; 走到这里说明没有前缀0了，开始打印

.full0:
    mov cl, '0'                     ; 跳到这里说明全是0，打印一个0
.put_each_num:
    push ecx                        ; 参数压栈
    call put_char                   
    add esp, 4                      ; 调用后恢复栈
    inc edi                         ; 偏移量++
    mov cl, [put_int_buffer + edi]  ; 获取下一个打印的字符
    cmp edi, 8                      ; 是不是打印完了
    jl .put_each_num                ; 小于8，继续打印
    popad                           ; 恢复寄存器
    ret


