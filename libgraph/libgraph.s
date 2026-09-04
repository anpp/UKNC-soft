.text
.globl _initGraph, _finishGraph, _clearScreen, _putPixel, _getPixel, _printTop, _printBottom, _invertScreen, _line, _fillRect
.globl _runPPU

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
PixelX:  .word -1
PixelY:  .word -1

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
0100 - FillRectPPU
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



_initGraph:
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

_finishGraph:
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


_clearScreen:
    bis $04, running_proc
1:
    bit $04, running_proc
    bne 1b

    rts  pc

_invertScreen:
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
    asr r0
    asr r0
    asr r0

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

22:
    rts  pc


_putPixel:    
    mov     6(sp), PxClr
    mov     2(sp), r0
    mov     4(sp), r1   
    jsr  pc, CalcAddress

    bis $1, running_proc
3:
    bit $1, running_proc
    bne 3b

    rts  pc



_getPixel:
    mov     6(sp), PxClr
    mov     2(sp), r0
    mov     4(sp), r1 
    jsr  pc, CalcAddress

    mov PixelX, r0
    bic $0b1111111111111000, r0 ;/ В r0 номер точки в октете
    /; r0 = номер точки (0..7) - подготовка сдвига для GetPixel
    asl r0
    asl r0               /; r0 = n * 4
    neg r0               /;сдвиг вправо
    mov r0, PxShift

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

_line:
    mov     10(sp), LineColor

    mov     2(sp), r0
    mov     4(sp), r1
    mov     6(sp), PixelX1
    mov     8(sp), PixelY1

    cmp  r0, PixelX1
    blt  2f          /;X1 > X0 - не меняем координаты
    /;X
    mov  r0, -(sp)
    mov  PixelX1, -(sp)
    mov  (sp)+, r0
    mov  (sp)+, PixelX1
    /;Y
    mov  r1, -(sp)
    mov  PixelY1, -(sp)
    mov  (sp)+, r1
    mov  (sp)+, PixelY1

2:
    mov  r0, PixelX0
    mov  r1, PixelY0

    jsr  pc, CalcAddress    

    bis $040, running_proc
1:
    bit $040, running_proc
    bne 1b

    rts  pc

_fillRect:
    mov     10(sp), LineColor /;используются те же переменные, что и для Line

    mov     2(sp), PixelX0
    mov     4(sp), PixelY0
    mov     6(sp), PixelX1
    mov     8(sp), PixelY1

    mov  PixelX0, r0
    mov  PixelY0, r1

    jsr  pc, CalcAddress    

    bis $0100, running_proc
1:
    bit $0100, running_proc
    bne 1b

    rts  pc



_printTop:
    mov   $0, top_or_bottom
    br    1f
_printBottom:
    mov   $1, top_or_bottom
1:
    mov   2(sp), position_service_string
    mov   4(sp), addr_buffer_string

    bis   $010, running_proc
2:
    bit $010, running_proc
    bne 2b

    rts  pc


_runPPU:
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
    /; сперва таблица адресов
    mov  pc, r1
    add  $TAddr - ., r1
    mov  pc, r0
LT:
    tst  (r1)        /;Есть ли еще адреса?
    beq  begin       /;0 - уже нет
    add  r0, (r1)+   /;Скорректировать адрес
    br   LT          /;до конца таблицы

begin:
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
    jmp LinePPU
end_line:
    mov $RunProcPPU, @r4
    bic $040, @r5         /LinePPU выполнена

7:

    asr BitsProcPPU          /Проверка на FillRectPPU
    bcc 8f
    jmp FillRectPPU
end_fillrect:
    mov $RunProcPPU, @r4
    bic $0100, @r5         /FillRectPPU выполнена

8:  
    jmp MainPPU
100:    
    rts  pc

ClearScreenPPU:
    clr  @$0177020
    clr  @$0177022
    mov  $0177024, r1
    mov	 $0100000, @r4
    mov	 $(80 * 286), r2
1:
    clr  @r1
    inc	 @r4
    sob	 r2, 1b

    rts  pc

InvertScreenPPU:
    mov  $0177012, r1       / 0 план
    mov	 $0100000, @r4
    mov	 $(80 * 286), r3
