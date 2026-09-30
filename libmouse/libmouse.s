.globl _initMouse, _finishMouse, _setOnClick, _showMouse, _hideMouse, _getMouseXY


.text

/;CPU
rsk2 = 0176674
rdk2 = 0176676

/;PPU
rsk1 = 0177076
rdk1 = 0177072

pplen = (pp.end - pp.beg) >> 1

mp:
            .byte   0
command:    .byte   01
            .word   032
addrPP:     .word   0
WORD3:      .word   pplen
WORDS:      .word   pplen
.even

.macro  mput  adrmp
    jsr r2, pp_mput
    .word   \adrmp
.endm

CoordMouse:
MX: .word   0
MY: .word   0


OnClickEvent:  .word   0

OldInt460:     .word   0

VisibleMouse:   .word   0
finishShowHide: .word   1

/;Подпрограмма перемещения в К2 адреса МП
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



/=============================================================================
Int460:
    mov  r2, -(sp)
    
    mov  @$0176662, r2    
    cmp	r2, $0376	/;проверка регистра приемника канала 1 на кодовый байт
    bne	99f

    tst  OnClickEvent
    beq  99f              /;Если обработчик не установлен - выход
    
    /;Cохраняем все регистры, так как непонятно, что будет в функции OnClickEvent
    mov  r0, -(sp)
    mov  r1, -(sp)
    mov  r3, -(sp)
    mov  r4, -(sp)    
    mov  r5, -(sp)
    
    mov     MY, -(sp)
    mov     MX, -(sp)
    jsr     pc, @OnClickEvent
    add     $4, sp

    mov  (sp)+, r5
    mov  (sp)+, r4
    mov  (sp)+, r3
    mov  (sp)+, r1
    mov  (sp)+, r0

99:
    mov  (sp)+, r2
    tst  OldInt460     /;на случай, если уже кто-то перехватил это прерывание
    beq  100f
    jmp  @OldInt460
100:
    rti


_initMouse:
    jsr   pc, InitLineTable

    mput  mp
    bne	1f

    movb  $020, command
    mov	$pp.beg, WORD3
    mput	mp
    bne	1f

    movb  $030, command
    mput  mp

    mtps  $0200
    bis   $0100, @$0176660      /;Разрешение прерывания 0460    
    mov   @$0460, OldInt460
    mov   $Int460, @$0460
    mtps  $0
    
    mov  $1, r0
    rts  pc

1:
    mov  $0, r0
    rts  pc


InitLineTable:
    clr     r0
    clr     r1
1:  
    mov     r0, LineTable(r1)
    add     $80, r0                 /; +80 байт на строку
    add     $2, r1
    cmp     r1, $(286 * 2)
    blt     1b
    rts     pc


/;=============================================================================================
_finishMouse:
    /; запуск подпрограммы в ПП FinishMousePPU
    mov  addrPP, r0
    mov  r0, r1
    add  $(FinishMousePPU - pp.beg), r0
    movb  $030, command
    mov   r0, addrPP
    mput  mp

    /;дождаться завершения
1:
    tst   finished
    beq   1b

    /;освобождение памяти
    movb  $2, command
    mov   r1, addrPP
    mput  mp

    mtps   $0200
    bic    $0200, @$0176660      /;Запрет прерывания 0460
    mov    OldInt460, @$0460
    mtps   $0

    rts   pc

/;=============================================================================================
_showMouse:
    mov $1, VisibleMouse
    br  2f
_hideMouse:
    mov $0, VisibleMouse

    mov $100, r0 /;задержка чтоб мышь успела скрыться (по факту и без неё работает)
1:
    nop
    nop
    sob r0, 1b
2:
    rts pc

/;=============================================================================================
_getMouseXY:
                                                                                  	
    mov   MX, r0
    mov   MY, r1

    rts     pc


/;Аргумент - адрес функции
_setOnClick:
    mov  2(sp), OnClickEvent
    rts  pc


