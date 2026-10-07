#include "../libgraph/libgraph.h"

// Маска активных сегментов для цифр 0..9 (бит 0 = 'a', бит 1 = 'b', ..., бит 6 = 'g')
const unsigned char segmentMap[10] = {
    0b00111111, // 0: a,b,c,d,e,f
    0b00000110, // 1: b,c
    0b01011011, // 2: a,b,d,e,g
    0b01001111, // 3: a,b,c,d,g
    0b01100110, // 4: b,c,f,g
    0b01101101, // 5: a,c,d,f,g
    0b01111101, // 6: a,c,d,e,f,g
    0b00000111, // 7: a,b,c
    0b01111111, // 8: все сегменты
    0b01101111  // 9: a,b,c,d,f,g
};

// Рисование одного сегмента (горизонтального или вертикального)
void drawSegment(int x, int y, int w, int h, bool active)
{
    if (active)
    {
        fillRect(x, y, x + w - 1, y + h - 1, COLOR_RED);
    }
    else
    {
        // Неактивный сегмент 
        for (int px = x; px < x + w; px++)
        {
            for (int py = y; py < y + h; py++)
            {
            	putPixel(px, py, COLOR_BLACK);
            }
        }
    }
}

void draw7SegDigit(int x, int y, int digit)
{
    if (digit < 0 || digit > 9) digit = 0;

    unsigned char mask = segmentMap[digit];

    int segL = 7; // Длина горизонтального сегмента
    int segT = 2; // Толщина сегмента

    // a (верхний)
    drawSegment(x + 2, y, segL, segT, mask & (1 << 0));
    // b (верхний правый)
    drawSegment(x + 2 + segL, y + 2, segT, segL, mask & (1 << 1));
    // c (нижний правый)
    drawSegment(x + 2 + segL, y + 4 + segL, segT, segL, mask & (1 << 2));
    // d (нижний)
    drawSegment(x + 2, y + 4 + segL * 2, segL, segT, mask & (1 << 3));
    // e (нижний левый)
    drawSegment(x, y + 4 + segL, segT, segL, mask & (1 << 4));
    // f (верхний левый)
    drawSegment(x, y + 2, segT, segL, mask & (1 << 5));
    // g (средний)
    drawSegment(x + 2, y + 2 + segL, segL, segT, mask & (1 << 6));
}

void drawNumberDisplay(int x, int y, int number)
{
    if (number < 0) number = 0;
    if (number > 999) number = 999;

    int d1 = (number / 100) % 10; // Сотни
    int d2 = (number / 10) % 10;  // Десятки
    int d3 = number % 10;         // Единицы

    int digitWidth = 13;
    int digitPadding = 3;
    int totalWidth = (digitWidth * 3) + (digitPadding * 2) + 4;
    int totalHeight = 23 + 4;

    // задний фон и фаску рамки
    //drawDigitalPanel(x, y, x + totalWidth, y + totalHeight);

    int startX = x + 3;
    int startY = y + 3;

    draw7SegDigit(startX, startY, d1);
    draw7SegDigit(startX + digitWidth + digitPadding, startY, d2);
    draw7SegDigit(startX + (digitWidth + digitPadding) * 2, startY, d3);
}

