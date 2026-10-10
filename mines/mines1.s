	.text
	.even
	.globl	_OnFrameEvent
_OnFrameEvent:
	mov	_frameCounter,r0
	inc	r0
	mov	r0,_frameCounter
	rts	pc
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
	.data
LC_0:
	.byte 033,045,041,063,014,0
	.text
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
	.even
	.globl	_random_init
_random_init:
	mov	02(sp),r0
	mov	04(sp),r1
	tst	r0
	bne	L_44
	tst	r1
L_44:
	bne	L_42
	mov	$-066452,r0
	mov	$-071536,r1
L_42:
	mov	r0,_g_seed
	mov	r1,_g_seed+02
	rts	pc
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
	.even
	.globl	_Cell_isMine
_Cell_isMine:
	movb	@02(sp),r0
	bicb	$-02,r0
	rts	pc
	.even
	.globl	_Cell_isOpen
_Cell_isOpen:
	movb	@02(sp),r0
	clc
	rorb	r0
	bicb	$-02,r0
	rts	pc
	.even
	.globl	_Cell_isFlagged
_Cell_isFlagged:
	movb	@02(sp),r0
	clc
	rorb	r0
	asrb	r0
	bicb	$-02,r0
	rts	pc
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
	.even
	.globl	_Cell_init
_Cell_init:
	clrb	@02(sp)
	rts	pc
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
	bicb	$-02,r0
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
	.even
	.globl	_stopTimer
_stopTimer:
	clr	-(sp)
	jsr	pc,_setOnFrame
	clr	_frameCounter
	add	$02,sp
	rts	pc
	.even
	.globl	_startTimer
_startTimer:
	mov	$_OnFrameEvent,-(sp)
	jsr	pc,_setOnFrame
	add	$02,sp
	rts	pc
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
	.data
	.even
L_142:
	.word	L_146
	.word	L_145
	.word	L_144
	.word	L_143
	.word	L_141
	.text
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
	.even
	.globl	_drawMenuButton
_drawMenuButton:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	mov	012(sp),r2
	movb	014(sp),r5
	mov	r2,r3
	ash	$04,r3	
	add	r2,r3
	asl	r3
	mov	$0100,r0
	add	r3,r0
	mov	$0136,r1
	add	r3,r1
	tstb	r5
	beq	L_149
	mov	r1,-(sp)
	mov	$0620,-(sp)
	mov	r0,-(sp)
	mov	$0360,-(sp)
	jsr	pc,_drawPressedButton
L_163:
	asl	r2
	mov	_menuLabels(r2),r2
	movb	(r2),r0
	add	$010,sp
	tstb	r0
	beq	L_148
	clr	r1
L_152:
	inc	r1
	mov	r2,r4
	add	r1,r4
	tstb	(r4)
	bne	L_152
	mov	$024,r4
	sub	r1,r4
	asl	r4
	asl	r4
	tstb	r5
	beq	L_164
	add	$0362,r4
	add	$0115,r3
L_154:
	mov	r4,r5
	br	L_155
L_156:
	mov	$01,-(sp)
	clr	-(sp)
	mov	r3,-(sp)
	mov	r5,-(sp)
	movb	r0,-(sp)
	jsr	pc,_putChar
	add	$010,r5
	add	$012,sp
	inc	r2
	movb	(r2),r0
	beq	L_148
L_155:
	cmpb	r0,$012
	bne	L_156
	add	$013,r3
	mov	r4,r5
	inc	r2
	movb	(r2),r0
	bne	L_155
L_148:
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
	br	L_163
L_164:
	add	$0360,r4
	add	$0113,r3
	br	L_154
	.even
_processMenuClick.part.0:
	cmp	02(sp),$077
	ble	L_165
	cmp	02(sp),$0136
	ble	L_167
	cmp	02(sp),$0141
	ble	L_165
	cmp	02(sp),$0200
	ble	L_168
	cmp	02(sp),$0203
	ble	L_165
	cmp	02(sp),$0242
	ble	L_169
	mov	02(sp),r0
	add	$-0246,r0
	cmp	r0,$036
	bhi	L_171
	movb	$03,_currentMode
	jsr	pc,_hideMouse
	movb	$01,-(sp)
	mov	$03,-(sp)
	jsr	pc,_drawMenuButton
	jsr	pc,_showMouse
	mov	$02,_currentState
	add	$04,sp
L_165:
	rts	pc
L_171:
	rts	pc
