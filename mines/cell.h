#include <stdbool.h>

// Объединение занимает 1 байт
typedef union 
{
    struct {
        unsigned char isMine        : 1;
        unsigned char isOpen        : 1;
        unsigned char isFlagged     : 1;
        unsigned char neighborMines : 4;
        unsigned char reserved      : 1; 
    } fields;
    unsigned char raw; 
} Cell;

// ==========================================
// Геттеры
// ==========================================

bool Cell_isMine(const Cell *c)
{
    return c->fields.isMine;
}

bool Cell_isOpen(const Cell *c)
{
    return c->fields.isOpen;
}

bool Cell_isFlagged(const Cell *c)
{
    return c->fields.isFlagged;
}

unsigned char Cell_getNeighborMines(const Cell *c)
{
    return c->fields.neighborMines;
}

// ==========================================
// Сеттеры
// ==========================================

void Cell_setMine(Cell *c, bool val)
{
    c->fields.isMine = val ? 1 : 0;
}

void Cell_setOpen(Cell *c, bool val)
{
    c->fields.isOpen = val ? 1 : 0;
}

void Cell_setFlagged(Cell *c, bool val)
{
    c->fields.isFlagged = val ? 1 : 0;
}

void Cell_toggleFlag(Cell *c)
{
    c->fields.isFlagged = !c->fields.isFlagged;
}

void Cell_setNeighborMines(Cell *c, unsigned char count)
{
    c->fields.neighborMines = count & 0x0F; // Маска 4 бит (0..15)
}

void Cell_init(Cell *c)
{
    c->raw = 0; // Полный сброс всех флагов
}
