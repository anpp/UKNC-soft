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


    PrintTop(1, "              ");
    FinishGraph();    
    FinishKeyb();    
}
