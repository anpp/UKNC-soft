#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"
#include "../libmouse/libmouse.h"
#include "../common/random.h"
#include "cell.h"

#define SCREEN_W   640
#define SCREEN_H   264

#define SMILE_W    28
#define SMILE_H    28
#define CELL_SIZE  18

#define HEADER_H 30
#define MAX_FIELD_W  (SCREEN_W / CELL_SIZE)
#define MAX_FIELD_H  ((SCREEN_H - HEADER_H) / CELL_SIZE)

#define MENU_BTN_W 160
#define MENU_BTN_H 30
#define MENU_BTN_STEP 34

typedef enum
{
    STATE_MENU,
    STATE_GAME,
    STATE_EXIT,
    STATE_INIT,
    STATE_MOUSEDOWN
} GameState;

typedef enum
{
    SMILE_INIT,
    SMILE_NORMAL,
    SMILE_WIN,
    SMILE_DEAD
} SmileState;


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

Point currentCell;
bool  hasCurrentCell = false;

int field_w = 9;
int field_h = 9;
int total_mines = 10;

Point queue[MAX_FIELD_W * MAX_FIELD_H];

Cell board[MAX_FIELD_W][MAX_FIELD_H];
Cell board_copy[MAX_FIELD_W][MAX_FIELD_H];

bool gameOver = false;
bool gameWon = false;
bool firstClick = true;
volatile GameState currentState = STATE_MENU;
char currentMode = -1;
bool initBySmile = false;

int smileX, smileY;

char* emptystr = "                                 ";


// Глобальные переменные для передачи клика из обработчика в main
volatile bool hasPendingClick = false;
volatile int pendingX = 0;
volatile int pendingY = 0;
volatile bool pendingLeft = true;
volatile bool pendingDown;

int offset_x, offset_y; 


void drawFlag(int x, int y)
{
    fillRect(x, y, x + 1, y + 8, COLOR_BLACK);
    fillRect(x - 4, y + 8, x + 5, y + 8, COLOR_BLACK);
    fillRect(x - 6, y, x, y + 3, COLOR_RED);
}


void drawButton(int x1, int y1, int x2, int y2)
{
    rect(x1, y1, x2, y2, COLOR_BLACK);
    fillRect(x1 + 1, y1 + 1, x2 - 1, y2 - 1, COLOR_CYAN);
    fillRect(x1 + 1, y1 + 1, x2 - 1, y1 + 2, COLOR_WHITE);
    fillRect(x1 + 1, y2 - 2, x2 - 1, y2 - 1, COLOR_MAGENTA);
    fillRect(x2 - 2, y1 + 2, x2 - 1, y2 - 1, COLOR_MAGENTA);
    fillRect(x1 + 1, y1 + 1, x1 + 2, y2 - 1, COLOR_WHITE);
}

void drawPressedButton(int x1, int y1, int x2, int y2)
{
    rect(x1, y1, x2, y2, COLOR_BLACK);
    fillRect(x1 + 1, y1 + 1, x2 - 1, y2 - 1, COLOR_CYAN);
    fillRect(x1 + 1, y1 + 1, x2 - 1, y1 + 2, COLOR_MAGENTA);
    fillRect(x1 + 1, y2 - 2, x2 - 1, y2 - 1, COLOR_WHITE);
    fillRect(x2 - 2, y1 + 2, x2 - 1, y2 - 1, COLOR_WHITE);
    fillRect(x1 + 1, y1 + 1, x1 + 2, y2 - 1, COLOR_MAGENTA);
}

