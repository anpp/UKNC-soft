#ifndef LIB_KEYB_H
#define LIB_KEYB_H

extern bool InitKeyb();
extern void FinishKeyb();
extern int kbhit();
extern void WaitAnyKey();
extern void SetOnKeyEvent(void *addr_func);

#endif //LIB_KEYB_H
