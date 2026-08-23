#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"

#define WIDTH   640
#define HEIGHT  264

void main()
{
    InitKeyb();
    InitGraph();

    PrintTop(1, "INVERT SCREEN");
    PrintBottom(1, "PRESS ANY KEY");

    InvertScreen();
    WaitAnyKey();
    InvertScreen();

    PrintTop(1, "                   ");
    PrintBottom(1, "                ");
    
    FinishGraph();    
    FinishKeyb();    
}
