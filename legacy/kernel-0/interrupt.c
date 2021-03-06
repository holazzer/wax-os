#include "interrupt.h"
#include "stdint.h"
#include "global.h"
#include "io.h"
#include "print.h"

#define PIC_M_CTRL 0x20
#define PIC_M_DATA 0x21
#define PIC_S_CTRL 0xa0
#define PIC_S_DATA 0xa1

#define IDT_DESC_CNT 0x21

struct gate_desc {
    uint16_t func_offset_low_word;
    uint16_t selector;
    uint8_t dcount;
    uint8_t attribute;
    uint16_t func_offset_high_word;
};

static void make_idt_desc(struct gate_desc* p_desc, 
                uint8_t attr, intr_handler function);
static struct gate_desc idt[IDT_DESC_CNT];

extern intr_handler intr_entry_table[IDT_DESC_CNT];  // defined in kernel.s


static void pic_init(){
    outb(PIC_M_CTRL, 0x11);
    outb(PIC_M_DATA, 0x20);
    outb(PIC_M_DATA, 0x04);
    outb(PIC_M_DATA, 0x01);
    
    outb(PIC_S_CTRL, 0x11);
    outb(PIC_S_DATA, 0x28);
    outb(PIC_S_DATA, 0x02);
    outb(PIC_S_DATA, 0x01);

    outb(PIC_M_DATA, 0xfe);
    outb(PIC_S_DATA, 0xff);

    put_str("    pic_init done\n");
}

static void make_idt_desc(struct gate_desc* p_desc, uint8_t attr, intr_handler function){
    p_desc->func_offset_low_word  = (uint32_t)function & 0x0000ffff;
    p_desc->func_offset_high_word = ((uint32_t)function & 0xffff0000) >> 16; 
    p_desc->selector;
    p_desc->dcount = 0;
    p_desc->attribute = attr;
}

static void idt_desc_init(){
    int i;
    for(i = 0; i < IDT_DESC_CNT ; i++){
        make_idt_desc(&idt[i], IDT_DESC_ATTR_DPL0, intr_entry_table[i]);
    }
    put_str("    idt_desc_init done\n");  // call .-149 (0xc000169b)
}

void idt_init(){
    put_str("idt_init start\n");
    idt_desc_init();                // call .+404 (0xc0001705)
    pic_init();
    uint64_t idt_operand = (sizeof(idt)-1)|(((uint64_t)((uint32_t)idt)) << 16);
    asm volatile ("lidt %0"::"m"(idt_operand));  // lidt ss:[ebp-32] 
    put_str("idt_init done\n");     // call .+1049 (0xc0001b8d)
}





