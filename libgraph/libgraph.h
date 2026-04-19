#ifndef LIB_GRAPH_H
#define LIB_GRAPH_H

extern void InitGraph();
extern void FinishGraph();
extern void ClearScreen();
extern void PutPixel(unsigned int x,unsigned int y, unsigned int color);
extern unsigned int GetPixel(unsigned int x, unsigned int y);
extern void PrintTop(unsigned position, char *buffer);
extern void PrintBottom(unsigned position, char *buffer);

#endif //LIB_GRAPH_H
