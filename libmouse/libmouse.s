.globl _initMouse, _finishMouse, _setOnClick

.text

/CPU
rsk2 = 0176674
rdk2 = 0176676

/PPU
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

/структура для отправки данных во время работы (координат и тп)
mp1:
             .byte   0
command1:    .byte   020
             .word   032
addrPP1:     .word   0
addrCP1:     .word   0
WORDS1:      .word   0
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
    
    /jsr     pc, _GetMouseXY
    /mov     r1, -(sp)   /;координата y
    /mov     r0, -(sp)   /;координата x
mov $50, -(sp)
mov $30, -(sp)
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
    mtps  $0200
    bis   $0100, @$0176660      /;Разрешение прерывания 0460    
    mov   @$0460, OldInt460
    mov   $Int460, @$0460
    mtps  $0

    mput  mp
    bne	1f

    movb  $020, command
    mov	$pp.beg, WORD3
    mput	mp
    bne	1f

    movb  $030, command
    mput  mp
    
    mov  $1, r0
    rts  pc

1:
    mov  $0, r0
    rts  pc

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
_GetMouseXY:
    mov addrPP, r0
    add $(MouseOldX - pp.beg), r0  /;В r0 адрес координат в PPU

    movb    $10, command1
    mov    r0, addrPP1
    mov     $CoordMouse, addrCP1
    mov     $2, WORDS1
    mput    mp1

    mov     MX, r0
    mov     MY, r1

    rts     pc


/;Аргумент - адрес функции
_setOnClick:
    mov  2(sp), OnClickEvent
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
    mtps	$0200
    mov	@$0100, intTimer
    mov	TIProcAdr, @$0100
    mtps	$0

    mov	@$022664, VStrings
    dec	VStrings
    mov	@$022666, BytesInString

    mov	@$02476, r0
    mov	@r0, offsetV
    mov	@r0, OldOffsetV

    mov	$0177010, r4
    jsr pc, XorMouse

    rts   pc


/=============================================================================
PullCPU:
    bitb   $020, @$rsk1     /;готовность источника канала 1 PPU
    beq    PullCPU
    mov    2(sp), @$rdk1    /;посылка байта для вызывания прерывания 460 в CPU

    rts    pc


/=============================================================================
ParseMouse:
    /;mtps	#200

    mov	@$02476, r0
    mov	@r0, offsetV

    cmp	@r0, $0154540 /; список 220 видеострок для области отображения меню УСТАНОВКА
    bge	exit

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
    asr	r1
    rol	r2
    add	r1, MouseX
        /; Y and LMB
    swab    r0
    movb    r0, R1
    asr	r1
    rol	r2
    sub	r1, MouseY		/; Y is inverted
    
    /;проверка на клик левой кнопкой, пока в лоб
    bic $2, r2
    bic $2, r3
    cmp r3, r2
    blos 111f /; меньше или равно, кнопка или не нажата или не отжималась
    mov     $0376, -(sp)
    jsr pc, PullCPU
    add $2, sp
111:

    mov	r2, MouseRL
    mov	$0177010, r4
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

    mov	$8, HeightForDraw
    jsr   pc, XorMouse
    
    /;мышь стерта, пока не нарисована новая, проверка на завершение работы
    tst	finished
    beq	99f

    mtps  $0200
    mov	intTimer, @$0100
    mtps   $0
    br exit

99:
    mov	MouseX, MouseOldX
    mov	MouseY, MouseOldY
    mov	offsetV, OldOffsetV
    jsr pc, XorMouse

    mov	VStrings, r0
    inc	r0
    sub	MouseOldY, r0
    cmp	r0, $8
    ble	9f
    mov	$8, r0
9:
    mov	r0, HeightForDraw

exit:
    /;mtps  $0
    rts  pc
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
    mov r0, -(sp)
    mov r1, -(sp)
    mov r2, -(sp)
    mov r3, -(sp)
    mov r4, -(sp)
    mov r5, -(sp)
    
    jsr pc, ParseMouse


    mov (sp)+, r5
    mov (sp)+, r4
    mov (sp)+, r3
    mov (sp)+, r2
    mov (sp)+, r1
    mov (sp)+, r0
    mov (sp)+, @$0177010

    jmp @intTimer
/=============================================================================

finished:  .word 0   /;флаг завершения, устанавливается из CPU вызовом MouseFinish

intTimer:   .word 0

MouseX:     .word 320
MouseY:     .word 140
MouseRL:    .word 0

MouseOldX:   .word 320
MouseOldY:   .word 140

CharsInString:  .word   0	/;Кол-во символов в строке (22656 + 4)       
VStrings:       .word   0	/;Число отображаемых видеострок (22656 + 6)
BytesInString:  .word   0	/;Длина видеостроки в байтах (22656 + 10)
offsetV:        .word   0	/;адрес верхней видеостроки пользовательского экрана
OldOffsetV:     .word   0	/;адрес верхней видеостроки пользовательского экрана (предыдущий)
HeightForDraw:  .word   8
OldHeightForDraw: .word 8 /; проверка на бит нулевого плана



TAddr: /; Таблица адресов
TIProcAdr:      .word TimerInt - LT
adrProc:        .word ParseMouse - LT
adrMouseSpr:    .word MouSpr - LT
.word 0


HDraw:   .word 0



/=============================================================================
XorMouse:
    mov r5, -(sp)
    mov HeightForDraw, HDraw
    /; R4 was set earlier
    mov $0177012, r5

    mov MouseOldY, r1
    mul BytesInString, r1
    mov MouseOldX, r0
    mov r0, r3				/; preshifted sprite addition
    bic $0b1111111111111000, r3		/; 8-pix
    ash $4, r3				/; * 16 bytes (sprite size)
    asr r0
    asr r0
    asr r0
    add r1, r0
    add OldOffsetV, r0			/; R0 = mouse vaddr
    cmp r0, $0154540 /; список 220 видеострок для области отображения меню УСТАНОВКА
    blt 1f
    sub $054540, r0 /; 154540 - 100000 = 54540
      
1:  
    mov r0, (r4)
    mov adrMouseSpr, r0
    add r3, r0				/; adjust to preshifted sprite
    mov BytesInString, r1		/; vaddr addition
    dec r1
    
    tst HDraw
    beq ex
    mov HDraw, r3
cicle:
    mov (r0)+, r2
    xor r2, (r5)
    inc (r4)
    swab    r2
    xor r2, (r5)
    add r1, (r4)
    
    /;	Расскоментировать, чтоб не было визуально видно переход курсора на границе рулона
    /;cmp	(R4), #154540 ; список 220 видеострок для области отображения меню УСТАНОВКА
    /    ;blt	. + 6
    /;sub	#54540, (R4) ; 154540 - 100000 = 54540

    sob r3, cicle
    /;dec HDraw
    /;bne cicle

ex:
    mov (sp)+, r5
    rts pc
/=============================================================================

MouSpr:	/;0
    .word	0b0000000000000001
    .word	0b0000000000000011
    .word	0b0000000000000111
    .word	0b0000000000001111
    .word	0b0000000000011111
    .word	0b0000000000111111
    .word	0b0000000001111111
    .word	0b0000000000001111
    /;1
    .word	0b0000000000000010
    .word	0b0000000000000110
    .word	0b0000000000001110
    .word	0b0000000000011110
    .word	0b0000000000111110
    .word	0b0000000001111110
    .word	0b0000000011111110
    .word	0b0000000000011110
    /;2
    .word	0b0000000000000100
    .word	0b0000000000001100
    .word	0b0000000000011100
    .word	0b0000000000111100
    .word	0b0000000001111100
    .word	0b0000000011111100
    .word	0b0000000111111100
    .word	0b0000000000111100
    /;3
    .word	0b0000000000001000
    .word	0b0000000000011000
    .word	0b0000000000111000
    .word	0b0000000001111000
    .word	0b0000000011111000
    .word	0b0000000111111000
    .word	0b0000001111111000
    .word	0b0000000001111000
    /;4
    .word	0b0000000000010000
    .word	0b0000000000110000
    .word	0b0000000001110000
    .word	0b0000000011110000
    .word	0b0000000111110000
    .word	0b0000001111110000
    .word	0b0000011111110000
    .word	0b0000000011110000
    /;5
    .word	0b0000000000100000
    .word	0b0000000001100000
    .word	0b0000000011100000
    .word	0b0000000111100000
    .word	0b0000001111100000
    .word	0b0000011111100000
    .word	0b0000111111100000
    .word	0b0000000111100000
    /;6
    .word	0b0000000001000000
    .word	0b0000000011000000
    .word	0b0000000111000000
    .word	0b0000001111000000
    .word	0b0000011111000000
    .word	0b0000111111000000
    .word	0b0001111111000000
    .word	0b0000001111000000
    /;7
    .word	0b0000000010000000
    .word	0b0000000110000000
    .word	0b0000001110000000
    .word	0b0000011110000000
    .word	0b0000111110000000
    .word	0b0001111110000000
    .word	0b0011111110000000
    .word	0b0000011110000000

pp.end:
/=============================================================================================