1:
    com  @r1
    com  @r5         /;r5 = $0177014 (1, 2 планы)
    inc	 @r4
    sob	 r3, 1b

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
    mov  r0, @r4
    mov  @r5, r0  /В r0 параметр в ЦП - 0 - top, 1 - bottom
    tstb r0
    beq  111f                /top - ничего не делаем
    mov  $0104056, code_emt   /emt 056
 
111:
    inc   (r4)          /$position_service_string            
    movb  @r5, @addr_for_emt      /Параметр в ЦП - позиция вывода
 
    inc  (r4)          /$addr_buffer_string
    mov  @r5, r0      /В r0 адрес адреса строки в ЦП
    clc
    ror  r0                 /В r0 адрес строки в ЦП
    mov  r0, @r4 

1:
    mov  @r5, r2  
    bcs  2f

    movb r2, (r1)+ 
    beq  3f
2:
    swab r2
    movb r2, (r1)+ 
    beq  3f
   
    inc  (r4)
    
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



/;=========================LinePPU==============================================================
.macro CorrectAddressLineUpDown
    cmp     r3, $0100000
    blo     1000f                      /; < 0100000 -> Underflow
    cmp     r3, $0154540
    blo     2000f                      /; [0100000..0154540) -> Норма
    sub     $054540, r3           /; Overflow (>= 0154540)
    br      2000f
1000:
    add     $054540, r3           /; Underflow (< 0100000)
2000:
.endm

.macro CorrectAddressLineUp
    cmp     r3, $0154540
    blo     1000f                      /; [0100000..0154540) -> Норма
    sub     $054540, r3           /; Overflow (>= 0154540)
1000:
.endm

LinePPU:
    /;цвет
    mov $LineColorPPU, @r4
    mov @r5, @$0177016        

    mov     $0177024, r2

    inc     (r4)
    mov     @r5, x0
    inc     (r4)
    mov     @r5, y0
    inc     (r4)
    mov     @r5, x1
    inc     (r4)
    mov     @r5, y1

    /; адрес и маска для первого пикселя
    mov     $PxlAddress, @r4
    mov     @r5, r3          /;r3 - адрес текущего пикселя
    inc     (r4)
    mov     @r5, r1          /;r1 - маска пикселя в октете

    /; сохраним регистр r5, во всех остальных попрограммах это РД
    mov     r5, -(sp)

    /;Абсолютный адрес таблицы масок на вершине стека
    mov     TMaskTable, -(sp)

    /; команды add $80, r3
    mov $062703, stepay1
    mov $000120, stepay1 + 2
    mov $062703, stepay2
    mov $000120, stepay2 + 2

    /; По X всегда идем вправо
    /; Вычисление dx = |LastX - FirstX| и sx (направление по X)
    sub     x0, x1           /; r2 = LastX - FirstX

    /; Вычисление dy = |LastY - FirstY| и sy (направление по Y)
    sub     y0, y1           /; r3 = LastY - FirstY    
    bge     1f
    neg     y1               /; r3 = dy = |dy|
    /; команды sub $80, r3
    mov $0162703, stepay1
    mov $000120, stepay1 + 2
    mov $0162703, stepay2
    mov $000120, stepay2 + 2

1:                          /; r3 = dy

    /; Сравнение dx и dy для определения ведущей оси
    cmp     x1, y1
    blt     DrawYMajor       /; Если dy > dx, идем по оси Y

/; --- Отрисовка с ведущей осью X (dx >= dy) ---
DrawXMajor:
    mov     y1, r12
    asl     r12
    mov     r12, r11
    sub     x1, r11          /; r11 = err = 2*dy - dx
    mov     y1, r14
    sub     x1, r14          /; r14 = dy - dx
    asl     r14

    mov     x1, r5          /; r5 = счётчик точек = dx
    inc     r5

10:
    /; Запись пикселя
    mov  r3, @r4
    movb r1, @r2

    /; --- Исправленный порядок: сначала проверка ошибки ---
    tst     r11
    blt     11f              /; если err < 0, Y не меняем
    /; err >= 0 – увеличиваем адрес по Y (сама координата не нужна) и корректируем err
