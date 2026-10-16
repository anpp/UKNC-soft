.text
.globl _runPPU, _getmemPPU, _freememPPU


rsk2 = 0176674
rdk2 = rsk2+2

mp:
            .byte   0
command:    .byte   01
            .word   032
addrPP:     .word   0
addrCP:     .word   0
WORDS:      .word   0
.even

.macro  mput  adrmp
    jsr r2, pp_mput
    .word   \adrmp
.endm


//Подпрограмма перемещения в К2 адреса МП
//=============================================================================
pp_mput: 
    jsr pc, 5f      //Подождем готовности К2
1:
    jsr pc, 4f      //Вытолкнем в К2 первые 2 байта адреса
    cmp     r2, $2f //Байты завершения переданы ?
    beq     3f      //..да - перейдем к проверке ответа
    clrb    @-(r2)  //Очистим байт ответа
    jsr     r2, 1b  //Передадим 2 байта завершения 0377
    .word   -1      //Байты завершения
2:
    tstb    @(r2)+  //Проверим ответ
3:
    rts     r2          //Выйдем в основную программу (или на 2b)
4:
    mov     pc, -(sp)   //Обеспечим повторный вход
    movb    (r2)+, @$rdk2   //Передача байта в К2
5:
    tstb    @$rsk2  //Ожидание готовности К2
    bpl     5b
    rts pc 
//=============================================================================


_runPPU:
    mov   4(sp), r0
    clc
    ror   r0
    movb  $01, command  //выделение памяти
    mov   r0, WORDS     //кол-во слов
    mov   r0, addrCP    //кол-во слов
    mput  mp
    bne   1f

    movb  $020, command  //копирование
    mov   2(sp), addrCP
    mput  mp
    bne   1f

    movb  $030, command  //запуск
    mput  mp

    movb  $2, command   //освобождение
    mput  mp
1:

    rts   pc


_getmemPPU:
    mov   2(sp), r0
    clc
    ror   r0
    movb  $01, command  //выделение памяти
    mov   r0, WORDS     //кол-во слов
    mov   r0, addrCP    //кол-во слов
    mput  mp
    bne   1f

    mov   addrPP, r0
    rts   pc
1:
    mov   $0, r0
    rts   pc


_freememPPU:
    mov   2(sp), addrPP

    movb  $2, command   //освобождение
    mput  mp

    rts   pc
