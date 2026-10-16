	.text
	.section	.text.OnFrameEvent,"ax",@progbits
	.even
	.globl	_OnFrameEvent
_OnFrameEvent:
	mov	_frameCounter,r0
	inc	r0
	mov	r0,_frameCounter
	rts	pc
	.section	.text.OnMouseEvent,"ax",@progbits
	.even
	.globl	_OnMouseEvent
_OnMouseEvent:
	mov	_currentState,r0
	cmp	r0,$03
	beq	L_3
	mov	02(sp),_pendingX
	mov	04(sp),_pendingY
	movb	06(sp),_pendingLeft
	movb	$01,_hasPendingClick
	movb	010(sp),_pendingDown
L_3:
	rts	pc
	.section	.text.OnKeyEvent,"ax",@progbits
	.even
	.globl	_OnKeyEvent
_OnKeyEvent:
	add	$-04,sp
	cmpb	010(sp),$06
	beq	L_14
	cmpb	010(sp),$0113
	beq	L_15
L_8:
	add	$04,sp
	rts	pc
L_15:
	tstb	06(sp)
	bne	L_8
	mov	_palette,r0
	mov	_palette+02,r1
	tst	r0
	bne	L_16
	tst	r1
	cln
L_16:
	bne	L_13
	mov	$-0604,-(sp)
	mov	$-062550,-(sp)
	jsr	pc,_setPalette
	mov	r0,_palette
	mov	r1,_palette+02
	add	$04,sp
	br	L_8
L_14:
	tstb	06(sp)
	bne	L_8
	mov	_currentState,r0
	tst	r0
	beq	L_11
	cmp	r0,$01
	bne	L_8
	clr	_currentState
	br	L_8
L_13:
	mov	_palette,(sp)
	mov	_palette+02,02(sp)
	mov	_palette,r0
	mov	_palette+02,r1
	mov	02(sp),-(sp)
	clc
	ror	r0
	ror	r1
	ashc	$-017,r0	
	mov	r1,-(sp)
	jsr	pc,_setPalette
	mov	r0,_palette
	mov	r1,_palette+02
	add	$04,sp
	br	L_8
L_11:
	mov	$02,_currentState
	br	L_8
	.section	.text.rect,"ax",@progbits
	.even
	.globl	_rect
_rect:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	014(sp),r5
	mov	016(sp),r3
	mov	022(sp),r4
	mov	r4,-(sp)
	mov	022(sp),-(sp)
	mov	016(sp),-(sp)
	mov	r5,-(sp)
	mov	022(sp),-(sp)
	mov	$_fillRect,r2
	jsr	pc,(r2)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	r3,-(sp)
	mov	r5,-(sp)
	mov	034(sp),-(sp)
	jsr	pc,(r2)
	mov	r4,-(sp)
	mov	046(sp),-(sp)
	mov	r3,-(sp)
	mov	r5,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	mov	r4,-(sp)
	mov	060(sp),-(sp)
	mov	r3,-(sp)
	mov	064(sp),-(sp)
	mov	060(sp),-(sp)
	jsr	pc,(r2)
	add	$050,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.text.putText1,"ax",@progbits
	.even
	.globl	_putText1
_putText1:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	012(sp),r5
	mov	016(sp),r2
	mov	022(sp),r4
	movb	(r5),r0
	beq	L_18
	mov	014(sp),r3
	br	L_22
L_20:
	mov	r4,-(sp)
	mov	022(sp),-(sp)
	mov	r2,-(sp)
	mov	r3,-(sp)
	movb	r0,-(sp)
	jsr	pc,_putChar
	add	$010,r3
	add	$012,sp
	inc	r5
	movb	(r5),r0
	beq	L_18
L_22:
	cmpb	r0,$012
	bne	L_20
	add	$013,r2
	mov	014(sp),r3
	inc	r5
	movb	(r5),r0
	bne	L_22
L_18:
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.text.outK0,"ax",@progbits
	.even
	.globl	_outK0
_outK0:
	mov	r2,-(sp)
	mov	04(sp),r1
	movb	(r1),r0
	beq	L_27
	movb	@$-0214,r2
L_31:
	tstb	r2
	bge	L_30
	inc	r1
	movb	r0,@$-0212
	movb	(r1),r0
	bne	L_31
L_27:
	mov	(sp)+,r2
	rts	pc
L_30:
	br	L_30
	.section	.rodata
LC_0:
	.byte 033,045,041,063,014,0
	.section	.text.resetScreen,"ax",@progbits
	.even
	.globl	_resetScreen
_resetScreen:
	mov	r2,-(sp)
	mov	r3,-(sp)
	movb	@$-0214,r3
	movb	$033,r2
	mov	$LC_0,r1
	mov	$05,r0
L_39:
	tstb	r3
	bge	L_38
	inc	r1
	movb	r2,@$-0212
	movb	(r1),r2
	sob	r0,L_39
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_38:
	br	L_38
	.section	.text.random_init,"ax",@progbits
	.even
	.globl	_random_init
_random_init:
	mov	02(sp),r0
	mov	04(sp),r1
	tst	r0
	bne	L_44
	tst	r1
	cln
L_44:
	bne	L_42
	mov	$-066452,r0
	mov	$-071536,r1
L_42:
	mov	r0,_g_seed
	mov	r1,_g_seed+02
	rts	pc
	.section	.text.random_range,"ax",@progbits
	.even
	.globl	_random_range
_random_range:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-014,sp
	mov	030(sp),r4
	cmp	026(sp),r4
	blos	L_46
	mov	026(sp),r0
	mov	r4,026(sp)
	mov	r0,r4
L_46:
	mov	r4,r1
	clr	r0
	clr	r2
	mov	$01,r3
	add	r0,r2
	add	r1,r3
	adc	r2
	mov	r2,04(sp)
	mov	r3,06(sp)
	mov	026(sp),02(sp)
	clr	(sp)
	sub	(sp),r2
	sub	02(sp),r3
	sbc	r2
	mov	r2,010(sp)
	mov	r3,012(sp)
	mov	_g_seed,r0
	mov	_g_seed+02,r1
	ashc	$015,r0	
	mov	_g_seed,r4
	xor	r0,r4
	mov	_g_seed+02,r5
	xor	r1,r5
	mov	r4,r0
	mov	r5,r1
	clc
	ror	r0
	ror	r1
	ashc	$-020,r0	
	mov	r0,r2
	xor	r4,r2
	mov	r1,r3
	xor	r5,r3
	mov	r2,r0
	mov	r3,r1
	ashc	$05,r0	
	mov	r0,r4
	xor	r2,r4
	mov	r1,r5
	xor	r3,r5
	mov	r5,r0
	cmp	04(sp),(sp)
	bne	L_49
	cmp	06(sp),02(sp)
	cln
	clv
	bcc	L_49
	sen
L_49:
	beq	L_48
	mov	012(sp),-(sp)
	mov	012(sp),-(sp)
	mov	r5,-(sp)
	mov	r4,-(sp)
	jsr	pc,___umodsi3
	add	$010,sp
	mov	026(sp),r0
	add	r1,r0
L_48:
	mov	r4,_g_seed
	mov	r5,_g_seed+02
	add	$014,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.text.Cell_isMine,"ax",@progbits
	.even
	.globl	_Cell_isMine
_Cell_isMine:
	movb	@02(sp),r0
	bicb	$-02,r0
	rts	pc
	.section	.text.Cell_isOpen,"ax",@progbits
	.even
	.globl	_Cell_isOpen
_Cell_isOpen:
	movb	@02(sp),r0
	clc
	rorb	r0
	bicb	$-02,r0
	rts	pc
	.section	.text.Cell_isFlagged,"ax",@progbits
	.even
	.globl	_Cell_isFlagged
_Cell_isFlagged:
	movb	@02(sp),r0
	clc
	rorb	r0
	asrb	r0
	bicb	$-02,r0
	rts	pc
	.section	.text.Cell_getNeighborMines,"ax",@progbits
	.even
	.globl	_Cell_getNeighborMines
_Cell_getNeighborMines:
	movb	@02(sp),r0
	clc
	rorb	r0
	asrb	r0
	asrb	r0
	bicb	$-020,r0
	rts	pc
	.section	.text.Cell_setMine,"ax",@progbits
	.even
	.globl	_Cell_setMine
_Cell_setMine:
	movb	04(sp),r0
	bicb	$-02,r0
	movb	@02(sp),r1
	bicb	$01,r1
	bisb	r0,r1
	movb	r1,@02(sp)
	rts	pc
	.section	.text.Cell_setOpen,"ax",@progbits
	.even
	.globl	_Cell_setOpen
_Cell_setOpen:
	movb	04(sp),r0
	bicb	$-02,r0
	aslb	r0
	movb	@02(sp),r1
	bicb	$02,r1
	bisb	r0,r1
	movb	r1,@02(sp)
	rts	pc
	.section	.text.Cell_setFlagged,"ax",@progbits
	.even
	.globl	_Cell_setFlagged
_Cell_setFlagged:
	movb	04(sp),r0
	bicb	$-02,r0
	aslb	r0
	aslb	r0
	movb	@02(sp),r1
	bicb	$04,r1
	bisb	r0,r1
	movb	r1,@02(sp)
	rts	pc
	.section	.text.Cell_toggleFlag,"ax",@progbits
	.even
	.globl	_Cell_toggleFlag
_Cell_toggleFlag:
	movb	$04,r0
	bicb	@02(sp),r0
	movb	@02(sp),r1
	bicb	$04,r1
	bisb	r0,r1
	movb	r1,@02(sp)
	rts	pc
	.section	.text.Cell_setNeighborMines,"ax",@progbits
	.even
	.globl	_Cell_setNeighborMines
_Cell_setNeighborMines:
	movb	04(sp),r0
	bicb	$-020,r0
	aslb	r0
	aslb	r0
	aslb	r0
	movb	@02(sp),r1
	bicb	$0170,r1
	bisb	r0,r1
	movb	r1,@02(sp)
	rts	pc
	.section	.text.Cell_init,"ax",@progbits
	.even
	.globl	_Cell_init
_Cell_init:
	clrb	@02(sp)
	rts	pc
	.section	.text.drawSegment,"ax",@progbits
	.even
	.globl	_drawSegment
_drawSegment:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-02,sp
	mov	014(sp),r0
	add	020(sp),r0
	tstb	024(sp)
	bne	L_61
	tst	020(sp)
	ble	L_60
	tst	022(sp)
	ble	L_60
	mov	016(sp),r1
	add	022(sp),r1
	mov	r1,(sp)
	mov	$_putPixel,r5
	mov	r0,r3
	sub	014(sp),r3
	mov	014(sp),r1
	inc	r1
	cmp	r1,r0
	bgt	L_70
	cmp	r0,$-0100000
	beq	L_70
L_66:
	mov	016(sp),r4
	mov	(sp),r2
	sub	r4,r2
	mov	r4,r0
	inc	r0
	cmp	r0,(sp)
	bgt	L_69
	cmp	(sp),$-0100000
	beq	L_69
L_65:
	clr	-(sp)
	mov	r4,-(sp)
	mov	020(sp),-(sp)
	jsr	pc,(r5)
	inc	r4
	add	$06,sp
	sob	r2,L_65
	inc	014(sp)
	sob	r3,L_66
L_60:
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_70:
	mov	$01,r3
	br	L_66
L_69:
	mov	$01,r2
	br	L_65
L_61:
	mov	$02,-(sp)
	mov	020(sp),r1
	add	024(sp),r1
	dec	r1
	mov	r1,-(sp)
	dec	r0
	mov	r0,-(sp)
	mov	024(sp),-(sp)
	mov	024(sp),-(sp)
	jsr	pc,_fillRect
	add	$012,sp
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.text.draw7SegDigit,"ax",@progbits
	.even
	.globl	_draw7SegDigit
_draw7SegDigit:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-024,sp
	mov	042(sp),r0
	mov	036(sp),r1
	add	$02,r1
	mov	r1,012(sp)
	mov	036(sp),r1
	add	$011,r1
	mov	r1,014(sp)
	mov	040(sp),r1
	add	$02,r1
	mov	r1,04(sp)
	cmp	r0,$011
	bhi	L_121
	jmp	L_117
L_121:
	clrb	016(sp)
	movb	$040,020(sp)
	movb	$020,017(sp)
	movb	$010,021(sp)
	movb	$04,02(sp)
	movb	$02,06(sp)
L_76:
	mov	$02,-(sp)
	mov	042(sp),r0
	inc	r0
	mov	r0,-(sp)
	mov	042(sp),r1
	add	$010,r1
	mov	r1,-(sp)
	mov	046(sp),-(sp)
	mov	022(sp),-(sp)
	jsr	pc,_fillRect
	add	$012,sp
L_78:
	mov	040(sp),r0
	add	$011,r0
	mov	r0,010(sp)
	mov	036(sp),r1
	add	$012,r1
	mov	r1,022(sp)
	tstb	06(sp)
	beq	L_122
	jmp	L_80
L_122:
	mov	036(sp),r0
	add	$013,r0
	mov	r0,(sp)
	mov	014(sp),r3
	mov	$_putPixel,r2
L_81:
	mov	04(sp),r4
	mov	010(sp),r0
	sub	r4,r0
	mov	r0,r5
L_83:
	clr	-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	inc	r4
	add	$06,sp
	sob	r5,L_83
	inc	r3
	cmp	r3,(sp)
	bne	L_81
L_82:
	mov	040(sp),r1
	add	$013,r1
	mov	r1,(sp)
	mov	040(sp),r0
	add	$022,r0
	mov	r0,06(sp)
	tstb	02(sp)
	beq	L_123
	jmp	L_84
L_123:
	mov	036(sp),r1
	add	$013,r1
	mov	r1,02(sp)
	mov	014(sp),r3
	mov	$_putPixel,r2
L_85:
	mov	(sp),r4
	mov	06(sp),r1
	sub	r4,r1
	mov	r1,r5
L_87:
	clr	-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	inc	r4
	add	$06,sp
	sob	r5,L_87
	inc	r3
	cmp	r3,02(sp)
	bne	L_85
L_86:
	tstb	021(sp)
	beq	L_124
	jmp	L_118
L_124:
	mov	012(sp),r3
	mov	$_putPixel,r2
	mov	040(sp),r4
	add	$024,r4
	mov	014(sp),r0
	sub	r3,r0
	mov	r0,02(sp)
L_88:
	mov	06(sp),r5
L_90:
	clr	-(sp)
	mov	r5,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	inc	r5
	add	$06,sp
	cmp	r5,r4
	bne	L_90
	inc	r3
	dec	02(sp)
	beq	L_125
	jmp	L_88
L_125:
L_89:
	mov	036(sp),r1
	inc	r1
	mov	r1,02(sp)
	tstb	017(sp)
	beq	L_126
	jmp	L_119
L_126:
	mov	036(sp),r3
	mov	$_putPixel,r2
L_91:
	mov	(sp),r4
	mov	06(sp),r1
	sub	r4,r1
	mov	r1,r5
L_93:
	clr	-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	inc	r4
	add	$06,sp
	sob	r5,L_93
	inc	r3
	cmp	r3,012(sp)
	bne	L_91
L_92:
	tstb	020(sp)
	beq	L_127
	jmp	L_120
L_127:
	mov	036(sp),r3
	mov	$_putPixel,r2
L_94:
	mov	04(sp),r4
	mov	010(sp),r1
	sub	r4,r1
	mov	r1,r5
L_96:
	clr	-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	inc	r4
	add	$06,sp
	sob	r5,L_96
	inc	r3
	cmp	r3,012(sp)
	bne	L_94
L_95:
	tstb	016(sp)
	bne	L_116
	mov	$_putPixel,r2
	mov	014(sp),r3
	sub	012(sp),r3
	mov	(sp),r5
	mov	012(sp),r4
	mov	r3,(sp)
L_97:
	mov	010(sp),r3
L_99:
	clr	-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	jsr	pc,(r2)
	inc	r3
	add	$06,sp
	cmp	r5,r3
	bne	L_99
	inc	r4
	dec	(sp)
	beq	L_128
	jmp	L_97
L_128:
	add	$024,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_117:
	movb	_segmentMap(r0),r0
	movb	r0,r1
	bicb	$-03,r1
	movb	r1,06(sp)
	movb	r0,r1
	bicb	$-05,r1
	movb	r1,02(sp)
	movb	r0,r1
	bicb	$-011,r1
	movb	r1,021(sp)
	movb	r0,r1
	bicb	$-021,r1
	movb	r1,017(sp)
	movb	r0,r1
	bicb	$-041,r1
	movb	r1,020(sp)
	movb	r0,r1
	bicb	$-0101,r1
	movb	r1,016(sp)
	bit	r0,$01
	beq	L_129
	jmp	L_76
L_129:
	mov	012(sp),r3
	mov	$_putPixel,r2
	mov	04(sp),r5
	mov	$07,(sp)
L_77:
	mov	040(sp),r4
L_79:
	clr	-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	inc	r4
	add	$06,sp
	cmp	r5,r4
	bne	L_79
	inc	r3
	dec	(sp)
	beq	L_130
	jmp	L_77
L_130:
	jmp	L_78
L_80:
	mov	$02,-(sp)
	mov	042(sp),r1
	add	$010,r1
	mov	r1,-(sp)
	mov	026(sp),-(sp)
	mov	012(sp),-(sp)
	mov	024(sp),-(sp)
	jsr	pc,_fillRect
	add	$012,sp
	jmp	L_82
L_116:
	mov	$02,-(sp)
	mov	042(sp),r0
	add	$012,r0
	mov	r0,-(sp)
	mov	042(sp),r1
	add	$010,r1
	mov	r1,-(sp)
	mov	016(sp),-(sp)
	mov	022(sp),-(sp)
	jsr	pc,_fillRect
	add	$012,sp
	add	$024,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_120:
	mov	$02,-(sp)
	mov	042(sp),r0
	add	$010,r0
	mov	r0,-(sp)
	mov	06(sp),-(sp)
	mov	012(sp),-(sp)
	mov	046(sp),-(sp)
	jsr	pc,_fillRect
	add	$012,sp
	jmp	L_95
L_119:
	mov	$02,-(sp)
	mov	042(sp),r0
	add	$021,r0
	mov	r0,-(sp)
	mov	06(sp),-(sp)
	mov	06(sp),-(sp)
	mov	046(sp),-(sp)
	jsr	pc,_fillRect
	add	$012,sp
	jmp	L_92
L_118:
	mov	$02,-(sp)
	mov	042(sp),r0
	add	$023,r0
	mov	r0,-(sp)
	mov	042(sp),r1
	add	$010,r1
	mov	r1,-(sp)
	mov	014(sp),-(sp)
	mov	022(sp),-(sp)
	jsr	pc,_fillRect
	add	$012,sp
	jmp	L_89
L_84:
	mov	$02,-(sp)
	mov	042(sp),r0
	add	$021,r0
	mov	r0,-(sp)
	mov	026(sp),-(sp)
	mov	06(sp),-(sp)
	mov	024(sp),-(sp)
	jsr	pc,_fillRect
	add	$012,sp
	jmp	L_86
	.section	.text.drawNumberDisplay,"ax",@progbits
	.even
	.globl	_drawNumberDisplay
_drawNumberDisplay:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	016(sp),r2
	cmp	r2,$01747
	ble	L_132
	mov	$01747,r2
L_133:
	mov	014(sp),r4
	add	$03,r4
	mov	$___udivhi3,r5
	mov	$0144,-(sp)
	mov	r2,-(sp)
	jsr	pc,(r5)
	add	$04,sp
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	016(sp),r0
	add	$03,r0
	mov	r0,-(sp)
	mov	$_draw7SegDigit,r3
	jsr	pc,(r3)
	mov	$012,-(sp)
	mov	r2,-(sp)
	jsr	pc,(r5)
	add	$04,sp
	mov	$___umodhi3,r5
	mov	$012,-(sp)
	mov	r0,-(sp)
	jsr	pc,(r5)
	add	$04,sp
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	024(sp),r0
	add	$023,r0
	mov	r0,-(sp)
	jsr	pc,(r3)
	mov	$012,-(sp)
	mov	r2,-(sp)
	jsr	pc,(r5)
	add	$04,sp
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	032(sp),r0
	add	$043,r0
	mov	r0,-(sp)
	jsr	pc,(r3)
	add	$022,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_132:
	tst	r2
	bge	L_133
	clr	r2
	br	L_133
	.section	.text.stopTimer,"ax",@progbits
	.even
	.globl	_stopTimer
_stopTimer:
	clr	-(sp)
	jsr	pc,_setOnFrame
	clr	_frameCounter
	add	$02,sp
	rts	pc
	.section	.text.startTimer,"ax",@progbits
	.even
	.globl	_startTimer
_startTimer:
	mov	$_OnFrameEvent,-(sp)
	jsr	pc,_setOnFrame
	add	$02,sp
	rts	pc
	.section	.text.drawFlag,"ax",@progbits
	.even
	.globl	_drawFlag
_drawFlag:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	012(sp),r2
	mov	014(sp),r3
	mov	$010,r5
	add	r3,r5
	clr	-(sp)
	mov	r5,-(sp)
	mov	r2,r0
	inc	r0
	mov	r0,-(sp)
	mov	r3,-(sp)
	mov	r2,-(sp)
	mov	$_fillRect,r4
	jsr	pc,(r4)
	clr	-(sp)
	mov	r5,-(sp)
	mov	$05,r0
	add	r2,r0
	mov	r0,-(sp)
	mov	r5,-(sp)
	mov	$-04,r0
	add	r2,r0
	mov	r0,-(sp)
	jsr	pc,(r4)
	mov	$02,-(sp)
	mov	$03,r0
	add	r3,r0
	mov	r0,-(sp)
	mov	r2,-(sp)
	mov	r3,-(sp)
	add	$-06,r2
	mov	r2,-(sp)
	jsr	pc,(r4)
	add	$036,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.text.drawButton,"ax",@progbits
	.even
	.globl	_drawButton
_drawButton:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-04,sp
	clr	-(sp)
	mov	026(sp),-(sp)
	mov	026(sp),-(sp)
	mov	026(sp),-(sp)
	mov	026(sp),-(sp)
	jsr	pc,_rect
	mov	036(sp),r4
	dec	r4
	mov	034(sp),r5
	dec	r5
	mov	032(sp),r0
	inc	r0
	mov	r0,014(sp)
	mov	030(sp),r3
	inc	r3
	mov	$05,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	022(sp),-(sp)
	mov	r3,-(sp)
	mov	$_fillRect,r2
	jsr	pc,(r2)
	mov	044(sp),r0
	add	$02,r0
	mov	$07,-(sp)
	mov	r0,-(sp)
	mov	r5,-(sp)
	mov	034(sp),-(sp)
	mov	r3,-(sp)
	mov	r0,036(sp)
	jsr	pc,(r2)
	mov	$03,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	070(sp),r1
	add	$-02,r1
	mov	r1,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	add	$050,sp
	mov	$03,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	06(sp),r0
	mov	r0,-(sp)
	mov	032(sp),r0
	add	$-02,r0
	mov	r0,-(sp)
	jsr	pc,(r2)
	mov	$07,-(sp)
	mov	r4,-(sp)
	mov	034(sp),r1
	add	$02,r1
	mov	r1,-(sp)
	mov	022(sp),-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	add	$030,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.text.drawPressedButton,"ax",@progbits
	.even
	.globl	_drawPressedButton
_drawPressedButton:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-04,sp
	clr	-(sp)
	mov	026(sp),-(sp)
	mov	026(sp),-(sp)
	mov	026(sp),-(sp)
	mov	026(sp),-(sp)
	jsr	pc,_rect
	mov	036(sp),r4
	dec	r4
	mov	034(sp),r5
	dec	r5
	mov	032(sp),r0
	inc	r0
	mov	r0,014(sp)
	mov	030(sp),r3
	inc	r3
	mov	$05,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	022(sp),-(sp)
	mov	r3,-(sp)
	mov	$_fillRect,r2
	jsr	pc,(r2)
	mov	044(sp),r0
	add	$02,r0
	mov	$03,-(sp)
	mov	r0,-(sp)
	mov	r5,-(sp)
	mov	034(sp),-(sp)
	mov	r3,-(sp)
	mov	r0,036(sp)
	jsr	pc,(r2)
	mov	$07,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	070(sp),r1
	add	$-02,r1
	mov	r1,-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	add	$050,sp
	mov	$07,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	06(sp),r0
	mov	r0,-(sp)
	mov	032(sp),r0
	add	$-02,r0
	mov	r0,-(sp)
	jsr	pc,(r2)
	mov	$03,-(sp)
	mov	r4,-(sp)
	mov	034(sp),r1
	add	$02,r1
	mov	r1,-(sp)
	mov	022(sp),-(sp)
	mov	r3,-(sp)
	jsr	pc,(r2)
	add	$030,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.text.drawSmile,"ax",@progbits
	.even
	.globl	_drawSmile
_drawSmile:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-06,sp
	mov	020(sp),r5
	mov	$016,r2
	add	r5,r2
	mov	022(sp),r4
	add	$016,r4
	mov	$06,-(sp)
	mov	$010,-(sp)
	mov	r4,-(sp)
	mov	r2,-(sp)
	mov	$_fillCircle,r3
	jsr	pc,(r3)
	mov	$01,-(sp)
	mov	$010,-(sp)
	mov	r4,-(sp)
	mov	r2,-(sp)
	mov	$_circle,r4
	jsr	pc,(r4)
	add	$020,sp
	cmp	024(sp),$04
	bhi	L_139
	mov	024(sp),r0
	asl	r0
	jmp	@L_142(r0)
	.section	.rodata.drawSmile,"a",@progbits
	.even
L_142:
	.word	L_146
	.word	L_145
	.word	L_144
	.word	L_143
	.word	L_141
	.section	.text.drawSmile
L_143:
	mov	022(sp),r4
	add	$010,r4
	clr	-(sp)
	clr	-(sp)
	mov	r4,-(sp)
	mov	$06,r0
	add	r5,r0
	mov	r0,-(sp)
	movb	$052,-(sp)
	mov	$_putChar,r3
	jsr	pc,(r3)
	clr	-(sp)
	clr	-(sp)
	mov	r4,-(sp)
	mov	r2,-(sp)
	movb	$052,-(sp)
	jsr	pc,(r3)
	mov	046(sp),r0
	add	$021,r0
	clr	-(sp)
	mov	r0,-(sp)
	mov	$017,r1
	add	r5,r1
	mov	r1,-(sp)
	mov	r0,-(sp)
	mov	$015,r0
	add	r5,r0
	mov	r0,-(sp)
	jsr	pc,_fillRect
	mov	060(sp),r4
	add	$022,r4
	clr	-(sp)
	mov	r4,-(sp)
	mov	$014,r1
	add	r5,r1
	mov	r1,-(sp)
	mov	$_putPixel,r2
	jsr	pc,(r2)
	mov	066(sp),r3
	add	$023,r3
	add	$044,sp
L_147:
	clr	-(sp)
	mov	r3,-(sp)
	mov	$013,r0
	add	r5,r0
	mov	r0,-(sp)
	jsr	pc,(r2)
	clr	-(sp)
	mov	r4,-(sp)
	mov	$020,r1
	add	r5,r1
	mov	r1,-(sp)
	jsr	pc,(r2)
	clr	-(sp)
	mov	r3,-(sp)
	add	$021,r5
	mov	r5,-(sp)
	jsr	pc,(r2)
	add	$022,sp
L_139:
	add	$06,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_141:
	mov	022(sp),r0
	add	$014,r0
	clr	-(sp)
	mov	$01,-(sp)
	mov	r0,-(sp)
	mov	$012,r1
	add	r5,r1
	mov	r1,-(sp)
	mov	r0,010(sp)
	jsr	pc,(r3)
	clr	-(sp)
	mov	$01,-(sp)
	mov	014(sp),r0
	mov	r0,-(sp)
	add	$022,r5
	mov	r5,-(sp)
	jsr	pc,(r3)
	clr	-(sp)
	mov	$03,-(sp)
	mov	046(sp),r0
	add	$021,r0
	mov	r0,-(sp)
	mov	r2,-(sp)
	jsr	pc,(r4)
	add	$030,sp
	add	$06,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_146:
	mov	022(sp),r2
	add	$014,r2
	clr	-(sp)
	mov	$01,-(sp)
	mov	r2,-(sp)
	mov	$012,r0
	add	r5,r0
	mov	r0,-(sp)
	jsr	pc,(r3)
	clr	-(sp)
	mov	$01,-(sp)
	mov	r2,-(sp)
	mov	$022,r1
	add	r5,r1
	mov	r1,-(sp)
	jsr	pc,(r3)
	mov	042(sp),r0
	add	$023,r0
	clr	-(sp)
	mov	r0,-(sp)
	mov	$021,r1
	add	r5,r1
	mov	r1,-(sp)
	mov	r0,-(sp)
	add	$013,r5
	mov	r5,-(sp)
	jsr	pc,_fillRect
	add	$032,sp
	add	$06,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_145:
	mov	022(sp),r2
	add	$014,r2
	clr	-(sp)
	mov	$01,-(sp)
	mov	r2,-(sp)
	mov	$012,r0
	add	r5,r0
	mov	r0,-(sp)
	jsr	pc,(r3)
	clr	-(sp)
	mov	$01,-(sp)
	mov	r2,-(sp)
	mov	$022,r1
	add	r5,r1
	mov	r1,-(sp)
	jsr	pc,(r3)
	mov	042(sp),r0
	add	$023,r0
	clr	-(sp)
	mov	r0,-(sp)
	mov	$017,r1
	add	r5,r1
	mov	r1,-(sp)
	mov	r0,-(sp)
	mov	$015,r0
	add	r5,r0
	mov	r0,-(sp)
	jsr	pc,_fillRect
	mov	054(sp),r4
	add	$022,r4
	clr	-(sp)
	mov	r4,-(sp)
	mov	$014,r1
	add	r5,r1
	mov	r1,-(sp)
	mov	$_putPixel,r2
	jsr	pc,(r2)
	mov	062(sp),r3
	add	$021,r3
	add	$040,sp
	jmp	L_147
