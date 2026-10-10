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
	cmp	02(sp),$077
	ble	L_159
	cmp	02(sp),$0136
	ble	L_161
	cmp	02(sp),$0141
	ble	L_159
	cmp	02(sp),$0200
	ble	L_162
	cmp	02(sp),$0203
	ble	L_159
	cmp	02(sp),$0242
	ble	L_163
	mov	02(sp),r0
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
	mov	$015,_field_h
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
	jsr	pc,_clearScreen
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
	.section	.text.drawPressedCell,"ax",@progbits
	.even
	.globl	_drawPressedCell
_drawPressedCell:
	mov	r2,-(sp)
	mov	04(sp),r0
	asl	r0
	asl	r0
	asl	r0
	add	04(sp),r0
	asl	r0
	add	_offset_x,r0
	mov	06(sp),r1
	asl	r1
	asl	r1
	asl	r1
	add	06(sp),r1
	asl	r1
	add	_offset_y,r1
	mov	$022,r2
	add	r1,r2
	mov	r2,-(sp)
	mov	$022,r2
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
	mov	014(sp),r1
	mov	r1,r3
	asl	r3
	asl	r3
	asl	r3
	add	r1,r3
	asl	r3
	add	_offset_x,r3
	mov	016(sp),r4
	asl	r4
	asl	r4
	asl	r4
	add	016(sp),r4
	asl	r4
	add	_offset_y,r4
	mov	$022,r0
	add	r3,r0
	mov	$022,r5
	add	r4,r5
	mov	r1,r2
	asl	r2
	add	r1,r2
	asl	r2
	asl	r2
	add	r1,r2
	add	$_board,r2
	add	016(sp),r2
	movb	(r2),r1
	clc
	rorb	r1
	bit	r1,$01
	bne	L_169
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
	bne	L_179
L_168:
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_169:
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
	bne	L_180
	movb	(r2),r0
	clc
	rorb	r0
	asrb	r0
	asrb	r0
	bicb	$-020,r0
	beq	L_168
	mov	$060,r1
	add	r0,r1
	decb	r0
	clr	r2
	cmpb	r0,$02
	bhi	L_174
	bic	$0177400,r0
	asl	r0
	mov	_CSWTCH.180(r0),r2
L_174:
	mov	$02,-(sp)
	mov	r2,-(sp)
	add	$04,r4
	mov	r4,-(sp)
	add	$06,r3
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
L_179:
	add	$05,r4
	mov	r4,-(sp)
	add	$011,r3
	mov	r3,-(sp)
	jsr	pc,_drawFlag
	add	$04,sp
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_180:
	add	$011,r4
	add	$011,r3
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
	add	$-010,sp
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
	mov	_field_w,r0
	asl	r0
	asl	r0
	asl	r0
	add	_field_w,r0
	mov	$0500,r1
	sub	r0,r1
	mov	r1,_offset_x
	mov	_field_h,r0
	asl	r0
	asl	r0
	asl	r0
	add	_field_h,r0
	mov	$0223,r2
	sub	r0,r2
	mov	r2,_offset_y
	mov	$0462,_smileX
	mov	$0167,r1
	sub	r0,r1
	mov	r1,_smileY
	mov	r2,-(sp)
	mov	$0516,-(sp)
	mov	r1,-(sp)
	mov	$0462,-(sp)
	jsr	pc,_drawButton
	clr	-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	mov	$_drawSmile,r0
	jsr	pc,(r0)
	add	$044,sp
	mov	_total_mines,-(sp)
	mov	_offset_y,r1
	add	$-033,r1
	mov	r1,-(sp)
	mov	_offset_x,-(sp)
	mov	$_drawNumberDisplay,r2
	jsr	pc,(r2)
	mov	_seconds,-(sp)
	mov	_offset_y,r0
	add	$-033,r0
	mov	r0,-(sp)
	mov	_field_w,r0
	asl	r0
	asl	r0
	asl	r0
	add	_field_w,r0
	asl	r0
	add	_offset_x,r0
	add	$-061,r0
	mov	r0,-(sp)
	jsr	pc,(r2)
	mov	_field_w,r4
	add	$014,sp
	tst	r4
	bgt	L_212
	jmp	L_183
