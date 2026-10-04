#ifndef LIB_KEYB_H
#define LIB_KEYB_H

#define KEY_AR2    06
#define KEY_SPACE  0113


extern bool initKeyb();
extern void finishKeyb();
extern int kbhit();
extern void waitAnyKey();
extern void setOnKeyEvent(void *addr_func);

#endif //LIB_KEYB_H
