## 编译

这次把编译的目标都放在 build 文件夹下。

编译 main.c :

```
$ gcc kernel/main.c -I lib -I lib/kernel -c -fno-builtin -o build/main.o -m32 -fno-stack-protector
```

编译 print.s :

```
$ nasm lib/kernel/print.s -f elf -o build/print.o
```

编译 kernel.s :

```
$ nasm kernel/kernel.s -f elf -o build/kernel.o
```

编译 interrupt.c :

```
$ gcc kernel/interrupt.c -I lib -I lib/kernel -c -fno-builtin -o build/interrupt.o -m32 -fno-stack-protector
```

编译 init.c :

```
$ gcc kernel/init.c -I lib -I lib/kernel -c -fno-builtin -o build/init.o -m32
```


检查:

```
$ file build/*.o
build/init.o:      ELF 32-bit LSB relocatable, Intel 80386, version 1 (SYSV), not stripped
build/interrupt.o: ELF 32-bit LSB relocatable, Intel 80386, version 1 (SYSV), not stripped
build/kernel.o:    ELF 32-bit LSB relocatable, Intel 80386, version 1 (SYSV), not stripped
build/main.o:      ELF 32-bit LSB relocatable, Intel 80386, version 1 (SYSV), not stripped
build/print.o:     ELF 32-bit LSB relocatable, Intel 80386, version 1 (SYSV), not stripped
```

## 链接：

```
$ ld -Ttext 0xc0001500 -e main -o build/kernel.bin -m elf_i386 build/main.o build/init.o build/interrupt.o build/kernel.o build/print.o

build/interrupt.o: In function `idt_init':
interrupt.c:(.text+0x219): undefined reference to `__stack_chk_fail_local'
ld: build/kernel.bin: hidden symbol `__stack_chk_fail_local' isn't defined
ld: final link failed: Bad value
```

互联网搜索告诉我：不要用ld，直接用gcc就可以了。

http://blog.chinaunix.net/uid-20745012-id-91457.html

https://stackoverflow.com/questions/10712972/what-is-the-use-of-fno-stack-protector


换成：
```
$ gcc build/*.o -Ttext 0xc0001500 -e main -o build/kernel.bin -m32
```

检查是否正确链接了：
```
$ readelf -e build/kernel.bin 
ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Shared object file)
  Machine:                           Intel 80386
  Version:                           0x1
  Entry point address:               0xc0001bce
  Start of program headers:          52 (bytes into file)
  Start of section headers:          16772 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         10
  Size of section headers:           40 (bytes)
  Number of section headers:         29
  Section header string table index: 28

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        c0001500 001500 000914 00  AX  0   0 16  <==== 看到.text的起始位置是0xc0001500 ，应该没问题
  [ 2] .interp           PROGBITS        00000174 000174 000013 00   A  0   0  1
  [ 3] .note.ABI-tag     NOTE            00000188 000188 000020 00   A  0   0  4
  [ 4] .note.gnu.build-i NOTE            000001a8 0001a8 000024 00   A  0   0  4
  [ 5] .gnu.hash         GNU_HASH        000001cc 0001cc 000020 04   A  6   0  4
  [ 6] .dynsym           DYNSYM          000001ec 0001ec 000080 10   A  7   1  4
  [ 7] .dynstr           STRTAB          0000026c 00026c 0000b1 00   A  0   0  1
  [ 8] .gnu.version      VERSYM          0000031e 00031e 000010 02   A  6   0  2
  [ 9] .gnu.version_r    VERNEED         00000330 000330 000040 00   A  7   1  4
  [10] .rel.dyn          REL             00000370 000370 000268 08   A  6   0  4
  [11] .rel.plt          REL             000005d8 0005d8 000010 08  AI  6  22  4
  [12] .init             PROGBITS        000005e8 0005e8 000023 00  AX  0   0  4
  [13] .plt              PROGBITS        00000610 000610 000030 04  AX  0   0 16
  [14] .plt.got          PROGBITS        00000640 000640 000010 08  AX  0   0  8
  [15] .fini             PROGBITS        c0001e14 001e14 000014 00  AX  0   0  4
  [16] .rodata           PROGBITS        c0001e28 001e28 000068 00   A  0   0  4
  [17] .eh_frame_hdr     PROGBITS        c0001e90 001e90 000074 00   A  0   0  4
  [18] .eh_frame         PROGBITS        c0001f04 001f04 0001e4 00   A  0   0  4
  [19] .init_array       INIT_ARRAY      c0003ed0 002ed0 000004 04  WA  0   0  4
  [20] .fini_array       FINI_ARRAY      c0003ed4 002ed4 000004 04  WA  0   0  4
  [21] .dynamic          DYNAMIC         c0003ed8 002ed8 000100 08  WA  7   0  4
  [22] .got              PROGBITS        c0003fd8 002fd8 000028 04  WA  0   0  4
  [23] .data             PROGBITS        c0004000 003000 0000a8 00  WA  0   0  4
  [24] .bss              NOBITS          c00040c0 0030a8 000128 00  WA  0   0 32
  [25] .comment          PROGBITS        00000000 0030a8 000029 01  MS  0   0  1
  [26] .symtab           SYMTAB          00000000 0030d4 0008f0 10     27 111  4
  [27] .strtab           STRTAB          00000000 0039c4 0006c2 00      0   0  1
  [28] .shstrtab         STRTAB          00000000 004086 0000fc 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  p (processor specific)

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  PHDR           0x000034 0x00000034 0x00000034 0x00140 0x00140 R   0x4
  INTERP         0x000174 0x00000174 0x00000174 0x00013 0x00013 R   0x1
      [Requesting program interpreter: /lib/ld-linux.so.2]
  LOAD           0x000000 0x00000000 0x00000000 0x00650 0x00650 R E 0x1000
  LOAD           0x001500 0xc0001500 0xc0001500 0x00be8 0x00be8 R E 0x1000
  LOAD           0x002ed0 0xc0003ed0 0xc0003ed0 0x001d8 0x00318 RW  0x1000
  DYNAMIC        0x002ed8 0xc0003ed8 0xc0003ed8 0x00100 0x00100 RW  0x4
  NOTE           0x000188 0x00000188 0x00000188 0x00044 0x00044 R   0x4
  GNU_EH_FRAME   0x001e90 0xc0001e90 0xc0001e90 0x00074 0x00074 R   0x4
  GNU_STACK      0x000000 0x00000000 0x00000000 0x00000 0x00000 RWE 0x10
  GNU_RELRO      0x002ed0 0xc0003ed0 0xc0003ed0 0x00130 0x00130 R   0x1

 Section to Segment mapping:
  Segment Sections...
   00
   01     .interp
   02     .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rel.dyn .rel.plt .init .plt .plt.got
   03     .text .fini .rodata .eh_frame_hdr .eh_frame
   04     .init_array .fini_array .dynamic .got .data .bss 
   05     .dynamic
   06     .note.ABI-tag .note.gnu.build-id
   07     .eh_frame_hdr
   08
   09     .init_array .fini_array .dynamic .got
```


```
$ file build/kernel.bin 
build/kernel.bin: ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-, for GNU/Linux 3.2.0, BuildID[sha1]=142f9606378551b81d93bcfb041bf9997d7c14df, not stripped
```


写硬盘：

```
$ dd if=build/kernel.bin of=hd60M.img bs=512 seek=9 count=200 conv=notrunc
35+1 records in
35+1 records out
17932 bytes (18 kB, 18 KiB) copied, 0.0050867 s, 3.5 MB/s
```

用 gcc 编译再链接比分开编译再用 ld 链接要大得多。因为 gcc 加了很多 general 的字段，我们用不上的。



gcc 编译后把 _start放到 0xc0001500 的位置，而不是main函数。。。
可是我明明写了 -e main 啊。。。



解决了，gcc是把entry point设置为了main的地址，但是他还是很坚持地把自己的 _start 放在了 .text端的开始位置。

但是我想要的是让 main 放在 0xc0001500 啊


最终解决办法：

https://stackoverflow.com/questions/4492799/undefined-reference-to-stack-chk-fail

所有 gcc 编译的，加上 -fno-stack-protector ，这样就可以用 ld 来链接了。

为了让 main 落在 0xc0001500 的位置，在编译时候需要把 main.o 写在最前面。


## 运行

运行失败，最后没有看到时钟中断的触发：


```
(0) [0x0000000000001542] 0008:00000000c0001542 (unk. ctxt): jmp .-2 (0xc0001542)      ; ebfe
00018076040i[XGUI ] Mouse capture off
<bochs:139> c
00018241105e[CPU0 ] int_trap_gate(): selector null
00018241105e[CPU0 ] int_trap_gate(): selector null
00018241105e[CPU0 ] int_trap_gate(): selector null
00018241105i[CPU0 ] CPU is in protected mode (active)
00018241105i[CPU0 ] CS.mode = 32 bit
00018241105i[CPU0 ] SS.mode = 32 bit
00018241105i[CPU0 ] EFER   = 0x00000000
00018241105i[CPU0 ] | EAX=c0001c8a  EBX=c0003000  ECX=0000c000  EDX=30c00000
00018241105i[CPU0 ] | ESP=c009eff0  EBP=c009eff8  ESI=00070000  EDI=00000000
00018241105i[CPU0 ] | IOPL=0 id vip vif ac vm RF nt of df IF tf SF zf af pf cf
00018241105i[CPU0 ] | SEG sltr(index|ti|rpl)     base    limit G D
00018241105i[CPU0 ] |  CS:0008( 0001| 0|  0) 00000000 ffffffff 1 1
00018241105i[CPU0 ] |  DS:0010( 0002| 0|  0) 00000000 ffffffff 1 1
00018241105i[CPU0 ] |  SS:0010( 0002| 0|  0) 00000000 ffffffff 1 1
00018241105i[CPU0 ] |  ES:0010( 0002| 0|  0) 00000000 ffffffff 1 1
00018241105i[CPU0 ] |  FS:0000( 0005| 0|  0) 00000000 0000ffff 0 0
00018241105i[CPU0 ] |  GS:0018( 0003| 0|  0) c00b8000 00007fff 1 1
00018241105i[CPU0 ] | EIP=c0001542 (c0001542)
00018241105i[CPU0 ] | CR0=0xe0000011 CR2=0x00000000
00018241105i[CPU0 ] | CR3=0x00100000 CR4=0x00000000
(0).[18241105] [0x0000000000001542] 0008:00000000c0001542 (unk. ctxt): jmp .-2 (0xc0001542)      ; ebfe
00018241105e[CPU0 ] exception(): 3rd (13) exception with no resolution, shutdown status is 00h, resetting
00018241105i[SYS  ] bx_pc_system_c::Reset(HARDWARE) called
00018241105i[CPU0 ] cpu hardware reset
00018241105i[APIC0] allocate APIC id=0 (MMIO enabled) to 0x00000000fee00000
00018241105i[CPU0 ] CPUID[0x00000000]: 00000002 756e6547 6c65746e 49656e69
00018241105i[CPU0 ] CPUID[0x00000001]: 00000633 00010800 00002028 1fcbfbff
00018241105i[CPU0 ] CPUID[0x00000002]: 00410601 00000000 00000000 00000000
00018241105i[CPU0 ] CPUID[0x80000000]: 80000008 00000000 00000000 00000000
00018241105i[CPU0 ] CPUID[0x80000001]: 00000000 00000000 00000101 2a100000
00018241105i[CPU0 ] CPUID[0x80000002]: 20202020 20202020 20202020 6e492020
00018241105i[CPU0 ] CPUID[0x80000003]: 286c6574 50202952 69746e65 52286d75
00018241105i[CPU0 ] CPUID[0x80000004]: 20342029 20555043 20202020 00202020
00018241105i[CPU0 ] CPUID[0x80000005]: 01ff01ff 01ff01ff 40020140 40020140
00018241105i[CPU0 ] CPUID[0x80000006]: 00000000 42004200 02008140 00000000
00018241105i[CPU0 ] CPUID[0x80000007]: 00000000 00000000 00000000 00000000
00018241105i[CPU0 ] CPUID[0x80000008]: 00003028 00000000 00000000 00000000
00018241105i[PLGIN] reset of 'pci' plugin device by virtual method
00018241105i[PLGIN] reset of 'pci2isa' plugin device by virtual method
00018241105i[PLGIN] reset of 'cmos' plugin device by virtual method
00018241105i[PLGIN] reset of 'dma' plugin device by virtual method
00018241105i[PLGIN] reset of 'pic' plugin device by virtual method
00018241105i[PLGIN] reset of 'pit' plugin device by virtual method
00018241105i[PLGIN] reset of 'floppy' plugin device by virtual method
00018241105i[PLGIN] reset of 'vga' plugin device by virtual method
00018241105i[PLGIN] reset of 'acpi' plugin device by virtual method
00018241105i[PLGIN] reset of 'ioapic' plugin device by virtual method
00018241105i[PLGIN] reset of 'keyboard' plugin device by virtual method
00018241105i[PLGIN] reset of 'harddrv' plugin device by virtual method
00018241105i[PLGIN] reset of 'pci_ide' plugin device by virtual method
00018241105i[PLGIN] reset of 'unmapped' plugin device by virtual method
00018241105i[PLGIN] reset of 'biosdev' plugin device by virtual method
00018241105i[PLGIN] reset of 'speaker' plugin device by virtual method
00018241105i[PLGIN] reset of 'extfpuirq' plugin device by virtual method
00018241105i[PLGIN] reset of 'parallel' plugin device by virtual method
00018241105i[PLGIN] reset of 'serial' plugin device by virtual method
00018241105i[PLGIN] reset of 'gameport' plugin device by virtual method
00018241105i[PLGIN] reset of 'iodebug' plugin device by virtual method
Next at t=18241106
(0) [0x00000000fffffff0] f000:fff0 (unk. ctxt): jmp far f000:e05b         ; ea5be000f0
00018241106i[XGUI ] Mouse capture off
```