L_167:
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
L_168:
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
L_169:
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
	.data
LC_1:
	.byte 0115,0111,0116,0105,0123,0127,0105,0105,0120,0105,0122,040,055,040,0115,0101,0111,0116,040,0115,0105,0116,0125,0
	.text
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
	.even
	.globl	_drawCell
_drawCell:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-04,sp
	mov	016(sp),r5
	mov	r5,r3
	asl	r3
	asl	r3
	asl	r3
	add	r5,r3
	asl	r3
	add	_offset_x,r3
	mov	020(sp),r4
	asl	r4
	asl	r4
	asl	r4
	add	020(sp),r4
	asl	r4
	add	_offset_y,r4
	mov	$022,r0
	add	r3,r0
	mov	$022,r1
	add	r4,r1
	mov	r5,r2
	asl	r2
	add	r5,r2
	asl	r2
	asl	r2
	add	r5,r2
	add	$_board,r2
	add	020(sp),r2
	movb	(r2),r5
	clc
	rorb	r5
	bicb	$-02,r5
	bne	L_175
	mov	r1,-(sp)
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,_drawButton
	movb	(r2),r0
	clc
	rorb	r0
	asrb	r0
	bicb	$-02,r0
	add	$010,sp
	tstb	r0
	bne	L_185
L_174:
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_175:
	mov	_innercellcolor,-(sp)
	mov	r1,-(sp)
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	mov	r0,014(sp)
	mov	r1,012(sp)
	jsr	pc,_fillRect
	clr	-(sp)
	mov	014(sp),r1
	mov	r1,-(sp)
	mov	020(sp),r0
	mov	r0,-(sp)
	mov	r4,-(sp)
	mov	r3,-(sp)
	jsr	pc,_rect
	movb	(r2),r0
	bicb	$-02,r0
	add	$024,sp
	tstb	r0
	bne	L_186
	movb	(r2),r0
	clc
	rorb	r0
	asrb	r0
	asrb	r0
	bicb	$-020,r0
	beq	L_174
	mov	$060,r1
	add	r0,r1
	decb	r0
	clr	r2
	cmpb	r0,$02
	bhi	L_180
	bic	$0177400,r0
	asl	r0
	mov	_CSWTCH.180(r0),r2
L_180:
	mov	$02,-(sp)
	mov	r2,-(sp)
	add	$04,r4
	mov	r4,-(sp)
	add	$06,r3
	mov	r3,-(sp)
	movb	r1,-(sp)
	jsr	pc,_putChar
	add	$012,sp
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_185:
	add	$05,r4
	mov	r4,-(sp)
	add	$011,r3
	mov	r3,-(sp)
	jsr	pc,_drawFlag
	add	$04,sp
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_186:
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
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.data
LC_2:
	.byte 0115,0111,0116,0105,0123,0127,0105,0105,0120,0105,0122,040,055,040,0
LC_3:
	.byte 0114,0117,0101,0104,0111,0116,0107,056,056,056,0
LC_4:
	.byte 0105,0123,0103,050,0101,0122,062,051,040,055,040,0142,0141,0143,0153,0
LC_5:
	.byte 0123,0120,0101,0103,0105,040,055,040,0160,0141,0154,0145,0164,0164,0145,0
	.text
	.even
	.globl	_drawInitialBoard
_drawInitialBoard:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-06,sp
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
	mov	_field_w,r1
	add	$014,sp
	tst	r1
	bgt	L_223
	jmp	L_189
L_223:
	mov	_field_h,r3
	mov	$_board,r5
	add	r3,r5
	mov	r1,r0
	asl	r0
	add	r1,r0
	asl	r0
	asl	r0
	add	r1,r0
	add	r5,r0
	mov	r0,02(sp)
	tst	r3
	bgt	L_224
	jmp	L_222
L_224:
	mov	02(sp),r0
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
	mov	r5,04(sp)
	mov	r3,(sp)
	mov	r5,r3
	mov	$_board_copy,r5
L_191:
	mov	r3,r2
	sub	(sp),r2
	mov	r5,r1
	mov	(sp),r0
L_190:
	movb	(r2)+,(r1)+
	sob	r0,L_190
	add	$015,r5
	add	$015,r3
	sob	r4,L_191
	mov	04(sp),r5
	mov	(sp),r3
L_192:
	tst	r3
	ble	L_221
	mov	02(sp),r0
	sub	r5,r0
	add	$-015,r0
	mov	r0,r2
	ash	$06,r2	
	sub	r0,r2
	ash	$06,r2	
	add	r0,r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r0,r2
	inc	r2
L_199:
	mov	r5,r1
	sub	r3,r1
	mov	r3,r0
L_195:
	clrb	(r1)+
	sob	r0,L_195
	add	$015,r5
	sob	r2,L_199
L_197:
	clr	r2
	mov	$_board_copy,r4
L_200:
	clr	r5
	tst	r3
	ble	L_204
	mov	r2,r3
	asl	r3
	add	r2,r3
L_203:
	tstb	_initBySmile
	beq	L_201
	mov	r3,r0
	asl	r0
	asl	r0
	add	r2,r0
	add	r4,r0
	add	r5,r0
	movb	(r0),r1
	clc
	rorb	r1
	bicb	$-02,r1
	bne	L_201
	movb	(r0),r0
	clc
	rorb	r0
	asrb	r0
	bicb	$-02,r0
	beq	L_202
L_201:
	mov	r5,-(sp)
	mov	r2,-(sp)
	jsr	pc,_drawCell
	add	$04,sp
L_202:
	inc	r5
	cmp	_field_h,r5
	bgt	L_203
L_204:
	inc	r2
	cmp	_field_w,r2
	ble	L_189
	mov	_field_h,r3
	br	L_200
L_189:
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	mov	$_drawSmile,r1
	jsr	pc,(r1)
	mov	$01,_currentState
	mov	_emptystr,-(sp)
	mov	$01,-(sp)
	mov	$_printBottom,r0
	jsr	pc,(r0)
	mov	$LC_4,-(sp)
	mov	$01,-(sp)
	mov	$_printBottom,r1
	jsr	pc,(r1)
	mov	$LC_5,-(sp)
	mov	$022,-(sp)
	mov	$_printBottom,r0
	jsr	pc,(r0)
	add	$030,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_222:
	mov	r5,r0
	mov	02(sp),r2
L_193:
	mov	$015,r1
	add	r0,r1
	cmp	r1,r2
	beq	L_192
	add	$032,r0
	cmp	r0,r2
	bne	L_193
	br	L_192
L_221:
	mov	02(sp),r1
L_198:
	mov	$015,r0
	add	r5,r0
	cmp	r0,r1
	beq	L_197
	add	$032,r5
	cmp	r5,r1
	bne	L_198
	br	L_197
	.data
LC_6:
	.byte 0131,0117,0125,040,0127,0111,0116,041,0
	.text
	.even
	.globl	_checkWinCondition
_checkWinCondition:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-04,sp
	tst	_field_w
	ble	L_232
	mov	_field_h,02(sp)
	tst	02(sp)
	ble	L_232
	clr	(sp)
	clr	r4
	mov	_field_w,r5
L_229:
	clr	r2
	mov	(sp),r3
	mul	$015,r3
	add	$_board,r3
	mov	02(sp),r1
L_228:
	mov	r3,r0
	add	r2,r0
	movb	(r0),r0
	clc
	rorb	r0
	bicb	$-02,r0
	bne	L_227
	inc	r4
L_227:
	inc	r2
	sob	r1,L_228
	inc	(sp)
	sob	r5,L_229
L_226:
	cmp	_total_mines,r4
	beq	L_235
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_235:
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
L_232:
	clr	r4
	br	L_226
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
	bne	L_276
	tst	r3
L_276:
	bne	L_237
	mov	$-066452,r2
	mov	$-071536,r3
L_237:
	mov	r2,_g_seed
	mov	r3,_g_seed+02
	mov	_total_mines,r5
	mov	_field_w,020(sp)
	tst	r5
	ble	L_244
	mov	020(sp),r1
	dec	r1
	mov	r1,04(sp)
	mov	_field_h,r1
	dec	r1
	mov	r1,02(sp)
	clr	r3
	br	L_243
L_241:
	mov	r4,r1
	asl	r1
	add	r4,r1
	asl	r1
	asl	r1
	add	r4,r1
	add	$_board,r1
	add	r0,r1
	movb	(r1),r0
	bicb	$-02,r0
	bne	L_242
	bisb	$01,(r1)
	inc	r3
L_242:
	cmp	r3,r5
	bge	L_244