/--------------------------------------------------------------------------------------
.macro calcCurrVRAM
/;  MouseY обрабатывается до макроса, результат в r2

    mov MouseX, r0
    mov r0, r1
    bic $0b1111111111111000, r1     /; r3 = величина сдвига (0..7)

    asr r0
    asr r0
    asr r0
    add r2, r0
    add offsetV, r0			/; R0 = mouse vaddr
    cmp r0, $0154540 /; список 220 видеострок для области отображения меню УСТАНОВКА
    blt 1f
    sub $054540, r0 /; 154540 - 100000 = 54540
1:
    mov   r0, currVRAM

.endm


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
    mov adrLineTable, table_80mul1
    mov adrLineTable, table_80mul2
    mov adrShift32Table, table_32mul1
    mov adrShift32Table, table_32mul2

    mov	$0177010, r4
    mov	$0177014, r5

    mov	@$022664, VStrings
    dec	VStrings
    mov	@$022666, BytesInString

    mov	@$02476, r0
    mov	@r0, offsetV
    
    /; Вычисление Y * 80 через таблицу
    mov     MouseY, r2
    asl     r2                  /; r2 = Y * 2 (индекс слова в таблице)
table_80mul1 = . + 2
    mov 0(r2),  r2              /; r2 = Y * 80
    calcCurrVRAM
    asl r1
table_32mul1 = . + 2
    mov 0(r1), r1              /;в r1 предумноженное на 32 значение смещения прешифта спрайта (используется далее)

    mtps	$0200
    mov	@$0100, intTimer
    mov	TIProcAdr, @$0100
    mtps	$0

    rts   pc



/=============================================================================
PullCPU:
    bitb   $020, @$rsk1     /;готовность источника канала 1 PPU
    beq    PullCPU
    mov    2(sp), @$rdk1    /;посылка байта для вызывания прерывания 460 в CPU

    rts    pc


/=============================================================================
.macro CheckShowMousePPU
    mov  $VisibleMouse, r3
    clc
    ror  r3           /;в r3 адрес VisibleMouse в ЦП
    mov  r3, @r4
    mov  @r5, VisibleMousePPU
.endm


/=============================================================================
.macro SaveBackground
/;r0 - адрес ВОЗУ 
    mov r1, -(sp)
    mov $0154540, -(sp)

    mov $0177012, r3
    mov adrBkgr, r1
    mov  r0, @r4

    .rept 9
    
    mov  @r5, (r1)+
    mov  @r3, (r1)+
    inc  @r4
    mov  @r5, (r1)+
    mov  @r3, (r1)+

    add   r2, @r4          /; Смещение на строку вниз (+79 байт)
    cmp   @r4, @sp
    blo   2f
    sub   $054540, @r4
2:
    .endr

    tst (sp)+
    mov (sp)+, r1
.endm
/=============================================================================


/=============================================================================
.macro RestoreBackground
    tst VisibleMousePPU
    bne 1f
    jmp notrestore
1: 
    mov $0154540, -(sp)
    mov currVRAM, @r4
    mov $0177012, r3
    mov adrBkgr, r1
    mov  $79, r2

    .rept 9
    mov  (r1)+, @r5
    mov  (r1)+, @r3
    inc  @r4
    mov  (r1)+, @r5
    mov  (r1)+, @r3

    add   r2, @r4          /; Смещение на строку вниз (+79 байт)
    cmp   @r4, @sp
    blo   2f
    sub   $054540, @r4
2:
    .endr
    tst (sp)+
notrestore:
.endm
/=============================================================================


/-----------------------------------------------------------------------------
.macro paint_sprite_macro1
    mov   r0, @r4
    add   r2, @r4 /;для первого спрайта выводим на строку ниже
    inc   @r4

    .rept 6           /;7 итераций, последняя отдельно, чтоб не делать лишний перевод строки

    movb (r1)+,@r5
    inc   @r4
    movb (r1)+,@r5

    /; --- Переход на следующую строку ---
    add   r2, @r4          /; Смещение на строку вниз (+79 байт)
    .endr

    /;последняя итерация
    movb (r1)+,@r5
    inc   @r4
    movb (r1)+,@r5
    
.endm

/-----------------------------------------------------------------------------
.macro paint_sprite_macro2
    mov   r0, @r4

    .rept 8           /;9 итераций, последняя отдельно, чтоб не делать лишний перевод строки

    movb (r1)+,@r5
    inc   @r4
    movb (r1)+,@r5

    /; --- Переход на следующую строку ---
    add   r2, @r4          /; Смещение на строку вниз (+79 байт)
    cmp   @r4, r3
    blo   2f
    sub   $054540, @r4
2:
    .endr

    /;последняя итерация
    movb (r1)+,@r5
    inc   @r4
    movb (r1)+,@r5
    
.endm


/=============================================================================
.macro PaintMouse
/;  r0 - VRAM
    mov @$0177016, -(sp)    

    mov $79, r2                      /;r2 используется в SaveBackground, paint_sprite_macro1, paint_sprite_macro2
    SaveBackground

    CheckShowMousePPU                 /;Проверка флага из ЦП - видимая ли мышь?
/;    tst VisibleMousePPU              /;tst не нужен, флаги установлены в CheckShowMousePPU
    bne     paint
    jmp     notpaint
paint:
    mov $0177024, r5
    mov $0154540, r3                /;r3 испорчен в CheckShowMousePPU
    /; в r1 смещение прешифта, вычислено ранее

    mov   $7, @$0177016
    add   adrMouseSpr, r1
    paint_sprite_macro1
/;====================ОКАНТОВКА===================================
    mov   $0, @$0177016
    paint_sprite_macro2
/;====================ОКАНТОВКА===================================
notpaint:
    mov   (sp)+, @$0177016
.endm
/=============================================================================



/=============================================================================
.macro ParseMouse
    /;mtps $0200

    mov $0177010, r4
    mov $0177014, r5

    /;каждый кадр это не нужно для нерезидента
    /;mov  @$02476, r0
    /;mov  @r0, offsetV

    /;cmp @r0, $0154540 /; список 220 видеострок для области отображения меню УСТАНОВКА
    /;bge exit

    mov	@$0177400, r0
    /;	проверки, что координаты и рулон не менялись
    /;bit	#^B1111111011111110, R0
    /;bne	go
    /;cmp	offsetV, OldOffsetV
    /;beq	exit

go:

   /; [YYYYYYYLXXXXXXXR] signed 7-bit
    mov	MouseRL, r3		/; R3 - old RL buttons
    clr	r2			/; R2 - RL buttons
                          /; X and RMB
    movb    r0, r1
    asr r1
    rol r2
    add	r1, MouseX
        /; Y and LMB
    swab    r0
    movb    r0, R1
    asr r1
    rol r2
    sub	r1, MouseY		/; Y is inverted
    
/; Проверка на отжатие ЛКМ (1 -> 0)
    bit     $1, r3              /; Проверяем старое состояние (LMB)
    beq     111f                /; Если старая была 0
    bit     $1, r2              /; Проверяем новое состояние (LMB)
    bne     111f                /; Если новая 1

    mov $CoordMouse, @r4
    clc
    ror @r4
    mov MouseX, @r5
    inc @r4    
    mov MouseY, @r5

    mov     $0376, -(sp)
    jsr pc, PullCPU
    add $2, sp
111:

    mov     r2, MouseRL
    mov     $639, r2            /; максмальная координата x

    /; --- Ограничение X [0 .. 639] ---
    cmp     MouseX, r2
    blos    54f                 /; 0 <= MouseX <= 639
    bpl     52f                 /; Если разность > 0, значит MouseX > 639
    clr     MouseX              /; Иначе MouseX < 0
    br      54f
52: 
    mov     r2, MouseX

