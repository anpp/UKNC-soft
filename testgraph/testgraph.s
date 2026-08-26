	.text
	.data
LC_0:
	.byte 0124,0105,0123,0124,040,0107,0122,0101,0120,0110,040,0114,0111,0102,0
LC_1:
	.byte 040,040,040,040,040,040,040,040,040,040,040,040,040,040,0
	.text
	.even
	.globl	_main
_main:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	mov	r5,-(sp)
	jsr	pc,___main
	jsr	pc,_InitKeyb
	jsr	pc,_InitGraph
	jsr	pc,_ClearScreen
	mov	$LC_0,-(sp)
	mov	$01,-(sp)
	mov	$_PrintTop,r5
	jsr	pc,(r5)
	add	$04,sp
	clr	r2
	mov	$_Line,r4
	mov	$0100,r3
L_2:
	mov	$07,-(sp)
	mov	$0407,-(sp)
	mov	r2,-(sp)
	clr	-(sp)
	mov	r2,-(sp)
	jsr	pc,(r4)
	add	$012,r2
	add	$012,sp
	sob	r3,L_2
	clr	r2
	mov	$033,r3
L_3:
	mov	$07,-(sp)
	mov	r2,-(sp)
	mov	$01177,-(sp)
	mov	r2,-(sp)
	clr	-(sp)
	jsr	pc,(r4)
	add	$012,r2
	add	$012,sp
	sob	r3,L_3
	jsr	pc,_WaitAnyKey
	mov	$LC_1,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r5)
	jsr	pc,_FinishGraph
	jsr	pc,_FinishKeyb
	add	$04,sp
	mov	(sp)+,r5
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
