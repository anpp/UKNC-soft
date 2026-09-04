#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"

#define WIDTH   640
#define HEIGHT  264

void main()
{
    initKeyb();
    initGraph();

    printTop(1, "INVERT SCREEN");
    printBottom(1, "PRESS ANY KEY");

    invertScreen();
    waitAnyKey();
    invertScreen();

    printTop(1, "                   ");
    printBottom(1, "                ");
    
    finishGraph();    
    finishKeyb();    
}
