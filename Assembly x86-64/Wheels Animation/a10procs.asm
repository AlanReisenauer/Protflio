; *****************************************************************
;  Name: Alan Reisenauer
;  Description: see below 

; -----
;  to run use format: ./wheels -sp <septNumber> -cl <septNumber> -sz <septNumber>
;  Function: getParams
;	Gets, checks, converts, and returns command line arguments.

;  Function drawWheels()
;	Plots functions

; ---------------------------------------------------------

;	MACROS (if any) GO HERE


; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define program specific constants.

SPD_MIN		equ	1
SPD_MAX		equ	50			; 101(7) = 50

CLR_MIN		equ	0
CLR_MAX		equ	0xFFFFFF	; 0xFFFFFF = 262414110(7)

SIZ_MIN		equ	100			; 202(7) = 100
SIZ_MAX		equ	2000		; 5555(7) = 2000

; -----
;  Local variables for getParams functions.

STR_LENGTH	equ	12

errUsage	db	"Usage: ./wheels -sp <septNumber> -cl <septNumber> "
		db	"-sz <septNumber>"
		db	LF, NULL
errBadCL	db	"Error, invalid or incomplete command line argument."
		db	LF, NULL

errSpdSpec	db	"Error, speed specifier incorrect."
		db	LF, NULL
errSpdValue	db	"Error, speed value must be between 1 and 101(7)."
		db	LF, NULL

errClrSpec	db	"Error, color specifier incorrect."
		db	LF, NULL
errClrValue	db	"Error, color value must be between 0 and 262414110(7)."
		db	LF, NULL

errSizSpec	db	"Error, size specifier incorrect."
		db	LF, NULL
errSizValue	db	"Error, size value must be between 202(7) and 5555(7)."
		db	LF, NULL

; -----
;  Local variables for drawWheels routine.

t			dq	0.0			; loop variable
s			dq	0.0
tStep		dq	0.001		; t step
sStep		dq	0.0
x			dq	0			; current x
y			dq	0			; current y
scale		dq	7500.0		; speed scale

fltZero		dq	0.0
fltOne		dq	1.0
fltTwo		dq	2.0
fltThree	dq	3.0
fltFour		dq	4.0
fltSix		dq	6.0
fltTwoPiS	dq	0.0

pi			dq	3.14159265358

fltTmp1		dq	0.0
fltTmp2		dq	0.0

red			dd	0			; 0-255
green		dd	0			; 0-255
blue		dd	0			; 0-255


; ------------------------------------------------------------

section  .text

; -----
; Open GL routines.

extern	glutInit, glutInitDisplayMode, glutInitWindowSize, glutInitWindowPosition
extern	glutCreateWindow, glutMainLoop
extern	glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern	glutSwapBuffers, gluPerspective, glutPostRedisplay
extern	glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern	glClear, glLoadIdentity, glMatrixMode, glViewport
extern	glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern	glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d

extern	cos, sin


; ******************************************************************
;  Function getParams()
;	Gets draw speed, draw color, and screen size
;	from the command line arguments.

;	Performs error checking, converts ASCII/septenary to integer.
;	Command line format (fixed order):
;	  "-sp <septNumber> -cl <septNumber> -sz <septNumber>"

; -----
;  Arguments:
;	rdi - ARGC,  double-word, value 
;	rsi - ARGV,  double-word, address
;	rdx - speed, double-word, address
;	rcx - color, double-word, address
;	r8  - size,  double-word, address

; Returns:
;	speed, color, and size via reference (of all valid)
;	TRUE or FALSE

global getParams
getParams:

;push registers if needed
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	push 	r12
	push 	r13
	push 	r14
	push 	r15

	mov		r12, rsi
	mov		r13, rdx
	mov		r14, rcx
	mov		r15, r8

;check if argc = 1, then usage error message
;check if argc != 7, then error
cmp		rdi, 1
je		errUsgMsg

cmp		rdi, 7
jne		errBadCLCount

;check if argv[1] = "-", "s", "p", NULL
mov		rbx, qword[rsi+8]

mov		al, byte[rbx]
cmp		al, "-"
jne		errSpeedSpec

mov		al, byte[rbx+1]
mov		al, "s"
jne		errSpeedSpec

mov		al, byte[rbx+2]
mov		al, "p"
jne		errSpeedSpec

mov		al, byte[rbx+3]
mov		al, NULL
jne		errSpeedSpec

;-----------------------
;check argv[3]
mov		rbx, qword[rsi+24]

mov		al, byte[rbx]
cmp		al, "-"
jne		errColSpec

mov		al, byte[rbx+1]
mov		al, "c"
jne		errColSpec

mov		al, byte[rbx+2]
mov		al, "l"
jne		errColSpec

mov		al, byte[rbx+3]
mov		al, NULL
jne		errColSpec

;-----------------------
;check argv[5]
mov		rbx, qword[rsi+40]

mov		al, byte[rbx]
cmp		al, "-"
jne		errSizeSpec

mov		al, byte[rbx+1]
mov		al, "s"
jne		errSizeSpec

mov		al, byte[rbx+2]
mov		al, "z"
jne		errSizeSpec

mov		al, byte[rbx+3]
mov		al, NULL
jne		errSizeSpec

;check if argv[2] is base-7
mov		rdi, qword[r12+8*2]
call	sept2int

;if returning a negative, send to error
cmp		eax, 0
jl		errSpeedVal

cmp		eax, SPD_MIN
jb		errSpeedVal

cmp		eax, SPD_MAX
Ja		errSpeedVal

;is good
mov		dword[r13], eax

;----------------
;color val
;check if argv[4] is base-7
mov		rdi, qword[r12+8*4]
call	sept2int

;if returning a negative, send to error
cmp		eax, 0
jl		errColVal

cmp		eax, CLR_MIN
jb		errColVal

cmp		eax, CLR_MAX
Ja		errColVal

;is good
mov		dword[r14], eax

;----------------
;size val
;check if argv[6] is base-7
mov		rdi, qword[r12+8*6]
call	sept2int

;if returning a negative, send to error
cmp		eax, 0
jl		errSizeVal

cmp		eax, SIZ_MIN
jb		errSizeVal

cmp		eax, SIZ_MAX
Ja		errSizeVal

;is good
mov		dword[r15], eax
jmp		successParam


;-------------------------------------------------
;error messages bank
;-------------------------------------------------

;error message for usageMsg
errUsgMsg:
	mov rdi, errUsage
	jmp		printIt

;error message for bad command line args
errBadCLCount:
	mov rdi, errBadCL
	jmp		printIt

;return false and print error message when error with speed flag
errSpeedSpec:
	mov rdi, errSpdSpec
	jmp		printIt

;return false and print error message when error with color flag
errColSpec:
	mov rdi, errClrSpec
	jmp		printIt

;return false and print error message when error with size flag
errSizeSpec
	mov rdi, errSizSpec
	jmp		printIt

;return false and print error message when error with speed value
errSpeedVal:
	mov rdi, errSpdValue
	jmp		printIt

;return false and print error message when error with size value
errColVal:
	mov rdi, errClrValue
	jmp		printIt

;return false and print error message when error with color value
errSizeVal:
	mov rdi, errSizValue
	jmp		printIt

;returns sucess and leaves function
successParam:
	mov		rax, TRUE
	jmp		exitParam

;prints the error message and goes to exit
printIt:
	call	printString
	mov 	rax, FALSE

;exit funct
exitParam:
;pop registers if needed
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp

ret

; ******************************************************************
; convert from septinary to integer
;  --------
;	Arguements:
;	septinaryNumber

global sept2int
sept2int:
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	push 	r12
	push 	r13
	push 	r14
	push 	r15

	mov r14, 0
	mov rcx, 0
	mov rax, 0

	nxtChar:
		;get char, chr = str[i]
		mov ecx, 0
		mov cl, byte[rdi+r14]

		;if char == NULL
		;	goto lenChrLpDone
		cmp cl, NULL
		je 	chrLpDone

		;convert char to int
		;	if "0"-"1" == int = char - "0"
		sub	cl, "0"

		;if excedes 7 then invalid input
		cmp	cl,	7
		jae	invalidIN

		cmp	cl, 0
		jb	invalidIN

		;rsum = (rsum*7)+int
		mov r11d, 7
		mul	r11d
		add eax, ecx

		;inc i
		inc r14

		; goto NxtChar
		jmp nxtChar

	chrLpDone:
	jmp exitSept

	invalidIN:
	mov rax, -1

	exitSept:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp

ret

; ******************************************************************
;  Draw wheels function.
;	Plot the provided functions (see PDF).

; -----
;  Arguments:
;	none -> accesses global variables.
;	nothing -> is void

; -----
;  Gloabl variables Accessed:

common	speed		1:4			; draw speed, dword, integer value
common	color		1:4			; draw color, dword, integer value
common	size		1:4			; screen size, dword, integer value

global drawWheels
drawWheels:
	push	rbp

; do NOT push any additional registers.
; If needed, save regitser to quad variable...

; -----
;  Set draw speed step
;	sStep = speed / scale

;	YOUR CODE GOES HERE

cvtsi2sd	xmm0, dword[speed]
divsd		xmm0, qword[scale]

movsd		qword[sStep], xmm0

; -----
;  Prepare for drawing
	; glClear(GL_COLOR_BUFFER_BIT);
	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

	; glBegin();
	mov	rdi, GL_POINTS
	call	glBegin

; -----
;  Set draw color(r,g,b)
;	uses glColor3ub(r,g,b)

;	YOUR CODE GOES HERE

;red - 23-16 - 8bits
;green - 15-8 - 8bits
;blue - 7-0 - 8bits

mov		ebx, dword[color]

mov		rdi, 0
mov 	rsi, 0
mov		rdx, 0

mov		dl, bl
ror		ebx, 8
mov		sil, bl
ror		ebx, 8
mov		dil, bl

call	glColor3ub

; -----
;  main plot loop
;	iterate t from 0.0 to 2*pi by tStep
;	uses glVertex2d(x,y) for each formula


;	YOUR CODE GOES HERE
movsd	xmm0, qword[fltZero]
movsd	qword[t], xmm0 
;for(t=0; t<=2pi; t+=tStep)
plotLoop1:
	movsd	xmm0, qword[fltTwo]
	mulsd	xmm0, qword[pi]

	ucomisd	xmm0, qword[t]
	jbe	plotLoop1done

	;x1 = cos(t)
	movsd	xmm0, qword[t]
	call	cos
	movsd	qword[x], xmm0 

	;y1 = sin(t)
	movsd	xmm0, qword[t]
	call	sin
	movsd	qword[y], xmm0 

	;call glVertex2d(x1,y1)
	movsd	xmm0, qword[x]
	movsd	xmm1, qword[y]
	call	glVertex2d
	
;----------------------------------------------	
	;calculating x2 and y2 
	movsd	xmm0, qword[t]
	call 	cos
	divsd	xmm0, qword[fltThree]

	;saving cos(t)/3.0 for later
	movsd	qword[fltTmp1], xmm0

	movsd	xmm0, qword[fltTwo]
	mulsd	xmm0, qword[pi]
	mulsd	xmm0, qword[s]

	;saving 2piS for calculations
	movsd	qword[fltTwoPiS], xmm0

	call cos

	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]
	addsd	xmm0, qword[fltTmp1]

	movsd	qword[x], xmm0

	;calculating the y2 value
	movsd	xmm0, qword[t]
	call 	sin
	divsd	xmm0, qword[fltThree]

	;saving sin(t)/3.0 for later
	movsd	qword[fltTmp1], xmm0

	movsd	xmm0, qword[fltTwoPiS]

	call sin

	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]
	addsd	xmm0, qword[fltTmp1]

	movsd	qword[y], xmm0

	;call glVertex2d(x2,y2)
	movsd	xmm0, qword[x]
	movsd	xmm1, qword[y]
	call	glVertex2d

;----------------------------------------------
	;calculating x3 and y3
	;tcos(4piS)/6pi+2cos(2piS)/3=x3
	movsd	xmm0, qword[fltFour]
	mulsd	xmm0, qword[pi]
	mulsd	xmm0, qword[s]

	call cos

	mulsd	xmm0, qword[t]
	
	movsd	xmm1, qword[fltSix]
	mulsd	xmm1, qword[pi]

	divsd	xmm0, xmm1
	movsd	qword[fltTmp1], xmm0

	movsd	xmm0, qword[fltTwoPiS]

	call cos

	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	addsd	xmm0, qword[fltTmp1]

	movsd	qword[x], xmm0

	;y3 = fltTmp2-tsin(4piS)/6pi
	movsd	xmm0, qword[fltFour]
	mulsd	xmm0, qword[pi]
	mulsd	xmm0, qword[s]

	call sin

	mulsd	xmm0, qword[t]
	
	movsd	xmm1, qword[fltSix]
	mulsd	xmm1, qword[pi]

	divsd	xmm0, xmm1

	movsd	qword[fltTmp1], xmm0

	movsd	xmm0, qword[fltTwoPiS]

	call sin

	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	subsd	xmm0, qword[fltTmp1]

	movsd	qword[y], xmm0

	;call glVertex2d(x3,y3)
	movsd	xmm0, qword[x]
	movsd	xmm1, qword[y]
	call	glVertex2d

;----------------------------------------------
	;calculating x4 and y4
	;2cos(2piS)/3+tCos(4piS+2pi/3)/6pi
	movsd	xmm0, qword[pi]
	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	movsd	xmm1, qword[pi]
	mulsd	xmm1, qword[fltFour]
	mulsd	xmm1, qword[s]

	addsd	xmm0, xmm1

	call	cos

	mulsd	xmm0, qword[t]

	movsd	xmm2, qword[fltSix]
	mulsd	xmm2, qword[pi]

	divsd	xmm0, xmm2

	movsd	qword[fltTmp1], xmm0

	movsd	xmm0, qword[fltTwoPiS]

	call cos

	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	addsd	xmm0, qword[fltTmp1]

	movsd	qword[x], xmm0

	;2sin(2piS)/3-tsin(4piS+2pi/3)/6pi
	movsd	xmm0, qword[pi]
	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	movsd	xmm1, qword[pi]
	mulsd	xmm1, qword[fltFour]
	mulsd	xmm1, qword[s]

	addsd	xmm0, xmm1

	call	sin

	mulsd	xmm0, qword[t]

	movsd	xmm2, qword[fltSix]
	mulsd	xmm2, qword[pi]

	divsd	xmm0, xmm2

	movsd	qword[fltTmp1], xmm0

	movsd	xmm0, qword[fltTwoPiS]

	call 	sin

	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	subsd	xmm0, qword[fltTmp1]

	movsd	qword[y], xmm0

	;call glVertex2d(x3,y3)
	movsd	xmm0, qword[x]
	movsd	xmm1, qword[y]
	call	glVertex2d

;----------------------------------------------

;	;calculating x5 and y5
;	;2cos(2piS)/3+tCos(4piS-2pi/3)/6pi
	movsd	xmm0, qword[pi]
	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	movsd	xmm1, qword[pi]
	mulsd	xmm1, qword[fltFour]
	mulsd	xmm1, qword[s]

	subsd	xmm1, xmm0

	movsd	xmm0, xmm1

	call	cos

	mulsd	xmm0, qword[t]

	movsd	xmm2, qword[fltSix]
	mulsd	xmm2, qword[pi]

	divsd	xmm0, xmm2

	movsd	qword[fltTmp1], xmm0

	movsd	xmm0, qword[fltTwoPiS]

	call cos

	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	addsd	xmm0, qword[fltTmp1]

	movsd	qword[x], xmm0

	;2sin(2piS)/3-tsin(4piS-2pi/3)/6pi
	movsd	xmm0, qword[pi]
	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	movsd	xmm1, qword[pi]
	mulsd	xmm1, qword[fltFour]
	mulsd	xmm1, qword[s]

	subsd	xmm1, xmm0

	movsd	xmm0, xmm1

	call	sin

	mulsd	xmm0, qword[t]

	movsd	xmm2, qword[fltSix]
	mulsd	xmm2, qword[pi]

	divsd	xmm0, xmm2

	movsd	qword[fltTmp1], xmm0

	movsd	xmm0, qword[fltTwoPiS]

	call 	sin

	mulsd	xmm0, qword[fltTwo]
	divsd	xmm0, qword[fltThree]

	subsd	xmm0, qword[fltTmp1]

	movsd	qword[y], xmm0

	;call glVertex2d(x5,y5)
	movsd	xmm0, qword[x]
	movsd	xmm1, qword[y]
	call	glVertex2d

	;t++
	movsd	xmm0, qword[t]
	addsd	xmm0, qword[tStep]
	movsd	qword[t], xmm0


jmp	plotLoop1

plotLoop1done:

; -----
;  Display image

	call	glEnd
	call	glFlush

; -----
;  Update s, s += sStep;
;  if (s > 1.0)
;	s = 0.0;

	movsd	xmm0, qword [s]			; s+= sStep
	addsd	xmm0, qword [sStep]
	movsd	qword [s], xmm0

	movsd	xmm0, qword [s]
	movsd	xmm1, qword [fltOne]
	ucomisd	xmm0, xmm1			; if (s > 1.0)
	jbe	resetDone

	movsd	xmm0, qword [fltZero]
	movsd	qword [sStep], xmm0
resetDone:

	call	glutPostRedisplay

; -----

	pop	rbp
	ret

; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rbx
	ret

; ******************************************************************

