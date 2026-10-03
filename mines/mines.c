#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"
#include "../libmouse/libmouse.h"
#include "../common/random.h"
#include "cell.h"

#define SCREEN_W   640
#define SCREEN_H   264

#define CELL_SIZE  18

#define HEADER_H 32
#define MAX_FIELD_W  (SCREEN_W / CELL_SIZE)
#define MAX_FIELD_H  ((SCREEN_H - HEADER_H) / CELL_SIZE)

#define MENU_BTN_W 160
#define MENU_BTN_H 30
#define MENU_BTN_STEP 34

typedef enum
{
    STATE_MENU,
    STATE_GAME,
    STATE_EXIT
} GameState;

const char *menuLabels[] = {
    "BEGINNER",
    "AMATEUR",
    "PROFESSIONAL",
    "EXIT"
};

typedef struct
{
    unsigned char x;
    unsigned char y;
} Point;

int field_w = 9;
int field_h = 9;
int total_mines = 10;

Point queue[MAX_FIELD_W * MAX_FIELD_H];
Cell board[MAX_FIELD_W][MAX_FIELD_H];
bool gameOver = false;
bool gameWon = false;
bool firstClick = true;
GameState currentState = STATE_MENU;

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

void drawPressedButton(unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2)
{
    rect(x1, y1, x2, y2, COLOR_BLACK);
    fillRect(x1 + 1, y1 + 1, x2 - 1, y2 - 1, COLOR_CYAN);
    fillRect(x1 + 1, y1 + 1, x2 - 1, y1 + 2, COLOR_MAGENTA);
    fillRect(x1 + 1, y2 - 2, x2 - 1, y2 - 1, COLOR_WHITE);
    fillRect(x2 - 2, y1 + 2, x2 - 1, y2 - 1, COLOR_WHITE);
    fillRect(x1 + 1, y1 + 1, x1 + 2, y2 - 1, COLOR_MAGENTA);
}

void drawMenuButton(int index, bool pressed)
{
    unsigned int x1 = (SCREEN_W - MENU_BTN_W) / 2;
    unsigned int y1 = (SCREEN_H - (4 * MENU_BTN_STEP)) / 2 + index * MENU_BTN_STEP;
    unsigned int x2 = x1 + MENU_BTN_W;
    unsigned int y2 = y1 + MENU_BTN_H;

    if(pressed)
      drawPressedButton(x1, y1, x2, y2);
    else
      drawButton(x1, y1, x2, y2);
    
    const char *label = menuLabels[index];
    int textLen = 0;
    while (label[textLen] != '\0') textLen++;
    unsigned int textX = x1 + (MENU_BTN_W - textLen * 8) / 2;
    unsigned int textY = y1 + (MENU_BTN_H - 8) / 2;
    
    if(pressed)
    {
      textX += 2;
      textY += 2;
    }    

    putText1(label, textX, textY, COLOR_BLACK, 1);
}

void drawMenu()
{
    hideMouse();
    clearScreen();
    printTop(1, "MINESWEEPER - MAIN MENU");
    
    drawMenuButton(0, false);
    drawMenuButton(1, false);
    drawMenuButton(2, false);
    drawMenuButton(3, false);
    showMouse();
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
            putChar('P', x1 + 6, y1 + 4, COLOR_RED, 2);
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
            switch(Cell_getNeighborMines(c))
            {
            case 1: 
                color = COLOR_BLUE;
                break;
            case 2: 
                color = COLOR_GREEN;
                break;
            case 3: 
                color = COLOR_RED;
                break;
            default:
              color = COLOR_BLACK;
            }
            putChar(digit, x1 + 6, y1 + 4, color, 2);
        }
    }
}

void drawInitialBoard()
{
    gameOver = false;
    gameWon = false;
    firstClick = true;

    offset_x = (SCREEN_W / 2) - (field_w * CELL_SIZE / 2);
    offset_y = ((SCREEN_H + 30) / 2) - (field_h * CELL_SIZE / 2); //по вертикале оставляем свободное место наверху

    for (int x = 0; x < field_w; x++)
    {
        for (int y = 0; y < field_h; y++)
            Cell_init(&board[x][y]);
    }

    for (int x = 0; x < field_w; x++)
      for (int y = 0; y < field_h; y++)
        drawCell(x, y);
}

void checkWinCondition()
{
    int closedOrFlaggedCount = 0;
    for (int x = 0; x < field_w; x++)
    {
        for (int y = 0; y < field_h; y++)
        {
            if (!Cell_isOpen(&board[x][y]))
                closedOrFlaggedCount++;
        }
    }
    if (closedOrFlaggedCount == total_mines)
    {
        gameWon = true;
        gameOver = true;
        printTop(1, "YOU WIN! PRESS ANY KEY");
    }
}

