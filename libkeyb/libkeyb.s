.globl _InitKeyb, _FinishKeyb, _WaitAnyKey, _kbhit

.text

rsk2 = 0176674
rdk2 = rsk2+2

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


key_pressed:   .word 0
finished:      .word 0

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



_InitKeyb:
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

_FinishKeyb:
    / запуск подпрограммы в ПП FinishKeybPPU
    mov  addrPP, r0
    mov  r0, r1
    add  $(FinishKeybPPU - pp.beg), r0
    movb  $030, command
    mov   r0, addrPP
    mput  mp

    /дождаться завершения
1:
    tst   finished
    beq   1b

    /освобождение памяти
    movb  $2, command
    mov   r1, addrPP
    mput  mp
    rts   pc


_WaitAnyKey:
   mov   $0, key_pressed
1:
    tst  key_pressed
    beq  1b
    rts  pc

_kbhit:
    mov  key_pressed, r0
    rts  pc

/=============================================================================================
pp.beg:
    mtps  $0200

    mov	  @$0300, OldIntKbd
    mov   pc, r0
    add   $IntKbd - ., r0   /в r0 адрес  IntKbd
    mov   r0, @$0300

    mtps  $0
    rts   pc

IntKbd:	
    mov  r0, -(sp)
    mov  @$0177010, -(sp)

    mov  @$0177702, r0
    bit  $0b10000000, r0                /key pressed?
    bne  100f
    /запишем в ЦП код нажатой клавиши
    mov   $key_pressed, r0 
    asr   r0

    mov  r0, @$0177010
    mov  $1, @$0177014
    /mov  r0, @$0177014
    /;cmp  r0, #0b01001011             / is it 'space'?
    /;bne  10f
    /;br   20f
100:
    mov  (sp)+, @$0177010
    mov  (sp)+, r0
    rti


FinishKeybPPU:    
    mtps  $0200

    /восстановление прерывания клавиатуры
    mov  OldIntKbd, @$0300    

    mtps  $0

    /признак завершения в ЦП
    mov $finished, r0
    asr r0
    mov r0, @$0177010
    mov $1, @$0177014    

    rts  pc

/;====================ДАННЫЕ ПП======================================================

OldIntKbd:   .word 0


pp.end:

