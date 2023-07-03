; *****************************************************************
;  Name: Alan Reisenauer
;  Description: See below

; -----------------------------------------------------------------
;  Write some assembly language functions.

;  The function, shellSort(), sorts the numbers into descending
;  order (large to small).  Uses the shell sort algorithm (modified to sort in descending order).

;  The function, basicStats(), finds the minimum, median, and maximum,
;  sum, and average for a list of numbers.
;  Note, the median is determined after the list is sorted.
;	This function must call the lstSum() and lstAvergae()
;	functions to get the corresponding values.
;	The lstAvergae() function must call the lstSum() function.

;  The function, linearRegression(), computes the linear regression of
;  the two data sets.  Summation and division performed as integer.

; *****************************************************************

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

; -----
;  Local variables for shellSort() function (if any).

h 			dd 1
j			dd 0
i			dd 0
tmp			dd 0

; -----
;  Local variables for basicStats() function (if any).

; -----------------------------------------------------------------

section	.bss

; -----
;  Local variables for linearRegression() function (if any).

qSum		resq	1
dSum		resq	1
tmpx		resq	1
tmpy		resq	1
len			resd	1
tmpTop		resq	1

; *****************************************************************

section	.text

; --------------------------------------------------------
;  Shell sort function (form asst #7).
;	Updated to sort in descending order.

; -----
;  HLL Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi

;  Returns:
;	sorted list (list passed by reference)

global	shellSort
shellSort:

	push rbx
	push rbp
	push r12


;	YOUR CODE GOES HERE
	
	mov eax, dword[rdi]

	mov eax, 1
	mov r12d, 3
	;while ( (h*3+1) < length ) {
	setupH:
		cmp eax, esi
		ja setupHDone
		;h = 3 * h + 1;
		mul r12d
		inc eax
		mov dword[h], eax
		mov dword[h+4], edx
	;}
	setupHDone:

	;while ( h>0 ) {
	outsideLP:
		cmp dword[h], 0
		jbe outsideLPDone

		;i=h-1
		mov r9, 0
		mov r9d, dword[h]
		mov dword[i], r9d
		dec dword[i]
		;for (i = h-1; i < length; i++) {
		secondLP:
			;if i >= length leave loop
			cmp dword[i], esi
			jae secondLPDone


			;tmp = lst[i];
			mov r9d, dword[i]
			mov ebx, dword[rdi+r9*4]
			mov dword[tmp], ebx

			;j = i;
			mov dword[j], r9d


			;;for ( j=i; (j >= h) && (lst[j-h] < tmp); j = j-h) {
			thirdLP:
				;if j<h leave loop
				mov r11, 0
				mov r11d, dword[j]
				cmp r11d, dword[h]
				jl thirdLPDone

				;j-h
				
				mov r8, 0
				mov rbx, 0
				mov rax, 0
				mov r8d, dword[j] 
				mov eax, dword[h]
				sub r8d, eax
				mov ebx, dword[tmp]
				;if lst[j-h]>=tmp leave loop
				cmp dword[rdi+r8*4], ebx
				jge thirdLPDone

				;lst[j] = lst[j-h];
				mov r11d, dword[j]
				mov r10, 0
				mov r10d, dword[rdi+r8*4]
				mov dword[rdi+r11*4], r10d

				mov dword[j], r8d
				jmp thirdLP
			;}
			thirdLPDone:
			mov r11, 0
			mov r11d, dword[j]
			;lst[j] = tmp;
			mov r10d, dword[tmp]
			mov dword[rdi+r11*4], r10d

			;i++
			inc dword[i]
			jmp secondLP
		;}
		secondLPDone:
		;h = h / 3;
		mov r12, 0
		mov r12d, 3
		mov eax, dword[h]
		mov edx, 0
		div r12d
		mov dword[h], eax

		jmp outsideLP
	;}
	outsideLPDone:
	
	pop r12
	pop rbp
	pop rbx

ret

; --------------------------------------------------------
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstSum() and lstAvergae() functions
;  to get the corresponding values.

;  Note, assumes the list is already sorted.

; -----
;  Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi
;	3) minimum, addr - rdx
;	4) median, addr - rcx
;	5) maximum, addr - r8
;	6) sum, addr - r9
;	7) ave, addr - stack, rbp+16

;  Returns:
;	minimum, median, maximum, sum, and average
;	via pass-by-reference (addresses on stack)

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
	mov dword[r8], eax

	;min = list[len-1]
	mov r10, 0
	mov r10d, esi
	dec r10
	mov eax, dword[rdi+r10*4]
	mov dword[rdx], eax

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

; --------------------------------------------------------
;  Function to calculate the sum of a list.

; -----
;  Call:
;	ans = lstSum(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

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

; --------------------------------------------------------
;  Function to calculate the average of a list.
;  Note, must call the lstSum() fucntion.

; -----
;  Call:
;	ans = lstAve(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

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

; --------------------------------------------------------
;  Function to calculate the linear regression
;  between two lists (of equal size).
;  Due to the data sizes, the summation for the dividend (top)
;  MUST be performed as a quad-word.

; -----
;  Call:
;	linearRegression(xList, yList, len, xAve, yAve, b0, b1)

;  Arguments Passed:
;	1) xList, address - rdi
;	2) yList, address - rsi
;	3) length, value - edx
;	4) xList average, value - ecx
;	5) yList average, value - r8d
;	6) b0, address - r9
;	7) b1, address - stack, rpb+16

;  Returns:
;	b0 and b1 via reference

global linearRegression
linearRegression:


;	YOUR CODE GOES HERE
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	push 	r12
	push 	r13
	push 	r14

	;len = len
	mov dword[len], edx

	;rTop=0
	mov dword[qSum], 0
	mov dword[dSum], 0
	;i = 0
	mov r12, 0
	;for(i = 0; i < len; i++){
		topLoop:
		cmp r12d, dword[len]
		jge topLoopDone
		;rtop = (xlst[i]-xave)*(ylst[i]-yave)
		;xlst[i]-xave
		mov eax, dword[rdi+r12*4]
		sub eax, ecx
		mov dword[tmpx], eax
		
		;store this value for rBtm
		imul dword[tmpx]
		add dword[dSum], eax
		add dword[dSum+4], edx

		;ylst[i]-yave
		mov rax, 0
		mov eax, dword[rsi+r12*4]
		sub eax, r8d
		mov dword[tmpy], eax

		;multiply them together
		imul dword[tmpx]
		mov dword[tmpTop], eax
		mov dword[tmpTop+4], edx
		mov rax, qword[tmpTop]
		;store in rTop
		add qword[qSum], rax

		inc r12
		jmp topLoop
	;}
	topLoopDone:

	;b1=rTop/rBtm
	mov rax, 0
	mov rdx, 0
	mov rax, qword[qSum]
	cqo
	mov rbx, qword[dSum]
	idiv rbx

	mov rbx, qword[rbp+16]
	mov dword[rbx], eax

	;b0=yave-b1*xave
	;b1*xave
	mov eax, dword[rbx]
	imul eax, ecx
	sub r8d, eax

	mov dword[r9], r8d


	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	ret

; ********************************************************************************
