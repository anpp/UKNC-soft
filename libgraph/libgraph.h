#ifndef LIB_GRAPH_H
#define LIB_GRAPH_H

extern void initGraph();
extern void finishGraph();
extern void clearScreen();
extern void putPixel(unsigned int x,unsigned int y, unsigned int color);
extern unsigned int getPixel(unsigned int x, unsigned int y);
extern void printTop(unsigned position, char *buffer);
extern void printBottom(unsigned position, char *buffer);
extern void invertScreen();
extern void line(unsigned int x1,unsigned int y1, unsigned int x2,unsigned int y2, unsigned int color);
extern void fillRect(unsigned int x1,unsigned int y1, unsigned int x2,unsigned int y2, unsigned int color);
extern void putChar(char ch, unsigned int x, unsigned int y, unsigned int color);


void rect(unsigned int x1,unsigned int y1, unsigned int x2,unsigned int y2, unsigned int color)
{
    fillRect(x1, y1, x1, y2, color);
    fillRect(x1, y1, x2, y1, color);
    fillRect(x2, y1, x2, y2, color);
    fillRect(x1, y2, x2, y2, color);
}


void putText(const char *str, unsigned int x, unsigned int y, unsigned int color) 
{
    for (; *str; x += 8)
        putChar(*str++, x, y, color);
}

//putText с обработкой переносов
void putText1(const char *str, unsigned int x, unsigned int y, unsigned int color) 
{
    for (unsigned int start_x = x; *str; str++) 
    {
        if (*str == '\n') 
        {
            x = start_x;
            y += 11; 
            continue;
        }
        putChar(*str, x, y, color);
        x += 8;
    }
}

#endif //LIB_GRAPH_H