L_144:
	mov	022(sp),r2
	add	$014,r2
	clr	-(sp)
	mov	$03,-(sp)
	mov	r2,-(sp)
	mov	$012,r1
	add	r5,r1
	mov	r1,-(sp)
	jsr	pc,(r3)
	clr	-(sp)
	mov	$03,-(sp)
	mov	r2,-(sp)
	mov	$022,r0
	add	r5,r0
	mov	r0,-(sp)
	jsr	pc,(r3)
	mov	$020,r1
	add	r5,r1
	mov	r1,022(sp)
	mov	$014,r0
	add	r5,r0
	mov	r0,024(sp)
	clr	-(sp)
	mov	044(sp),r1
	add	$013,r1
	mov	r1,-(sp)
	mov	026(sp),-(sp)
	mov	050(sp),r0
	add	$012,r0
	mov	r0,-(sp)
	mov	034(sp),-(sp)
	mov	$_fillRect,r3
	jsr	pc,(r3)
	mov	054(sp),r2
	add	$022,r2
	mov	$017,r1
	add	r5,r1
	mov	$015,r4
	add	r5,r4
	clr	-(sp)
	mov	r2,-(sp)
	mov	r1,-(sp)
	mov	r2,-(sp)
	mov	r4,-(sp)
	mov	r1,044(sp)
	jsr	pc,(r3)
	mov	066(sp),r0
	add	$023,r0
	add	$044,sp
	clr	-(sp)
	mov	r0,-(sp)
	mov	04(sp),r1
	mov	r1,-(sp)
	mov	r0,-(sp)
	mov	r4,-(sp)
	jsr	pc,(r3)
	clr	-(sp)
	mov	r2,-(sp)
	mov	022(sp),-(sp)
	mov	$_putPixel,r3
	jsr	pc,(r3)
	mov	042(sp),r4
	add	$021,r4
	clr	-(sp)
	mov	r4,-(sp)
	mov	$013,r1
	add	r5,r1
	mov	r1,-(sp)
	jsr	pc,(r3)
	clr	-(sp)
	mov	r2,-(sp)
	mov	034(sp),-(sp)
	jsr	pc,(r3)
	clr	-(sp)
	mov	r4,-(sp)
	add	$021,r5
	mov	r5,-(sp)
	jsr	pc,(r3)
	add	$042,sp
	add	$06,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.text.drawMenuButton,"ax",@progbits
	.even
	.globl	_drawMenuButton
_drawMenuButton:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-02,sp
	mov	014(sp),r2
	mov	r2,r4
	ash	$04,r4	
	add	r2,r4
	asl	r4
	mov	$0100,r0
	add	r4,r0
	mov	$0136,r1
	add	r4,r1
	tstb	016(sp)
	beq	L_149
	mov	r1,-(sp)
	mov	$0620,-(sp)
	mov	r0,-(sp)
	mov	$0360,-(sp)
	jsr	pc,_drawPressedButton
	asl	r2
	mov	_menuLabels(r2),r3
	movb	(r3),r2
	add	$010,sp
	tstb	r2
	beq	L_148
	inc	r3
	mov	r3,-(sp)
	jsr	pc,_strlen
	add	$02,sp
	mov	$023,r5
	sub	r0,r5
	asl	r5
	asl	r5
	mov	$0362,r0
	add	r5,r0
	mov	r0,(sp)
	add	$0115,r4
L_156:
	mov	(sp),r5
	br	L_153
L_154:
	mov	$01,-(sp)
	clr	-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	movb	r2,-(sp)
	jsr	pc,_putChar
	add	$010,r5
	add	$012,sp
	movb	(r3),r2
	beq	L_148
L_158:
	inc	r3
L_153:
	cmpb	r2,$012
	bne	L_154
	add	$013,r4
	mov	(sp),r5
	movb	(r3),r2
	bne	L_158
L_148:
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_149:
	mov	r1,-(sp)
	mov	$0620,-(sp)
	mov	r0,-(sp)
	mov	$0360,-(sp)
	jsr	pc,_drawButton
	asl	r2
	mov	_menuLabels(r2),r3
	movb	(r3),r2
	add	$010,sp
	tstb	r2
	beq	L_148
	inc	r3
	mov	r3,-(sp)
	jsr	pc,_strlen
	add	$02,sp
	add	$0113,r4
	mov	$023,r5
	sub	r0,r5
	asl	r5
	asl	r5
	mov	$0360,r0
	add	r5,r0
	mov	r0,(sp)
	br	L_156
	.section	.text.processMenuClick.part.0,"ax",@progbits
	.even
_processMenuClick.part.0:
	cmp	r0,$077
	ble	L_159
	cmp	r0,$0136
	ble	L_161
	cmp	r0,$0141
	ble	L_159
	cmp	r0,$0200
	ble	L_162
	cmp	r0,$0203
	ble	L_159
	cmp	r0,$0242
	ble	L_163
	add	$-0246,r0
	cmp	r0,$036
	bhi	L_165
	movb	$03,_currentMode
	jsr	pc,_hideMouse
	movb	$01,-(sp)
	mov	$03,-(sp)
	jsr	pc,_drawMenuButton
	jsr	pc,_showMouse
	mov	$02,_currentState
	add	$04,sp
L_159:
	rts	pc
L_165:
	rts	pc
L_161:
	clrb	_currentMode
	jsr	pc,_hideMouse
	movb	$01,-(sp)
	clr	-(sp)
	jsr	pc,_drawMenuButton
	jsr	pc,_showMouse
	mov	$011,_field_w
	mov	$011,_field_h
	mov	$012,_total_mines
	mov	$01,_currentState
	add	$04,sp
	rts	pc
L_162:
	movb	$01,_currentMode
	jsr	pc,_hideMouse
	movb	$01,-(sp)
	mov	$01,-(sp)
	jsr	pc,_drawMenuButton
	jsr	pc,_showMouse
	mov	$024,_field_w
	mov	$014,_field_h
	mov	$045,_total_mines
	mov	$01,_currentState
	add	$04,sp
	rts	pc
L_163:
	movb	$02,_currentMode
	jsr	pc,_hideMouse
	movb	$01,-(sp)
	mov	$02,-(sp)
	jsr	pc,_drawMenuButton
	jsr	pc,_showMouse
	mov	$043,_field_w
	mov	$016,_field_h
	mov	$0132,_total_mines
	mov	$01,_currentState
	add	$04,sp
	rts	pc
	.section	.rodata
LC_1:
	.byte 0115,0111,0116,0105,0123,0127,0105,0105,0120,0105,0122,040,055,040,0115,0101,0111,0116,040,0115,0105,0116,0125,0
	.section	.text.drawMenu,"ax",@progbits
	.even
	.globl	_drawMenu
_drawMenu:
	mov	r2,-(sp)
	jsr	pc,_hideMouse
	tstb	_needClear
	bne	L_168
L_167:
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	mov	$_printTop,r2
	jsr	pc,(r2)
	mov	$LC_1,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r2)
	clrb	-(sp)
	clr	-(sp)
	mov	$_drawMenuButton,r2
	jsr	pc,(r2)
	clrb	-(sp)
	mov	$01,-(sp)
	jsr	pc,(r2)
	clrb	-(sp)
	mov	$02,-(sp)
	jsr	pc,(r2)
	clrb	-(sp)
	mov	$03,-(sp)
	jsr	pc,(r2)
	jsr	pc,_showMouse
	add	$030,sp
	mov	(sp)+,r2
	rts	pc
L_168:
	jsr	pc,_clearScreen
	br	L_167
	.section	.text.drawPressedCell,"ax",@progbits
	.even
	.globl	_drawPressedCell
_drawPressedCell:
	mov	r2,-(sp)
	mov	04(sp),r0
	ash	$04,r0	
	add	_offset_x,r0
	mov	06(sp),r1
	ash	$04,r1	
	add	_offset_y,r1
	mov	$020,r2
	add	r1,r2
	mov	r2,-(sp)
	mov	$020,r2
	add	r0,r2
	mov	r2,-(sp)
	mov	r1,-(sp)
	mov	r0,-(sp)
	jsr	pc,_drawPressedButton
	add	$010,sp
	mov	(sp)+,r2
	rts	pc
	.section	.text.drawCell,"ax",@progbits
	.even
	.globl	_drawCell
_drawCell:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-02,sp
	mov	014(sp),r3
	ash	$04,r3	
	add	_offset_x,r3
	mov	016(sp),r4
	ash	$04,r4	
	add	_offset_y,r4
	mov	$020,r0
	add	r3,r0
	mov	$020,r5
	add	r4,r5
	mov	014(sp),r2
	asl	r2
	asl	r2
	asl	r2
	sub	014(sp),r2
	asl	r2
	add	$_board,r2
	add	016(sp),r2
	movb	(r2),r1
	clc
	rorb	r1
	bit	r1,$01
	bne	L_171
	mov	r5,-(sp)
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,_drawButton
	movb	(r2),r0
	clc
	rorb	r0
	asrb	r0
	add	$010,sp
	bit	r0,$01
	bne	L_181
L_170:
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_171:
	mov	_innercellcolor,-(sp)
	mov	r5,-(sp)
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	mov	r0,012(sp)
	jsr	pc,_fillRect
	clr	-(sp)
	mov	r5,-(sp)
	mov	016(sp),r0
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,_rect
	add	$024,sp
	movb	(r2),r0
	bit	r0,$01
	bne	L_182
	movb	(r2),r0
	clc
	rorb	r0
	asrb	r0
	asrb	r0
	bicb	$-020,r0
	beq	L_170
	mov	$060,r1
	add	r0,r1
	decb	r0
	clr	r2
	cmpb	r0,$02
	bhi	L_176
	bic	$0177400,r0
	asl	r0
	mov	_CSWTCH.191(r0),r2
L_176:
	mov	$02,-(sp)
	mov	r2,-(sp)
	add	$04,r4
	mov	r4,-(sp)
	add	$05,r3
	mov	r3,-(sp)
	movb	r1,-(sp)
	jsr	pc,_putChar
	add	$012,sp
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_181:
	add	$04,r4
	mov	r4,-(sp)
	add	$010,r3
	mov	r3,-(sp)
	jsr	pc,_drawFlag
	add	$04,sp
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_182:
	add	$010,r4
	add	$010,r3
	clr	-(sp)
	mov	$04,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,_fillCircle
	mov	$02,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,_putPixel
	add	$016,sp
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.section	.rodata
LC_2:
	.byte 0115,0111,0116,0105,0123,0127,0105,0105,0120,0105,0122,040,055,040,0
LC_3:
	.byte 0114,0117,0101,0104,0111,0116,0107,056,056,056,0
LC_4:
	.byte 0105,0123,0103,050,0101,0122,062,051,040,055,040,0142,0141,0143,0153,0
LC_5:
	.byte 0123,0120,0101,0103,0105,040,055,040,0160,0141,0154,0145,0164,0164,0145,0
	.section	.text.drawInitialBoard,"ax",@progbits
	.even
	.globl	_drawInitialBoard
_drawInitialBoard:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-014,sp
	mov	$03,_currentState
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	mov	$_printTop,r2
	jsr	pc,(r2)
	mov	$LC_2,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r2)
	movb	_currentMode,r0
	asl	r0
	mov	_menuLabels(r0),-(sp)
	mov	$017,-(sp)
	jsr	pc,(r2)
	clr	-(sp)
	jsr	pc,_setOnFrame
	clr	_frameCounter
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	mov	$_printBottom,r0
	jsr	pc,(r0)
	mov	$LC_3,-(sp)
	mov	$01,-(sp)
	mov	$_printBottom,r1
	jsr	pc,(r1)
	clrb	_gameOver
	clrb	_gameWon
	movb	$01,_firstClick
	clr	_flags
	clr	_seconds
	mov	$050,r0
	sub	_field_w,r0
	asl	r0
	asl	r0
	asl	r0
	mov	r0,_offset_x
	mov	_field_h,r2
	asl	r2
	asl	r2
	asl	r2
	mov	$0223,r1
	sub	r2,r1
	mov	r1,_offset_y
	mov	$0462,_smileX
	mov	$0167,r0
	sub	r2,r0
	mov	r0,_smileY
	mov	r1,-(sp)
	mov	$0516,-(sp)
	mov	r0,-(sp)
	mov	$0462,-(sp)
	jsr	pc,_drawButton
	clr	-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	mov	$_drawSmile,r3
	jsr	pc,(r3)
	add	$044,sp
	mov	_total_mines,-(sp)
	mov	_offset_y,r0
	add	$-033,r0
	mov	r0,-(sp)
	mov	_offset_x,-(sp)
	mov	$_drawNumberDisplay,r2
	jsr	pc,(r2)
	mov	_seconds,-(sp)
	mov	_offset_y,r1
	add	$-033,r1
	mov	r1,-(sp)
	mov	_field_w,r0
	ash	$04,r0	
	add	_offset_x,r0
	add	$-061,r0
	mov	r0,-(sp)
	jsr	pc,(r2)
	mov	_field_w,016(sp)
	add	$014,sp
	tst	02(sp)
	bgt	L_237
	jmp	L_185
L_237:
	mov	_field_h,r5
	mov	$_board_copy,r3
	mov	$_board,r4
	mov	02(sp),r0
	asl	r0
	asl	r0
	asl	r0
	sub	02(sp),r0
	asl	r0
	mov	r0,04(sp)
	mov	r0,r1
	add	r3,r1
	tst	r5
	bgt	L_238
	jmp	L_190
L_238:
	mov	$_board,06(sp)
	sub	$_board_copy+016,r1
	clc
	ror	r1
	mov	r1,r0
	asl	r0
	asl	r0
	asl	r0
	add	r1,r0
	asl	r0
	asl	r0
	asl	r0
	add	r1,r0
	mov	r0,r1
	ash	$011,r1	
	mov	r0,r2
	add	r1,r2
	neg	r2
	bic	$-0100000,r2
	inc	r2
	mov	r4,010(sp)
	mov	r2,r4
	mov	$_board,r2
L_186:
	mov	r5,-(sp)
	mov	r2,-(sp)
	mov	r3,-(sp)
	jsr	pc,_memcpy
	add	$016,r3
	add	$016,r2
	add	$06,sp
	sob	r4,L_186
	mov	010(sp),r4
L_189:
	mov	04(sp),r2
	add	$_board,r2
	tst	r5
	ble	L_188
L_187:
	mov	r5,-(sp)
	clr	-(sp)
	mov	r4,-(sp)
	jsr	pc,_memset
	mov	$016,r0
	add	r4,r0
	add	$06,sp
	cmp	r2,r0
	beq	L_191
	mov	r5,-(sp)
	clr	-(sp)
	mov	r0,-(sp)
	jsr	pc,_memset
	add	$034,r4
	add	$06,sp
	cmp	r2,r4
	bne	L_187
L_191:
	tst	r5
	bgt	L_239
	jmp	L_185
L_239:
	movb	_initBySmile,013(sp)
	clr	06(sp)
	clr	r1
	mov	02(sp),010(sp)
L_198:
	mov	06(sp),r0
	tstb	013(sp)
	beq	L_233
	mov	06(sp),r3
	mul	$07,r3
	mov	r3,r2
	asl	r2
	mov	r2,04(sp)
	clr	r3
L_192:
	mov	04(sp),r2
	add	$_board_copy,r2
	add	r3,r2
	movb	(r2),r4
	clc
	rorb	r4
	bit	r4,$01
	beq	L_234
L_195:
	mov	r1,r2
	asl	r2
	mov	r0,_cells_to_draw(r2)
	inc	r3
	cmp	r5,r3
	bne	L_240
	jmp	L_206
L_240:
	add	02(sp),r0
	inc	r1
	br	L_192
L_188:
	mov	$016,r0
	add	r4,r0
	cmp	r2,r0
	beq	L_191
	add	$034,r4
	cmp	r2,r4
	bne	L_188
	br	L_191
L_190:
	mov	$016,r0
	add	r3,r0
	cmp	r0,r1
	beq	L_189
	add	$034,r3
	cmp	r1,r3
	bne	L_190
	br	L_189
L_234:
	movb	(r2),r2
	clc
	rorb	r2
	asrb	r2
	bit	r2,$01
	bne	L_195
	inc	r3
	cmp	r5,r3
	beq	L_193
	add	02(sp),r0
	br	L_192
L_233:
	mov	r1,r2
	clr	r3
L_194:
	mov	r2,r1
	inc	r1
	mov	r2,r4
	asl	r4
	mov	r0,_cells_to_draw(r4)
	mov	r3,r4
	inc	r4
	cmp	r4,r5
	beq	L_193
	add	02(sp),r0
	add	$02,r2
	asl	r1
	mov	r0,_cells_to_draw(r1)
	add	$02,r3
	add	02(sp),r0
	cmp	r5,r3
	bne	L_194
	mov	r2,r1
L_193:
	inc	06(sp)
	dec	010(sp)
	beq	L_241
	jmp	L_198
L_241:
L_236:
	tst	r1
	beq	L_185
	mov	r1,r2
	dec	r2
	cmp	r1,$01
	bne	L_242
	jmp	L_235
L_242:
	asl	r1
	mov	r1,06(sp)
	mov	r1,r3
	add	$_cells_to_draw-02,r3
	mov	$___umodhi3,04(sp)
	mov	r2,r5
L_201:
	jsr	pc,_lfsr
	mov	r2,r1
	inc	r1
	mov	r1,-(sp)
	mov	r0,-(sp)
	jsr	pc,@010(sp)
	add	$04,sp
	mov	(r3),r1
	asl	r0
	mov	_cells_to_draw(r0),(r3)
	mov	r1,_cells_to_draw(r0)
	dec	r2
	add	$-02,r3
	sob	r5,L_201
	mov	_field_w,02(sp)
L_200:
	mov	$___udivhi3,r5
	mov	06(sp),r2
	add	$-02,r2
	clc
	ror	r2
	inc	r2
	mov	$_cells_to_draw,r1
	mov	02(sp),r4
L_202:
	mov	(r1)+,r3
	mov	_cell_sprite_addr,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	mov	r1,06(sp)
	jsr	pc,(r5)
	add	$04,sp
	ash	$04,r0	
	add	_offset_y,r0
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,@014(sp)
	add	$04,sp
	ash	$04,r0	
	add	_offset_x,r0
	mov	r0,-(sp)
	mov	$_drawSprite,r3
	jsr	pc,(r3)
	add	$06,sp
	mov	(sp),r1
	dec	r2
	beq	L_243
	jmp	L_220
L_243:
L_185:
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	mov	$_drawSmile,r0
	jsr	pc,(r0)
	mov	$01,_currentState
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	mov	$_printBottom,r1
	jsr	pc,(r1)
	mov	$LC_4,-(sp)
	mov	$01,-(sp)
	mov	$_printBottom,r3
	jsr	pc,(r3)
	mov	$LC_5,-(sp)
	mov	$022,-(sp)
	jsr	pc,(r3)
	add	$036,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_206:
	inc	r1
	inc	06(sp)
	dec	010(sp)
	beq	L_244
	jmp	L_198
L_244:
	jmp	L_236
L_220:
	mov	_field_w,r4
	br	L_202
L_235:
	asl	r1
	mov	r1,06(sp)
	mov	$___umodhi3,04(sp)
	br	L_200
	.section	.rodata
LC_6:
	.byte 0131,0117,0125,040,0127,0111,0116,041,0
	.section	.text.checkWinCondition,"ax",@progbits
	.even
	.globl	_checkWinCondition
_checkWinCondition:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-06,sp
	tst	_field_w
	ble	L_252
	mov	_field_h,04(sp)
	tst	04(sp)
	ble	L_252
	clr	(sp)
	clr	r4
	mov	$_board,r5
	mov	_field_w,02(sp)
L_249:
	clr	r2
	mov	(sp),r3
	mul	$07,r3
	asl	r3
	mov	04(sp),r1
L_248:
	mov	r5,r0
	add	r3,r0
	add	r2,r0
	movb	(r0),r0
	clc
	rorb	r0
	bit	r0,$01
	bne	L_247
	inc	r4
L_247:
	inc	r2
	sob	r1,L_248
	inc	(sp)
	dec	02(sp)
	beq	L_256
	jmp	L_249
L_256:
L_246:
	cmp	_total_mines,r4
	beq	L_255
	add	$06,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_255:
	movb	$01,_gameWon
	movb	$01,_gameOver
	clr	-(sp)
	jsr	pc,_setOnFrame
	clr	_frameCounter
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	mov	$_printTop,r2
	jsr	pc,(r2)
	mov	$LC_6,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r2)
	mov	$02,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawSmile
	add	$020,sp
	add	$06,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_252:
	clr	r4
	br	L_246
	.section	.text.generateMines,"ax",@progbits
	.even
	.globl	_generateMines
_generateMines:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-024,sp
	jsr	pc,_getFrameCount
	mov	r0,r3
	clr	r2
	tst	r2
	bne	L_298
	tst	r3
	cln
L_298:
	bne	L_258
	mov	$-066452,r2
	mov	$-071536,r3
L_258:
	mov	r2,_g_seed
	mov	r3,_g_seed+02
	mov	_total_mines,(sp)
	mov	_field_w,r5
	tst	(sp)
	ble	L_265
	mov	r5,r1
	dec	r1
	mov	r1,04(sp)
	mov	_field_h,r1
	dec	r1
	mov	r1,02(sp)
	clr	r3
	mov	r5,012(sp)
	mov	036(sp),r4
	br	L_264
L_262:
	mov	r5,r1
	asl	r1
	asl	r1
	asl	r1
	sub	r5,r1
	asl	r1
	add	$_board,r1
	add	r0,r1
	movb	(r1),r0
	bit	r0,$01
	bne	L_263
	bisb	$01,(r1)
	inc	r3
L_263:
	cmp	r3,(sp)
	bge	L_295
L_264:
	mov	04(sp),-(sp)
	clr	-(sp)
	jsr	pc,_random_range
	mov	r0,r5
	mov	06(sp),-(sp)
	clr	-(sp)
	jsr	pc,_random_range
	add	$010,sp
	cmp	r5,r4
	bne	L_262
	cmp	r0,040(sp)
	bne	L_262
	cmp	r3,(sp)
	blt	L_264
L_295:
	mov	012(sp),r5
L_265:
	tst	r5
	ble	L_257
	mov	_field_h,012(sp)
	mov	$02,r1
	add	r5,r1
	tst	012(sp)
	bgt	L_299
	jmp	L_281
L_299:
	mov	$02,04(sp)
	clr	r0
	mov	012(sp),r1
	add	$02,r1
	mov	r1,020(sp)
	mov	r5,016(sp)
	mov	r5,022(sp)
L_279:
	mov	$02,r5
	mov	$07,r1
	mul	r0,r1
	mov	r1,r0
	asl	r0
	mov	r0,010(sp)
	mov	020(sp),r3
	sub	r5,r3
	mov	022(sp),r4
L_277:
	mov	$-02,r0
	add	r5,r0
	mov	r0,(sp)
	mov	010(sp),r0
	add	$_board,r0
	add	(sp),r0
	movb	(r0),r0
	bit	r0,$01
	beq	L_296
L_267:
	inc	r5
	sob	r3,L_277
	dec	016(sp)
	beq	L_300
	jmp	L_289
L_300:
L_257:
	add	$024,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_289:
	mov	04(sp),r0
	dec	r0
	inc	04(sp)
	br	L_279
L_296:
	mov	04(sp),r1
	add	$-03,r1
	clr	02(sp)
	mov	$-03,r0
	add	r5,r0
	mov	r0,06(sp)
	mov	r3,014(sp)
L_268:
	mov	06(sp),r0
	cmp	r1,$-01
	beq	L_271
L_276:
	mov	r5,r2
	sub	r0,r2
L_269:
	cmp	r1,r4
	blt	L_272
	inc	r0
	sob	r2,L_269
L_270:
	inc	r1
	cmp	r1,04(sp)
	bne	L_268
L_275:
	mov	014(sp),r3
	mov	010(sp),r1
	add	$_board,r1
	add	(sp),r1
	movb	02(sp),r0
	bicb	$-020,r0
	aslb	r0
	aslb	r0
	aslb	r0
	movb	(r1),r2
	bicb	$0170,r2
	bisb	r0,r2
	movb	r2,(r1)
	br	L_267
L_271:
	mov	r0,r2
	inc	r2
	cmp	r2,r5
	beq	L_270
	add	$02,r0
	cmp	r5,r0
	bne	L_271
	inc	r1
	cmp	r1,04(sp)
	bne	L_268
	br	L_275
L_272:
	mov	r0,r3
	cmp	r0,$-01
	beq	L_282
	cmp	012(sp),r0
	bgt	L_273
L_293:
	inc	r0
	cmp	r5,r0
	bne	L_276
	inc	r1
	cmp	r1,04(sp)
	bne	L_268
	br	L_275
L_282:
	clr	r3
	clr	r0
L_273:
	mov	r1,r2
	asl	r2
	asl	r2
	asl	r2
	sub	r1,r2
	asl	r2
	add	$_board,r2
	add	r3,r2
	movb	(r2),r2
	bicb	$-02,r2
	add	r2,02(sp)
	br	L_293
L_281:
	mov	$02,r0
	mov	r0,r2
	inc	r2
	cmp	r2,r1
	beq	L_257
L_297:
	cmp	r5,r0
	beq	L_257
	add	$02,r0
	mov	r0,r2
	inc	r2
	cmp	r2,r1
	bne	L_297
	br	L_257
	.section	.rodata
LC_7:
	.byte 0102,0117,0117,0115,041,0
	.section	.text.openCell,"ax",@progbits
	.even
	.globl	_openCell
_openCell:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-026,sp
	mov	040(sp),r0
	bis	042(sp),r0
	bge	L_404
	jmp	L_301
L_404:
	cmp	_field_w,040(sp)
	bgt	L_405
	jmp	L_301
L_405:
	cmp	_field_h,042(sp)
	bgt	L_406
	jmp	L_301
L_406:
	mov	040(sp),r2
	asl	r2
	asl	r2
	asl	r2
	sub	040(sp),r2
	asl	r2
	add	$_board,r2
	add	042(sp),r2
	movb	(r2),r0
	clc
	rorb	r0
	bit	r0,$01
	beq	L_407
	jmp	L_301
L_407:
	movb	(r2),r0
	clc
	rorb	r0
	asrb	r0
	bit	r0,$01
	beq	L_408
	jmp	L_301
L_408:
	movb	(r2),r0
	bit	r0,$01
	beq	L_409
	jmp	L_400
L_409:
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawSmile
	bisb	$02,(r2)
	mov	050(sp),-(sp)
	mov	050(sp),-(sp)
	mov	$_drawCell,034(sp)
	jsr	pc,@034(sp)
	mov	$_queue,r2
	mov	054(sp),r1
	ash	$010,r1	
	clr	r0
	bisb	052(sp),r0
	bis	r1,r0
	mov	r0,(r2)
	add	$012,sp
	mov	$01,012(sp)
	clr	06(sp)
	mov	r2,r5
	br	L_327
L_310:
	add	$02,r5
	cmp	06(sp),012(sp)
	blt	L_410
	jmp	L_301
L_410:
L_327:
	inc	06(sp)
	clr	r3
	bisb	(r5),r3
	clr	r0
	bisb	01(r5),r0
	mov	r0,010(sp)
	mov	r3,r0
	asl	r0
	asl	r0
	asl	r0
	sub	r3,r0
	asl	r0
	add	$_board,r0
	add	010(sp),r0
	movb	(r0),r0
	clc
	rorb	r0
	asrb	r0
	asrb	r0
	bit	r0,$017
	bne	L_310
	mov	r3,r1
	dec	r1
	mov	$-01,r4
	mov	r3,014(sp)
	mov	r5,020(sp)
L_311:
	mov	014(sp),r3
	tst	r4
	beq	L_325
	mov	r1,r3
L_325:
	mov	010(sp),r5
	dec	r5
	mov	$-01,r2
	tst	r4
	beq	L_392
	cmp	r3,$-01
	bne	L_411
	jmp	L_401
L_411:
L_392:
	mov	r1,(sp)
L_366:
	cmp	_field_w,r3
	bgt	L_402
L_323:
	inc	r2
	cmp	r2,$02
	beq	L_390
L_393:
	inc	r5
	tst	r4
	bne	L_366
L_315:
	tst	r2
	bne	L_366
	inc	r5
	mov	$01,r2
	cmp	_field_w,r3
	ble	L_323
L_402:
	cmp	r5,$-01
	beq	L_320
	cmp	_field_h,r5
	ble	L_323
	mov	r3,r0
	asl	r0
	asl	r0
	asl	r0
	sub	r3,r0
	asl	r0
	add	$_board,r0
	add	r5,r0
	mov	r0,024(sp)
	movb	(r0),r1
	clc
	rorb	r1
	bit	r1,$01
	bne	L_323
	movb	(r0),r1
	clc
	rorb	r1
	asrb	r1
	bit	r1,$01
	bne	L_323
	bisb	$02,(r0)
	mov	r5,-(sp)
	mov	r3,-(sp)
	jsr	pc,@026(sp)
	mov	016(sp),r0
	asl	r0
	mov	r0,06(sp)
	clr	r1
	bisb	r3,r1
	mov	r1,030(sp)
	mov	r5,r0
	ash	$010,r0	
	mov	r0,022(sp)
	bis	r0,r1
	mov	06(sp),r0
	mov	r1,_queue(r0)
	inc	016(sp)
	inc	r2
	add	$04,sp
	cmp	r2,$02
	bne	L_393
L_390:
	mov	(sp),r1
L_313:
	inc	r4
	inc	r1
	cmp	r4,$02
	bne	L_311
	mov	020(sp),r5
	jmp	L_310
L_308:
	inc	r5
	cmp	r5,_field_w
	blt	L_304
L_305:
	clr	-(sp)
	jsr	pc,_setOnFrame
	clr	_frameCounter
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	mov	$_printTop,r2
	jsr	pc,(r2)
	mov	$LC_7,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r2)
	mov	$03,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawSmile
	add	$020,sp
L_301:
	add	$026,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_401:
	cmp	r2,$01
	beq	L_313
L_403:
	mov	$01,r2
	cmp	r2,$01
	bne	L_403
	br	L_313
L_320:
	inc	r2
	cmp	r2,$02
	beq	L_390
	clr	r5
	tst	r4
	beq	L_412
	jmp	L_366
L_412:
	jmp	L_315
L_400:
	bisb	$02,(r2)
	mov	$02,_innercellcolor
	mov	042(sp),-(sp)
	mov	042(sp),-(sp)
	mov	$_drawCell,026(sp)
	jsr	pc,@026(sp)
	mov	$07,_innercellcolor
	movb	$01,_gameOver
	add	$04,sp
	tst	_field_w
	ble	L_305
	clr	r5
	mov	022(sp),r4
L_304:
	tst	_field_h
	ble	L_308
	clr	r2
	mov	$07,r3
	mul	r5,r3
	asl	r3
	add	$_board,r3
	br	L_307
L_306:
	inc	r2
	cmp	r2,_field_h
	bge	L_308
