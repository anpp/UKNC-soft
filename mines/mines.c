#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"
#include "../libmouse/libmouse.h"
#include "../common/random.h"

#define SCREEN_W   640
#define SCREEN_H   264

#define FIELD_W    10
#define FIELD_H    10
#define CELL_SIZE  20
#define OFFSET_X   220
#define OFFSET_Y   32
#define TOTAL_MINES 12

#define COLOR_BLACK   0
#define COLOR_BLUE    1
#define COLOR_RED     2
#define COLOR_MAGENTA 3
#define COLOR_GREEN   4
#define COLOR_CYAN    5
#define COLOR_YELLOW  6
#define COLOR_WHITE   7


typedef struct
{
    bool isMine;
    bool isOpen;
    bool isFlagged;
    unsigned int neighborMines;
} Cell;

typedef struct
{
    int x;
    int y;
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
    unsigned int x1 = OFFSET_X + cx * CELL_SIZE;
    unsigned int y1 = OFFSET_Y + cy * CELL_SIZE;
    unsigned int x2 = x1 + CELL_SIZE;
    unsigned int y2 = y1 + CELL_SIZE;

    Cell *c = &board[cx][cy];

    if (!c->isOpen)
    {
        drawButton(x1, y1, x2, y2);
        if (c->isFlagged)
            putText("P", x1 + 6, y1 + 3, COLOR_RED);
    } 
    else
    {
        fillRect(x1, y1, x2, y2, COLOR_WHITE);
        rect(x1, y1, x2, y2, COLOR_BLACK);

        if (c->isMine)
        {
            fillCircle(x1 + CELL_SIZE / 2, y1 + CELL_SIZE / 2, 4, COLOR_BLACK);
            putPixel(x1 + CELL_SIZE / 2, y1 + CELL_SIZE / 2, COLOR_RED);
        }
        else 
        if (c->neighborMines > 0)
        {
            char digit = (char)('0' + c->neighborMines);
            
            unsigned int color = COLOR_BLUE;
            if (c->neighborMines == 2) color = COLOR_GREEN;
            else 
            if (c->neighborMines > 2) color = COLOR_RED;
            else 
            if (c->neighborMines >= 4) color = COLOR_BLACK;

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
            if (!board[x][y].isOpen)
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
    gameOver = false;
    gameWon = false;

    for (int x = 0; x < FIELD_W; x++)
    {
        for (int y = 0; y < FIELD_H; y++)
        {
            board[x][y].isMine = false;
            board[x][y].isOpen = false;
            board[x][y].isFlagged = false;
            board[x][y].neighborMines = 0;
        }
    }

    int placed = 0;
    while (placed < TOTAL_MINES)
    {
        int rx = random_range(0, FIELD_W - 1);
        int ry = random_range(0, FIELD_H - 1);
        if (!board[rx][ry].isMine)
        {
            board[rx][ry].isMine = true;
            placed++;
        }
    }

    for (int x = 0; x < FIELD_W; x++)
    {
        for (int y = 0; y < FIELD_H; y++)
        {
            if (board[x][y].isMine) continue;
            
            unsigned int count = 0;
            for (int dx = -1; dx <= 1; dx++)
            {
                for (int dy = -1; dy <= 1; dy++)
                {
                    int nx = x + dx;
                    int ny = y + dy;
                    if (nx >= 0 && nx < FIELD_W && ny >= 0 && ny < FIELD_H)
                      if (board[nx][ny].isMine) count++;
                }
            }
            board[x][y].neighborMines = count;
        }
    }
}

void openCell(int startX, int startY)
{
    if (startX < 0 || startX >= FIELD_W || startY < 0 || startY >= FIELD_H) return;
    if (board[startX][startY].isOpen || board[startX][startY].isFlagged) return;

    if (board[startX][startY].isMine)
    {
        board[startX][startY].isOpen = true;
        drawCell(startX, startY);
        gameOver = true;
        for (int i = 0; i < FIELD_W; i++)
        {
            for (int j = 0; j < FIELD_H; j++)
            {
                if (board[i][j].isMine && !board[i][j].isOpen)
                {
                    board[i][j].isOpen = true;
                    drawCell(i, j);
                }
            }
        }
        printTop(1, "BOOM! PRESS ANY KEY");
        return;
    }

    int head = 0;
    int tail = 0;

    board[startX][startY].isOpen = true;
    drawCell(startX, startY);

    queue[tail].x = startX;
    queue[tail].y = startY;
    tail++;

    while (head < tail)
    {
        Point p = queue[head++];

        if (board[p.x][p.y].neighborMines == 0)
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
                        if (!board[nx][ny].isOpen && !board[nx][ny].isFlagged)
                        {
                            board[nx][ny].isOpen = true;
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

    if (x < OFFSET_X || y < OFFSET_Y) return;
    int cx = (x - OFFSET_X) / CELL_SIZE;
    int cy = (y - OFFSET_Y) / CELL_SIZE;

    if (cx < 0 || cx >= FIELD_W || cy < 0 || cy >= FIELD_H) return;

    hideMouse();

    if (isRight) 
    { 
        if (!board[cx][cy].isOpen) 
        {
            board[cx][cy].isFlagged = !board[cx][cy].isFlagged;
            drawCell(cx, cy);
        }
    }
    else 
    {
        if (!board[cx][cy].isFlagged) 
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