L_212:
	mov	_field_h,r2
	mov	$_board_copy,r5
	mov	r5,r1
	mov	$_board,r3
	mov	r4,r0
	asl	r0
	add	r4,r0
	asl	r0
	asl	r0
	add	r4,r0
	mov	r0,(sp)
	add	r5,r0
	tst	r2
	ble	L_186
	mov	$_board,04(sp)
	sub	r5,r0
	add	$-015,r0
	mov	r0,r4
	ash	$06,r4	
	sub	r0,r4
	ash	$06,r4	
	add	r0,r4
	mov	r4,r0
	asl	r0
	asl	r0
	add	r0,r4
	inc	r4
	mov	r2,02(sp)
	mov	r3,06(sp)
	mov	r1,r3
	mov	r4,r2
	mov	$_board,r4
L_184:
	mov	02(sp),-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,_memcpy
	add	$015,r3
	add	$015,r4
	add	$06,sp
	sob	r2,L_184
	mov	02(sp),r2
	mov	06(sp),r3
L_185:
	mov	(sp),r1
	add	$_board,r1
	mov	r1,(sp)
	tst	r2
	ble	L_190
L_188:
	mov	r2,-(sp)
	clr	-(sp)
	mov	r3,-(sp)
	jsr	pc,_memset
	mov	$015,r0
	add	r3,r0
	add	$06,sp
	cmp	r0,(sp)
	beq	L_187
	mov	r2,-(sp)
	clr	-(sp)
	mov	r0,-(sp)
	jsr	pc,_memset
	add	$032,r3
	add	$06,sp
	cmp	(sp),r3
	bne	L_188
L_187:
	clr	r4
L_189:
	clr	r3
	tst	r2
	ble	L_194
	mov	r4,r2
	asl	r2
	add	r4,r2
L_193:
	tstb	_initBySmile
	beq	L_191
	mov	r2,r0
	asl	r0
	asl	r0
	add	r4,r0
	add	r5,r0
	add	r3,r0
	movb	(r0),r1
	clc
	rorb	r1
	bit	r1,$01
	bne	L_191
	movb	(r0),r0
	clc
	rorb	r0
	asrb	r0
	bit	r0,$01
	beq	L_192
L_191:
	mov	r3,-(sp)
	mov	r4,-(sp)
	jsr	pc,_drawCell
	add	$04,sp
L_192:
	inc	r3
	cmp	_field_h,r3
	bgt	L_193
L_194:
	inc	r4
	cmp	_field_w,r4
	ble	L_183
	mov	_field_h,r2
	br	L_189
L_186:
	mov	$015,r4
	add	r1,r4
	cmp	r0,r4
	beq	L_185
	add	$032,r1
	cmp	r0,r1
	bne	L_186
	br	L_185
L_190:
	mov	$015,r0
	add	r3,r0
	cmp	r1,r0
	beq	L_187
	add	$032,r3
	cmp	r1,r3
	bne	L_190
	br	L_187
L_183:
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
	mov	$_printBottom,r0
	jsr	pc,(r0)
	mov	$LC_5,-(sp)
	mov	$022,-(sp)
	mov	$_printBottom,r1
	jsr	pc,(r1)
	add	$032,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
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
	add	$-04,sp
	tst	_field_w
	ble	L_220
	mov	_field_h,02(sp)
	tst	02(sp)
	ble	L_220
	clr	(sp)
	clr	r4
	mov	_field_w,r5
L_217:
	clr	r1
	mov	(sp),r3
	mul	$015,r3
	add	$_board,r3
	mov	02(sp),r0
L_216:
	mov	r3,r2
	add	r1,r2
	movb	(r2),r2
	clc
	rorb	r2
	bit	r2,$01
	bne	L_215
	inc	r4
L_215:
	inc	r1
	sob	r0,L_216
	inc	(sp)
	sob	r5,L_217
L_214:
	cmp	_total_mines,r4
	beq	L_223
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_223:
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
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_220:
	clr	r4
	br	L_214
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
	bne	L_264
	tst	r3
	cln