L_243:
	mov	04(sp),-(sp)
	clr	-(sp)
	jsr	pc,_random_range
	mov	r0,r4
	mov	06(sp),-(sp)
	clr	-(sp)
	jsr	pc,_random_range
	add	$010,sp
	cmp	r4,036(sp)
	bne	L_241
	cmp	r0,040(sp)
	bne	L_241
	cmp	r3,r5
	blt	L_243
L_244:
	tst	020(sp)
	ble	L_236
	mov	_field_h,012(sp)
	mov	020(sp),r1
	add	$02,r1
	tst	012(sp)
	bgt	L_277
	jmp	L_260
L_277:
	mov	$02,04(sp)
	clr	r0
	mov	012(sp),r1
	add	$02,r1
	mov	r1,022(sp)
	mov	020(sp),016(sp)
L_258:
	mov	$02,r2
	mov	$015,r1
	mul	r0,r1
	mov	r1,r0
	add	$_board,r0
	mov	r0,010(sp)
	mov	022(sp),r5
	sub	r2,r5
	mov	020(sp),r4
L_256:
	mov	$-02,r0
	add	r2,r0
	mov	r0,(sp)
	mov	010(sp),r0
	add	(sp),r0
	movb	(r0),r0
	bicb	$-02,r0
	beq	L_274
L_246:
	inc	r2
	sob	r5,L_256
	dec	016(sp)
	beq	L_278
	jmp	L_268
L_278:
L_236:
	add	$024,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_268:
	mov	04(sp),r0
	dec	r0
	inc	04(sp)
	br	L_258
L_274:
	mov	04(sp),r1
	add	$-03,r1
	clr	02(sp)
	mov	$-03,r0
	add	r2,r0
	mov	r0,06(sp)
	mov	r5,014(sp)
L_247:
	mov	06(sp),r0
	cmp	r1,$-01
	beq	L_250
L_255:
	mov	r2,r3
	sub	r0,r3
L_248:
	cmp	r1,r4
	blt	L_251
	inc	r0
	sob	r3,L_248
L_249:
	inc	r1
	cmp	r1,04(sp)
	bne	L_247
L_254:
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
	br	L_246
L_250:
	mov	r0,r3
	inc	r3
	cmp	r3,r2
	beq	L_249
	add	$02,r0
	cmp	r2,r0
	bne	L_250
	inc	r1
	cmp	r1,04(sp)
	bne	L_247
	br	L_254
L_251:
	mov	r0,r5
	cmp	r0,$-01
	beq	L_261
	cmp	012(sp),r0
	bgt	L_252
L_272:
	inc	r0
	cmp	r2,r0
	bne	L_255
	inc	r1
	cmp	r1,04(sp)
	bne	L_247
	br	L_254
L_261:
	clr	r5
	clr	r0
L_252:
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
	br	L_272
L_260:
	mov	$02,r0
	mov	r0,r2
	inc	r2
	cmp	r2,r1
	beq	L_236
L_275:
	cmp	020(sp),r0
	beq	L_236
	add	$02,r0
	mov	r0,r2
	inc	r2
	cmp	r2,r1
	bne	L_275
	br	L_236
	.data
LC_7:
	.byte 0102,0117,0117,0115,041,0
	.text
	.even
	.globl	_openCell
_openCell:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	add	$-024,sp
	mov	036(sp),r2
	mov	040(sp),r0
	bis	r2,r0
	bge	L_382
	jmp	L_279
L_382:
	cmp	_field_w,r2
	bgt	L_383
	jmp	L_279
L_383:
	cmp	_field_h,040(sp)
	bgt	L_384
	jmp	L_279
L_384:
	mov	r2,r3
	asl	r3
	add	r2,r3
	asl	r3
	asl	r3
	add	r2,r3
	add	$_board,r3
	add	040(sp),r3
	movb	(r3),r0
	clc
	rorb	r0
	bicb	$-02,r0
	beq	L_385
	jmp	L_279
L_385:
	movb	(r3),r0
	clc
	rorb	r0
	asrb	r0
	bicb	$-02,r0
	beq	L_386
	jmp	L_279
L_386:
	movb	(r3),r0
	bicb	$-02,r0
	beq	L_387
	jmp	L_378
L_387:
	mov	$01,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	jsr	pc,_drawSmile
	bisb	$02,(r3)
	mov	046(sp),-(sp)
	mov	r2,-(sp)
	mov	$_drawCell,032(sp)
	jsr	pc,@032(sp)
	mov	$_queue,r1
	mov	052(sp),r0
	ash	$010,r0	
	bic	$0177400,r2
	bis	r0,r2
	mov	r2,(r1)
	add	$012,sp
	mov	$01,012(sp)
	clr	04(sp)
	mov	r1,r5
	br	L_305