void drawSmile(int x, int y, SmileState st)
{
    int xc = x + (SMILE_W / 2);
    int yc = y + (SMILE_H / 2);
    fillCircle(xc, yc, (SMILE_W / 2) - 6, COLOR_YELLOW);
    circle(xc, yc, (SMILE_W / 2) - 6, COLOR_BLUE);

    switch(st)
    {
    case SMILE_INIT:
        fillCircle(xc - 4, yc - 2, 1, COLOR_BLACK);
        fillCircle(xc + 4, yc - 2, 1, COLOR_BLACK);
        fillRect(xc - 3, yc + 5, xc + 3, yc + 5, COLOR_BLACK);
        break;
    case SMILE_DEAD:
        putChar('*', xc - 8, yc - 6, COLOR_BLACK, 0);
        putChar('*', xc + 0, yc - 6, COLOR_BLACK, 0);
 
        fillRect(xc - 1, yc + 3, xc + 1, yc + 3, COLOR_BLACK);
        putPixel(xc - 2, yc + 4, COLOR_BLACK);
        putPixel(xc - 3, yc + 5, COLOR_BLACK);
        putPixel(xc + 2, yc + 4, COLOR_BLACK);
        putPixel(xc + 3, yc + 5, COLOR_BLACK);
        break;
    case SMILE_NORMAL:
        fillCircle(xc - 4, yc - 2, 1, COLOR_BLACK);
        fillCircle(xc + 4, yc - 2, 1, COLOR_BLACK);

        fillRect(xc - 1, yc + 5, xc + 1, yc + 5, COLOR_BLACK);
        putPixel(xc - 2, yc + 4, COLOR_BLACK);
        putPixel(xc - 3, yc + 3, COLOR_BLACK);
        putPixel(xc + 2, yc + 4, COLOR_BLACK);
        putPixel(xc + 3, yc + 3, COLOR_BLACK);
        break;
    case SMILE_WIN:
        fillCircle(xc - 4, yc - 2, 3, COLOR_BLACK);
        fillCircle(xc + 4, yc - 2, 3, COLOR_BLACK);
        fillRect(xc - 2, yc - 4, xc + 2, yc - 3, COLOR_BLACK);

        fillRect(xc - 1, yc + 4, xc + 1, yc + 4, COLOR_BLACK);
        fillRect(xc - 1, yc + 5, xc + 1, yc + 5, COLOR_BLACK);
        putPixel(xc - 2, yc + 4, COLOR_BLACK);
        putPixel(xc - 3, yc + 3, COLOR_BLACK);
        putPixel(xc + 2, yc + 4, COLOR_BLACK);
        putPixel(xc + 3, yc + 3, COLOR_BLACK);

        break;
    default:
        break;
    }
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
    printTop(1, emptystr);
    printTop(1, "MINESWEEPER - MAIN MENU");
    
    drawMenuButton(0, false);
    drawMenuButton(1, false);
    drawMenuButton(2, false);
    drawMenuButton(3, false);
    showMouse();
}

void drawPressedCell(int cx, int cy)
{
    int x1 = offset_x + cx * CELL_SIZE;
    int y1 = offset_y + cy * CELL_SIZE;
    int x2 = x1 + CELL_SIZE;
    int y2 = y1 + CELL_SIZE;

    Cell *c = &board[cx][cy];
    drawPressedButton(x1, y1, x2, y2);
}


