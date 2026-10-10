#include "../libgraph/libgraph.h"
#include "../libkeyb/libkeyb.h"

#define WIDTH   640
#define HEIGHT  264


#define PI 3.14159265f
#define TWO_PI 6.28318530f
#define INV_TWO_PI 0.15915494f
static const int angles[] = {12868, 7596, 4014, 2037, 1022, 511, 256, 128, 64, 32};

void cordic_calc(int angle, int *res_cos, int *res_sin) 
{
    register int x = 9949; // K * 16384
    register int y = 0;
    register int z = angle;

    for (int i = 0; i < 10; i++) 
    {
        int x_old = x;
        if (z >= 0) {
            x -= (y >> i);
            y += (x_old >> i);
            z -= angles[i];
        } else {
            x += (y >> i);
            y -= (x_old >> i);
            z += angles[i];
        }
    }
    *res_cos = x;
    *res_sin = y;
}

float fsin1(float x) 
{
    int k = (int)(x * INV_TWO_PI);
    x -= (float)k * TWO_PI;
    if (x > PI) x -= TWO_PI;
    if (x < -PI) x += TWO_PI;

    if (x > 1.570796f) x = PI - x;
    else if (x < -1.570796f) x = -PI - x;

    int r_sin, r_cos;
    cordic_calc(x * 16384, &r_cos, &r_sin);
    
    return r_sin / 16384.0f;
}

float fcos1(float x) 
{
    return fsin1(x + (PI / 2.0f));
}


void main()
{
    initKeyb();
    initGraph();
    clearScreen();

    float a = 40.0f;
    float stepx = 12.0;
    float y, y2, x2;
    
    int centerX = WIDTH / 2;
    int centerY = HEIGHT / 2;


    for (float x = -(WIDTH / 2); x < (WIDTH / 2); x += stepx)
    {
        y = a * fsin1(x / a);
        //y = x / 2.0f - a;
        x2 = x + stepx;
        y2 = a * fsin1(x2 / a);

        int screenX = (int)(centerX + x);
        int screenY = (int)(centerY - y);
        int screenX2 = (int)(centerX + x2);
        int screenY2 = (int)(centerY - y2);

        if (screenX >= 0 && screenX2 < WIDTH && screenY >= 0 && screenY2 < HEIGHT)
            line(screenX, screenY, screenX2, screenY2, 7); 
            //putPixel(screenX, screenY, 7);
    }
    waitAnyKey();

    resetScreen();

    finishGraph();    
    finishKeyb();
}
