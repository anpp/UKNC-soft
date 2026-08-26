#ifndef LIB_GRAPH_H
#define LIB_GRAPH_H

extern void InitGraph();
extern void FinishGraph();
extern void ClearScreen();
extern void PutPixel(unsigned int x,unsigned int y, unsigned int color);
extern unsigned int GetPixel(unsigned int x, unsigned int y);
extern void PrintTop(unsigned position, char *buffer);
extern void PrintBottom(unsigned position, char *buffer);
extern void InvertScreen();
extern void Line(unsigned int x1,unsigned int y1, unsigned int x2,unsigned int y2, unsigned int color);

#endif //LIB_GRAPH_H
