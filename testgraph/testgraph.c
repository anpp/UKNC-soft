#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"

#define WIDTH   640
#define HEIGHT  264

void main()
{
    InitKeyb();
    InitGraph();
    ClearScreen();

    PrintTop(1, "TEST GRAPH LIB");

    // ---- Рисуем сетку с шагом 10 ----
    // Вертикальные линии (x = 0, 10, 20, ..., 640)
    for (int x = 0; x < WIDTH; x += 10) {
        Line(x, 0, x, HEIGHT - 1, 7);
    }
    // Горизонтальные линии (y = 0, 10, 20, ..., 264)
    for (int y = 0; y < HEIGHT; y += 10) {
        Line(0, y, WIDTH - 1, y, 7);
    }
    // ---------------------------------

    WaitAnyKey();
    PrintTop(1, "              ");

    FinishGraph();    
    FinishKeyb();    
}
