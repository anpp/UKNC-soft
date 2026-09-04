#ifndef LIB_KEYB_H
#define LIB_KEYB_H

extern bool initKeyb();
extern void finishKeyb();
extern int kbhit();
extern void waitAnyKey();
extern void setOnKeyEvent(void *addr_func);

#endif //LIB_KEYB_H
