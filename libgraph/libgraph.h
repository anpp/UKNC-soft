#ifndef LIB_GRAPH_H
#define LIB_GRAPH_H

#define COLOR_BLACK   0
#define COLOR_BLUE    1
#define COLOR_RED     2
#define COLOR_MAGENTA 3
#define COLOR_GREEN   4
#define COLOR_CYAN    5
#define COLOR_YELLOW  6
#define COLOR_WHITE   7


extern bool initGraph();
extern void finishGraph();
extern void clearScreen();
extern void putPixel(int x, int y, unsigned int color);
extern unsigned int getPixel(int x, int y);
extern void printTop(unsigned position, const char *buffer);
extern void printBottom(unsigned position, const char *buffer);
extern void invertScreen();
extern void line(int x1, int y1, int x2, int y2, unsigned int color);
extern void fillRect(int x1, int y1, int x2, int y2, unsigned int color);
extern void putChar(char ch, int x, int y, unsigned int color, unsigned int bold_value);
extern void putText(const char *str, int x, int y, unsigned int color);
extern void circle(int x, int y, unsigned int r, unsigned int color);
extern void fillCircle(int x, int y, unsigned int r, unsigned int color);
extern unsigned int getFrameCount();


void rect(int x1, int y1, int x2, int y2, unsigned int color)
{
    fillRect(x1, y1, x1, y2, color);
    fillRect(x1, y1, x2, y1, color);
    fillRect(x2, y1, x2, y2, color);
    fillRect(x1, y2, x2, y2, color);
}

/*
void putText2(const char *str, unsigned int x, unsigned int y, unsigned int color) 
{
    for (; *str; x += 8)
        putChar(*str++, x, y, color);
}
*/

//putText с обработкой переносов
void putText1(const char *str, int x, int y, unsigned int color, unsigned int bold_value) 
{
    for (unsigned int start_x = x; *str; str++) 
    {
        if (*str == '\n') 
        {
            x = start_x;
            y += 11; 
            continue;
        }
        putChar(*str, x, y, color, bold_value);
        x += 8;
    }
}

void outK0(char *a)
{
    register char *regK0 = (char *)0177564;
    while(*a != 0)
    {
        while((*regK0 & 0200)==0);
        regK0[2]=(*a++);
    }
}


void resetScreen()
{
    outK0("\033%!3\f");
}


#endif //LIB_GRAPH_H
