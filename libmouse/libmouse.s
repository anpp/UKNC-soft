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
1:  mov     r0, LineTable(r1)
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
    /; 1. Вычисление Y * 80 через таблицу
    mov     MouseY, r1
    asl     r1                      /; r1 = Y * 2 (индекс слова в таблице)
    add     adrLineTable, r1
    mov     @r1, r1       /; r1 = Y * 80

    mov MouseX, r0
    mov r0, r3
    bic $0b1111111111111000, r3		/; r3 = величина сдвига (0..7)

    asl r3
    add adrShift18Table, r3
    mov @r3, shift                      /;в shift предумноженное на 18 значение смещения прешифта спрайта

    asr r0
    asr r0
    asr r0
    add r1, r0
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
    mov	$0177010, r4
    mov	$0177014, r5

    mov	@$022664, VStrings
    dec	VStrings
    mov	@$022666, BytesInString

    mov	@$02476, r0
    mov	@r0, offsetV
    
    calcCurrVRAM /;макрос

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
.macro SaveBackground
/;r0 - адрес ВОЗУ
    mov r0, -(sp)
 
    mov $80, r2
    mov $0177012, r3
    mov adrBkgr, r1
    .rept 9

    mov  r0, @r4
    mov  @r5, (r1)+
    mov  @r3, (r1)+
    inc  @r4
    mov  @r5, (r1)+
    mov  @r3, (r1)+

    add   r2, r0          /; Смещение на строку вниз (+80 байт)
    cmp   r0, $0154540
    blt   2f
    sub   $054540, r0
2:
    .endr

    mov (sp)+, r0
.endm
/=============================================================================


/=============================================================================
.macro RestoreBackground
    tst VisibleMousePPU
    bne 1f
    jmp notrestore
1: 
    mov currVRAM, r0
    mov $0177012, r3
    mov adrBkgr, r1
    mov  $80, r2

    .rept 9
    mov  r0, @r4
    mov  (r1)+, @r5
    mov  (r1)+, @r3
    inc  @r4
    mov  (r1)+, @r5
    mov  (r1)+, @r3

    add   r2, r0          /; Смещение на строку вниз (+80 байт)
    cmp   r0, $0154540
    blt   2f
    sub   $054540, r0
2:
    .endr
notrestore:
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
    
    /;проверка на клик левой кнопкой, пока в лоб
    bic $2, r2
    bic $2, r3
    cmp r3, r2
    blos 111f /; меньше или равно, кнопка или не нажата или не отжималась

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

    mov	r2, MouseRL
    mov	BytesInString, r2

    /;	умножение на 8 - 80 байт на 8 = 640 пикселей
    asl	R2
    asl	R2
    asl	R2
    dec	R2

    tst	MouseX
    bge	52f
    clr	MouseX
    br	54f
52:	cmp  MouseX, r2
    ble	54f
    mov	r2,  MouseX
54:	tst  MouseY
    bge	56f
    clr	MouseY
    br	58f
56:	cmp  MouseY, VStrings
    ble	58f
    mov	VStrings, MouseY
58:

    RestoreBackground
    
    /;мышь стерта, пока не нарисована новая, проверка на завершение работы
    tst	finished
    beq	99f

    mtps  $0200
    mov	intTimer, @$0100
    mtps   $0
    br exit

99:
    calcCurrVRAM
    jmp PaintMouse
end_paintmouse:

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
.macro CheckShowMousePPU
    mov  $VisibleMouse, r1
    clc
    ror  r1           /;в ro адрес VisibleMouse в ЦП
    mov  r1, @r4
    mov  @r5, VisibleMousePPU
.endm


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



/-----------------------------------------------------------------------------
.macro paint_sprite_macro1
    mov $80, r2
    /; --- Переход на следующую строку ---
    add   r2, r0          /; Смещение на строку вниз (+80 байт)
    cmp   r0, $0154540
    blt   22f
    sub   $054540, r0
22: 
    add shift, r1
   
    .rept 7
    mov   (r1)+, r3

    mov   r0, @r4
    movb  r3, @r5
    inc   @r4
    swab  r3
    movb  r3, @r5

    /; --- Переход на следующую строку ---
    add   r2, r0          /; Смещение на строку вниз (+80 байт)
    cmp   r0, $0154540
    blt   2f
    sub   $054540, r0
2:
    .endr
    
.endm

/-----------------------------------------------------------------------------
.macro paint_sprite_macro2
    mov $80, r2

    add shift, r1

    .rept 9
    mov   (r1)+, r3

    mov   r0, @r4
    movb  r3, @r5
    inc   @r4
    swab  r3
    movb  r3, @r5

    /; --- Переход на следующую строку ---
    add   r2, r0          /; Смещение на строку вниз (+80 байт)
    cmp   r0, $0154540
    blt   2f
    sub   $054540, r0
2:
    .endr
    
.endm


/=============================================================================
PaintMouse:
/;  r0 - VRAM
    mov @$0177016, -(sp)    
    mov r5, -(sp)


    SaveBackground
end_savebkg:    

    CheckShowMousePPU                 /;Проверка флага из ЦП - видимая ли мышь?
/;    tst VisibleMousePPU              /;tst не нужен, флаги установлены в CheckShowMousePPU
    bne     paint
    jmp     notpaint
paint:
    mov $0177024, r5

    mov   $7, @$0177016
    mov   adrMouseSpr, r1
    tst (r1)+                      /;r1 = r1 + 2
    paint_sprite_macro1
/;====================ОКАНТОВКА===================================
    mov   $0, @$0177016
    mov   currVRAM, r0
    mov   adrMouseSprEdging, r1
    paint_sprite_macro2
/;====================ОКАНТОВКА===================================

notpaint:
    mov   (sp)+, r5
    mov   (sp)+, @$0177016
    jmp   end_paintmouse
/=============================================================================



/;==============================ДАННЫЕ ПП=====================================
MouSpr:
    /;0
    .word    0b0000000000000000
    .word    0b0000000000000010
    .word    0b0000000000000110
    .word    0b0000000000001110
    .word    0b0000000000011110
    .word    0b0000000000111110
    .word    0b0000000000001110
    .word    0b0000000000001110
    .word    0b0000000000000000
    /;1
    .word    0b0000000000000000
    .word    0b0000000000000100
    .word    0b0000000000001100
    .word    0b0000000000011100
    .word    0b0000000000111100
    .word    0b0000000001111100
    .word    0b0000000000011100
    .word    0b0000000000011100
    .word    0b0000000000000000
    /;2
    .word    0b0000000000000000
    .word    0b0000000000001000
    .word    0b0000000000011000
    .word    0b0000000000111000
    .word    0b0000000001111000
    .word    0b0000000011111000
    .word    0b0000000000111000
    .word    0b0000000000111000
    .word    0b0000000000000000
    /;3
    .word    0b0000000000000000
    .word    0b0000000000010000
    .word    0b0000000000110000
    .word    0b0000000001110000
    .word    0b0000000011110000
    .word    0b0000000111110000
    .word    0b0000000001110000
    .word    0b0000000001110000
    .word    0b0000000000000000
    /;4
    .word    0b0000000000000000
    .word    0b0000000000100000
    .word    0b0000000001100000
    .word    0b0000000011100000
    .word    0b0000000111100000
    .word    0b0000001111100000
    .word    0b0000000011100000
    .word    0b0000000011100000
    .word    0b0000000000000000
    /;5
    .word    0b0000000000000000
    .word    0b0000000001000000
    .word    0b0000000011000000
    .word    0b0000000111000000
    .word    0b0000001111000000
    .word    0b0000011111000000
    .word    0b0000000111000000
    .word    0b0000000111000000
    .word    0b0000000000000000
    /;6
    .word    0b0000000000000000
    .word    0b0000000010000000
    .word    0b0000000110000000
    .word    0b0000001110000000
    .word    0b0000011110000000
    .word    0b0000111110000000
    .word    0b0000001110000000
    .word    0b0000001110000000
    .word    0b0000000000000000
    /;7
    .word    0b0000000000000000
    .word    0b0000000100000000
    .word    0b0000001100000000
    .word    0b0000011100000000
    .word    0b0000111100000000
    .word    0b0001111100000000
    .word    0b0000011100000000
    .word    0b0000011100000000
    .word    0b0000000000000000

.even

MouSprEdging:
    /;0
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
adrMouseSpr:       .word MouSpr - LT
adrMouseSprEdging: .word MouSprEdging - LT
adrBkgr:           .word Bkgr - LT
adrLineTable:      .word LineTable - LT
adrShift18Table:   .word Shift18Table - LT
.word 0

.even
shift: .word 0
VisibleMousePPU:  .word 0
counter: .word 0 /;счетчик тактов

LineTable:  .fill 286, 2, 0 ;/286 строк

Shift18Table: .word   0, 18, 36, 54, 72, 90, 108, 126   /;таблица умножения на 18 байт (размер спрайта мыши)

.even

pp.end:
/=============================================================================================

