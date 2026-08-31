.text
.globl _InitGraph, _FinishGraph, _ClearScreen, _PutPixel, _GetPixel, _PrintTop, _PrintBottom, _InvertScreen, _Line
.globl _RunPPU

base_addr = .

entry = 01000
crt0size = 016

offset_size = base_addr - (entry + crt0size)

rsk2 = 0176674
rdk2 = rsk2+2

pplen = (pp.end - pp.beg) >> 1

PxlPPU = (Pxl - offset_size) >> 1
PxlColorPPU = (PxClr - offset_size) >> 1
PxlAddress = (PxlAddr - offset_size) >> 1
PxShiftPPU = (PxShift - offset_size) >> 1
RecColor = (received_color - offset_size) >> 1
OffPPU = (offsetV - offset_size) >> 1
RunProcPPU = (running_proc - offset_size) >> 1
LineColorPPU = (LineColor - offset_size) >> 1

mp:
            .byte   0
command:    .byte   01
            .word   032
addrPP:     .word   0
WORD3:      .word   pplen
WORDS:      .word   pplen
.even

/структура для отправки данных во время работы (координат и тп)
mp1:
             .byte   0
command1:    .byte   020
             .word   032
addrPP1:     .word   0
addrCP1:     .word   0
WORDS1:      .word   0
.even

Pxl:      /(порядок не менять)
PxlAddr: .word 0
PxlMask: .word 0
PxClr:   .word 0
PxShift: .word 0
PixelX:  .word 0
PixelY:  .word 0

received_color: .word   -1
offsetV:	.word	0	/адрес верхней видеостроки пользовательского экрана

running_proc:	.word 0   /слово флагов для запуска подпрограмм в ПП
/*
01  - PutPixelPPU
02  - GetPixelPPU
04  - ClearSreenPPU
010 - PrintTopBottomPPU
020 - InvertScreenPPU
040 - LinePPU
.
.
.
0100000 - завершение главного цикла ПП
*/

finished:                 .word 0

/параметры для вывода строки в служебные экраны (порядок не менять)
top_or_bottom:            .word 0  /0 - top, 1 - bottom
position_service_string:  .word 0  / позиция вывода
addr_buffer_string:       .word 0  / адрес строки


.macro  mput  adrmp
    jsr r2, pp_mput
    .word   \adrmp
.endm


/Подпрограмма перемещения в К2 адреса МП
/=============================================================================
pp_mput: 
    jsr pc, 5f      /Подождем готовности К2
1:
    jsr pc, 4f      /Вытолкнем в К2 первые 2 байта адреса
    cmp     r2, $2f /Байты завершения переданы ?
    beq     3f      /..да - перейдем к проверке ответа
    clrb    @-(r2)  /Очистим байт ответа
    jsr     r2, 1b  /Передадим 2 байта завершения 0377
    .word   -1      /Байты завершения
2:
    tstb    @(r2)+  /Проверим ответ
3:
    rts     r2          /Выйдем в основную программу (или на 2b)
4:
    mov     pc, -(sp)   /Обеспечим повторный вход
    movb    (r2)+, @$rdk2   /Передача байта в К2
5:
    tstb    @$rsk2  /Ожидание готовности К2
    bpl     5b
    rts pc 
/=============================================================================



_InitGraph:
    mput  mp
    bne	1f

    movb  $020, command
    mov	$pp.beg, WORD3
    mput	mp
    bne	1f

    movb  $030, command
    mput  mp
    
    rts  pc

1:
    rts  pc

_FinishGraph:
    bis $0100000, running_proc  /флаг завершения для ПП

    / запуск подпрограммы в ПП FinishGraphPPU
    mov  addrPP, r0
    add  $(FinishGraphPPU - pp.beg), r0
    movb  $030, command1
    mov   r0, addrPP1
    mput  mp1

    /дождаться завершения
