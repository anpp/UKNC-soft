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
        FillRect(x, 0, x, HEIGHT - 1, 7);
    }
    // Горизонтальные линии (y = 0, 10, 20, ..., 264)
    for (int y = 0; y < HEIGHT; y += 10) {
        FillRect(0, y, WIDTH - 1, y, 7);
    }
    // ---------------------------------
 
Line(10, 10, 600, 200, 7);
Line(350, 200, 0, 0, 6);

Line(10, 200, 150, 10, 5);
Line(150, 30, 10, 220, 5);

Line(0, 200, 600, 10, 3);
Line(620, 30, 20, 220, 3);


Line(500, 250, 200, 40, 4);

    FillRect(200, 100, 500, 180, 6);
    FillRect(198, 181, 502, 205, 3);

    FillRect(80, 50, 82, 100, 2);

    WaitAnyKey();
    PrintTop(1, "              ");

    FinishGraph();    
    FinishKeyb();    
}
