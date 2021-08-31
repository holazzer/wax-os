#include "timer.h"
#include "io.h"
#include "print.h"

#define IRQ0_FREQUENCY 100                                 // 希望的频率：100Hz
#define INPUT_FREQUENCY 1193180                            // 计数频率: 1.1MHz
#define COUNTER0_VALUE INPUT_FREQUENCY / IRQ0_FREQUENCY    // 计数次数，每计数x次发出一次中断
#define COUNTER0_PORT 0x40                                 // 计数器0的端口号
#define COUNTER0_NO 0                                      // 计数器号：0
#define COUNTER0_MODE 2                                    // 工作方式：方式2 比率发生器
#define READ_WRITE_LATCH 3
#define PIT_CONTROL_PORT 0x43

static void frequency_set(uint8_t counter_port,
                          uint8_t counter_no,
                          uint8_t rwl,
                          uint8_t counter_mode,
                          uint16_t counter_value){

    outb( PIT_CONTROL_PORT, (uint8_t) (counter_no << 6 | rwl << 4 | counter_mode << 1 ) );
    outb( counter_port,     (uint8_t)  counter_value );
    outb( counter_port,     (uint8_t) (counter_value >> 8) );
}

void timer_init(){
    put_str("timer init start\n");
    frequency_set(COUNTER0_PORT, COUNTER0_NO, READ_WRITE_LATCH, COUNTER0_MODE, COUNTER0_VALUE);
    put_str("timer init done\n");
}