1:
    tst   finished
    beq   1b

    /освободить память
    movb  $2, command
    mput  mp
    rts   pc


_ClearScreen:
    bis $04, running_proc
1:
    bit $04, running_proc
    bne 1b

    rts  pc

_InvertScreen:
    bis $020, running_proc
11:
    bit $020, running_proc
    bne 11b

    rts  pc

/Вычисление адрес вы ВОЗУ для ПП по координатам в PixelX, PixelY, результат в PxlAddr
CalcAddress:
/;сравнение предыдущих и новых координат, если равны - адрес не вычисляется
    cmp  r0, PixelX
    bne  11f
    cmp  r1, PixelY
    bne  11f
    br   22f
11:
    /;сохранение пред. координат
    mov  r0, PixelX
    mov  r1, PixelY

    mul $80, r1
    /деление координаты x на 8
    ash $-3, r0

    add r1, r0
    add offsetV, r0
    cmp r0, $0154540 / список 220 видеострок для области отображения меню УСТАНОВКА
    blt 1f
    sub $054540, r0 / 154540 - 100000 = 54540
1:
    mov  r0,  PxlAddr

    /;вычисление маски пикселя (будет использовано в ПП)
    mov PixelX, r0
    bic $0b1111111111111000, r0 ;/ В r0 номер точки в октете
    /; Подготовка маски для вывода пикселя
    mov     $1, r1
    ash     r0, r1
    mov     r1, PxlMask

    /; r0 = номер точки (0..7) - подготовка сдвига для GetPixel
    asl r0
    asl r0               / r0 = n * 4
    neg r0              /сдвиг вправо
    mov r0, PxShift

22:
    rts  pc


_PutPixel:    
    mov     6(sp), PxClr
    mov     2(sp), r0
    mov     4(sp), r1   
    jsr  pc, CalcAddress

    bis $1, running_proc
3:
    bit $1, running_proc
    bne 3b

    rts  pc



_GetPixel:
    mov     6(sp), PxClr
    mov     2(sp), r0
    mov     4(sp), r1 
    jsr  pc, CalcAddress

    bis $2, running_proc
3:
    tst received_color
    bmi 3b
    mov received_color, r0
    mov $-1, received_color
    
    rts  pc


LineColor:.word 0
PixelX0:  .word 0
PixelY0:  .word 0
PixelX1:  .word 0
PixelY1:  .word 0

_Line:
    mov     10(sp), LineColor

    mov     2(sp), PixelX0
    mov     4(sp), PixelY0
    mov     6(sp), PixelX1
    mov     8(sp), PixelY1    

    bis $040, running_proc
1:
    bit $040, running_proc
    bne 1b

    rts  pc

_PrintTop:
    mov   $0, top_or_bottom
    br    1f
_PrintBottom:
    mov   $1, top_or_bottom
1:
    mov   2(sp), position_service_string
    mov   4(sp), addr_buffer_string

    bis   $010, running_proc
2:
    bit $010, running_proc
    bne 2b

    rts  pc


_RunPPU:
    mov  4(sp), r0
    clc
    ror  r0
    movb  $01, command1  /выделение памяти
    mov  r0, WORDS1  /кол-во слов
    mov  r0, addrCP1 /кол-во слов
    mput  mp1
    bne	1f

    movb  $020, command1  /копирование
    mov	  2(sp), addrCP1
    mput  mp1
    bne	1f

    movb  $030, command1 /запуск
    mput  mp1

    movb  $2, command1  /освобождение
    mput  mp1
1:

    rts  pc

/=============================================================================================
pp.beg:
    mov  @$02476, r0
    mov  @r0, offsetVPPU

    mov $0177010, r4
    mov $0177014, r5

    / рулон в CPU
    mov $OffPPU, @r4
    mov offsetVPPU, @r5
    
    jsr  pc, MainPPU
    rts  pc


    /Основной цикл
MainPPU:
    mov $RunProcPPU, @r4
    mov @r5, BitsProcPPU

    bmi 100f              /BitsProcPPU
     
    asr BitsProcPPU           /Проверка на PutPixel
    bcc 2f
    jmp PutPixelPPU
end_putpixel:
    mov $RunProcPPU, @r4
    bic $01, @r5          /PutPixel выполнена
2:
    asr BitsProcPPU          /Проверка на GetPixel
    bcc 3f
    jmp GetPixelPPU
end_getpixel:
    mov $RunProcPPU, @r4
    bic $02, @r5          /GetPixel выполнена

3: 
    asr BitsProcPPU          /Проверка на ClearScreen
    bcc 4f
    jsr pc, ClearScreenPPU

    mov $RunProcPPU, @r4
    bic $04, @r5           /ClearScreen выполнена
                         
4:
    asr BitsProcPPU          /Проверка на PrintTopBottom
    bcc 5f
    jsr pc, PrintTopBottomPPU

    mov $RunProcPPU, @r4
    bic $010, @r5
                         /PrintTopBottom выполнена
5:
    asr BitsProcPPU          /Проверка на InvertScreen
    bcc 6f
    jsr pc, InvertScreenPPU

    mov $RunProcPPU, @r4
    bic $020, @r5         /InvertScreen выполнена

6:
    asr BitsProcPPU          /Проверка на LinePPU
    bcc 7f
    jsr pc, LinePPU

    mov $RunProcPPU, @r4
    bic $040, @r5         /LinePPU выполнена

7:  
    jmp MainPPU
100:    
    rts  pc

ClearScreenPPU:
    mov	 r0, -(sp)
    mov	 r1, -(sp)
    mov	 r2, -(sp)

    clr  @$0177020
    clr  @$0177022
    mov  $0177024, r1
    mov	 $0100000, @r4
    mov	 $(80 * 286), r2
1:
    clr  @r1
    inc	 @r4
    sob	 r2, 1b

    mov  (sp)+, r2
    mov  (sp)+, r1
    mov  (sp)+, r0

    rts  pc

InvertScreenPPU:
    mov	 r0, -(sp)
    mov	 r1, -(sp)
    mov	 r2, -(sp)
    mov	 r3, -(sp)

    mov  $0177010, r0      / регистр адреса ВОЗУ в ПП
    mov  $0177012, r1       / 0 план
    mov  $0177014, r2       / 1, 2 планы
    mov	 $0100000, @r0
    mov	 $(80 * 286), r3
1:
    com  @r1
    com  @r2
    inc	 @r0
    sob	 r3, 1b

    mov  (sp)+, r3
    mov  (sp)+, r2
    mov  (sp)+, r1
    mov  (sp)+, r0

    rts  pc


PutPixelPPU:    
    mov $PxlAddress, @r4
    mov @r5, r0          /В r0 готовый адрес из ЦП

    inc (r4)
    mov @r5, r3          /в r3 маска пикселя

    inc (r4)    / color
    mov (r5), r2	

    / Запись пикселя (r0 - адрес, r2 - цвет, r3 - маска пикселя в октете)
    mov r0, @r4
    mov r2, @$0177016
    movb r3, @$0177024

    jmp end_putpixel


GetPixelPPU:
    mov $PxlAddress, @r4
    mov @r5, r0          /В r0 готовый адрес из ЦП

    mov $PxShiftPPU, @r4
    mov @r5, r2          /в r2 число сдвигов вправо для @$0177024

    mov r0, @r4
    tst @$0177024    / чтение регистров цвета фона
    
    mov @$0177020, r1    / младшее слово
    mov @$0177022, r0    / старшее слово
    ashc r2, r0         / сдвиг 32 бит регистров r0:r1

    bic $0b1111111111111000, r1

    / цвет в CPU
    mov $RecColor, @r4
    mov r1, @r5

    jmp end_getpixel



