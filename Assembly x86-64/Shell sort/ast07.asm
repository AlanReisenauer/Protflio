; *****************************************************************
;  Name: Alan Reisenauer
;  Description:	Sort a list of number using the shell sort
;		algorithm.  Also finds the minimum, median, 
;		maximum, and average of the list.

; -----
; Shell Sort

;	h = 1;
;       while ( (h*3+1) < a.length) {
;	    h = 3 * h + 1;
;	}

;       while( h > 0 ) {
;           for (i = h-1; i < a.length; i++) {
;               tmp = a[i];
;               j = i;
;               for( j = i; (j >= h) && (a[j-h] > B); j -= h) {
;                   a[j] = a[j-h];
;               }
;               a[j] = tmp;
;           }
;           h = h / 3;
;       }

; =====================================================================
;  Macro to convert integer to septenary value in ASCII format.
;  Reads <integer>, converts to ASCII/septenary string including
;	NULL into <string>

;  Note, the macro is calling using RSI, so the macro itself should
;	 NOT use the RSI register until is saved elsewhere.

;  Arguments:
;	%1 -> <integer>, value
;	%2 -> <string>, string address

;  Macro usgae
;	int2aSept	<integer-value>, <string-address>

;  Example usage:
;	int2aSept	dword [diamsArrays+rsi*4], tempString

;  For example, to get value into a local register:
;		mov	eax, %1

%macro	int2aSept	2


;	ensureing registers are set properly
		mov rax, 0
		mov eax, %1
		mov r10, 0
		mov r11d, 7
		mov r8, %2
		mov rbx, "+"
		mov rdi, 0
		mov rdx, 0

	;divides by 7 unitl ans = 0
	;stores remainder into stack
	cmp %1, 0
	JGE %%divideLoop
	neg eax

	%%divideLoop:
		div r11d
		push rdx
		inc r10

		mov rdx, 0
		cmp eax, 0
		jne %%divideLoop
		
	;adding the spaces that are needed to 
	;go before the sign
		mov r9, 0
		mov r9, STR_LENGTH
		dec r9
		dec r9
		sub r9, r10
	%%Spaces:
		mov byte[r8+rdi], " "
		inc rdi

		dec r9
		cmp r9, 0
		JG %%Spaces

	;if + then move on, if negative change symbol
		mov eax, %1
		cmp	eax, 0
		JGE %%sign
		mov rbx, "-"
	;adding the sign to the string
	%%sign:
		mov byte[r8+rdi], bl
		inc rdi

	;moves stack into string
	%%popLoop:
		pop rax

		add al, "0"

		mov byte[r8+rdi], al
		inc rdi
		
		dec r10
		cmp r10,0
		jne %%popLoop
		mov byte[r8+rdi], NULL


%endmacro


; =====================================================================
;  Simple macro to display a string to the console.
;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

;  Macro usage:
;	printString  <stringAddr>

;  Arguments:
;	%1 -> <stringAddr>, string address

%macro	printString	1
	push	rax			; save altered registers (cautionary)
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	lea	rdi, [%1]		; get address
	mov	rdx, 0			; character count
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	lea	rsi, [%1]		; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================
;  Data Declarations.

section	.data

; -----
;  Define constants.

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
NULL		equ	0
ESC		equ	27

; -----
;  Provided data

lst	dd	1113, 1232, 2146, 1376, 5120, 2356,  164, 4565, 155, 3157
	dd	 759, 326,  171,  147, 5628, 7527, 7569,  177, 6785, 3514
	dd	1001,  128, 1133, 1105,  327,  101,  115, 1108,    1,  115
	dd	1227, 1226, 5129,  117,  107,  105,  109,  999,  150,  414
	dd	 107, 6103,  245, 6440, 1465, 2311,  254, 4528, 1913, 6722
	dd	1149,  126, 5671, 4647,  628,  327, 2390,  177, 8275,  614
	dd	3121,  415,  615,  122, 7217,    1,  410, 1129,  812, 2134
	dd	 221, 2234,  151,  432,  114, 1629,  114,  522, 2413,  131
	dd	5639,  126, 1162,  441,  127,  877,  199,  679, 1101, 3414
	dd	2101,  133, 1133, 2450,  532, 8619,  115, 1618, 9999,  115
	dd	 219, 3116,  612,  217,  127, 6787, 4569,  679,  675, 4314
	dd	1104,  825, 1184, 2143, 1176,  134, 4626,  100, 4566,  346
	dd	1214, 6786,  617,  183,  512, 7881, 8320, 3467,  559, 1190
	dd	 103,  112,    1, 2186,  191,   86,  134, 1125, 5675,  476
	dd	5527, 1344, 1130, 2172,  224, 7525,  100,    1,  100, 1134   
	dd	 181,  155, 1145,  132,  167,  185,  150,  149,  182,  434
	dd	 581,  625, 6315,    1,  617,  855, 6737,  129, 4512,    1
	dd	 177,  164,  160, 1172,  184,  175,  166, 6762,  158, 4572
	dd	6561,  283, 1133, 1150,  135, 5631, 8185,  178, 1197,  185
	dd	 649, 6366, 1162,  167,  167,  177,  169, 1177,  175, 1169

len	dd	200

min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0


; -----
;  Misc. data definitions (if any).

h		dd	0
i		dd	0
j		dd	0
tmp		dd	0
hold	dd	0

; -----
;  Provided string definitions.

STR_LENGTH	equ	12			; chars in string, with NULL

newLine		db	LF, NULL

hdr		db	"---------------------------"
		db	"---------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #7", ESC, "[0m"
		db	LF, "Shell Sort", LF, LF, NULL

hdrMin		db	"Minimum:  ", NULL
hdrMed		db	"Median:   ", NULL
hdrMax		db	"Maximum:  ", NULL
hdrSum		db	"Sum:      ", NULL
hdrAve		db	"Average:  ", NULL

; ---------------------------------------------

section .bss

tmpString	resb	STR_LENGTH

; ---------------------------------------------

section	.text
global	_start
_start:

; ******************************
;  Shell Sort.
;  Find sum and compute the average.
;  Get/save min and max.
;  Find median.

;Shell Sort
;h = 1;
mov dword[h], 1
mov eax, dword[h]
mov r12d, 3
;while ( (h*3+1) < length ) {
setupH:
	cmp eax, dword[len]
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
	dec r9
	;for (i = h-1; i < length; i++) {
	secondLP:
		;if i >= length leave loop
		cmp r9d, dword[len]
		jae secondLPDone


		;tmp = lst[i];
		mov ebx, dword[lst+r9*4]
		mov dword[tmp], ebx

		;j = i;
		mov dword[j], r9d


		;;for ( j=i; (j >= h) && (lst[j-h] >tmp); j = j-h) {
		thirdLP:
			;if j<h leave loop
			mov r11, 0
			mov r11d, dword[j]
			cmp r11d, dword[h]
			jb thirdLPDone
			
			mov rbx, 0
			;j-h
			mov r8, 0
			mov rbx, 0
			mov r12, 0
			mov r12d, dword[h]
			mov r8d, r11d
			sub r8d, r12d
			mov ebx, dword[tmp]
			;if lst[j-h]=<tmp leave loop
			cmp dword[lst+r8*4], ebx
			jbe thirdLPDone

			;lst[j] = lst[j-h];
			mov r11d, dword[j]
			mov r10, 0
			mov r10d, dword[lst+r8*4]
			mov dword[lst+r11*4], r10d

			mov dword[j], r8d
			jmp thirdLP
		;}
		thirdLPDone:
		mov r11, 0
		mov r11d, dword[j]
		;lst[j] = tmp;
		mov r10d, dword[tmp]
		mov dword[lst+r11*4], r10d

		;i++
		inc r9
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

;Finding the sum
    mov rbx, lst
    mov ecx, dword[len]
    mov eax, 0
    sumLp:
        add eax, dword[rbx]
        add rbx, 4
        dec ecx
        cmp ecx, 0
        JG sumLp
    mov dword[sum], eax

;Computing the average
	mov rax, 0
	mov rdx, 0
    mov eax, dword [sum]
    div      dword [len]
    mov      dword [avg], eax

;Get the Min
    mov eax, dword[lst]
    mov dword[min], eax
    mov rsi, 0
    mov ecx, dword[len]
    minLoopStart:
        mov eax, dword[lst+rsi*4]
        cmp dword[min], eax
        JLE minLoopDone
        mov dword[min], eax
    minLoopDone:
        inc rsi
        loop minLoopStart

;Get the Max
    mov eax, dword[lst]
    mov dword[max], eax
    mov rsi, 0
    mov ecx, dword[len]
    maxLoopStart:
        mov eax, dword[lst+rsi*4]
        cmp dword[max], eax
        JGE maxLoopDone
        mov dword[max], eax
    maxLoopDone:
        inc rsi
        loop maxLoopStart
;Find the median
    ;getting the indexed values 
    ;and adding them together
    mov eax, dword[lst+100*4]
    mov ebx, dword[lst+99*4]
	add eax, ebx
    ;dividing all of the values by 3
    mov rdx, 0
    mov r11d, 2
    div r11d
    mov dword[med], eax

; ******************************
;  Display results to screen in septenary.

	printString	hdr

	printString	hdrMin
	int2aSept	dword [min], tmpString
	printString	tmpString
	printString	newLine

	printString	hdrMed
	int2aSept	dword [med], tmpString
	printString	tmpString
	printString	newLine

	printString	hdrMax
	int2aSept	dword [max], tmpString
	printString	tmpString
	printString	newLine

	printString	hdrSum
	int2aSept	dword [sum], tmpString
	printString	tmpString
	printString	newLine

	printString	hdrAve
	int2aSept	dword [avg], tmpString
	printString	tmpString
	printString	newLine
	printString	newLine

; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall

