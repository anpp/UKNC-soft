#ifndef LIB_MOUSE_H
#define LIB_MOUSE_H

extern bool initMouse();
extern void finishMouse();
extern void setOnClick(void *addr_func);
extern void showMouse();
extern void hideMouse();
bool isRightButtonClick() {return false;};

#endif //LIB_MOUSE_H