void drawCell(int cx, int cy)
{
    int x1 = offset_x + cx * CELL_SIZE;
    int y1 = offset_y + cy * CELL_SIZE;
    int x2 = x1 + CELL_SIZE;
    int y2 = y1 + CELL_SIZE;

    Cell *c = &board[cx][cy];
    
    if(!Cell_isOpen(c))
    {
        drawButton(x1, y1, x2, y2);
        if (Cell_isFlagged(c))
            drawFlag(x1 + 9, y1 + 5);
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
    currentState = STATE_INIT;
    printTop(1, emptystr);
    printTop(1, "MINESWEEPER - ");
    printTop(15, menuLabels[currentMode]);

    printBottom(1, emptystr);
    printBottom(1, "LOADING...");

    gameOver = false;
    gameWon = false;
    firstClick = true;

    offset_x = (SCREEN_W / 2) - (field_w * CELL_SIZE / 2);
    offset_y = ((SCREEN_H + 30) / 2) - (field_h * CELL_SIZE / 2); //по вертикале оставляем свободное место наверху

    smileX = (SCREEN_W / 2) - (SMILE_W / 2);
    smileY = offset_y - SMILE_H;

    drawButton(smileX, smileY, smileX + SMILE_W, smileY + SMILE_H);
    drawSmile(smileX, smileY, SMILE_INIT);

    //копия поля
    for (int x = 0; x < field_w; x++)
        for (int y = 0; y < field_h; y++)
            board_copy[x][y] = board[x][y];
    
    //сброс игрового поля
    for (int x = 0; x < field_w; x++)
        for (int y = 0; y < field_h; y++)
            Cell_init(&board[x][y]);

    //отрисовка 
    for (int x = 0; x < field_w; x++)
        for (int y = 0; y < field_h; y++)
        {
            if (initBySmile && !(Cell_isOpen(&board_copy[x][y]) || Cell_isFlagged(&board_copy[x][y])))
                continue;
            drawCell(x, y);
        }

    drawSmile(smileX, smileY, SMILE_NORMAL);
    currentState = STATE_GAME;

    printBottom(1, emptystr);
    printBottom(1, "ESC(AR2) - back");
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
        printTop(1, emptystr);
        printTop(1, "YOU WIN!");
        drawSmile(smileX, smileY, SMILE_WIN);
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
        printTop(1, emptystr);
        printTop(1, "BOOM!");
        drawSmile(smileX, smileY, SMILE_DEAD);
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
void OnMouseEvent(int x, int y, bool isLeft, bool down) 
{
    if(currentState == STATE_INIT) return;
    pendingX = x;
    pendingY = y;
    pendingLeft = isLeft;
    hasPendingClick = true;
    pendingDown = down;
}

void processMenuClick(int x, int y)
{
    int btnX1 = (SCREEN_W - MENU_BTN_W) / 2;
    int btnX2 = btnX1 + MENU_BTN_W;

    if (x < btnX1 || x > btnX2) return;

    for (int i = 0; i < 4; i++)
    {
        int btnY1 = (SCREEN_H - (4 * MENU_BTN_STEP)) / 2 + i * MENU_BTN_STEP;
        int btnY2 = btnY1 + MENU_BTN_H;

        if (y >= btnY1 && y <= btnY2)
        {
            currentMode = i;
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
                field_w = 20;
                field_h = 12;
                total_mines = 37;
                currentState = STATE_GAME;
            }
            else if (i == 2)
            {
                field_w = 35;
                field_h = 13;
                total_mines = 90;
                currentState = STATE_GAME;
            }
            else if (i == 3)
                currentState = STATE_EXIT;
            break;
        }
    }
}

void releaseCurrentCell()
{
    if(hasCurrentCell)
    {
        hideMouse();
        drawCell(currentCell.x, currentCell.y);
        showMouse();
        hasCurrentCell = false;
    }
}


void processClick(int x, int y, bool isRight, bool isDown) 
{
    if (currentState == STATE_MENU)
    {
        if (!isRight)
            {
                if(!isDown) return;
                processMenuClick(x, y);
            }
        return;
    }

    if (x >= smileX && x < (smileX + SMILE_W) && y >= smileY && y < (smileY + SMILE_H))
    {
        releaseCurrentCell();

        if(!isDown || isRight) return;
        hideMouse();

        drawPressedButton(smileX, smileY, smileX + SMILE_W, smileY + SMILE_H);
        drawSmile(smileX + 2, smileY + 2, SMILE_NORMAL);
        drawButton(smileX, smileY, smileX + SMILE_W, smileY + SMILE_H);
        drawSmile(smileX, smileY, SMILE_NORMAL);

        initBySmile = true;
        drawInitialBoard();
        showMouse();
        return;
    }

    if (gameOver) return;

    if (x < offset_x || y < offset_y) 
    {
        releaseCurrentCell();
        return;
    }

    int cx = (x - offset_x) / CELL_SIZE;
    int cy = (y - offset_y) / CELL_SIZE;

    if (cx < 0 || cx >= field_w || cy < 0 || cy >= field_h)
    {
        releaseCurrentCell();
        return;
    }


    hideMouse();

    if (isRight && isDown) 
    { 
        if(!Cell_isOpen(&board[cx][cy])) 
        {
            Cell_toggleFlag(&board[cx][cy]);
            drawCell(cx, cy);
        }
    }
    else 
    {
        if(!Cell_isFlagged(&board[cx][cy]) && !isRight) 
        { 
            if(isDown && !Cell_isOpen(&board[cx][cy]))
            {
                currentCell.x = cx;
                currentCell.y = cy;
                drawPressedCell(cx, cy);
                hasCurrentCell = true;
                showMouse();
                return;
            }
            else
            {
                if(currentCell.x != cx || currentCell.y != cy)
                {
                    releaseCurrentCell();
                    showMouse();
                    return;
                }
            }
              
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

void OnKeyEvent(bool Up, unsigned char key_code)
{
    if(key_code == KEY_AR2 && !Up)
    {
        switch(currentState)
        {
        case STATE_MENU:
            currentState = STATE_EXIT;
            break;
        case STATE_GAME:
            currentState = STATE_MENU;
            break;
        default:
            break;
        }
    }
}

void main() 
{
    if (!initMouse()) return;
    if (!initKeyb()) return;
    if (!initGraph()) return;

    setOnClick(OnMouseEvent);
    setOnKeyEvent(OnKeyEvent);

    while (currentState != STATE_EXIT)
    {
        if (currentState == STATE_MENU)
        {
            drawMenu();

            printBottom(1, emptystr);
            printBottom(1, "ESC(AR2) - exit");

            while (currentState == STATE_MENU)
            {
                if (hasPendingClick)
                {
                    hasPendingClick = false;
                    processClick(pendingX, pendingY, !pendingLeft, pendingDown);
                }
            }
        }
        else if (currentState == STATE_GAME)
        {
            hideMouse();
            clearScreen();

            initBySmile = false;
            drawInitialBoard();
            hasPendingClick = false;

            showMouse();

            while (currentState == STATE_GAME)
            {
                if (hasPendingClick)
                {
                    hasPendingClick = false;
                    processClick(pendingX, pendingY, !pendingLeft, pendingDown);
                }
            }
        }
    }

    printTop(1, emptystr);
    printBottom(1, emptystr);

    hideMouse();
    resetScreen();

    finishGraph();
    finishMouse();
    finishKeyb();
}