PrintTopBottomPPU:
    mov  pc, r1
    add  $str_buff - ., r1
    mov  r1, addr_for_emt    
    
    inc  r1
    mov  r1, r3

    /Очистка буфера
    mov  $20, r2    
11:
    clr (r3)+
    sob  r2, 11b 

    mov  $0104052, code_emt  /emt 052 по-умолчанию

    mov  $top_or_bottom, r0
    clc
    ror  r0                 
    mov  r0, @$0177010
    mov  @$0177014, r0  /В r0 параметр в ЦП - 0 - top, 1 - bottom
    tstb r0
    beq  111f                /top - ничего не делаем
    mov  $0104056, code_emt   /emt 056
 
111:
    inc   @$0177010          /$position_service_string            
    movb  @$0177014, @addr_for_emt      /Параметр в ЦП - позиция вывода
 
    inc  @$0177010          /$addr_buffer_string
    mov  @$0177014, r0      /В r0 адрес адреса строки в ЦП
    clc
    ror  r0                 /В r0 адрес строки в ЦП
    mov  r0, @$0177010 

    mov  $0177010, r0

1:
    mov  @$0177014, r2  
    bcs  2f

    movb r2, (r1)+ 
    beq  3f
2:
    swab r2
    movb r2, (r1)+ 
    beq  3f
   
    inc  @r0
    
    br   1b
3:
    clrb @r1

code_emt:
    emt  052
addr_for_emt:  .word 0    

    rts  pc


FinishGraphPPU: 
    mov $finished, r0
    clc
    ror r0
    mov r0, @$0177010
    mov $1, @$0177014    
    rts  pc


CalcAddressPPU:
    mov r0, PixelX0PPU

    mul $80, r1
    /деление координаты x на 8
    ash $-3, r0

    add r1, r0
    add offsetVPPU, r0
    cmp r0, $0154540 / список 220 видеострок для области отображения меню УСТАНОВКА
    blt 1f
    sub $054540, r0 / 154540 - 100000 = 54540
1:
    mov  r0,  PxlAddrPPU

    /;вычисление маски пикселя (будет использовано в ПП)
    mov PixelX0PPU, r0
    bic $0b1111111111111000, r0 ;/ В r0 номер точки в октете
    /; Подготовка маски для вывода пикселя
    mov     $1, r1
    ash     r0, r1
    mov     r1, PxlMaskPPU

    rts pc

LinePPU:    
    /;цвет
    mov $LineColorPPU, @r4
    mov @r5, @$0177016

    inc     (r4)
    mov     @r5, PixelX0PPU
    inc     (r4)
    mov     @r5, PixelY0PPU
    inc     (r4)
    mov     @r5, PixelX1PPU
    inc     (r4)
    mov     @r5, PixelY1PPU

    mov     PixelX0PPU, r0 /x0
    mov     PixelY0PPU, r1 /y0
    mov     PixelX1PPU, r2 /x1
    mov     PixelY1PPU, r3 /y1   

    mov     $1, stepX           /;sx (шаг по X = +1)
    /; Вычисление dx = |LastX - FirstX| и sx (направление по X)
    sub     r0, r2           /; r2 = LastX - FirstX
    bge     1f
    neg     r2               /; r2 = dx = |dx|
    neg     stepX               /; r4 = sx = -1
1:                          /; r2 = dx

    mov     $1, stepY           /;sy (шаг по Y = +1)
    /; Вычисление dy = |LastY - FirstY| и sy (направление по Y)
    sub     r1, r3           /; r3 = LastY - FirstY    
    bge     2f
    neg     r3               /; r3 = dy = |dy|
    neg     stepY               /; r5 = sy = -1
2:                          /; r3 = dy

    /; Сравнение dx и dy для определения ведущей оси
    cmp     r2, r3
    blt     DrawYMajor       /; Если dy > dx, идем по оси Y

