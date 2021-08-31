gcc -I lib/kernel/ -I lib/ -I kernel/ -c -fno-builtin -o build/main.o kernel/main.c   -m32  -fno-stack-protector
nasm -f elf -o build/print.o lib/kernel/print.s 
nasm -f elf -o build/kernel.o kernel/kernel.s
gcc -I lib/kernel/ -I lib/ -I kernel/ -c -fno-builtin -o build/interrupt.o kernel/interrupt.c   -m32  -fno-stack-protector
gcc -I lib/kernel/ -I lib/ -I kernel/ -c -fno-builtin -o build/init.o kernel/init.c   -m32  -fno-stack-protector

ld -Ttext 0xc0001500 -e main -o build/kernel.bin  build/main.o  build/init.o  build/interrupt.o  build/print.o  build/kernel.o -m elf_i386


# dd if=build/kernel.bin of=vm/hd60M.img bs=512 seek=9 count=200 conv=notrunc

# 14+1 records in
# 14+1 records out
# 7448 bytes (7.4 kB, 7.3 KiB) copied, 0.0060193 s, 1.2 MB/s  