stepay1:
    add     $80, r3
    CorrectAddressLineUpDown

    add     r14, r11         /; err += 2*(dy - dx)
    br      12f
11:
    add     r12, r11         /; err += 2*dy   (Y не меняется)
12:
    /; Теперь увеличиваем X (ведущая координата)
    mov     x0, r0
    inc     r0
    mov     r0, x0
    bic     $0177770, R0  /; В r0 номер точки в октете
    bne     333f           /; добавлять адрес не нужно    
    inc     r3
    CorrectAddressLineUp
333:
    /;вычисление маски пикселя
    add     (sp), r0
    movb    (r0), r1

    sob     r5, 10b  /; если счётчик > 0 – продолжаем
    br      LineExit

/; --- Отрисовка с ведущей осью Y (dy > dx) ---
DrawYMajor:
    mov     x1, r12
    asl     r12
    mov     r12, r11
    sub     y1, r11          /; r11 = err = 2*dx - dy
    mov     x1, r14
    sub     y1, r14          /; r14 = dx - dy
    asl     r14

    mov     y1, r5          /; r5 = счётчик точек = dy
    inc     r5
20:
    /; Запись пикселя
    mov  r3, @r4
    movb r1, @r2

    /; --- Исправленный порядок: сначала проверка ошибки ---
    tst     r11
    blt     21f              /; если err < 0, X не меняем
    /; err >= 0 – увеличиваем X и корректируем err
    mov     x0, r0
    inc     r0
    mov     r0, x0
    bic     $0177770, R0  /; В r0 номер точки в октете
    bne     44f           /; добавлять адрес не нужно
    inc     r3
    CorrectAddressLineUp
44:    
   /;вычисление маски пикселя
    add     (sp), r0
    movb    (r0), r1

    add     r14, r11         /; err += 2*(dx - dy)
    br      22f
21:
    add     r12, r11         /; err += 2*dx   (X не меняется)
22:
    /; Теперь увеличиваем адрес по Y (ведущая координата), сама координата не нужна
stepay2:
    add     $80, r3
    CorrectAddressLineUpDown
    sob     r5, 20b /; если счётчик > 0 – продолжаем

LineExit:
    tst     (sp)+
    mov     (sp)+, r5
    jmp     end_line


/;=========================FillRectPPU==============================================================

.macro CorrectAddressFillRect
    cmp     r3, $0154540
    blo     2000f                      /; [0100000..0154540) -> Норма
    sub     $054540, r3           /; Overflow (>= 0154540)
2000:
.endm


FillRectPPU:
    /; Цвет (устанавливается один раз перед циклами)
    mov     $LineColorPPU, @r4
    mov     @r5, @$0177016        

    inc     (r4)
    mov     @r5, x0
    inc     (r4)
    mov     @r5, y0
    inc     (r4)
    mov     @r5, r0               /; r0 = x1
    inc     (r4)
    mov     @r5, r1               /; r1 = y1

    /; Адрес первого пикселя от ЦП
    mov     $PxlAddress, @r4
    mov     @r5, r3               /; r3 = адрес текущего пикселя (VRAM)

    mov     r5, -(sp)             /; сохраняем рабочий регистр r5

    /; --- Вычисление dy = y1 - y0 + 1 (высота прямоугольника) ---
    sub     y0, r1
    inc     r1                    /; r1 = dy (высота в пикселях)

    /; --- Вычисление смещений битов и количества байтовых колонок ---
    mov     x0, r2
    bic     $0177770, r2          /; r2 = bit_start (x0 & 7)

    mov     r0, r5
    bic     $0177770, r5          /; r5 = bit_end (x1 & 7)

    asr     x0
    asr     x0
    asr     x0                    /; x0 = byte_start (x0 >> 3)

    asr     r0
    asr     r0
    asr     r0                    /; r0 = byte_end (x1 >> 3)

    sub     x0, r0                /; r0 = CountX (количество шагов по колонкам)

    /; --- Проверка: всё в одной колонке или нет? ---
    tst     r0
    bne     MultiColumn