void generateMines(int safeX, int safeY)
{
    random_init(getFrameCount());

    int placed = 0;
    while (placed < total_mines)
    {
        int rx = random_range(0, field_w - 1);
        int ry = random_range(0, field_h - 1);
        
        // Не ставим мину в ячейку первого клика
        if (rx == safeX && ry == safeY) continue;

        if (!Cell_isMine(&board[rx][ry]))
        {
            Cell_setMine(&board[rx][ry], true);
            placed++;
        }
    }

    // Расчет цифр-соседей
    for (int x = 0; x < field_w; x++)
    {
        for (int y = 0; y < field_h; y++)
        {
            if (Cell_isMine(&board[x][y])) continue;
            
            unsigned int count = 0;
            for (int dx = -1; dx <= 1; dx++)
            {
                for (int dy = -1; dy <= 1; dy++)
                {
                    int nx = x + dx;
                    int ny = y + dy;
                    if (nx >= 0 && nx < field_w && ny >= 0 && ny < field_h)
                        if (Cell_isMine(&board[nx][ny])) count++;
                }
            }
            Cell_setNeighborMines(&board[x][y], count);
        }
    }
}

void openCell(int startX, int startY)
{
    if (startX < 0 || startX >= field_w || startY < 0 || startY >= field_h) return;
    if (Cell_isOpen(&board[startX][startY]) || Cell_isFlagged(&board[startX][startY])) return;

    if (Cell_isMine(&board[startX][startY]))
    {
        Cell_setOpen(&board[startX][startY], true);
        drawCell(startX, startY);
        gameOver = true;
        for (int i = 0; i < field_w; i++)
        {
            for (int j = 0; j < field_h; j++)
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

                    if (nx >= 0 && nx < field_w && ny >= 0 && ny < field_h)
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

void processMenuClick(unsigned x, unsigned y)
{
    unsigned int btnX1 = (SCREEN_W - MENU_BTN_W) / 2;
    unsigned int btnX2 = btnX1 + MENU_BTN_W;

    if (x < btnX1 || x > btnX2) return;

    for (int i = 0; i < 4; i++)
    {
        unsigned int btnY1 = (SCREEN_H - (4 * MENU_BTN_STEP)) / 2 + i * MENU_BTN_STEP;
        unsigned int btnY2 = btnY1 + MENU_BTN_H;

        if (y >= btnY1 && y <= btnY2)
        {
            hideMouse();
            drawMenuButton(i, true);
            showMouse(); 
            if (i == 0)
            {
                field_w = 9;
                field_h = 9;
                total_mines = 10;
                currentState = STATE_GAME;
            }
            else if (i == 1)
            {
                field_w = 18;
                field_h = 12;
                total_mines = 40;
                currentState = STATE_GAME;
            }
            else if (i == 2)
            {
                field_w = 35;
                field_h = 13;
                total_mines = 99;
                currentState = STATE_GAME;
            }
            else if (i == 3)
                currentState = STATE_EXIT;
            break;
        }
    }
}

void processClick(unsigned x, unsigned y, bool isRight) 
{
    if (currentState == STATE_MENU)
    {
        if (!isRight)
            processMenuClick(x, y);
        return;
    }

    if (gameOver) return;

    if (x < offset_x || y < offset_y) return;
    int cx = (x - offset_x) / CELL_SIZE;
    int cy = (y - offset_y) / CELL_SIZE;

    if (cx < 0 || cx >= field_w || cy < 0 || cy >= field_h) return;

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
            if (firstClick)
            {
                generateMines(cx, cy);
                firstClick = false;
            }

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

    setOnClick(OnClickEvent);

    while (currentState != STATE_EXIT)
    {
        if (currentState == STATE_MENU)
        {
            drawMenu();

            while (currentState == STATE_MENU)
            {
                if (hasPendingClick)
                {
                    hasPendingClick = false;
                    processClick(pendingX, pendingY, !pendingLeft);
                }
            }
        }
        else if (currentState == STATE_GAME)
        {
            hideMouse();
            clearScreen();
            printTop(1, "                                 ");
            printTop(1, "MINESWEEPER");

            drawInitialBoard();
            showMouse();

            while (!gameOver && currentState == STATE_GAME)
            {
                if (hasPendingClick)
                {
                    hasPendingClick = false;
                    processClick(pendingX, pendingY, !pendingLeft);
                }
            }

            if (gameOver)
            {
                waitAnyKey();
                currentState = STATE_MENU;
            }
        }
    }

    printTop(1, "                                 ");

    hideMouse();
    resetScreen();

    finishGraph();
    finishMouse();
    finishKeyb();
}
