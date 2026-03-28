#define WIDTH   640
#define HEIGHT  264

#define UP    0
#define RIGHT 1
#define DOWN  2
#define LEFT  3

extern void InitGraph();
extern void FinishGraph();
extern void ClearScreen();
extern void PutPixel(unsigned int x,unsigned int y, unsigned int color);
extern unsigned int GetPixel(unsigned int x, unsigned int y);
extern void PrintTop(char *buffer);

extern void InitKeyb();
extern void FinishKeyb();
extern int kbhit();


/* -------- тьюрмитная программа -------- */

struct rule {
    char state;
    unsigned cur_color;
    unsigned new_color;
    int turn;        /* -1, 0, +1 */
    char next_state;
};

struct rule prog[] = {
/*
//Красная сприраль
 {'A', 0, 2, 1, 'B'},
 {'B', 0, 2, 1,'C'},
 {'A', 2, 0, -1, 'B'},
 {'B', 2, 2, 1, 'C'},
 {'C', 0, 0, 1, 'A'},
 {'C', 2, 0, 1, 'D'},
 {'D', 0, 2, 1, 'A'},
 {'D', 2, 0, 1, 'C'}
*/
/*
//Зеленая пирамида
    {'A', 0, 4, 0, 'C'},
    {'A', 4, 0, 0, 'B'},
    {'B', 4, 4, 1, 'A'},
    {'B', 7, 4, 1, 'A'},
    {'C', 4, 0, -1, 'A'},
    {'C', 0, 7, -1, 'A'},
    {'C', 7, 4, -1, 'A'}
*/
/*
{'A', 0,   6,  -1, 'A'},
{'A', 6,   1,  -1, 'A'},
{'A', 1,   4,  -1, 'A'},
{'A', 4,   5,  -1, 'A'},
{'A', 5,   2,  1, 'A'},
{'A', 2,   7,  1, 'A'},
{'A', 7,   3,  1, 'A'},
{'A', 3,   0,  1, 'A'}
*/
/*
//Каша
{'A', 0, 1,  1, 'A'}, // Цвет 0 -> 1, поворот направо
{'A', 1, 2,  1, 'A'}, // Цвет 1 -> 2, поворот направо
{'A', 2, 3, -1, 'A'}, // Цвет 2 -> 3, поворот налево
{'A', 3, 4, -1, 'A'}, // Цвет 3 -> 4, поворот налево
{'A', 4, 5,  1, 'A'}, // Цвет 4 -> 5, поворот направо
{'A', 5, 6,  1, 'A'}, // Цвет 5 -> 6, поворот направо
{'A', 6, 0, -1, 'A'}  // Цвет 6 -> 0, поворот налево
*/
//Красиво
{'A', 0, 1,  1, 'A'},
{'A', 1, 2,  1, 'A'},
{'A', 2, 3, -1, 'A'},
{'A', 3, 4, -1, 'A'},
{'A', 4, 5, -1, 'A'},
{'A', 5, 6, -1, 'A'},
{'A', 6, 7,  1, 'A'},
{'A', 7, 0,  1, 'A'}
};

#define N_RULES (sizeof(prog)/sizeof(prog[0]))

/* -------- состояние тьюрмита -------- */

int ant_x;
int ant_y;
unsigned ant_dir;
char ant_state;

/* ------------------------------------ */

void turn_ant(int t)
{
    if (t == 1)
        ant_dir = (ant_dir + 1) & 3;
    if (t == -1)
        ant_dir = (ant_dir + 3) & 3;
}

/* ------------------------------------ */

void move_ant()
{
    if (ant_dir == UP)
        ant_y--;
    if (ant_dir == DOWN)
        ant_y++;
    if (ant_dir == LEFT)
        ant_x--;
    if (ant_dir == RIGHT)
        ant_x++;

    if (ant_x < 0) ant_x = WIDTH - 1;
    if (ant_y < 0) ant_y = HEIGHT - 1;
    if (ant_x >= WIDTH) ant_x = 0;
    if (ant_y >= HEIGHT) ant_y = 0;
}

/* ------------------------------------ */

struct rule *find_rule(char state, unsigned int color)
{
    register volatile int i;

    for (i = 0; i < N_RULES; ++i)
        if (prog[i].state == state &&
            prog[i].cur_color == color)
            return &prog[i];

        return 0;   /* тьюрмит умирает */
}

/* ------------------------------------ */

int step()
{
    unsigned volatile color;
    volatile struct rule *r;

    color = GetPixel(ant_x, ant_y);

    r = find_rule(ant_state, color);
    if (r == 0)
        return 0;   /* смерть */

    PutPixel(ant_x, ant_y, r->new_color);

    turn_ant(r->turn);
    ant_state = r->next_state;

    move_ant();
    return 1;       /* жив */
}

/* ------------------------------------ */

void main()
{
    InitKeyb();
    InitGraph();
    ClearScreen();

    PrintTop("Turmit");

    ant_x = WIDTH / 2;
    ant_y = HEIGHT / 2;
    ant_dir = RIGHT;
    ant_state = 'A';


    while (step() && !kbhit())
        ;    
    PrintTop("       ");
    FinishGraph();    
    FinishKeyb();    
}
