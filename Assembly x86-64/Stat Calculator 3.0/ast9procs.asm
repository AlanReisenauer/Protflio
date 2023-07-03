; *****************************************************************
;  Name: Alan Reisenauer
;  Description: See below

; -----------------------------------------------------------------------------
;  Write assembly language functions.

;  Function, shellSort(), sorts the numbers into ascending
;  order (small to large).  Uses the shell sort algorithm
;  modified to sort in ascending order.

;  Function lstSum() to return the sum of a list.

;  Function lstAverage() to return the average of a list.
;  Must call the lstSum() function.

;  Fucntion basicStats() finds the minimum, median, and maximum,
;  sum, and average for a list of numbers.
;  The median is determined after the list is sorted.
;  Must call the lstSum() and lstAverage() functions.

;  Function linearRegression() computes the linear regression.
;  for the two data sets.  Must call the lstAverage() function.

;  Function readSeptNum() should read a septenary number
;  from the user (STDIN) and perform apprpriate error checking.


; ******************************************************************************

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  Define program specific constants.

SUCCESS 	equ	0
NOSUCCESS	equ	1
OUTOFRANGEMIN	equ	2
OUTOFRANGEMAX	equ	3
INPUTOVERFLOW	equ	4
ENDOFINPUT	equ	5

LIMIT		equ	1510

MIN		equ	-100000
MAX		equ	100000

BUFFSIZE	equ	50			; 50 chars including NULL

; -----
;  NO static local variables allowed...


; ******************************************************************************

section	.text

; -----------------------------------------------------------------------------
;  Read an ASCII septenary number from the user.

;  Return codes:
;	SUCCESS			Successful conversion
;	NOSUCCESS		Invalid input entered
;	OUTOFRANGEMIN		Input below minimum value
;	OUTOFRANGEMAX		Input above maximum value
;	INPUTOVERFLOW		User entry character count exceeds maximum length
;	ENDOFINPUT		End of the input

; -----
;  Call:
;	status = readSeptNum(&numberRead);

;  Arguments Passed:
;	1) numberRead, addr - rdi

;  Returns:
;	number read (via reference)
;	status code (as above)

global readSeptNum
readSeptNum:

	push 	rbp
	mov 	rbp, rsp
	sub 	rsp, 55
	push 	rbx
	push 	r12
	push 	r13
	push 	r14

	mov 	dword[rbp-54], 7
	mov 	r12, rdi

;Loop to read the User input
lea		rbx, byte[rbp-50]
mov		r13, 0

getChar:
	;read Chr
	mov 	rax, SYS_read
	mov 	rdi, STDIN
	lea		rsi, byte[rbp-55]
	mov 	rdx, 1
	syscall
	;if chr == LF => exit lp
	mov 	al, byte[rbp-55]
	cmp 	al, LF
	je inputDone
	;if (i<bufferSize-1)
	cmp		r13, BUFFSIZE-1
	ja		buffFull
	;str[i] = chr
	mov		byte[rbx+r13], al
	;i++
	inc r13

buffFull:
	jmp getChar

inputDone:

;if i>Buffsize->set status exit function
cmp		r13, BUFFSIZE
jae		buffOver

cmp		r13, 0
je		lfDone

cmp		r13, BUFFSIZE
jbe		checkInput


checkInput:
;enter NULL to the end of string
;Loop to convert/check input
;ast#6

	mov r14, 0
	mov rcx, 0
	skipBlanks:
		;	get char, char = str[i]
		mov	cl, byte[rbx+r14]
		;	if char ne blank
		; 		goto next
		cmp	cl, " "
		jne checkSignPos
		;	inc i
		inc r14
		; 	goto skipBlanks
		jmp skipBlanks
	
	checkSignPos:
	cmp	cl, "+"
	je	sign

	checkNeg:
	cmp	cl, "-"
	je	sign

	jmp invalidIN

	sign:
		;	sign = 1
		mov r10, 1
		;	if char = "-"
		;		sign = -1
		cmp	cl, "-"
		jne	isPos
		mov	r10, -1

	isPos:
		mov eax, 0 ;rsum = 0
		inc r14

	nxtChar:
		;get char, chr = str[i]
		mov ecx, 0
		mov cl, byte[rbx+r14]

		;if char == LF
		;	goto lenChrLpDone
		cmp r14, r13
		je 	chrLpDone

		;convert char to int
		;	if "0"-"1" == int = char - "0"
		sub	cl, "0"

		;if excedes 7 then invalid input
		cmp	cl,	7
		jae	invalidIN

		;rsum = (rsum*7)+int
		mov r11d, 7
		mul	r11d
		add eax, ecx

		;inc i
		inc r14

		; goto NxtChar
		jmp nxtChar

	chrLpDone:
	;ans = rsum * sign
	imul r10d

