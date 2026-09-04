	.text
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
	jsr	pc,_initKeyb
	jsr	pc,_initGraph
	mov	$LC_0,-(sp)
	mov	$01,-(sp)
	mov	$_printTop,r3
	jsr	pc,(r3)
	mov	$LC_1,-(sp)
	mov	$01,-(sp)
	mov	$_printBottom,r2
	jsr	pc,(r2)
	mov	$_invertScreen,r4
	jsr	pc,(r4)
	jsr	pc,_waitAnyKey
	jsr	pc,(r4)
	mov	$LC_2,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r3)
	mov	$LC_3,-(sp)
	mov	$01,-(sp)
	jsr	pc,(r2)
	jsr	pc,_finishGraph
	jsr	pc,_finishKeyb
	add	$020,sp
	mov	(sp)+,r4
	mov	(sp)+,r3
	mov	(sp)+,r2
	rts	pc