54:
    /; --- Ограничение Y [0 .. VStrings] ---
    cmp     MouseY, VStrings
    blos    58f                 /; 0 <= MouseY <= VStrings
    bpl     56f                 /; Если разность > 0, значит MouseY > VStrings
    clr     MouseY              /; Иначе MouseY < 0
    br      58f
56: mov     VStrings, MouseY

58:
    RestoreBackground
    
    /;мышь стерта, пока не нарисована новая, проверка на завершение работы
    tst	finished
    beq	99f

    mtps  $0200
    mov	intTimer, @$0100
    mtps   $0
    jmp exit

99:
    /; Вычисление Y * 80 через таблицу
    mov     MouseY, r2
    asl     r2                  /; r2 = Y * 2 (индекс слова в таблице)
table_80mul2 = . + 2
    mov 0(r2),  r2              /; r2 = Y * 80
    calcCurrVRAM
    asl r1
table_32mul2 = . + 2
    mov 0(r1), r1              /;в r1 предумноженное на 32 значение смещения прешифта спрайта (используется далее)

    PaintMouse
    mov $0177014, r5    /;r5 портится в PaintMouse
exit:
    /;mtps  $0
.endm
/=============================================================================


/=============================================================================
FinishMousePPU:    
    /;признак завершения в ЦП
    mov $1, finished /;для ПП
    mov $finished, r0
    clc    
    ror   r0
    mov r0, @$0177010
    mov $1, @$0177014    

    rts  pc


/=============================================================================
TimerInt:
    mov @$0177010, -(sp)
    mov @$0177020, -(sp)
    mov @$0177022, -(sp)
    mov r0, -(sp)
    mov r1, -(sp)
    mov r2, -(sp)
    mov r3, -(sp)
    mov r4, -(sp)
    mov r5, -(sp)  

/;проверка на четность счетчика, рисуем раз в два кадра
/;    inc counter
/;    mov counter, r0
/;    clc
/;    ror r0
/;    bcs end_parsemouse
      
    ParseMouse

end_parsemouse:

    mov (sp)+, r5
    mov (sp)+, r4
    mov (sp)+, r3
    mov (sp)+, r2
    mov (sp)+, r1
    mov (sp)+, r0
    mov (sp)+, @$0177022
    mov (sp)+, @$0177020
    mov (sp)+, @$0177010

    jmp @intTimer
/=============================================================================