L_288:
	add	$02,r5
	cmp	04(sp),012(sp)
	blt	L_388
	jmp	L_279
L_388:
L_305:
	inc	04(sp)
	clr	r4
	bisb	(r5),r4
	clr	r0
	bisb	01(r5),r0
	mov	r0,06(sp)
	mov	r4,r0
	asl	r0
	add	r4,r0
	asl	r0
	asl	r0
	add	r4,r0
	add	$_board,r0
	add	06(sp),r0
	movb	(r0),r0
	clc
	rorb	r0
	asrb	r0
	asrb	r0
	bicb	$-020,r0
	bne	L_288
	mov	r4,r1
	dec	r1
	mov	r1,010(sp)
	mov	$-01,r0
	mov	r4,014(sp)
	mov	r5,016(sp)
L_289:
	mov	014(sp),r3
	tst	r0
	beq	L_303
	mov	010(sp),r3
L_303:
	mov	06(sp),r5
	dec	r5
	mov	$-01,r2
	tst	r0
	beq	L_344
	cmp	r3,$-01
	bne	L_389
	jmp	L_379
L_389:
L_344:
	cmp	_field_w,r3
	bgt	L_380
L_301:
	inc	r2
	cmp	r2,$02
	beq	L_291
L_371:
	inc	r5
	tst	r0
	bne	L_344
L_293:
	tst	r2
	bne	L_344
	inc	r5
	mov	$01,r2
	cmp	_field_w,r3
	ble	L_301
L_380:
	cmp	r5,$-01
	beq	L_298
	cmp	_field_h,r5
	ble	L_301
	mov	r3,r1
	asl	r1
	add	r3,r1
	asl	r1
	asl	r1
	add	r3,r1
	add	$_board,r1
	add	r5,r1
	movb	(r1),r4
	clc
	rorb	r4
	bicb	$-02,r4
	bne	L_301
	movb	(r1),r4
	clc
	rorb	r4
	asrb	r4
	bicb	$-02,r4
	bne	L_301
	bisb	$02,(r1)
	mov	r5,-(sp)
	mov	r3,-(sp)
	mov	r0,06(sp)
	jsr	pc,@024(sp)
	mov	016(sp),r1
	asl	r1
	mov	r1,04(sp)
	clr	r4
	bisb	r3,r4
	mov	r5,r1
	ash	$010,r1	
	mov	r1,026(sp)
	bis	r1,r4
	mov	04(sp),r1
	mov	r4,_queue(r1)
	inc	016(sp)
	inc	r2
	add	$04,sp
	mov	02(sp),r0
	cmp	r2,$02
	bne	L_371
L_291:
	inc	r0
	inc	010(sp)
	cmp	r0,$02
	bne	L_289
	mov	016(sp),r5
	jmp	L_288
L_286:
	inc	r5
	cmp	r5,_field_w
	blt	L_282
L_283:
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
L_279:
	add	$024,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_379:
	cmp	r2,$01
	beq	L_291
L_381:
	mov	$01,r2
	cmp	r2,$01
	bne	L_381
	br	L_291
L_298:
	inc	r2
	cmp	r2,$02
	beq	L_291
	clr	r5
	tst	r0
	beq	L_390
	jmp	L_344
L_390:
	jmp	L_293
L_378:
	bisb	$02,(r3)
	mov	$02,_innercellcolor
	mov	040(sp),-(sp)
	mov	r2,-(sp)
	mov	$_drawCell,024(sp)
	jsr	pc,@024(sp)
	mov	$07,_innercellcolor
	movb	$01,_gameOver
	add	$04,sp
	tst	_field_w
	ble	L_283
	clr	r5
	mov	020(sp),r3
L_282:
	tst	_field_h
	ble	L_286
	clr	r2
	mov	$015,r1
	mul	r5,r1
	mov	r1,r4
	add	$_board,r4
	br	L_285
L_284:
	inc	r2
	cmp	r2,_field_h
	bge	L_286
L_285:
	mov	r4,r0
	add	r2,r0
	movb	(r0),r1
	bicb	$-02,r1
	beq	L_284
	movb	(r0),r1
	clc
	rorb	r1
	bicb	$-02,r1
	bne	L_284
	bisb	$02,(r0)
	mov	r2,-(sp)
	mov	r5,-(sp)
	jsr	pc,(r3)
	add	$04,sp
	br	L_284
	.even
	.globl	_processMenuClick