L_307:
	mov	r3,r0
	add	r2,r0
	movb	(r0),r1
	bit	r1,$01
	beq	L_306
	clc
	rorb	r1
	bit	r1,$01
	bne	L_306
	bisb	$02,(r0)
	mov	r2,-(sp)
	mov	r5,-(sp)
	jsr	pc,(r4)
	add	$04,sp
	br	L_306
	.section	.text.processMenuClick,"ax",@progbits
	.even
	.globl	_processMenuClick
_processMenuClick:
	mov	02(sp),r0
	add	$-0360,r0
	cmp	r0,$0240
	bhi	L_413
	mov	04(sp),r0
	jsr	pc,_processMenuClick.part.0
L_413:
	rts	pc
	.section	.text.releaseCurrentCell,"ax",@progbits
	.even
	.globl	_releaseCurrentCell
_releaseCurrentCell:
	tstb	_hasCurrentCell
	bne	L_417
	rts	pc
L_417:
	jsr	pc,_hideMouse
	clr	r0
	bisb	_currentCell+01,r0
	mov	r0,-(sp)
	clr	r0
	bisb	_currentCell,r0
	mov	r0,-(sp)
	jsr	pc,_drawCell
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawSmile
	jsr	pc,_showMouse
	clrb	_hasCurrentCell
	add	$012,sp
	rts	pc
	.section	.text.processClick,"ax",@progbits
	.even
	.globl	_processClick
_processClick:
	mov	r2,-(sp)
	mov	r3,-(sp)
	add	$-014,sp
	mov	_currentState,r0
	tst	r0
	bne	L_419
	tstb	026(sp)
	bne	L_418
	tstb	030(sp)
	beq	L_418
	mov	022(sp),r0
	add	$-0360,r0
	cmp	r0,$0240
	bhi	L_418
	mov	024(sp),r0
	jsr	pc,_processMenuClick.part.0
L_418:
	add	$014,sp
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_419:
	cmp	022(sp),_smileX
	blt	L_456
	jmp	L_452
L_456:
L_423:
	tstb	_gameOver
	bne	L_418
	cmp	022(sp),_offset_x
	bge	L_457
	jmp	L_425
L_457:
	cmp	024(sp),_offset_y
	bge	L_458
	jmp	L_425
L_458:
	mov	022(sp),r0
	sub	_offset_x,r0
	ash	$-04,r0	
	cmp	r0,_field_w
	blt	L_459
	jmp	L_425
L_459:
	mov	024(sp),r1
	sub	_offset_y,r1
	ash	$-04,r1	
	cmp	r1,_field_h
	blt	L_460
	jmp	L_425
L_460:
	clr	r2
	bisb	_currentCell,r2
	cmp	r0,r2
	bne	L_461
	jmp	L_453
L_461:
L_427:
	tstb	030(sp)
	bne	L_462
	jmp	L_425
L_462:
	mov	r0,(sp)
	mov	r1,02(sp)
	jsr	pc,_hideMouse
	mov	(sp),r0
	mov	02(sp),r1
	tstb	026(sp)
	bne	L_463
	jmp	L_429
L_463:
L_433:
	mov	r0,r2
	asl	r2
	asl	r2
	asl	r2
	sub	r0,r2
	mov	r2,010(sp)
	asl	r2
	add	$_board,r2
	add	r1,r2
	mov	r2,06(sp)
	movb	(r2),r3
	clc
	rorb	r3
	bit	r3,$01
	bne	L_434
	movb	@06(sp),r3
	clc
	rorb	r3
	asrb	r3
	bit	r3,$01
	bne	L_435
	cmp	_flags,_total_mines
	bge	L_434
L_435:
	mov	010(sp),r2
	asl	r2
	add	$_board,r2
	add	r1,r2
	mov	r2,010(sp)
	movb	$04,r3
	bicb	(r2),r3
	movb	r3,012(sp)
	movb	(r2),r2
	bicb	$04,r2
	bisb	r3,r2
	movb	r2,@010(sp)
	mov	r1,-(sp)
	mov	r0,-(sp)
	jsr	pc,_drawCell
	movb	@014(sp),r0
	clc
	rorb	r0
	asrb	r0
	add	$04,sp
	bit	r0,$01
	bne	L_464
	jmp	L_440
L_464:
	mov	$01,r0
L_436:
	add	_flags,r0
	mov	r0,_flags
	mov	_total_mines,r1
	sub	r0,r1
	mov	r1,-(sp)
	mov	_offset_y,r2
	add	$-033,r2
	mov	r2,-(sp)
	mov	_offset_x,-(sp)
	jsr	pc,_drawNumberDisplay
	add	$06,sp
L_434:
	jsr	pc,_showMouse
	jmp	L_418
L_452:
	mov	_smileX,r0
	add	$033,r0
	cmp	022(sp),r0
	ble	L_465
	jmp	L_423
L_465:
	cmp	024(sp),_smileY
	bge	L_466
	jmp	L_423
L_466:
	mov	_smileY,r0
	add	$033,r0
	cmp	024(sp),r0
	ble	L_467
	jmp	L_423
L_467:
	tstb	_hasCurrentCell
	beq	L_468
	jmp	L_454
L_468:
L_424:
	tstb	030(sp)
	bne	L_469
	jmp	L_418
L_469:
	tstb	026(sp)
	beq	L_470
	jmp	L_418
L_470:
	jsr	pc,_hideMouse
	mov	_smileY,r2
	add	$034,r2
	mov	r2,-(sp)
	mov	_smileX,r3
	add	$034,r3
	mov	r3,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawPressedButton
	mov	$01,-(sp)
	mov	_smileY,r0
	add	$02,r0
	mov	r0,-(sp)
	mov	_smileX,r1
	add	$02,r1
	mov	r1,-(sp)
	mov	$_drawSmile,r0
	mov	r0,016(sp)
	jsr	pc,(r0)
	mov	_smileY,r2
	add	$034,r2
	mov	r2,-(sp)
	mov	_smileX,r3
	add	$034,r3
	mov	r3,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawButton
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	mov	034(sp),r0
	jsr	pc,(r0)
	movb	$01,_initBySmile
	jsr	pc,_drawInitialBoard
	jsr	pc,_showMouse
	add	$034,sp
	jmp	L_418
L_425:
	tstb	_hasCurrentCell
	bne	L_471
	jmp	L_418
L_471:
	jsr	pc,_hideMouse
	clr	r0
	bisb	_currentCell+01,r0
	mov	r0,-(sp)
	clr	r1
	bisb	_currentCell,r1
	mov	r1,-(sp)
	jsr	pc,_drawCell
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawSmile
	jsr	pc,_showMouse
	clrb	_hasCurrentCell
	add	$012,sp
	jmp	L_418
L_453:
	clr	r3
	bisb	_currentCell+01,r3
	cmp	r1,r3
	beq	L_472
	jmp	L_427
L_472:
	mov	r0,(sp)
	mov	r1,02(sp)
	jsr	pc,_hideMouse
	mov	(sp),r0
	mov	02(sp),r1
	tstb	026(sp)
	beq	L_432
	tstb	030(sp)
	bne	L_473
	jmp	L_434
L_473:
	jmp	L_433
L_429:
	mov	r0,r3
	asl	r3
	asl	r3
	asl	r3
	sub	r0,r3
	asl	r3
	add	$_board,r3
	add	r1,r3
	mov	r3,06(sp)
	movb	(r3),r2
	clc
	rorb	r2
	asrb	r2
	bit	r2,$01
	beq	L_474
	jmp	L_434
L_474:
	movb	(r3),r2
	clc
	rorb	r2
	bit	r2,$01
	beq	L_475
	jmp	L_434
L_475:
L_438:
	mov	r1,r3
	ash	$010,r3	
	mov	r3,06(sp)
	clr	r2
	bisb	r0,r2
	bis	r3,r2
	mov	r2,_currentCell
	mov	$04,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	mov	r0,06(sp)
	mov	r1,010(sp)
	jsr	pc,_drawSmile
	mov	06(sp),r0
	ash	$04,r0	
	add	_offset_x,r0
	mov	010(sp),r1
	ash	$04,r1	
	add	_offset_y,r1
	mov	$020,r3
	add	r1,r3
	mov	r3,-(sp)
	mov	$020,r2
	add	r0,r2
	mov	r2,-(sp)
	mov	r1,-(sp)
	mov	r0,-(sp)
	jsr	pc,_drawPressedButton
	movb	$01,_hasCurrentCell
	add	$016,sp
	jmp	L_434
L_454:
	jsr	pc,_hideMouse
	clr	r0
	bisb	_currentCell+01,r0
	mov	r0,-(sp)
	clr	r1
	bisb	_currentCell,r1
	mov	r1,-(sp)
	jsr	pc,_drawCell
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawSmile
	jsr	pc,_showMouse
	clrb	_hasCurrentCell
	add	$012,sp
	jmp	L_424
L_432:
	mov	r0,r3
	asl	r3
	asl	r3
	asl	r3
	sub	r0,r3
	asl	r3
	add	$_board,r3
	add	r1,r3
	mov	r3,06(sp)
	movb	(r3),r2
	clc
	rorb	r2
	asrb	r2
	bit	r2,$01
	beq	L_476
	jmp	L_434
L_476:
	movb	(r3),r2
	clc
	rorb	r2
	bit	r2,$01
	beq	L_477
	jmp	L_434
L_477:
	tstb	030(sp)
	bne	L_438
	tstb	_hasCurrentCell
	bne	L_478
	jmp	L_434
L_478:
	clrb	_hasCurrentCell
	tstb	_firstClick
	bne	L_455
L_439:
	mov	r1,-(sp)
	mov	r0,-(sp)
	jsr	pc,_openCell
	add	$04,sp
	tstb	_gameOver
	beq	L_479
	jmp	L_434
L_479:
	jsr	pc,_checkWinCondition
	jmp	L_434
L_440:
	mov	$-01,r0
	jmp	L_436
L_455:
	mov	r1,-(sp)
	mov	r0,-(sp)
	mov	r0,04(sp)
	mov	r1,06(sp)
	jsr	pc,_generateMines
	clrb	_firstClick
	mov	$_OnFrameEvent,-(sp)
	jsr	pc,_setOnFrame
	add	$06,sp
	mov	02(sp),r1
	mov	(sp),r0
	br	L_439
	.section	.text.initCellSprite,"ax",@progbits
	.even
	.globl	_initCellSprite
_initCellSprite:
	mov	r2,-(sp)
	mov	$020,-(sp)
	mov	$020,-(sp)
	clr	-(sp)
	clr	-(sp)
	jsr	pc,_drawButton
	mov	$01,-(sp)
	mov	$_pauseGraph,r2
	jsr	pc,(r2)
	mov	$0200,-(sp)
	jsr	pc,_getmemPPU
	mov	r0,_cell_sprite_addr
	mov	r0,-(sp)
	mov	$-0100000,-(sp)
	jsr	pc,_copySprite
	clr	-(sp)
	jsr	pc,(r2)
	add	$022,sp
	mov	(sp)+,r2
	rts	pc
	.section	.rodata
LC_8:
	.byte 0105,0123,0103,050,0101,0122,062,051,040,055,040,0145,0170,0151,0164,0
	.section	.text.main,"ax",@progbits
	.even
	.globl	_main
_main:
	mov	r2,-(sp)
	mov	r3,-(sp)
	add	$-014,sp
	jsr	pc,___main
	mov	$_resetScreen,r2
	jsr	pc,(r2)
	jsr	pc,_initMouse
	tstb	r0
	bne	L_510
L_481:
	add	$014,sp
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_510:
	jsr	pc,_initKeyb
	tstb	r0
	beq	L_481
	jsr	pc,_initGraph
	tstb	r0
	beq	L_481
	mov	$_OnMouseEvent,-(sp)
	jsr	pc,_setOnClick
	mov	$_OnKeyEvent,-(sp)
	jsr	pc,_setOnKeyEvent
	clr	-(sp)
	clr	-(sp)
	jsr	pc,_setPalette
	mov	r0,012(sp)
	mov	r1,010(sp)
	jsr	pc,_initCellSprite
	jsr	pc,_clearScreen
	mov	012(sp),r0
	mov	010(sp),r1
	mov	r1,-(sp)
	clc
	ror	r0
	ror	r1
	ashc	$-017,r0	
	mov	r1,-(sp)
	jsr	pc,_setPalette
	mov	_currentState,r0
	add	$014,sp
	mov	$_printBottom,04(sp)
	mov	$_hideMouse,012(sp)
	cmp	r0,$02
	bne	L_485
	br	L_490
L_486:
	mov	_currentState,r0
	cmp	r0,$01
	beq	L_511
L_491:
	mov	_currentState,r0
	cmp	r0,$02
	beq	L_490
L_485:
	mov	_currentState,r0
	tst	r0
	bne	L_486
	clr	-(sp)
	jsr	pc,_setOnFrame
	clr	_frameCounter
	jsr	pc,_drawMenu
	movb	$01,_needClear
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	jsr	pc,@012(sp)
	mov	$LC_8,-(sp)
	mov	$01,-(sp)
	jsr	pc,@016(sp)
	mov	$LC_5,-(sp)
	mov	$022,-(sp)
	jsr	pc,@022(sp)
	add	$016,sp
L_488:
	mov	_currentState,r0
	tst	r0
	bne	L_491
	movb	_hasPendingClick,r0
	tstb	r0
	beq	L_488
	clrb	_hasPendingClick
	movb	_pendingDown,07(sp)
	movb	_pendingLeft,r0
	mov	_pendingY,010(sp)
	mov	_pendingX,r1
	movb	07(sp),-(sp)
	mov	$01,r3
	xor	r3,r0
	movb	r0,-(sp)
	mov	014(sp),-(sp)
	mov	r1,-(sp)
	jsr	pc,_processClick
	add	$010,sp
	br	L_488
L_490:
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	jsr	pc,_printTop
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	jsr	pc,@014(sp)
	jsr	pc,@022(sp)
	jsr	pc,_finishGraph
	jsr	pc,_finishMouse
	jsr	pc,_finishKeyb
	jsr	pc,(r2)
	add	$010,sp
	jmp	L_481
L_511:
	jsr	pc,@012(sp)
	jsr	pc,_clearScreen
	clrb	_initBySmile
	jsr	pc,_drawInitialBoard
	clrb	_hasPendingClick
	jsr	pc,_showMouse
L_495:
	mov	_currentState,r0
	cmp	r0,$01
	bne	L_491
	mov	_frameCounter,r0
	cmp	r0,$061
	blos	L_493
	mov	_frameCounter,r0
	add	$-062,r0
	mov	r0,_frameCounter
	mov	_seconds,r0
	inc	r0
	mov	r0,r1
	cmp	r0,$01747
	ble	L_494
	mov	$01747,r1
	mov	r1,r0
L_494:
	mov	r1,_seconds
	mov	r0,-(sp)
	mov	_offset_y,r3
	add	$-033,r3
	mov	r3,-(sp)
	mov	_field_w,r0
	ash	$04,r0	
	add	_offset_x,r0
	add	$-061,r0
	mov	r0,-(sp)
	jsr	pc,_drawNumberDisplay
	add	$06,sp
L_493:
	movb	_hasPendingClick,r0
	tstb	r0
	beq	L_495
	clrb	_hasPendingClick
	movb	_pendingDown,07(sp)
	movb	_pendingLeft,r0
	mov	_pendingY,010(sp)
	mov	_pendingX,r1
	movb	07(sp),-(sp)
	mov	$01,r3
	xor	r3,r0
	movb	r0,-(sp)
	mov	014(sp),-(sp)
	mov	r1,-(sp)
	jsr	pc,_processClick
	add	$010,sp
	br	L_495
	.section	.rodata.CSWTCH.191,"a"
	.even
_CSWTCH.191:
	.word	01
	.word	04
	.word	02
	.globl	_palette
	.section	.bss.palette,"aw",@nobits
	.even
_palette:
	.=.+ 04
	.globl	_cells_to_draw
	.section	.bss.cells_to_draw,"aw",@nobits
	.even
_cells_to_draw:
	.=.+ 02140
	.globl	_frameCounter
	.section	.bss.frameCounter,"aw",@nobits
	.even
_frameCounter:
	.=.+ 02
	.globl	_offset_y
	.section	.bss.offset_y,"aw",@nobits
	.even
_offset_y:
	.=.+ 02
	.globl	_offset_x
	.section	.bss.offset_x,"aw",@nobits
	.even
_offset_x:
	.=.+ 02
	.globl	_pendingDown
	.section	.bss.pendingDown,"aw",@nobits
_pendingDown:
	.=.+ 01
	.globl	_pendingLeft
	.section	.data.pendingLeft,"aw"
_pendingLeft:
	.byte	01
	.globl	_pendingY
	.section	.bss.pendingY,"aw",@nobits
	.even
_pendingY:
	.=.+ 02
	.globl	_pendingX
	.section	.bss.pendingX,"aw",@nobits
	.even
_pendingX:
	.=.+ 02
	.globl	_hasPendingClick
	.section	.bss.hasPendingClick,"aw",@nobits
_hasPendingClick:
	.=.+ 01
	.globl	_emptystr
	.section	.rodata
LC_9:
	.byte 040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,0
	.section	.data.emptystr,"aw"
	.even
_emptystr:
	.word	LC_9
	.globl	_smileY
	.section	.bss.smileY,"aw",@nobits
	.even
_smileY:
	.=.+ 02
	.globl	_smileX
	.section	.bss.smileX,"aw",@nobits
	.even
_smileX:
	.=.+ 02
	.globl	_initBySmile
	.section	.bss.initBySmile,"aw",@nobits
_initBySmile:
	.=.+ 01
	.globl	_currentMode
	.section	.data.currentMode,"aw"
_currentMode:
	.byte	0377
	.globl	_currentState
	.section	.bss.currentState,"aw",@nobits
	.even
_currentState:
	.=.+ 02
	.globl	_firstClick
	.section	.data.firstClick,"aw"
_firstClick:
	.byte	01
	.globl	_gameWon
	.section	.bss.gameWon,"aw",@nobits
_gameWon:
	.=.+ 01
	.globl	_gameOver
	.section	.bss.gameOver,"aw",@nobits
_gameOver:
	.=.+ 01
	.globl	_board_copy
	.section	.bss.board_copy,"aw",@nobits
_board_copy:
	.=.+ 01060
	.globl	_board
	.section	.bss.board,"aw",@nobits
_board:
	.=.+ 01060
	.globl	_queue
	.section	.bss.queue,"aw",@nobits
	.even
_queue:
	.=.+ 02140
	.globl	_seconds
	.section	.bss.seconds,"aw",@nobits
	.even
_seconds:
	.=.+ 02
	.globl	_innercellcolor
	.section	.data.innercellcolor,"aw"
	.even
_innercellcolor:
	.word	07
	.globl	_flags
	.section	.bss.flags,"aw",@nobits
	.even
_flags:
	.=.+ 02
	.globl	_total_mines
	.section	.data.total_mines,"aw"
	.even
_total_mines:
	.word	012
	.globl	_field_h
	.section	.data.field_h,"aw"
	.even
_field_h:
	.word	011
	.globl	_field_w
	.section	.data.field_w,"aw"
	.even
_field_w:
	.word	011
	.globl	_needClear
	.section	.bss.needClear,"aw",@nobits
_needClear:
	.=.+ 01
	.globl	_hasCurrentCell
	.section	.bss.hasCurrentCell,"aw",@nobits
_hasCurrentCell:
	.=.+ 01
	.globl	_currentCell
	.section	.bss.currentCell,"aw",@nobits
	.even
_currentCell:
	.=.+ 02
	.globl	_cell_sprite_addr
	.section	.bss.cell_sprite_addr,"aw",@nobits
	.even
_cell_sprite_addr:
	.=.+ 02
	.globl	_menuLabels
	.section	.rodata
LC_10:
	.byte 0102,0105,0107,0111,0116,0116,0105,0122,0
LC_11:
	.byte 0101,0115,0101,0124,0105,0125,0122,0
LC_12:
	.byte 0120,0122,0117,0106,0105,0123,0123,0111,0117,0116,0101,0114,0
LC_13:
	.byte 0105,0130,0111,0124,0
	.section	.data.menuLabels,"aw"
	.even
_menuLabels:
	.word	LC_10
	.word	LC_11
	.word	LC_12
	.word	LC_13
	.globl	_segmentMap
	.section	.rodata.segmentMap,"a"
_segmentMap:
	.byte 077,06,0133,0117,0146,0155,0175,07,0177,0157
	.section	.data.g_seed,"aw"
	.even
_g_seed:
	.word	-066452
	.word	-071536
