	.text
	.even
	.globl	_OnKeyEvent
_OnKeyEvent:
	cmpb	04(sp),$06
	beq	L_9
	clrb	_esc
	tstb	02(sp)
	beq	L_1
	cmpb	04(sp),$013
	bne	L_1
	movb	_app_state,r0
	bic	$0177400,r0
	dec	r0
	clc
	ror	r0
	ash	$-016,r0	
	movb	r0,_app_state
L_1:
	rts	pc
L_9:
	tstb	02(sp)
	bne	L_3
	movb	$01,_esc
	rts	pc
L_3:
	clrb	_esc
	rts	pc
	.even
	.globl	_turn_ant
_turn_ant:
	cmp	02(sp),$01
	beq	L_13
	cmp	02(sp),$-01
	bne	L_10
	mov	_ant_dir,r0
	add	$03,r0
	bic	$-04,r0
	mov	r0,_ant_dir
L_10:
	rts	pc
L_13:
	mov	_ant_dir,r0
	inc	r0
	bic	$-04,r0
	mov	r0,_ant_dir
	rts	pc
	.even
	.globl	_move_ant
_move_ant:
	mov	r2,-(sp)
	mov	_ant_dir,r2
	mov	_ant_y,r0
	mov	_ant_x,r1
	tst	r2
	bne	L_15
	dec	r0
	mov	r0,_ant_y
L_16:
	tst	r1
	blt	L_24
L_19:
	tst	r0
	blt	L_25
	cmp	r1,$01177
	ble	L_20
	clr	_ant_x
L_20:
	cmp	r0,$0407
	ble	L_14
	clr	_ant_y
L_14:
	mov	(sp)+,r2
	rts	pc
L_15:
	cmp	r2,$02
	bne	L_17
	inc	r0
	mov	r0,_ant_y
	tst	r1
	bge	L_19
L_24:
	mov	$01177,_ant_x
	tst	r0
	bge	L_20
	mov	$0407,_ant_y
	mov	(sp)+,r2
	rts	pc
L_25:
	mov	$0407,_ant_y
	cmp	r1,$01177
	ble	L_14
	clr	_ant_x
	mov	(sp)+,r2
	rts	pc
L_17:
	cmp	r2,$03
	bne	L_18
	dec	r1
	mov	r1,_ant_x
	br	L_16
L_18:
	cmp	r2,$01
	bne	L_16
	inc	r1
	mov	r1,_ant_x
	br	L_16
	.even
	.globl	_find_rule
_find_rule:
	mov	r2,-(sp)
	mov	r5,-(sp)
	add	$-02,sp
	movb	010(sp),r1
	mov	012(sp),r5
	clr	(sp)
	mov	(sp),r0
	cmp	r0,$06
	blos	L_30
	br	L_27
L_28:
	mov	(sp),r0
	inc	r0
	mov	r0,(sp)
	mov	(sp),r0
	cmp	r0,$06
	bhi	L_27
L_30:
	mov	(sp),r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r2,r0
	asl	r0
	cmpb	_prog(r0),r1
	bne	L_28
	mov	(sp),r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r2,r0
	asl	r0
	cmp	_prog+02(r0),r5
	bne	L_28
	mov	(sp),r1
	mov	r1,r0
	asl	r0
	asl	r0
	add	r1,r0
	asl	r0
	add	$_prog,r0
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r2
	rts	pc
L_27:
	clr	r0
	add	$02,sp
	mov	(sp)+,r5
	mov	(sp)+,r2
	rts	pc
	.even
	.globl	_step
_step:
	mov	r2,-(sp)
	mov	r5,-(sp)
	add	$-04,sp
	mov	_ant_y,-(sp)
	mov	_ant_x,-(sp)
	jsr	pc,_GetPixel
	mov	r0,04(sp)
	mov	04(sp),r5
	movb	_ant_state,r1
	clr	06(sp)
	mov	06(sp),r0
	add	$04,sp
	cmp	r0,$06
	blos	L_33
	br	L_38
L_35:
	mov	02(sp),r0
	inc	r0
	mov	r0,02(sp)
	mov	02(sp),r0
	cmp	r0,$06
	bhi	L_38