L_264:
	bne	L_225
	mov	$-066452,r2
	mov	$-071536,r3
L_225:
	mov	r2,_g_seed
	mov	r3,_g_seed+02
	mov	_total_mines,r5
	mov	_field_w,020(sp)
	tst	r5
	ble	L_232
	mov	020(sp),r1
	dec	r1
	mov	r1,04(sp)
	mov	_field_h,r1
	dec	r1
	mov	r1,02(sp)
	clr	r3
	br	L_231
L_229:
	mov	r4,r1
	asl	r1
	add	r4,r1
	asl	r1
	asl	r1
	add	r4,r1
	add	$_board,r1
	add	r0,r1
	movb	(r1),r0
	bit	r0,$01
	bne	L_230
	bisb	$01,(r1)
	inc	r3
L_230:
	cmp	r3,r5
	bge	L_232
L_231:
	mov	04(sp),-(sp)
	clr	-(sp)
	jsr	pc,_random_range
	mov	r0,r4
	mov	06(sp),-(sp)
	clr	-(sp)
	jsr	pc,_random_range
	add	$010,sp
	cmp	r4,036(sp)
	bne	L_229
	cmp	r0,040(sp)
	bne	L_229
	cmp	r3,r5
	blt	L_231
L_232:
	tst	020(sp)
	ble	L_224
	mov	_field_h,012(sp)
	mov	020(sp),r1
	add	$02,r1
	tst	012(sp)
	bgt	L_265
	jmp	L_248
L_265:
	mov	$02,04(sp)
	clr	r0
	mov	012(sp),r1
	add	$02,r1
	mov	r1,022(sp)
	mov	020(sp),016(sp)
L_246:
	mov	$02,r2
	mov	$015,r1
	mul	r0,r1
	mov	r1,r0
	add	$_board,r0
	mov	r0,010(sp)
	mov	022(sp),r5
	sub	r2,r5
	mov	020(sp),r4
L_244:
	mov	$-02,r0
	add	r2,r0
	mov	r0,(sp)
	mov	010(sp),r0
	add	(sp),r0
	movb	(r0),r0
	bit	r0,$01
	beq	L_262
L_234:
	inc	r2
	sob	r5,L_244
	dec	016(sp)
	beq	L_266
	jmp	L_256
L_266:
L_224:
	add	$024,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_256:
	mov	04(sp),r0
	dec	r0
	inc	04(sp)
	br	L_246
L_262:
	mov	04(sp),r1
	add	$-03,r1
	clr	02(sp)
	mov	$-03,r0
	add	r2,r0
	mov	r0,06(sp)
	mov	r5,014(sp)
L_235:
	mov	06(sp),r0
	cmp	r1,$-01
	beq	L_238
L_243:
	mov	r2,r3
	sub	r0,r3
L_236:
	cmp	r1,r4
	blt	L_239
	inc	r0
	sob	r3,L_236
L_237:
	inc	r1
	cmp	r1,04(sp)
	bne	L_235
L_242:
	mov	014(sp),r5
	mov	010(sp),r1
	add	(sp),r1
	movb	02(sp),r0
	bicb	$-020,r0
	aslb	r0
	aslb	r0
	aslb	r0
	movb	(r1),r3
	bicb	$0170,r3
	bisb	r0,r3
	movb	r3,(r1)
	br	L_234
L_238:
	mov	r0,r3
	inc	r3
	cmp	r3,r2
	beq	L_237
	add	$02,r0
	cmp	r2,r0
	bne	L_238
	inc	r1
	cmp	r1,04(sp)
	bne	L_235
	br	L_242
L_239:
	mov	r0,r5
	cmp	r0,$-01
	beq	L_249
	cmp	012(sp),r0
	bgt	L_240
L_260:
	inc	r0
	cmp	r2,r0
	bne	L_243
	inc	r1
	cmp	r1,04(sp)
	bne	L_235
	br	L_242
L_249:
	clr	r5
	clr	r0
L_240:
	mov	r1,r3
	asl	r3
	add	r1,r3
	asl	r3
	asl	r3
	add	r1,r3
	add	$_board,r3
	add	r5,r3
	movb	(r3),r3
	bicb	$-02,r3
	add	r3,02(sp)
	br	L_260
L_248:
	mov	$02,r0
	mov	r0,r2
	inc	r2
	cmp	r2,r1
	beq	L_224
L_263:
	cmp	020(sp),r0
	beq	L_224
	add	$02,r0
	mov	r0,r2
	inc	r2
	cmp	r2,r1
	bne	L_263
	br	L_224
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
	mov	040(sp),r2
	mov	042(sp),r0
	bis	r2,r0
	bge	L_370
	jmp	L_267
L_370:
	cmp	_field_w,r2
	bgt	L_371
	jmp	L_267
L_371:
	cmp	_field_h,042(sp)
	bgt	L_372
	jmp	L_267
L_372:
	mov	r2,r3
	asl	r3
	add	r2,r3
	asl	r3
	asl	r3
	add	r2,r3
	add	$_board,r3
	add	042(sp),r3
	movb	(r3),r0
	clc
	rorb	r0
	bit	r0,$01
	beq	L_373
	jmp	L_267
L_373:
	movb	(r3),r0
	clc
	rorb	r0
	asrb	r0
	bit	r0,$01
	beq	L_374
	jmp	L_267
L_374:
	movb	(r3),r0
	bit	r0,$01
	beq	L_375
	jmp	L_366
L_375:
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawSmile
	bisb	$02,(r3)
	mov	050(sp),-(sp)
	mov	r2,-(sp)
	mov	$_drawCell,034(sp)
	jsr	pc,@034(sp)
	mov	$_queue,r1
	mov	054(sp),r0
	ash	$010,r0	
	bic	$0177400,r2
	bis	r0,r2
	mov	r2,(r1)
	mov	r1,r3
	add	$012,sp
	mov	$01,012(sp)
	clr	06(sp)
	br	L_293
L_276:
	add	$02,r3
	cmp	06(sp),012(sp)
	blt	L_376
	jmp	L_267
L_376:
L_293:
	inc	06(sp)
	clr	r4
	bisb	(r3),r4
	clr	r0
	bisb	01(r3),r0
	mov	r0,010(sp)
	mov	r4,r0
	asl	r0
	add	r4,r0
	asl	r0
	asl	r0
	add	r4,r0
	add	$_board,r0
	add	010(sp),r0
	movb	(r0),r0
	clc
	rorb	r0
	asrb	r0
	asrb	r0
	bit	r0,$017
	bne	L_276
	mov	r4,r1
	dec	r1
	mov	$-01,r5
	mov	r4,014(sp)
	mov	r3,020(sp)
L_277:
	mov	014(sp),r3
	tst	r5
	beq	L_291
	mov	r1,r3
L_291:
	mov	010(sp),r4
	dec	r4
	mov	$-01,r2
	tst	r5
	beq	L_358
	cmp	r3,$-01
	bne	L_377
	jmp	L_367
L_377:
L_358:
	mov	r1,(sp)
L_332:
	cmp	_field_w,r3
	bgt	L_368
L_289:
	inc	r2
	cmp	r2,$02
	beq	L_356
L_359:
	inc	r4
	tst	r5
	bne	L_332
L_281:
	tst	r2
	bne	L_332
	inc	r4
	mov	$01,r2
	cmp	_field_w,r3
	ble	L_289
L_368:
	cmp	r4,$-01
	beq	L_286
	cmp	_field_h,r4
	ble	L_289
	mov	r3,r0
	asl	r0
	add	r3,r0
	asl	r0
	asl	r0
	add	r3,r0
	add	$_board,r0
	add	r4,r0
	mov	r0,024(sp)
	movb	(r0),r1
	clc
	rorb	r1
	bit	r1,$01
	bne	L_289
	movb	(r0),r1
	clc
	rorb	r1
	asrb	r1
	bit	r1,$01
	bne	L_289
	bisb	$02,(r0)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,@026(sp)
	mov	016(sp),r0
	asl	r0
	mov	r0,06(sp)
	clr	r1
	bisb	r3,r1
	mov	r1,030(sp)
	mov	r4,r0
	ash	$010,r0	
	mov	r0,022(sp)
	bis	r0,r1
	mov	06(sp),r0
	mov	r1,_queue(r0)
	inc	016(sp)
	inc	r2
	add	$04,sp
	cmp	r2,$02
	bne	L_359
L_356:
	mov	(sp),r1
L_279:
	inc	r5
	inc	r1
	cmp	r5,$02
	bne	L_277
	mov	020(sp),r3
	jmp	L_276
L_274:
	inc	r5
	cmp	r5,_field_w
	blt	L_270
L_271:
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
L_267:
	add	$026,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_367:
	cmp	r2,$01
	beq	L_279
L_369:
	mov	$01,r2
	cmp	r2,$01
	bne	L_369
	br	L_279
L_286:
	inc	r2
	cmp	r2,$02
	beq	L_356
	clr	r4
	tst	r5
	beq	L_378
	jmp	L_332
L_378:
	jmp	L_281
L_366:
	bisb	$02,(r3)
	mov	$02,_innercellcolor
	mov	042(sp),-(sp)
	mov	r2,-(sp)
	mov	$_drawCell,026(sp)
	jsr	pc,@026(sp)
	mov	$07,_innercellcolor
	movb	$01,_gameOver
	add	$04,sp
	tst	_field_w
	ble	L_271
	clr	r5
	mov	022(sp),r4
L_270:
	tst	_field_h
	ble	L_274
	clr	r2
	mov	$015,r3
	mul	r5,r3
	add	$_board,r3
	br	L_273
L_272:
	inc	r2
	cmp	r2,_field_h
	bge	L_274
L_273:
	mov	r3,r0
	add	r2,r0
	movb	(r0),r1
	bit	r1,$01
	beq	L_272
	clc
	rorb	r1
	bit	r1,$01
	bne	L_272
	bisb	$02,(r0)
	mov	r2,-(sp)
	mov	r5,-(sp)
	jsr	pc,(r4)
	add	$04,sp
	br	L_272
	.section	.text.processMenuClick,"ax",@progbits
	.even
	.globl	_processMenuClick
_processMenuClick:
	mov	02(sp),r0
	add	$-0360,r0
	cmp	r0,$0240
	bhi	L_379
	mov	04(sp),-(sp)
	jsr	pc,_processMenuClick.part.0
	add	$02,sp
L_379:
	rts	pc
	.section	.text.releaseCurrentCell,"ax",@progbits
	.even
	.globl	_releaseCurrentCell
_releaseCurrentCell:
	tstb	_hasCurrentCell
	bne	L_383
	rts	pc
L_383:
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
	add	$-014,sp
	mov	_currentState,r0
	tst	r0
	bne	L_385
	tstb	024(sp)
	bne	L_384
	tstb	026(sp)
	beq	L_384
	mov	020(sp),r0
	add	$-0360,r0
	cmp	r0,$0240
	bhi	L_384
	mov	022(sp),-(sp)
	jsr	pc,_processMenuClick.part.0
	add	$02,sp
L_384:
	add	$014,sp
	mov	(sp)+,r2
	rts	pc
L_385:
	cmp	020(sp),_smileX
	blt	L_422
	jmp	L_418
L_422:
L_389:
	tstb	_gameOver
	bne	L_384
	mov	_offset_x,r0
	cmp	020(sp),r0
	bge	L_423
	jmp	L_391
L_423:
	mov	_offset_y,r1
	cmp	022(sp),r1
	bge	L_424
	jmp	L_391
L_424:
	mov	$022,-(sp)
	mov	022(sp),r2
	sub	r0,r2
	mov	r2,-(sp)
	mov	r1,04(sp)
	jsr	pc,___udivhi3
	add	$04,sp
	mov	r0,04(sp)
	mov	(sp),r1
	cmp	r0,_field_w
	blt	L_425
	jmp	L_391
L_425:
	mov	$022,-(sp)
	mov	024(sp),r0
	sub	r1,r0
	mov	r0,-(sp)
	jsr	pc,___udivhi3
	add	$04,sp
	cmp	r0,_field_h
	blt	L_426
	jmp	L_391
L_426:
	clr	r1
	bisb	_currentCell,r1
	cmp	04(sp),r1
	bne	L_427
	jmp	L_419
L_427:
L_393:
	tstb	026(sp)
	bne	L_428
	jmp	L_391
L_428:
	mov	r0,(sp)
	jsr	pc,_hideMouse
	mov	(sp),r0
	tstb	024(sp)
	bne	L_429
	jmp	L_395
L_429:
L_399:
	mov	04(sp),r2
	asl	r2
	add	04(sp),r2
	asl	r2
	asl	r2
	add	04(sp),r2
	mov	r2,06(sp)
	add	$_board,r2
	add	r0,r2
	mov	r2,010(sp)
	movb	(r2),r1
	clc
	rorb	r1
	bit	r1,$01
	bne	L_400
	movb	@010(sp),r1
	clc
	rorb	r1
	asrb	r1
	bit	r1,$01
	bne	L_401
	cmp	_flags,_total_mines
	bge	L_400
L_401:
	mov	06(sp),r2
	add	$_board,r2
	add	r0,r2
	mov	r2,06(sp)
	movb	$04,r1
	bicb	(r2),r1
	movb	r1,012(sp)
	movb	(r2),r2
	bicb	$04,r2
	bisb	r1,r2
	movb	r2,@06(sp)
	mov	r0,-(sp)
	mov	06(sp),-(sp)
	jsr	pc,_drawCell
	movb	@012(sp),r0
	clc
	rorb	r0
	asrb	r0
	add	$04,sp
	bit	r0,$01
	bne	L_430
	jmp	L_406
L_430:
	mov	$01,r0
L_402:
	add	_flags,r0
	mov	r0,_flags
	mov	_total_mines,r2
	sub	r0,r2
	mov	r2,-(sp)
	mov	_offset_y,r0
	add	$-033,r0
	mov	r0,-(sp)
	mov	_offset_x,-(sp)
	jsr	pc,_drawNumberDisplay
	add	$06,sp
L_400:
	jsr	pc,_showMouse
	jmp	L_384
L_418:
	mov	_smileX,r0
	add	$033,r0
	cmp	020(sp),r0
	ble	L_431
	jmp	L_389
L_431:
	cmp	022(sp),_smileY
	bge	L_432
	jmp	L_389
L_432:
	mov	_smileY,r0
	add	$033,r0
	cmp	022(sp),r0
	ble	L_433
	jmp	L_389
L_433:
	tstb	_hasCurrentCell
	beq	L_434
	jmp	L_420
L_434:
L_390:
	tstb	026(sp)
	bne	L_435
	jmp	L_384
L_435:
	tstb	024(sp)
	beq	L_436
	jmp	L_384
L_436:
	jsr	pc,_hideMouse
	mov	_smileY,r2
	add	$034,r2
	mov	r2,-(sp)
	mov	_smileX,r0
	add	$034,r0
	mov	r0,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawPressedButton
	mov	$01,-(sp)
	mov	_smileY,r1
	add	$02,r1
	mov	r1,-(sp)
	mov	_smileX,r2
	add	$02,r2
	mov	r2,-(sp)
	mov	$_drawSmile,r0
	mov	r0,016(sp)
	jsr	pc,(r0)
	mov	_smileY,r1
	add	$034,r1
	mov	r1,-(sp)
	mov	_smileX,r2
	add	$034,r2
	mov	r2,-(sp)
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
	jmp	L_384
L_391:
	tstb	_hasCurrentCell
	bne	L_437
	jmp	L_384
L_437:
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
	jmp	L_384
L_419:
	clr	r1
	bisb	_currentCell+01,r1
	cmp	r0,r1
	beq	L_438
	jmp	L_393
L_438:
	mov	r0,(sp)
	jsr	pc,_hideMouse
	mov	(sp),r0
	tstb	024(sp)
	bne	L_439
	jmp	L_398
L_439:
	tstb	026(sp)
	bne	L_440
	jmp	L_400
