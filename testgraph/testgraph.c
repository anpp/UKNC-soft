#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"

#define WIDTH   640
#define HEIGHT  264

void main()
{
    initKeyb();
    initGraph();
    clearScreen();

    printTop(1, "TEST GRAPH LIB");
                                      
    // ---- Рисуем сетку с шагом 10 ----
    // Вертикальные линии (x = 0, 10, 20, ..., 640)
 /*
    for (int x = 0; x < WIDTH; x += 10) {
        fillRect(x, 0, x, HEIGHT - 1, 7);
    }
    // Горизонтальные линии (y = 0, 10, 20, ..., 264)
    for (int y = 0; y < HEIGHT; y += 10) {
        fillRect(0, y, WIDTH - 1, y, 7);
    }
    // ---------------------------------
*/ 
line(10, 10, 600, 200, 7);
line(350, 200, 0, 0, 6);

line(10, 200, 150, 10, 5);
line(150, 30, 10, 220, 5);

line(0, 200, 600, 10, 3);
line(620, 30, 20, 220, 3);


line(500, 250, 200, 40, 4);

    fillRect(200, 100, 500, 180, 0);
    fillRect(198, 181, 502, 205, 3);

    fillRect(80, 50, 82, 100, 2);

    //прямоугольник с окантовкой
    rect(50, 60, 400, 120, 1);
    fillRect(51, 61, 399, 119, 6);

    putChar('A', 55, 220, 4);
    putChar('A', 56, 228, 5);
    putChar('A', 57, 236, 4);

    putText("Text!", 58, 200, 7);

    waitAnyKey();
    printTop(1, "              ");

    finishGraph();    
    finishKeyb();    
}