/;==============================ДАННЫЕ ПП=====================================
MouseSpr:
    /;0
    .word    0b0000000000000010
    .word    0b0000000000000110
    .word    0b0000000000001110
    .word    0b0000000000011110
    .word    0b0000000000111110
    .word    0b0000000000001110
    .word    0b0000000000001110

    .word    0b0000000000000011
    .word    0b0000000000000101
    .word    0b0000000000001001
    .word    0b0000000000010001
    .word    0b0000000000100001
    .word    0b0000000001000001
    .word    0b0000000011110001
    .word    0b0000000000010001
    .word    0b0000000000011111

    /;1
    .word    0b0000000000000100
    .word    0b0000000000001100
    .word    0b0000000000011100
    .word    0b0000000000111100
    .word    0b0000000001111100
    .word    0b0000000000011100
    .word    0b0000000000011100

    .word    0b0000000000000110
    .word    0b0000000000001010
    .word    0b0000000000010010
    .word    0b0000000000100010
    .word    0b0000000001000010
    .word    0b0000000010000010
    .word    0b0000000111100010
    .word    0b0000000000100010
    .word    0b0000000000111110

    /;2
    .word    0b0000000000001000
    .word    0b0000000000011000
    .word    0b0000000000111000
    .word    0b0000000001111000
    .word    0b0000000011111000
    .word    0b0000000000111000
    .word    0b0000000000111000

    .word    0b0000000000001100
    .word    0b0000000000010100
    .word    0b0000000000100100
    .word    0b0000000001000100
    .word    0b0000000010000100
    .word    0b0000000100000100
    .word    0b0000001111000100
    .word    0b0000000001000100
    .word    0b0000000001111100

    /;3
    .word    0b0000000000010000
    .word    0b0000000000110000
    .word    0b0000000001110000
    .word    0b0000000011110000
    .word    0b0000000111110000
    .word    0b0000000001110000
    .word    0b0000000001110000

    .word    0b0000000000011000
    .word    0b0000000000101000
    .word    0b0000000001001000
    .word    0b0000000010001000
    .word    0b0000000100001000
    .word    0b0000001000001000
    .word    0b0000011110001000
    .word    0b0000000010001000
    .word    0b0000000011111000

    /;4
    .word    0b0000000000100000
    .word    0b0000000001100000
    .word    0b0000000011100000
    .word    0b0000000111100000
    .word    0b0000001111100000
    .word    0b0000000011100000
    .word    0b0000000011100000

    .word    0b0000000000110000
    .word    0b0000000001010000
    .word    0b0000000010010000
    .word    0b0000000100010000
    .word    0b0000001000010000
    .word    0b0000010000010000
    .word    0b0000111100010000
    .word    0b0000000100010000
    .word    0b0000000111110000

    /;5
    .word    0b0000000001000000
    .word    0b0000000011000000
    .word    0b0000000111000000
    .word    0b0000001111000000
    .word    0b0000011111000000
    .word    0b0000000111000000
    .word    0b0000000111000000

    .word    0b0000000001100000
    .word    0b0000000010100000
    .word    0b0000000100100000
    .word    0b0000001000100000
    .word    0b0000010000100000
    .word    0b0000100000100000
    .word    0b0001111000100000
    .word    0b0000001000100000
    .word    0b0000001111100000

    /;6
    .word    0b0000000010000000
    .word    0b0000000110000000
    .word    0b0000001110000000
    .word    0b0000011110000000
    .word    0b0000111110000000
    .word    0b0000001110000000
    .word    0b0000001110000000

    .word    0b0000000011000000
    .word    0b0000000101000000
    .word    0b0000001001000000
    .word    0b0000010001000000
    .word    0b0000100001000000
    .word    0b0001000001000000
    .word    0b0011110001000000
    .word    0b0000010001000000
    .word    0b0000011111000000

    /;7
    .word    0b0000000100000000
    .word    0b0000001100000000
    .word    0b0000011100000000
    .word    0b0000111100000000
    .word    0b0001111100000000
    .word    0b0000011100000000
    .word    0b0000011100000000

    .word    0b0000000110000000
    .word    0b0000001010000000
    .word    0b0000010010000000
    .word    0b0000100010000000
    .word    0b0001000010000000
    .word    0b0010000010000000
    .word    0b0111100010000000
    .word    0b0000100010000000
    .word    0b0000111110000000

.even

Bkgr: .fill 38, 2, 0


finished:  .word 0   /;флаг завершения, устанавливается из CPU вызовом MouseFinish

intTimer:   .word 0

MouseX:     .word 320
MouseY:     .word 140
MouseRL:    .word 0

CharsInString:  .word   0	/;Кол-во символов в строке (22656 + 4)       
VStrings:       .word   0	/;Число отображаемых видеострок (22656 + 6)
BytesInString:  .word   0	/;Длина видеостроки в байтах (22656 + 10)
offsetV:        .word   0	/;адрес верхней видеостроки пользовательского экрана

currVRAM:       .word   0

TAddr: /; Таблица адресов
TIProcAdr:         .word TimerInt - LT
adrMouseSpr:       .word MouseSpr - LT
adrBkgr:           .word Bkgr - LT
adrLineTable:      .word LineTable - LT
adrShift32Table:   .word Shift32Table - LT
.word 0

.even
VisibleMousePPU:  .word 0
counter: .word 0 /;счетчик тактов

LineTable:  .fill 286, 2, 0 ;/286 строк

Shift32Table: .word   0, 32, 64, 96, 128, 160, 192, 224   /;таблица умножения на 32 байт (размер спрайта мыши и окатновки)

.even

pp.end:
/=============================================================================================