L_440:
	jmp	L_399
L_395:
	mov	04(sp),r1
	asl	r1
	add	04(sp),r1
	asl	r1
	asl	r1
	add	04(sp),r1
	add	$_board,r1
	add	r0,r1
	mov	r1,06(sp)
	movb	(r1),r2
	clc
	rorb	r2
	asrb	r2
	bit	r2,$01
	beq	L_441
	jmp	L_400
L_441:
	movb	(r1),r2
	clc
	rorb	r2
	bit	r2,$01
	beq	L_442
	jmp	L_400
L_442:
L_404:
	mov	r0,r1
	ash	$010,r1	
	mov	r1,06(sp)
	clr	r2
	bisb	04(sp),r2
	bis	r1,r2
	mov	r2,_currentCell
	mov	$04,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	mov	r0,06(sp)
	jsr	pc,_drawSmile
	mov	012(sp),r1
	asl	r1
	asl	r1
	asl	r1
	mov	r1,014(sp)
	add	012(sp),r1
	asl	r1
	add	_offset_x,r1
	mov	06(sp),r0
	mov	r0,r2
	asl	r2
	asl	r2
	asl	r2
	mov	r2,012(sp)
	add	r2,r0
	asl	r0
	add	_offset_y,r0
	mov	$022,r2
	add	r0,r2
	mov	r2,-(sp)
	mov	$022,r2
	add	r1,r2
	mov	r2,-(sp)
	mov	r0,-(sp)
	mov	r1,-(sp)
	jsr	pc,_drawPressedButton
	movb	$01,_hasCurrentCell
	add	$016,sp
	jmp	L_400
L_420:
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
	jmp	L_390
L_398:
	mov	04(sp),r1
	asl	r1
	add	04(sp),r1
	asl	r1
	asl	r1
	add	04(sp),r1
	add	$_board,r1
	add	r0,r1
	mov	r1,06(sp)
	movb	(r1),r2
	clc
	rorb	r2
	asrb	r2
	bit	r2,$01
	beq	L_443
	jmp	L_400
L_443:
	movb	(r1),r2
	clc
	rorb	r2
	bit	r2,$01
	beq	L_444
	jmp	L_400
L_444:
	tstb	026(sp)
	bne	L_404
	tstb	_hasCurrentCell
	bne	L_445
	jmp	L_400
L_445:
	clrb	_hasCurrentCell
	tstb	_firstClick
	bne	L_421
L_405:
	mov	r0,-(sp)
	mov	06(sp),-(sp)
	jsr	pc,_openCell
	add	$04,sp
	tstb	_gameOver
	beq	L_446
	jmp	L_400
L_446:
	jsr	pc,_checkWinCondition
	jmp	L_400
L_406:
	mov	$-01,r0
	jmp	L_402
L_421:
	mov	r0,-(sp)
	mov	06(sp),-(sp)
	mov	r0,04(sp)
	jsr	pc,_generateMines
	clrb	_firstClick
	mov	$_OnFrameEvent,-(sp)
	jsr	pc,_setOnFrame
	add	$06,sp
	mov	(sp),r0
	br	L_405
	.section	.rodata
LC_8:
	.byte 0105,0123,0103,050,0101,0122,062,051,040,055,040,0145,0170,0151,0164,0
	.section	.text.main,"ax",@progbits
	.even
	.globl	_main
_main:
	mov	r2,-(sp)
	add	$-010,sp
	jsr	pc,___main
	jsr	pc,_initMouse
	tstb	r0
	bne	L_476
L_447:
	add	$010,sp
	mov	(sp)+,r2
	rts	pc
L_476:
	jsr	pc,_initKeyb
	tstb	r0
	beq	L_447
	jsr	pc,_initGraph
	tstb	r0
	beq	L_447
	mov	$_OnMouseEvent,-(sp)
	jsr	pc,_setOnClick
	mov	$_OnKeyEvent,-(sp)
	jsr	pc,_setOnKeyEvent
	mov	_currentState,r0
	add	$04,sp
	mov	$_printBottom,02(sp)
	mov	$_hideMouse,06(sp)
	cmp	r0,$02
	bne	L_451
	br	L_456