L_33:
	mov	02(sp),r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r2,r0
	asl	r0
	cmpb	r1,_prog(r0)
	bne	L_35
	mov	02(sp),r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r2,r0
	asl	r0
	cmp	r5,_prog+02(r0)
	bne	L_35
	mov	02(sp),r0
	mov	r0,r2
	asl	r2
	asl	r2
	add	r0,r2
	mov	r2,r5
	asl	r5
	mov	$_prog+04,r0
	add	r5,r0
	mov	(r0),r0
	mov	r0,-(sp)
	mov	_ant_y,-(sp)
	mov	_ant_x,-(sp)
	jsr	pc,_PutPixel
	add	$_prog+06,r5
	mov	(r5),r0
	add	$06,sp
	cmp	r0,$01
	beq	L_44
	cmp	r0,$-01
	bne	L_39
	mov	_ant_dir,r0
	add	$03,r0
	bic	$-04,r0
	mov	r0,_ant_dir
L_39:
	asl	r2
	add	$_prog+010,r2
	movb	(r2),r0
	movb	r0,_ant_state
	jsr	pc,_move_ant
	mov	$01,r0
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r2
	rts	pc
L_38:
	clr	r0
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r2
	rts	pc
L_44:
	mov	_ant_dir,r0
	inc	r0
	bic	$-04,r0
	mov	r0,_ant_dir
	br	L_39
	.data
LC_0:
	.byte 0124,0165,0162,0155,0151,0164,0
LC_1:
	.byte 0120,0101,0125,0123,0105,0
LC_2:
	.byte 040,040,040,040,040,040,0
LC_3:
	.byte 040,040,040,040,040,040,040,0
	.text
	.even
	.globl	_main
_main:
	mov	r2,-(sp)
	mov	r3,-(sp)
	jsr	pc,___main
	jsr	pc,_InitKeyb
	mov	$_OnKeyEvent,-(sp)
	jsr	pc,_SetOnKeyEvent
	jsr	pc,_InitGraph
	jsr	pc,_ClearScreen
	mov	$LC_0,-(sp)
	mov	$01,-(sp)
	mov	$_PrintTop,r3
	jsr	pc,(r3)
	mov	$0500,_ant_x
	mov	$0204,_ant_y
	mov	$01,_ant_dir
	movb	$0101,_ant_state
	add	$06,sp
	br	L_47
L_49:
	movb	_esc,r0
	tstb	r0
	bne	L_51
	movb	_app_state,r0
	cmpb	r0,$01
	beq	L_56
L_47:
	jsr	pc,_step
	tst	r0
	bne	L_49
L_51:
	mov	$LC_3,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r3)
	jsr	pc,_FinishGraph
	jsr	pc,_FinishKeyb
	add	$04,sp
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
L_56:
	mov	$LC_1,-(sp)
	clr	-(sp)
	jsr	pc,_PrintBottom
	add	$04,sp
L_48:
	movb	_app_state,r0
	cmpb	r0,$01
	beq	L_48
	mov	$LC_2,-(sp)
	clr	-(sp)
	jsr	pc,_PrintBottom
	add	$04,sp
	br	L_47
	.globl	_esc
	.data
_esc:
	.=.+ 01
	.globl	_app_state
_app_state:
	.=.+ 01
	.globl	_ant_state
_ant_state:
	.=.+ 01
	.globl	_ant_dir
	.even
_ant_dir:
	.=.+ 02
	.globl	_ant_y
	.even
_ant_y:
	.=.+ 02
	.globl	_ant_x
	.even
_ant_x:
	.=.+ 02
	.globl	_prog
	.even
_prog:
	.byte	0101
	.=.+ 01
	.word	0
	.word	04
	.word	0
	.byte	0103
	.=.+ 01
	.byte	0101
	.=.+ 01
	.word	04
	.word	0
	.word	0
	.byte	0102
	.=.+ 01
	.byte	0102
	.=.+ 01
	.word	04
	.word	04
	.word	01
	.byte	0101
	.=.+ 01
	.byte	0102
	.=.+ 01
	.word	07
	.word	04
	.word	01
	.byte	0101
	.=.+ 01
	.byte	0103
	.=.+ 01
	.word	04
	.word	0
	.word	-01
	.byte	0101
	.=.+ 01
	.byte	0103
	.=.+ 01
	.word	0
	.word	07
	.word	-01
	.byte	0101
	.=.+ 01
	.byte	0103
	.=.+ 01
	.word	07
	.word	04
	.word	-01
	.byte	0101
	.=.+ 01