_processMenuClick:
	mov	02(sp),r0
	add	$-0360,r0
	cmp	r0,$0240
	bhi	L_391
	mov	04(sp),-(sp)
	jsr	pc,_processMenuClick.part.0
	add	$02,sp
L_391:
	rts	pc
	.even
	.globl	_releaseCurrentCell
_releaseCurrentCell:
	tstb	_hasCurrentCell
	bne	L_395
	rts	pc
L_395:
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
	.even
	.globl	_processClick
_processClick:
	mov	r2,-(sp)
	add	$-012,sp
	mov	_currentState,r0
	tst	r0
	bne	L_397
	tstb	022(sp)
	bne	L_396
	tstb	024(sp)
	beq	L_396
	mov	016(sp),r0
	add	$-0360,r0
	cmp	r0,$0240
	bhi	L_396
	mov	020(sp),-(sp)
	jsr	pc,_processMenuClick.part.0
	add	$02,sp
L_396:
	add	$012,sp
	mov	(sp)+,r2
	rts	pc
L_397:
	cmp	016(sp),_smileX
	blt	L_434
	jmp	L_430
L_434:
L_401:
	tstb	_gameOver
	bne	L_396
	mov	_offset_x,r0
	cmp	016(sp),r0
	bge	L_435
	jmp	L_403
L_435:
	mov	_offset_y,r1
	cmp	020(sp),r1
	bge	L_436
	jmp	L_403
L_436:
	mov	$022,-(sp)
	mov	020(sp),r2
	sub	r0,r2
	mov	r2,-(sp)
	mov	r1,04(sp)
	jsr	pc,___udivhi3
	add	$04,sp
	mov	r0,02(sp)
	mov	(sp),r1
	cmp	r0,_field_w
	blt	L_437
	jmp	L_403
L_437:
	mov	$022,-(sp)
	mov	022(sp),r0
	sub	r1,r0
	mov	r0,-(sp)
	jsr	pc,___udivhi3
	add	$04,sp
	cmp	r0,_field_h
	blt	L_438
	jmp	L_403
L_438:
	clr	r1
	bisb	_currentCell,r1
	cmp	02(sp),r1
	bne	L_439
	jmp	L_431
L_439:
L_405:
	tstb	024(sp)
	bne	L_440
	jmp	L_403
L_440:
	mov	r0,(sp)
	jsr	pc,_hideMouse
	mov	(sp),r0
	tstb	022(sp)
	bne	L_441
	jmp	L_407
L_441:
L_411:
	mov	02(sp),r2
	asl	r2
	add	02(sp),r2
	asl	r2
	asl	r2
	add	02(sp),r2
	mov	r2,04(sp)
	add	$_board,r2
	add	r0,r2
	mov	r2,06(sp)
	movb	(r2),r1
	clc
	rorb	r1
	bicb	$-02,r1
	bne	L_412
	movb	@06(sp),r1
	clc
	rorb	r1
	asrb	r1
	bicb	$-02,r1
	bne	L_413
	cmp	_flags,_total_mines
	bge	L_412
L_413:
	mov	04(sp),r2
	add	$_board,r2
	add	r0,r2
	mov	r2,04(sp)
	movb	$04,r1
	bicb	(r2),r1
	movb	r1,011(sp)
	movb	(r2),r2
	bicb	$04,r2
	bisb	r1,r2
	movb	r2,@04(sp)
	mov	r0,-(sp)
	mov	04(sp),-(sp)
	jsr	pc,_drawCell
	movb	@010(sp),r0
	clc
	rorb	r0
	asrb	r0
	bicb	$-02,r0
	add	$04,sp
	tstb	r0
	bne	L_442
	jmp	L_418
L_442:
	mov	$01,r0
L_414:
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
L_412:
	jsr	pc,_showMouse
	jmp	L_396
L_430:
	mov	_smileX,r0
	add	$033,r0
	cmp	016(sp),r0
	ble	L_443
	jmp	L_401
L_443:
	cmp	020(sp),_smileY
	bge	L_444
	jmp	L_401
L_444:
	mov	_smileY,r0
	add	$033,r0
	cmp	020(sp),r0
	ble	L_445
	jmp	L_401
L_445:
	tstb	_hasCurrentCell
	beq	L_446
	jmp	L_432
