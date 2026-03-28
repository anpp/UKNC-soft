	.text
	.even
	.globl	_turn_ant
_turn_ant:
	cmp	02(sp),$01
	beq	L_5
	cmp	02(sp),$-01
	bne	L_1
	mov	_ant_dir,r0
	add	$03,r0
	bic	$-04,r0
	mov	r0,_ant_dir
L_1:
	rts	pc
L_5:
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
	bne	L_7
	dec	r0
	mov	r0,_ant_y
L_8:
	tst	r1
	blt	L_16
L_11:
	tst	r0
	blt	L_17
	cmp	r1,$01177
	ble	L_12
	clr	_ant_x
L_12:
	cmp	r0,$0407
	ble	L_6
	clr	_ant_y
L_6:
	mov	(sp)+,r2
	rts	pc
L_7:
	cmp	r2,$02
	bne	L_9
	inc	r0
	mov	r0,_ant_y
	tst	r1
	bge	L_11
L_16:
	mov	$01177,_ant_x
	tst	r0
	bge	L_12
	mov	$0407,_ant_y
	mov	(sp)+,r2
	rts	pc
L_17:
	mov	$0407,_ant_y
	cmp	r1,$01177
	ble	L_6
	clr	_ant_x
	mov	(sp)+,r2
	rts	pc
L_9:
	cmp	r2,$03
	bne	L_10
	dec	r1
	mov	r1,_ant_x
	br	L_8
L_10:
	cmp	r2,$01
	bne	L_8
	inc	r1
	mov	r1,_ant_x
	br	L_8
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
	cmp	r0,$07
	blos	L_22
	br	L_19
L_20:
	mov	(sp),r0
	inc	r0
	mov	r0,(sp)
	mov	(sp),r0
	cmp	r0,$07
	bhi	L_19
L_22:
	mov	(sp),r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r2,r0
	asl	r0
	cmpb	_prog(r0),r1
	bne	L_20
	mov	(sp),r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r2,r0
	asl	r0
	cmp	_prog+02(r0),r5
	bne	L_20
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
L_19:
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
	cmp	r0,$07
	blos	L_25
	br	L_30
L_27:
	mov	02(sp),r0
	inc	r0
	mov	r0,02(sp)
	mov	02(sp),r0
	cmp	r0,$07
	bhi	L_30
L_25:
	mov	02(sp),r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r2,r0
	asl	r0
	cmpb	r1,_prog(r0)
	bne	L_27
	mov	02(sp),r2
	mov	r2,r0
	asl	r0
	asl	r0
	add	r2,r0
	asl	r0
	cmp	r5,_prog+02(r0)
	bne	L_27
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
	beq	L_36
	cmp	r0,$-01
	bne	L_31
	mov	_ant_dir,r0
	add	$03,r0
	bic	$-04,r0
	mov	r0,_ant_dir
L_31:
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
L_30:
	clr	r0
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r2
	rts	pc
L_36:
	mov	_ant_dir,r0
	inc	r0
	bic	$-04,r0
	mov	r0,_ant_dir
	br	L_31
	.data
LC_0:
	.byte 0124,0165,0162,0155,0151,0164,0
LC_1:
	.byte 040,040,040,040,040,040,040,0
	.text
	.even
	.globl	_main
_main:
	mov	r2,-(sp)
	mov	r3,-(sp)
	jsr	pc,___main
	jsr	pc,_InitKeyb
	jsr	pc,_InitGraph
	jsr	pc,_ClearScreen
	mov	$LC_0,-(sp)
	mov	$_PrintTop,r3
	jsr	pc,(r3)
	mov	$0500,_ant_x
	mov	$0204,_ant_y
	mov	$01,_ant_dir
	movb	$0101,_ant_state
	add	$02,sp
	br	L_39
L_45:
	jsr	pc,_kbhit
	tst	r0
	bne	L_38
L_39:
	jsr	pc,_step
	tst	r0
	bne	L_45
L_38:
	mov	$LC_1,-(sp)
	jsr	pc,(r3)
	jsr	pc,_FinishGraph
	jsr	pc,_FinishKeyb
	add	$02,sp
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
	.globl	_ant_state
	.data
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
	.word	01
	.word	01
	.byte	0101
	.=.+ 01
	.byte	0101
	.=.+ 01
	.word	01
	.word	02
	.word	01
	.byte	0101
	.=.+ 01
	.byte	0101
	.=.+ 01
	.word	02
	.word	03
	.word	-01
	.byte	0101
	.=.+ 01
	.byte	0101
	.=.+ 01
	.word	03
	.word	04
	.word	-01
	.byte	0101
	.=.+ 01
	.byte	0101
	.=.+ 01
	.word	04
	.word	05
	.word	-01
	.byte	0101
	.=.+ 01
	.byte	0101
	.=.+ 01
	.word	05
	.word	06
	.word	-01
	.byte	0101
	.=.+ 01
	.byte	0101
	.=.+ 01
	.word	06
	.word	07
	.word	01
	.byte	0101
	.=.+ 01
	.byte	0101
	.=.+ 01
	.word	07
	.word	0
	.word	01
	.byte	0101
	.=.+ 01