L_452:
	mov	_currentState,r0
	cmp	r0,$01
	beq	L_477
L_457:
	mov	_currentState,r0
	cmp	r0,$02
	beq	L_456
L_451:
	mov	_currentState,r0
	tst	r0
	bne	L_452
	clr	-(sp)
	jsr	pc,_setOnFrame
	clr	_frameCounter
	jsr	pc,_drawMenu
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	jsr	pc,@010(sp)
	mov	$LC_8,-(sp)
	mov	$01,-(sp)
	jsr	pc,@014(sp)
	mov	$LC_5,-(sp)
	mov	$022,-(sp)
	jsr	pc,@020(sp)
	add	$016,sp
L_454:
	mov	_currentState,r0
	tst	r0
	bne	L_457
	movb	_hasPendingClick,r0
	tstb	r0
	beq	L_454
	clrb	_hasPendingClick
	movb	_pendingDown,01(sp)
	movb	_pendingLeft,r0
	mov	_pendingY,04(sp)
	mov	_pendingX,r1
	movb	01(sp),-(sp)
	mov	$01,r2
	xor	r2,r0
	movb	r0,-(sp)
	mov	010(sp),-(sp)
	mov	r1,-(sp)
	jsr	pc,_processClick
	add	$010,sp
	br	L_454
L_456:
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	jsr	pc,_printTop
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	jsr	pc,@012(sp)
	jsr	pc,@016(sp)
	jsr	pc,_resetScreen
	jsr	pc,_finishGraph
	jsr	pc,_finishMouse
	jsr	pc,_finishKeyb
	add	$010,sp
	jmp	L_447
L_477:
	jsr	pc,@06(sp)
	jsr	pc,_clearScreen
	clrb	_initBySmile
	jsr	pc,_drawInitialBoard
	clrb	_hasPendingClick
	jsr	pc,_showMouse
L_461:
	mov	_currentState,r0
	cmp	r0,$01
	bne	L_457
	mov	_frameCounter,r0
	cmp	r0,$061
	blos	L_459
	mov	_frameCounter,r0
	add	$-062,r0
	mov	r0,_frameCounter
	mov	_seconds,r0
	inc	r0
	mov	r0,r1
	cmp	r0,$01747
	ble	L_460
	mov	$01747,r1
	mov	r1,r0
L_460:
	mov	r1,_seconds
	mov	r0,-(sp)
	mov	_offset_y,r1
	add	$-033,r1
	mov	r1,-(sp)
	mov	_field_w,r1
	mul	$022,r1
	mov	r1,r0
	add	_offset_x,r0
	add	$-061,r0
	mov	r0,-(sp)
	jsr	pc,_drawNumberDisplay
	add	$06,sp
L_459:
	movb	_hasPendingClick,r0
	tstb	r0
	beq	L_461
	clrb	_hasPendingClick
	movb	_pendingDown,01(sp)
	movb	_pendingLeft,r0
	mov	_pendingY,04(sp)
	mov	_pendingX,r1
	movb	01(sp),-(sp)
	mov	$01,r2
	xor	r2,r0
	movb	r0,-(sp)
	mov	010(sp),-(sp)
	mov	r1,-(sp)
	jsr	pc,_processClick
	add	$010,sp
	br	L_461
	.section	.rodata.CSWTCH.180,"a"
	.even
_CSWTCH.180:
	.word	01
	.word	04
	.word	02
	.globl	_palette
	.section	.bss.palette,"aw",@nobits
	.even
_palette:
	.=.+ 04
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
	.=.+ 0707
	.globl	_board
	.section	.bss.board,"aw",@nobits
_board:
	.=.+ 0707
	.globl	_queue
	.section	.bss.queue,"aw",@nobits
	.even
_queue:
	.=.+ 01616
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
	.globl	_hasCurrentCell
	.section	.bss.hasCurrentCell,"aw",@nobits
_hasCurrentCell:
	.=.+ 01
	.globl	_currentCell
	.section	.bss.currentCell,"aw",@nobits
	.even
_currentCell:
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