/; ============================================================================
/; ОДНА КОЛОНКА (CountX == 0)
/; ============================================================================
SingleColumn:
    add     TLeftMaskTable, r2
    movb    (r2), r2

    add     TRightMaskTable, r5
    movb    (r5), r5

    comb    r5                    /; Инвертируем RightMask: биты > bit_end становятся 1
    bicb    r5, r2

1:  mov     r3, @r4               /; Засылаем адрес VRAM
    movb    r2, @$0177024         /; Пишем маску
    add     $80, r3
    CorrectAddressFillRect
    sob     r1, 1b                /; Счетчик высоты в r1

    br      FillRectExit

/; ============================================================================
/; НЕСКОЛЬКО КОЛОНОК (CountX > 0)
/; ============================================================================
MultiColumn:
    mov     r5, -(sp)             /; сохраняем bit_end на стек
    /; На вершине стека сейчас лежит bit_end
    mov     r3, -(sp)             /; (sp) = адрес верхнего пикселя колонки

    /; --- 1. ПЕРВАЯ КОЛОНКА (Левый край) ---
    add     TLeftMaskTable, r2
    movb    (r2), r2               /; r2 = LeftMask
    mov     r1, r5                /; r5 = копируем высоту для внутреннего цикла

1:  mov     r3, @r4
    movb    r2, @$0177024
    add     $80, r3
    CorrectAddressFillRect
    sob     r5, 1b

    mov     (sp), r3              /; восстанавливаем верхний адрес колонки
    inc     r3                    /; шаг вправо по X (+1 байт)
    CorrectAddressFillRect
    mov     r3, (sp)              /; сохраняем новый верхний адрес
    dec     r0                    /; CountX--
    beq     DrawRightEdge         /; если средних колонок нет — сразу на правый край

    /; --- 2. СРЕДНИЕ КОЛОНКИ (Сплошная маска 0377) ---
DrawMiddle:
2:  mov     r1, r5                /; r5 = копируем высоту dy
3:  mov     r3, @r4
    movb    $0377, @$0177024      /; сплошная заливка октета
    add     $80, r3
    CorrectAddressFillRect
    sob     r5, 3b

    mov     (sp), r3              /; восстанавливаем верх колонки
    inc     r3                    /; шаг вправо (+1 байт)
    CorrectAddressFillRect
    mov     r3, (sp)              /; сохраняем новый верх
    sob     r0, 2b                /; цикл по колонкам (r0)

    /; --- 3. ПОСЛЕДНЯЯ КОЛОНКА (Правый край) ---
DrawRightEdge:
    tst     (sp)+                 /; снимаем сохранённый адрес колонки
    mov     (sp)+, r5             /; r5 = восстанавливаем bit_end
    add     TRightMaskTable, r5
    movb    (r5), r2/; r2 = RightMask

4:  mov     r3, @r4
    movb    r2, @$0177024
    add     $80, r3
    CorrectAddressFillRect
    sob     r1, 4b                /; используем r1 (dy) в последнем цикле

FillRectExit:
    mov     (sp)+, r5             /; восстанавливаем изначальный r5
    jmp     end_fillrect

//====================ДАННЫЕ ПП======================================================
offsetVPPU:	  .word	0         /адрес верхней видеостроки пользовательского экрана
BitsProcPPU:      .word 0         /битовая карта процессов

r12: .word 0
r11: .word 0
r14: .word 0
x0:   .word 0
y0:   .word 0
x1:   .word 0
y1:   .word 0

MaskTable: .byte 01, 02, 04, 010, 020, 040, 0100, 0200

/; Биты от N до 7 включительно (левая граница прямоугольника)
LeftMaskTable:
    .byte 0377, 0376, 0374, 0370, 0360, 0340, 0300, 0200

/; Биты от 0 до N включительно (правая граница прямоугольника)
RightMaskTable:
    .byte 0001, 0003, 0007, 0017, 0037, 0077, 0177, 0377

TAddr:  /; Таблица адресов
TMaskTable:      .word MaskTable - LT
TLeftMaskTable:  .word LeftMaskTable - LT
TRightMaskTable: .word RightMaskTable - LT
.word 0

str_buff:         .byte 0
str_buffer:       .fill 40, 1, 0  / Буфер для строки
.even


pp.end:
