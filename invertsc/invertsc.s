	.text
	.data
LC_0:
	.byte 0111,0116,0126,0105,0122,0124,040,0123,0103,0122,0105,0105,0116,0
LC_1:
	.byte 0120,0122,0105,0123,0123,040,0101,0116,0131,040,0113,0105,0131,0
LC_2:
	.byte 040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,0
LC_3:
	.byte 040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,040,0
	.text
	.even
	.globl	_main
_main:
	mov	r2,-(sp)
	mov	r3,-(sp)
	mov	r4,-(sp)
	jsr	pc,___main
	jsr	pc,_InitKeyb
	jsr	pc,_InitGraph
	mov	$LC_0,-(sp)
	mov	$01,-(sp)
	mov	$_PrintTop,r3
	jsr	pc,(r3)
	mov	$LC_1,-(sp)
	mov	$01,-(sp)
	mov	$_PrintBottom,r2
	jsr	pc,(r2)
	mov	$_InvertScreen,r4
	jsr	pc,(r4)
	jsr	pc,_WaitAnyKey
	jsr	pc,(r4)
	mov	$LC_2,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r3)
	mov	$LC_3,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r2)
	jsr	pc,_FinishGraph
	jsr	pc,_FinishKeyb
	add	$020,sp
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