;check if in bounds of min and max

cmp	eax, MIN
jle tooSmall

cmp	eax, MAX
jge	tooBig

;if everything is right, jump to a success
mov dword[r12], eax
jmp		readFuncDone

tooSmall:
mov		rax, OUTOFRANGEMIN
jmp		exit

tooBig:
mov		rax, OUTOFRANGEMAX
jmp		exit

invalidIN:
mov		rax, NOSUCCESS
jmp		exit

buffOver:
mov 	rax, INPUTOVERFLOW
jmp		exit

lfDone:
mov		rax, ENDOFINPUT
jmp		exit

readFuncDone:
mov 	rax, SUCCESS

exit:
	pop r14
	pop r13
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp

ret

; -----------------------------------------------------------------------------
;  Shell sort function.

; -----
;  HLL Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr
;	2) length, value

;  Returns:
;	sorted list (list passed by reference)

global	shellSort
shellSort:

	push rbx
	push rbp
	push r12
	push r13
	push r14
	push r15



;	YOUR CODE GOES HERE

	mov eax, 1
	mov r12d, 3
	;while ( (h*3+1) < length ) {
	setupH:
		cmp eax, esi
		jg setupHDone
		;h = 3 * h + 1;
		mul r12d
		inc eax
	;}
	setupHDone:

	;while ( h>0 ) {
	outsideLP:
		cmp eax, 0
		jbe outsideLPDone

		;i=h-1
		mov r9, 0
		mov r13, 0
		mov r14, 0
		mov r15, 0

		mov r9d, eax
		mov r13d, r9d
		dec r13d
		;for (i = h-1; i < length; i++) {
		secondLP:
			;if i >= length leave loop
			cmp r13d, esi
			jge secondLPDone


			;tmp = lst[i];
			mov r9d, r13d
			mov r15d, dword[rdi+r9*4]

			;j = i;
			mov r14d, r9d


			;;for ( j=i; (j >= h) && (lst[j-h] < tmp); j = j-h) {
			thirdLP:
				;if j<h leave loop
				mov r11, 0
				mov r11d, r14d
				cmp r11d, eax
				jl thirdLPDone

				;j-h
				
				mov r8, 0
				mov rbx, 0
				mov rax, 0
				mov r8d, r14d 
				sub r8d, eax
				;if lst[j-h]>=tmp leave loop
				cmp dword[rdi+r8*4], r15d
				jge thirdLPDone

				;lst[j] = lst[j-h];
				mov r11d, r14d
				mov r10, 0
				mov r10d, dword[rdi+r8*4]
				mov dword[rdi+r11*4], r10d

				mov r14d, r8d
				jmp thirdLP
			;}
			thirdLPDone:
			mov r11, 0
			mov r11d, r14d
			;lst[j] = tmp;
			mov r10d, r15d
			mov dword[rdi+r11*4], r10d

			;i++
			inc r13d
			jmp secondLP
		;}
		secondLPDone:
		;h = h / 3;
		mov r12, 0
		mov r12d, 3
		mov edx, 0
		div r12d

		jmp outsideLP
	;}
	outsideLPDone:
	
	pop r15
	pop r14
	pop	r13
	pop r12
	pop rbp
	pop rbx

ret

; -----------------------------------------------------------------------------
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstSum() and lstAvergae() functions
;  to get the corresponding values.

;  Note, assumes the list is already sorted.

; -----
;  HLL Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Returns:
;	minimum, median, maximum, sum, and average
;	via pass-by-reference (addresses on stack)



;	YOUR CODE GOES HERE

global basicStats
basicStats:

;	YOUR CODE GOES HERE
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14

	;max = list[0]
	mov eax, dword[rdi]
	mov dword[rdx], eax

	;min = list[len-1]
	mov r10, 0
	mov r10d, esi
	dec r10
	mov eax, dword[rdi+r10*4]
	mov dword[r8], eax

	;finding the median
	;ODD: lst[len/2]
	;even: (lst[len/2]+lst[len/2-1])/2
	;preserved rbx, r12,r13,r14,r15
	
	;finding len/2
	mov eax, esi
	mov edx, 0
	mov r10d, 2
	div r10d
	mov r11, 0
	mov r11d, eax

	;retrieving list[len/2]
	mov eax, dword[rdi+r11*4]

	;check if odd or even
	mov r10d, 1
	and r10d, esi
	cmp r10d, 1
	je odd

	;if even
	;lst[len/2]+lst[len/2-1]
	dec r11
	add eax, dword[rdi+r11*4]
	
	;div by 2
	cdq
	mov r10d, 2
	idiv r10d

	odd:
	;eax has results
	mov dword[rcx], eax

	;getting the sum from lst sum function
	mov r12, rdi
	mov r13d, esi
	mov r14, r9
	call lstSum
	mov dword[r14], eax

	;getting the average from the lstAve function
	mov rdi, r12
	mov esi, r13d
	call lstAve

	mov rbx, qword[rbp+16]
	mov dword[rbx], eax

	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	ret

; -----------------------------------------------------------------------------
;  Function to calculate the sum of a list.

; -----
;  Call:
;	ans = lstSum(lst, len)

;  Arguments Passed:
;	1) list, address
;	2) length, value

;  Returns:
;	sum (in eax)

global	lstSum
lstSum:

;	YOUR CODE GOES HERE

	;Finding the sum
	mov rax, 0
	mov rcx, 0
	mov ecx, esi
	mov r9, 0

	sumlp:
	add eax, dword[rdi+r9*4]
	inc r9
	loop sumlp

	ret

; -----------------------------------------------------------------------------
;  Function to calculate the average of a list.
;  Note, must call the lstSum() fucntion.

; -----
;  Call:
;	ans = lstAve(lst, len)

;  Arguments Passed:
;	1) list, address
;	2) length, value

;  Returns:
;	average (in eax)

global	lstAve
lstAve:
;	YOUR CODE GOES HERE
	push rbx
	mov ebx, esi

	;rdi & esi already set
	call lstSum
	cdq
	idiv ebx
	
	pop rbx
	ret

; -----------------------------------------------------------------------------
;  Function to calculate the linear regression
;  between two lists (of equal size).

; -----
;  Call:
;	linearRegression(xList, yList, len, xAve, yAve, b0, b1)

;  Arguments Passed:
;	1) xList, address
;	2) yList, address
;	3) length, value
;	4) xList average, value
;	5) yList average, value
;	6) b0, address
;	7) b1, address

;  Returns:
;	b0 and b1 via reference

;	1) xList, address - rdi
;	2) yList, address - rsi
;	3) length, value - edx
;	4) xList average, value - ecx
;	5) yList average, value - r8d
;	6) b0, address - r9
;	7) b1, address - stack, rpb+16

global  linearRegression
linearRegression:
;	YOUR CODE GOES HERE
;	push 	rbp
;	mov 	rbp, rsp
;	push 	r12
;	push 	r13
;	push 	r14
;	push	r15
;
;	;rTop=0
;    ;rBtm=0
;    mov r13, 0
;    mov r14, 0
;	mov r15, 0
;
;	;i = 0
;	mov r12, 0
;	;for(i = 0; i < len; i++){
;		topLoop:
;		cmp r12d, edx
;		jge topLoopDone
;		;rtop = (xlst[i]-xave)*(ylst[i]-yave)
;		;xlst[i]-xave
;		mov eax, dword[rdi]
;		sub eax, ecx
;        mov r15d, eax
;		
;		;store this value for rBtm
;		imul eax
;		add r14d, eax
;
;		;ylst[i]-yave
;		mov rax, 0
;		mov eax, dword[rsi+r12*4]
;		sub eax, r8d
;
;		;multiply them together
;		imul dword[r15d]
;		mov dword[eax+4], edx
;		;store in rTop
;		add qword[r13], rax
;
;		inc r12
;		jmp topLoop
;	;}
;	topLoopDone:
;
;	;b1=rTop/rBtm
;	mov rax, 0
;	mov rdx, 0
;	mov rax, qword[r13]
;	cqo
;	idiv r14
;
;	mov rbx, qword[rbp+16]
;	mov dword[rbx], eax
;
;	;b0=yave-b1*xave
;	;b1*xave
;	mov eax, dword[rbx]
;	imul eax, ecx
;	sub r8d, eax
;
;	mov dword[r9], r8d
;
;	pop	r15
;	pop r14
;	pop r13
;	pop r12
;	pop rbx
;	pop rbp

ret
; -----------------------------------------------------------------------------

