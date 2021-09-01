#ifndef __THREAD_THREAD_H
#define __THREAD_THREAD_H
#include "stdint.h"

typedef void thread_func(void*);   // 定义 thread_func 函数指针类型
// 函数指针参考：https://www.cnblogs.com/windlaughing/archive/2013/04/10/3012012.html

enum task_status {
    TASK_RUNNING,
    TASK_READY,
    TASK_BLOCKED,
    TASK_WAITING,
    TASK_HANGNG,
    TASK_DIED
};

// 中断栈
struct intr_stack {
    uint32_t vec_no;
    
    uint32_t edi, esi, ebp, esp_dummp;
    uint32_t ebx, edx, ecx, eax, gs, fs, es, ds;

    uint32_t err_code; 
    void (*eip) (void);
    uint32_t cs;
    uint32_t eflags;
    void* esp;
    uint32_t ss;
};

struct thread_stack {
    uint32_t ebp, ebx, edi, esi;
    void (*eip) (thread_func* func, void* func_arg);
    void (*unused_retaddr);
    thread_func* function;
    void* func_arg;
};

struct task_struct {
    uint32_t* self_kstack;
    enum task_status status;
    uint8_t priority;
    char name[16];
    uint32_t stack_magic;
};


void thread_create(struct task_struct* pthread, thread_func function, void* func_arg);
struct task_struct* thread_start(char* name, int prio, thread_func function, void* func_arg);
void init_thread(struct task_struct* pthread, char* name, int prio);

#endif
