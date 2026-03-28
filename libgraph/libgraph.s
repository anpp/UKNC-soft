.text
.globl _InitGraph, _FinishGraph, _ClearScreen, _PutPixel, _GetPixel, _PrintTop
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
RecColor = (received_color - offset_size) >> 1
OffPPU = (offsetV - offset_size) >> 1
RunProcPPU = (running_proc - offset_size) >> 1

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

Pxl:
PxlAddr: .word 0
PixelX:  .word 0
PxClr:   .word 0
PixelY:  .word 0


received_color: .word   -1
offsetV:	.word	0	/адрес верхней видеостроки пользовательского экрана

running_proc:	.word 0   /слово флагов для запуска подпрограмм в ПП
/*
01  - PutPixelPPU
02  - GetPixelPPU
04  - ClearSreenPPU
010 - PrintTopPPU
.
.
.
0100000 - завершение главного цикла ПП
*/

finished:            .word 0
addr_buffer_string:  .word 0


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

/Вычисление адрес вы ВОЗУ для ПП по координатам в PixelX, PixelY, результат в PxlAddr
CalcAddress:
    mov  PixelX, r0
    mov  PixelY, r1

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

    rts  pc


_PutPixel:    
    mov     6(sp), PxClr
/сравнение предыдущих и новых координат, если равны - адрес не вычисляется
    cmp  2(sp), PixelX
    bne  1f
    cmp  4(sp), PixelY
    bne  1f
    br   2f
1:
    mov     2(sp), PixelX
    mov     4(sp), PixelY
    
    jsr  pc, CalcAddress
2:
    bis $1, running_proc
3:
    bit $1, running_proc
    bne 3b

    rts  pc



_GetPixel:
    mov     6(sp), PxClr
/сравнение предыдущих и новых координат, если равны - адрес не вычисляется
    cmp  2(sp), PixelX
    bne  1f
    cmp  4(sp), PixelY
    bne  1f
    br   2f
1:
    mov     2(sp), PixelX
    mov     4(sp), PixelY
    
    jsr  pc, CalcAddress
2:
    bis $2, running_proc
3:
    tst received_color
    bmi 3b
    mov received_color, r0
    mov $-1, received_color
    
    rts  pc


_PrintTop:
    mov   2(sp), addr_buffer_string

    bis   $010, running_proc
1:
    bit $010, running_proc
    bne 1b

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

    / рулон в CPU
    mov $OffPPU, @$0177010
    mov offsetVPPU, @$0177014

    jsr  pc, MainPPU
    rts  pc


    /Основной цикл
MainPPU:
    mov $RunProcPPU, @$0177010
    mov $0177014, r0    

    bit $0100000, @r0    /проверка флага завершения
    bne 100f
     

    bit $1, @r0           /Проверка на PutPixel
    beq 2f
    jsr pc, PutPixelPPU

    mov $RunProcPPU, @$0177010
    mov $0177014, r0
    bic $1, @r0          /PutPixel выполнена
2:
    bit $2, @r0          /Проверка на GetPixel
    beq 3f
    jsr pc, GetPixelPPU

    mov $RunProcPPU, @$0177010
    mov $0177014, r0
    bic $2, @r0          /GetPixel выполнена
3: 
    bit $4, @r0          /Проверка на ClearScreen
    beq 4f
    jsr pc, ClearScreenPPU

    mov $RunProcPPU, @$0177010
    mov $0177014, r0
    bic $04, @r0
                         /ClearScreen выполнена
4:
    bit $010, @r0          /Проверка на PrintTop
    beq 5f
    jsr pc, PrintTopPPU

    mov $RunProcPPU, @$0177010
    mov $0177014, r0
    bic $010, @r0
                         /PrintTop выполнена
5:    
    jmp MainPPU
100:    
    rts  pc

ClearScreenPPU:
    mov	 r0, -(sp)
    mov	 r1, -(sp)
    mov	 r2, -(sp)

    clr  @$0177020
    clr  @$0177022
    mov  $0177010, r0      / регистр адреса ВОЗУ в ПП
    mov  $0177024, r1
    mov	 $0100000, @r0
    mov	 $(80 * 286), r2
1:
    clr  @r1
    inc	 @r0
    sob	 r2, 1b

    mov  (sp)+, r2
    mov  (sp)+, r1
    mov  (sp)+, r0

    rts  pc


PutPixelPPU:    
    mov $PxlAddress, @$0177010
    mov @$0177014, r0          /В r0 готовый адрес из ЦП

    inc @$0177010
    mov @$0177014, r2          /в r2 координата X

    bic $0b1111111111111000, r2 / В r2 номер точки в октете

    / Подготовка маски для вывода пикселя
    mov     $1, r3
    ash     r2, r3

    inc @$0177010    / color
    mov @$0177014, r2

    bic $0b1111111111111000, r2

    / Запись пикселя (r0 - адрес, r2 - цвет, r3 - маска пикселя в октете)
    mov r0, @$0177010
    mov r2, @$0177016
    movb r3, @$0177024

    rts  pc


GetPixelPPU:
    mov $PxlAddress, @$0177010
    mov @$0177014, r0          /В r0 готовый адрес из ЦП

    inc @$0177010
    mov @$0177014, r2          /в r2 координата X

    bic $0b1111111111111000, r2 / В r2 номер точки в октете

    mov r0, @$0177010
    tst @$0177024    / чтение регистров цвета фона

    / r2 = номер точки (0..7)
    asl r2
    asl r2               / r2 = n * 4

    neg r2
    mov @$0177020, r1    / старшее слово
    mov @$0177022, r0    / старшее слово
    ashc r2, r0         / сдвиг 32 бит регистров r0:r1

    bic $0b1111111111111000, r1

    / цвет в CPU
    mov $RecColor, @$0177010
    mov r1, @$0177014
    rts  pc


PrintTopPPU:
    mov  pc, r1
    add  $str_buff - ., r1
    mov  r1, adr_for_emt    
    
    inc  r1
    mov  r1, r3

    /Очистка буфера
    mov  $20, r2    
11:
    clr (r3)+
    sob  r2, 11b 

    mov  $addr_buffer_string, r0
    clc
    ror  r0                 /В r0 адрес адреса строки в ЦП
    mov  r0, @$0177010 
    mov  @$0177014, r0
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

    emt  052
adr_for_emt:  .word 0    

    rts  pc


FinishGraphPPU: 
    mov $finished, r0
    clc
    ror r0
    mov r0, @$0177010
    mov $1, @$0177014    
    rts  pc

//====================ДАННЫЕ ПП======================================================
offsetVPPU:	  .word	0         /адрес верхней видеостроки пользовательского экрана

str_buff:         .byte 0
str_buffer:       .fill 40, 1, 0  / Буфер для строки
.even


pp.end:

