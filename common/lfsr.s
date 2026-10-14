.text
.globl _lfsr

_lfsr:  
    clc
    ror  (pc)+
Lfsr00:  .word  0126341     /; 0ACE1
    bcc  Lfsr03
    mov  (pc)+, r0
Lfsr01:  .word  0132000    /; 0B400
    xor  r0, Lfsr00
Lfsr03:  
    mov  Lfsr00, r0
    rts  pc
