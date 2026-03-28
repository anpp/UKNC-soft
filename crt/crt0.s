        .globl _start
        .globl _main
        .globl ___main
        .globl _crt0size

_start:
        mov     @$042, sp
        jsr     pc, _main
        emt     0350

___main:
        rts     pc

_crt0size: .word . - _start