/; --- Отрисовка с ведущей осью X (dx >= dy) ---
DrawXMajor:
    mov     r3, r12
    asl     r12
    mov     r12, r11
    sub     r2, r11          /; r11 = err = 2*dy - dx

    mov     r2, r13          /; r13 = счётчик точек = dx
    inc     r13

10:
    /; Отправить пиксель (цвет, Y, X)
    /; CalcAddressPPU портит r0, и r1, в них же  принимает координаты
    mov  r0, -(sp)
    mov  r1, -(sp)
    jsr  pc, CalcAddressPPU
    mov (sp)+, r1
    mov (sp)+, r0

    / Запись пикселя (r0 - адрес, r2 - цвет, r3 - маска пикселя в октете)
    mov PxlAddrPPU, @r4
    movb PxlMaskPPU, @$0177024


    /; Если дошли до конечной точки по X – выход
    cmp     r0, PixelX1PPU
    beq     LineExit

    /; --- Исправленный порядок: сначала проверка ошибки ---
    tst     r11
    blt     11f              /; если err < 0, Y не меняем
    /; err >= 0 – увеличиваем Y и корректируем err
    add     stepY, r1           /; Y += sy
    mov     r3, r14
    sub     r2, r14          /; r14 = dy - dx
    asl     r14
    add     r14, r11         /; err += 2*(dy - dx)
    br      12f
11:
    add     r12, r11         /; err += 2*dy   (Y не меняется)
12:
    /; Теперь увеличиваем X (ведущая координата)
    add     stepX, r0           /; X += sx

    dec     r13
    bne     10b              /; если счётчик > 0 – продолжаем
    br      LineExit

/; --- Отрисовка с ведущей осью Y (dy > dx) ---
DrawYMajor:
    mov     r2, r12
    asl     r12
    mov     r12, r11
    sub     r3, r11          /; r11 = err = 2*dx - dy

    mov     r3, r13          /; r13 = счётчик точек = dy
    inc     r13

20:
    /; Отправить пиксель
    /; CalcAddressPPU портит r0, и r1, в них же  принимает координаты
    mov  r0, -(sp)
    mov  r1, -(sp)
    jsr  pc, CalcAddressPPU
    mov (sp)+, r1
    mov (sp)+, r0

    / Запись пикселя (r0 - адрес, r2 - цвет, r3 - маска пикселя в октете)
    mov PxlAddrPPU, @r4
    movb PxlMaskPPU, @$0177024


    /; Если дошли до конечной точки по Y – выход
    cmp     r1, PixelY1PPU
    beq     LineExit

    /; --- Исправленный порядок: сначала проверка ошибки ---
    tst     r11
    blt     21f              /; если err < 0, X не меняем
    /; err >= 0 – увеличиваем X и корректируем err
    add     stepX, r0           /; X += sx
    mov     r2, r14
    sub     r3, r14          /; r14 = dx - dy
    asl     r14
    add     r14, r11         /; err += 2*(dx - dy)
    br      22f
21:
    add     r12, r11         /; err += 2*dx   (X не меняется)
22:
    /; Теперь увеличиваем Y (ведущая координата)
    add     stepY, r1           /; Y += sy

    dec     r13
    bne     20b              /; если счётчик > 0 – продолжаем

LineExit:
    rts     pc


//====================ДАННЫЕ ПП======================================================
offsetVPPU:	  .word	0         /адрес верхней видеостроки пользовательского экрана
BitsProcPPU:      .word 0         /битовая карта процессов

PixelX0PPU:  .word 0
PixelY0PPU:  .word 0
PixelX1PPU:  .word 0
PixelY1PPU:  .word 0
r12: .word 0
r11: .word 0
r13: .word 0
r14: .word 0

stepX: .word 0
stepY: .word 0

PxlAddrPPU: .word 0
PxlMaskPPU: .word 0

str_buff:         .byte 0
str_buffer:       .fill 40, 1, 0  / Буфер для строки
.even


pp.end:

