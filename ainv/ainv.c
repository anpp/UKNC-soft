#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"
#include "random.h"

#define WIDTH   640
#define HEIGHT  264



void main()
{
    initKeyb();
    initGraph();
    clearScreen();


    printTop(1, "ASCII INVADERS");

    putText("                _ _   _                     _               ",(WIDTH / 2) - 240, 20, 7);
    putText("  __ _ ___  ___(_|_) (_)_ ____   ____ _  __| | ___ _ __ ___ ", (WIDTH / 2) - 240, 30, 7);
    putText(" / _` / __|/ __| | | | | '_ \\ \\ / / _` |/ _` |/ _ \\ '__/ __|", (WIDTH / 2) - 240, 40, 7);
    putText("| (_| \\__ \\ (__| | | | | | | \\ V / (_| | (_| |  __/ |  \\__ \\", (WIDTH / 2) - 240, 50, 7);
    putText(" \\__,_|___/\\___|_|_| |_|_| |_|\\_/ \\__,_|\\__,_|\\___|_|  |___/", (WIDTH / 2) - 240, 60, 7);


    putText2("                _ _   _                     _               ",(WIDTH / 2) - 240, 80, 7);
    putText2("  __ _ ___  ___(_|_) (_)_ ____   ____ _  __| | ___ _ __ ___ ", (WIDTH / 2) - 240, 90, 7);
    putText2(" / _` / __|/ __| | | | | '_ \\ \\ / / _` |/ _` |/ _ \\ '__/ __|", (WIDTH / 2) - 240, 100, 7);
    putText2("| (_| \\__ \\ (__| | | | | | | \\ V / (_| | (_| |  __/ |  \\__ \\", (WIDTH / 2) - 240, 110, 7);
    putText2(" \\__,_|___/\\___|_|_| |_|_| |_|\\_/ \\__,_|\\__,_|\\___|_|  |___/", (WIDTH / 2) - 240, 120, 7);


putText("Text!!!", 249, 200, 6);

    waitAnyKey();
    printTop(1, "              ");

    finishGraph();    
    finishKeyb();    
}