L_446:
L_402:
	tstb	024(sp)
	bne	L_447
	jmp	L_396
L_447:
	tstb	022(sp)
	beq	L_448
	jmp	L_396
L_448:
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
	jmp	L_396
L_403:
	tstb	_hasCurrentCell
	bne	L_449
	jmp	L_396
L_449:
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
	jmp	L_396
L_431:
	clr	r1
	bisb	_currentCell+01,r1
	cmp	r0,r1
	beq	L_450
	jmp	L_405
L_450:
	mov	r0,(sp)
	jsr	pc,_hideMouse
	mov	(sp),r0
	tstb	022(sp)
	bne	L_451
	jmp	L_410
L_451:
	tstb	024(sp)
	bne	L_452
	jmp	L_412
L_452:
	jmp	L_411
L_407:
	mov	02(sp),r1
	asl	r1
	add	02(sp),r1
	asl	r1
	asl	r1
	add	02(sp),r1
	add	$_board,r1
	add	r0,r1
	mov	r1,04(sp)
	movb	(r1),r2
	clc
	rorb	r2
	asrb	r2
	bicb	$-02,r2
	beq	L_453
	jmp	L_412
L_453:
	movb	(r1),r2
	clc
	rorb	r2
	bicb	$-02,r2
	beq	L_454
	jmp	L_412
L_454:
L_416:
	mov	r0,r1
	ash	$010,r1	
	mov	r1,04(sp)
	clr	r2
	bisb	02(sp),r2
	bis	r1,r2
	mov	r2,_currentCell
	mov	$04,-(sp)
	mov	_smileY,-(sp)
	mov	_smileX,-(sp)
	mov	r0,06(sp)
	jsr	pc,_drawSmile
	mov	010(sp),r1
	asl	r1
	asl	r1
	asl	r1
	mov	r1,012(sp)
	add	010(sp),r1
	asl	r1
	add	_offset_x,r1
	mov	06(sp),r0
	mov	r0,r2
	asl	r2
	asl	r2
	asl	r2
	mov	r2,010(sp)
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
	jmp	L_412
L_432:
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
	jmp	L_402
L_410:
	mov	02(sp),r1
	asl	r1
	add	02(sp),r1
	asl	r1
	asl	r1
	add	02(sp),r1
	add	$_board,r1
	add	r0,r1
	mov	r1,04(sp)
	movb	(r1),r2
	clc
	rorb	r2
	asrb	r2
	bicb	$-02,r2
	beq	L_455
	jmp	L_412
L_455:
	movb	(r1),r2
	clc
	rorb	r2
	bicb	$-02,r2
	beq	L_456
	jmp	L_412
L_456:
	tstb	024(sp)
	bne	L_416
	tstb	_hasCurrentCell
	bne	L_457
	jmp	L_412
L_457:
	clrb	_hasCurrentCell
	tstb	_firstClick
	bne	L_433
L_417:
	mov	r0,-(sp)
	mov	04(sp),-(sp)
	jsr	pc,_openCell
	add	$04,sp
	tstb	_gameOver
	beq	L_458
	jmp	L_412
L_458:
	jsr	pc,_checkWinCondition
	jmp	L_412
L_418:
	mov	$-01,r0
	jmp	L_414
L_433:
	mov	r0,-(sp)
	mov	04(sp),-(sp)
	mov	r0,04(sp)
	jsr	pc,_generateMines
	clrb	_firstClick
	mov	$_OnFrameEvent,-(sp)
	jsr	pc,_setOnFrame
	add	$06,sp
	mov	(sp),r0
	br	L_417
	.data
LC_8:
	.byte 0105,0123,0103,050,0101,0122,062,051,040,055,040,0145,0170,0151,0164,0
	.text
	.even
	.globl	_main
_main:
	mov	r2,-(sp)
	add	$-010,sp
	jsr	pc,___main
	jsr	pc,_initMouse
	tstb	r0
	bne	L_488
L_459:
	add	$010,sp
	mov	(sp)+,r2
	rts	pc
L_488:
	jsr	pc,_initKeyb
	tstb	r0
	beq	L_459
	jsr	pc,_initGraph
	tstb	r0
	beq	L_459
	mov	$_OnMouseEvent,-(sp)
	jsr	pc,_setOnClick
	mov	$_OnKeyEvent,-(sp)
	jsr	pc,_setOnKeyEvent
	mov	_currentState,r0
	add	$04,sp
	mov	$_printBottom,02(sp)
	mov	$_hideMouse,06(sp)
	cmp	r0,$02
	bne	L_463
	br	L_468
