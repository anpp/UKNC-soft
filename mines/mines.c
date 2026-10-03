#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"
#include "../libmouse/libmouse.h"
#include "../common/random.h"
#include "cell.h"

#define SCREEN_W   640
#define SCREEN_H   264

#define FIELD_W    30
#define FIELD_H    13
#define CELL_SIZE  20
#define TOTAL_MINES 50


typedef struct
{
    unsigned char x;
    unsigned char y;
} Point;

Point queue[FIELD_W * FIELD_H];
Cell board[FIELD_W][FIELD_H];
bool gameOver = false;
bool gameWon = false;

// Глобальные переменные для передачи клика из обработчика в main
volatile bool hasPendingClick = false;
volatile unsigned int pendingX = 0;
volatile unsigned int pendingY = 0;
volatile bool pendingLeft = true;

unsigned offset_x, offset_y; 

void drawButton(unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2)
{
    rect(x1, y1, x2, y2, COLOR_BLACK);
    fillRect(x1 + 1, y1 + 1, x2 - 1, y2 - 1, COLOR_CYAN);
    fillRect(x1 + 1, y1 + 1, x2 - 1, y1 + 2, COLOR_WHITE);
    fillRect(x1 + 1, y2 - 2, x2 - 1, y2 - 1, COLOR_MAGENTA);
    fillRect(x2 - 2, y1 + 2, x2 - 1, y2 - 1, COLOR_MAGENTA);
    fillRect(x1 + 1, y1 + 1, x1 + 2, y2 - 1, COLOR_WHITE);
}

void drawCell(int cx, int cy)
{
    unsigned int x1 = offset_x + cx * CELL_SIZE;
    unsigned int y1 = offset_y + cy * CELL_SIZE;
    unsigned int x2 = x1 + CELL_SIZE;
    unsigned int y2 = y1 + CELL_SIZE;

    Cell *c = &board[cx][cy];

    if(!Cell_isOpen(c))
    {
        drawButton(x1, y1, x2, y2);
        if (Cell_isFlagged(c))
            putText("P", x1 + 6, y1 + 3, COLOR_RED);
    } 
    else
    {
        fillRect(x1, y1, x2, y2, COLOR_WHITE);
        rect(x1, y1, x2, y2, COLOR_BLACK);

        if (Cell_isMine(c))
        {
            fillCircle(x1 + CELL_SIZE / 2, y1 + CELL_SIZE / 2, 4, COLOR_BLACK);
            putPixel(x1 + CELL_SIZE / 2, y1 + CELL_SIZE / 2, COLOR_RED);
        }
        else 
        if (Cell_getNeighborMines(c) > 0)
        {
            char digit = (char)('0' + Cell_getNeighborMines(c));
            
            unsigned int color = COLOR_BLUE;
            if (Cell_getNeighborMines(c) == 2) color = COLOR_GREEN;
            else 
            if (Cell_getNeighborMines(c) > 2) color = COLOR_RED;
            else 
            if (Cell_getNeighborMines(c) >= 4) color = COLOR_BLACK;

            putChar(digit, x1 + 6, y1 + 3, color);
        }
    }
}

void drawInitialBoard()
{
    for (int x = 0; x < FIELD_W; x++)
      for (int y = 0; y < FIELD_H; y++)
        drawCell(x, y);
}

void checkWinCondition()
{
    int closedOrFlaggedCount = 0;
    for (int x = 0; x < FIELD_W; x++)
    {
        for (int y = 0; y < FIELD_H; y++)
        {
            if (!Cell_isOpen(&board[x][y]))
                closedOrFlaggedCount++;
        }
    }
    if (closedOrFlaggedCount == TOTAL_MINES)
    {
        gameWon = true;
        gameOver = true;
        printTop(1, "YOU WIN! PRESS ANY KEY");
    }
}

void initGame()
{
    offset_x = (SCREEN_W / 2) - (FIELD_W * (CELL_SIZE / 2));
    offset_y = (SCREEN_H / 2) - (FIELD_H * (CELL_SIZE / 2));
    gameOver = false;
    gameWon = false;

    for (int x = 0; x < FIELD_W; x++)
    {
        for (int y = 0; y < FIELD_H; y++)
            Cell_init(&board[x][y]);
    }

    int placed = 0;
    while (placed < TOTAL_MINES)
    {
        int rx = random_range(0, FIELD_W - 1);
        int ry = random_range(0, FIELD_H - 1);
        if (!Cell_isMine(&board[rx][ry]))
        {
            Cell_setMine(&board[rx][ry], true);
            placed++;
        }
    }

    for (int x = 0; x < FIELD_W; x++)
    {
        for (int y = 0; y < FIELD_H; y++)
        {
            if (Cell_isMine(&board[x][y])) continue;
            
            unsigned int count = 0;
            for (int dx = -1; dx <= 1; dx++)
            {
                for (int dy = -1; dy <= 1; dy++)
                {
                    int nx = x + dx;
                    int ny = y + dy;
                    if (nx >= 0 && nx < FIELD_W && ny >= 0 && ny < FIELD_H)
                      if (Cell_isMine(&board[nx][ny])) count++;
                }
            }
            Cell_setNeighborMines(&board[x][y], count);
        }
    }
}

void openCell(int startX, int startY)
{
    if (startX < 0 || startX >= FIELD_W || startY < 0 || startY >= FIELD_H) return;
    if (Cell_isOpen(&board[startX][startY]) || Cell_isFlagged(&board[startX][startY])) return;

    if (Cell_isMine(&board[startX][startY]))
    {
        Cell_setOpen(&board[startX][startY], true);
        drawCell(startX, startY);
        gameOver = true;
        for (int i = 0; i < FIELD_W; i++)
        {
            for (int j = 0; j < FIELD_H; j++)
            {
                if (Cell_isMine(&board[i][j]) && !Cell_isOpen(&board[i][j]))
                {
                    Cell_setOpen(&board[i][j], true);
                    drawCell(i, j);
                }
            }
        }
        printTop(1, "BOOM! PRESS ANY KEY");
        return;
    }

    int head = 0;
    int tail = 0;

    Cell_setOpen(&board[startX][startY], true);
    drawCell(startX, startY);

    queue[tail].x = startX;
    queue[tail].y = startY;
    tail++;

    while (head < tail)
    {
        Point p = queue[head++];

        if(Cell_getNeighborMines(&board[p.x][p.y]) == 0)
        {
            for (int dx = -1; dx <= 1; dx++)
            {
                for (int dy = -1; dy <= 1; dy++)
                {
                    if (dx == 0 && dy == 0) continue;

                    int nx = p.x + dx;
                    int ny = p.y + dy;

                    if (nx >= 0 && nx < FIELD_W && ny >= 0 && ny < FIELD_H)
                    {
                        if (!Cell_isOpen(&board[nx][ny]) && !Cell_isFlagged(&board[nx][ny]))
                        {
                            Cell_setOpen(&board[nx][ny], true);
                            drawCell(nx, ny);

                            queue[tail].x = nx;
                            queue[tail].y = ny;
                            tail++;
                        }
                    }
                }
            }
        }
    }
}

// Легковесный обработчик: передает клик в главный цикл
void OnClickEvent(unsigned x, unsigned y, bool isLeft) 
{
    pendingX = x;
    pendingY = y;
    pendingLeft = isLeft;
    hasPendingClick = true;
}

void processClick(unsigned x, unsigned y, bool isRight) 
{
    if (gameOver) return;

    if (x < offset_x || y < offset_y) return;
    int cx = (x - offset_x) / CELL_SIZE;
    int cy = (y - offset_y) / CELL_SIZE;

    if (cx < 0 || cx >= FIELD_W || cy < 0 || cy >= FIELD_H) return;

    hideMouse();

    if (isRight) 
    { 
        if(!Cell_isOpen(&board[cx][cy])) 
        {
            Cell_toggleFlag(&board[cx][cy]);
            drawCell(cx, cy);
        }
    }
    else 
    {
        if(!Cell_isFlagged(&board[cx][cy])) 
        {
            openCell(cx, cy);
            if (!gameOver)
                checkWinCondition();
        }
    }

    showMouse();
}

void main() 
{
    if (!initMouse()) return;
    if (!initKeyb()) return;
    if (!initGraph()) return;

    random_init(500);

    clearScreen();
    printTop(1, "MINESWEEPER");

    initGame();

    hideMouse();
    drawInitialBoard();
    showMouse();

    setOnClick(OnClickEvent);

    while (!gameOver) 
    {
        if (hasPendingClick) 
        {
            hasPendingClick = false;
            processClick(pendingX, pendingY, !pendingLeft);
        }
    }

    waitAnyKey();

    printTop(1, "                                 ");

    finishGraph();
    finishMouse();
    finishKeyb();
}
