#include "list.h"
#include "interrupt.h"

// init list
void list_init(struct list* plist){
    plist->head.prev = NULL;
    plist->head.next = &plist->tail;
    plist->tail.prev = &plist->head;
    plist->tail.next = NULL;
}

// insert elem before provided node
void list_insert_before(struct list_elem* before, struct list_elem* elem){
    enum intr_status old_status = intr_disable();

    // [X]<->[before]
    // [X]<->[elem]<->[before]
    before->prev->next = elem;
    elem->prev = before->prev;
    elem->next = before;
    before->prev = elem;

    intr_set_status(old_status);
}


// insert elem to head of the list
void list_push_front(struct list* plist, struct list_elem* elem){
    // ([plist->head])<->[real-head]<->[...]
    list_insert_before(plist->head.next, elem);
}

// insert elem to the end of the list
void list_append(struct list* plist, struct list_elem* elem){
    //  [...]<->[real-tail]<->([plist->tail])
    list_insert_before(&plist->tail, elem);
}

// remove the elem from its list
void list_remove(struct list_elem* pelem){
    enum intr_status old_status = intr_disable();
    pelem->prev->next = pelem->next;
    pelem->next->prev = pelem->prev;
    intr_set_status(old_status);
}

// pop from head of the list
struct list_elem* list_pop_front(struct list* plist){
    struct list_elem* elem = plist->head.next;
    list_remove(elem);
    return elem;
}

// find if elem is in this list
bool list_elem_find(struct list* plist, struct list_elem* obj_elem){
    struct list_elem* elem = plist->head.next;
    while(elem != &plist->tail){
        if(elem == obj_elem){ return true; }
        elem = elem->next;
    }
    return false;
}

bool list_is_empty(struct list* plist){ return plist->head.next == plist->tail; }

uint32_t list_len(struct list* plist){
    struct list_elem* elem = plist->head.next;
    uint32_t length = 0;
    while( elem != &plist->tail ){ ++length; elem = elem->next; }
    return length;
}

// find the first elem that returns true for func(elem, arg) ... 
// I don't know why it was designed this way ...
struct list_elem* list_traversal(struct list* plist, function func, int arg){
    if(list_is_empty(plist)){ return NULL; }
    struct list_elem* elem = plist->head.next;
    while(elem != &plist->tail){
        if(func(elem, arg)){ return elem; } 
        elem = elem->next;
    }
    return NULL;
}