L_464:
	mov	_currentState,r0
	cmp	r0,$01
	beq	L_489
L_469:
	mov	_currentState,r0
	cmp	r0,$02
	beq	L_468
L_463:
	mov	_currentState,r0
	tst	r0
	bne	L_464
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
L_466:
	mov	_currentState,r0
	tst	r0
	bne	L_469
	movb	_hasPendingClick,r0
	tstb	r0
	beq	L_466
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
	br	L_466
L_468:
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
	jmp	L_459
L_489:
	jsr	pc,@06(sp)
	jsr	pc,_clearScreen
	clrb	_initBySmile
	jsr	pc,_drawInitialBoard
	clrb	_hasPendingClick
	jsr	pc,_showMouse
L_473:
	mov	_currentState,r0
	cmp	r0,$01
	bne	L_469
	mov	_frameCounter,r0
	cmp	r0,$061
	blos	L_471
	mov	_frameCounter,r0
	add	$-062,r0
	mov	r0,_frameCounter
	mov	_seconds,r0
	inc	r0
	mov	r0,r1
	cmp	r0,$01747
	ble	L_472
	mov	$01747,r1
	mov	r1,r0
L_472:
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
L_471:
	movb	_hasPendingClick,r0
	tstb	r0
	beq	L_473
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
	br	L_473
	.data
	.even
_CSWTCH.180:
	.word	01
	.word	04
	.word	02
	.globl	_palette
	.data
	.even
_palette:
	.=.+ 04
	.globl	_frameCounter
	.even
_frameCounter:
	.=.+ 02
	.globl	_offset_y
	.even
_offset_y:
	.=.+ 02
	.globl	_offset_x
	.even
_offset_x:
	.=.+ 02
	.globl	_pendingDown
_pendingDown:
	.=.+ 01
	.globl	_pendingLeft
_pendingLeft:
	.byte	01
	.globl	_pendingY
	.even
_pendingY:
	.=.+ 02
	.globl	_pendingX
	.even
_pendingX:
	.=.+ 02
	.globl	_hasPendingClick
_hasPendingClick:
	.=.+ 01
	.globl	_emptystr
	.data
LC_9:
	.byte 040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,0
	.data
	.even
_emptystr:
	.word	LC_9
	.globl	_smileY
	.even
_smileY:
	.=.+ 02
	.globl	_smileX
	.even
_smileX:
	.=.+ 02
	.globl	_initBySmile
_initBySmile:
	.=.+ 01
	.globl	_currentMode
_currentMode:
	.byte	0377
	.globl	_currentState
	.even
_currentState:
	.=.+ 02
	.globl	_firstClick
_firstClick:
	.byte	01
	.globl	_gameWon
_gameWon:
	.=.+ 01
	.globl	_gameOver
_gameOver:
	.=.+ 01
	.globl	_board_copy
_board_copy:
	.=.+ 0707
	.globl	_board
_board:
	.=.+ 0707
	.globl	_queue
	.even
_queue:
	.=.+ 01616
	.globl	_seconds
	.even
_seconds:
	.=.+ 02
	.globl	_innercellcolor
	.even
_innercellcolor:
	.word	07
	.globl	_flags
	.even
_flags:
	.=.+ 02
	.globl	_total_mines
	.even
_total_mines:
	.word	012
	.globl	_field_h
	.even
_field_h:
	.word	011
	.globl	_field_w
	.even
_field_w:
	.word	011
	.globl	_hasCurrentCell
_hasCurrentCell:
	.=.+ 01
	.globl	_currentCell
	.even
_currentCell:
	.=.+ 02
	.globl	_menuLabels
	.data
LC_10:
	.byte 0102,0105,0107,0111,0116,0116,0105,0122,0
LC_11:
	.byte 0101,0115,0101,0124,0105,0125,0122,0
LC_12:
	.byte 0120,0122,0117,0106,0105,0123,0123,0111,0117,0116,0101,0114,0
LC_13:
	.byte 0105,0130,0111,0124,0
	.data
	.even
_menuLabels:
	.word	LC_10
	.word	LC_11
	.word	LC_12
	.word	LC_13
	.globl	_segmentMap
	.data
_segmentMap:
	.byte 077,06,0133,0117,0146,0155,0175,07,0177,0157
	.data
	.even
_g_seed:
	.word	-066452
	.word	-071536
