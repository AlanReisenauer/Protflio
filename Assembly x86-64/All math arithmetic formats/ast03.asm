; *****************************************************************
;  Name: Alan Reisenauer
;  Description: Series of calcuations based on fixerd variables



; -----

;  Focus on learning basic arithmetic operations
;  (add, subtract, multiply, and divide).
;  Ensure understanding of signed and unsigned operations.

; *****************************************************************
;  Data Declarations (provided).

section	.data
; -----
;  Define standard constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Assignment #3 data declarations

; byte data declarations
bNum1		db	11
bNum2		db	15
bNum3		db	26
bNum4		db	37
bNum5		db	33
bNum6		db	-17
bNum7		db	-29
bNum8		db	-40
bAns1		db	0
bAns2		db	0
bAns3		db	0
bAns4		db	0
bAns5		db	0
bAns6		db	0
bAns7		db	0
bAns8		db	0
bAns9		db	0
bAns10		db	0
wAns11		dw	0
wAns12		dw	0
wAns13		dw	0
wAns14		dw	0
wAns15		dw	0
bAns16		db	0
bAns17		db	0
bAns18		db	0
bRem18		db	0
bAns19		db	0
bAns20		db	0
bAns21		db	0
bRem21		db	0

; word data declarations
wNum1		dw	229
wNum2		dw	467
wNum3		dw	1738
wNum4		dw	2210
wNum5		dw	375
wNum6		dw	-234
wNum7		dw	-361
wNum8		dw	-418
wAns1		dw	0
wAns2		dw	0
wAns3		dw	0
wAns4		dw	0
wAns5		dw	0
wAns6		dw	0
wAns7		dw	0
wAns8		dw	0
wAns9		dw	0
wAns10		dw	0
dAns11		dd	0
dAns12		dd	0
dAns13		dd	0
dAns14		dd	0
dAns15		dd	0
wAns16		dw	0
wAns17		dw	0
wAns18		dw	0
wRem18		dw	0
wAns19		dw	0
wAns20		dw	0
wAns21		dw	0
wRem21		dw	0

; double-word data declarations
dNum1		dd	136789
dNum2		dd	31342
dNum3		dd	1815
dNum4		dd	61569
dNum5		dd	42617
dNum6		dd	-1345
dNum7		dd	-2733
dNum8		dd	-4256
dAns1		dd	0
dAns2		dd	0
dAns3		dd	0
dAns4		dd	0
dAns5		dd	0
dAns6		dd	0
dAns7		dd	0
dAns8		dd	0
dAns9		dd	0
dAns10		dd	0
qAns11		dq	0
qAns12		dq	0
qAns13		dq	0
qAns14		dq	0
qAns15		dq	0
dAns16		dd	0
dAns17		dd	0
dAns18		dd	0
dRem18		dd	0
dAns19		dd	0
dAns20		dd	0
dAns21		dd	0
dRem21		dd	0

; quadword data declarations
qNum1		dq	246793
qNum2		dq	115732
qNum3		dq	1526241
qNum4		dq	254879
qNum5		dq	317517
qNum6		dq	-222147
qNum7		dq	-216517
qNum8		dq	-445758
qAns1		dq	0
qAns2		dq	0
qAns3		dq	0
qAns4		dq	0
qAns5		dq	0
qAns6		dq	0
qAns7		dq	0
qAns8		dq	0
qAns9		dq	0
qAns10		dq	0
dqAns11		ddq	0
dqAns12		ddq	0
dqAns13		ddq	0
dqAns14		ddq	0
dqAns15		ddq	0
qAns16		dq	0
qAns17		dq	0
qAns18		dq	0
qRem18		dq	0
qAns19		dq	0
qAns20		dq	0
qAns21		dq	0
qRem21		dq	0

; *****************************************************************

section	.text
global _start
_start:

; ********************************************
; Byte Operations

; unsigned byte additions
;	bAns1  = bNum1 + bNum2
;	bAns2  = bNum1 + bNum3
;	bAns3  = bNum3 + bNum4

  mov   al, byte [bNum1]
  add   al, byte [bNum2]
  mov   byte [bAns1], al

  mov   al, byte [bNum1]
  add   al, byte [bNum3]
  mov   byte [bAns2], al

  mov   al, byte [bNum3]
  add   al, byte [bNum4]
  mov   byte [bAns3], al

; -----
; signed byte additions
;	bAns4  = bNum5 + bNum6
;	bAns5  = bNum5 + bNum1

  mov   al, byte [bNum5]
  add   al, byte [bNum6]
  mov   byte [bAns4], al

  mov   al, byte [bNum5]
  add   al, byte [bNum1]
  mov   byte [bAns5], al
  
; -----
; unsigned byte subtractions
;	bAns6  = bNum1 - bNum2
;	bAns7  = bNum2 - bNum4
;	bAns8  = bNum4 - bNum3

  mov   al, byte [bNum1]
  sub   al, byte [bNum2]
  mov   byte [bAns6], al

  mov   al, byte [bNum2]
  sub   al, byte [bNum4]
  mov   byte [bAns7], al

  mov   al, byte [bNum4]
  sub   al, byte [bNum3]
  mov   byte [bAns8], al

; -----
; signed byte subtraction
;	bAns9  = bNum5 - bNum3
;	bAns10 = bNum6 - bNum2

  mov   al, byte [bNum5]
  sub   al, byte [bNum3]
  mov   byte [bAns9], al

  mov   al, byte [bNum6]
  sub   al, byte [bNum2]
  mov   byte [bAns10], al

; -----
; unsigned byte multiplication
;	wAns11 = bNum2 * bNum3
;	wAns12 = bNum3 * bNum4
;	wAns13 = bNum1 * bNum4

  mov al, byte [bNum2]
  mul     byte [bNum3]
  mov     word [wAns11], ax

  mov al, byte [bNum3]
  mul     byte [bNum4]
  mov     word [wAns12], ax

  mov al, byte [bNum1]
  mul     byte [bNum4]
  mov     word [wAns13], ax

; -----
; signed byte multiplication
;	wAns14 = bNum5 * bNum3
;	wAns15 = bNum5 * bNum6

  mov   al, byte [bNum5]
  imul      byte [bNum3]
  mov       word [wAns14], ax

  mov   al, byte [bNum5]
  imul      byte [bNum6]
  mov       word [wAns15], ax

; -----
; unsigned byte division
;	bAns16 = bNum1 / bNum4
;	bAns17 = bNum2 / bNum3
;	bAns18 = wAns13 / bNum2
;	bRem18 = wAns13 % bNum2

  mov al, byte [bNum1]
  mov ah, 0
  div     byte [bNum4]
  mov     byte [bAns16], al

  mov al, byte [bNum2]
  mov ah, 0
  div     byte [bNum3]
  mov     byte [bAns17], al

  mov al, byte [wAns13]
  mov ah, byte [wAns13+1]
  div     byte [bNum2]
  mov     byte [bAns18], al
  mov     byte [bRem18], ah

; -----
; signed byte division
;	bAns19 = bNum6 / bNum2
;	bAns20 = bNum6 / bNum4
;	bAns21 = wAns14 / bNum2
;	bRem21 = wAns14 % bNum2

  mov al, byte [bNum6]
  cbw
  idiv    byte [bNum2]
  mov     byte [bAns19], al

  mov al, byte [bNum6]
  cbw
  idiv    byte [bNum4]
  mov     byte [bAns20], al

  mov al, byte [wAns14]
  mov ah, byte [wAns14+1]
  idiv    byte [bNum2]
  mov     byte [bAns21], al
  mov     byte [bRem21], ah


; ********************************************
; Word Operations	

; unsigned word additions
;	wAns1  = wNum1 + wNum2
;	wAns2  = wNum1 + wNum3
;	wAns3  = wNum3 + wNum4

  mov ax, word [wNum1]
  add ax, word [wNum2]
  mov word [wAns1], ax

  mov ax, word [wNum1]
  add ax, word [wNum3]
  mov word [wAns2], ax

  mov ax, word [wNum3]
  add ax, word [wNum4]
  mov word [wAns3], ax

; -----
; signed word additions
;	wAns4  = wNum5 + wNum6
;	wAns5  = wNum5 + wNum3

  mov ax, word [wNum5]
  add ax, word [wNum6]
  mov word [wAns4], ax

  mov ax, word [wNum5]
  add ax, word [wNum3]
  mov word [wAns5], ax

; -----
; unsigned word subtractions
;	wAns6  = wNum2 - wNum1
;	wAns7  = wNum4 - wNum2
;	wAns8  = wNum1 - wNum3

  mov ax, word [wNum2]
  sub ax, word [wNum1]
  mov word [wAns6], ax

  mov ax, word [wNum4]
  sub ax, word [wNum2]
  mov word [wAns7], ax

  mov ax, word [wNum1]
  sub ax, word [wNum3]
  mov word [wAns8], ax

; -----
; signed word subtraction
;	wAns9  = wNum5 - wNum6
;	wAns10 = wNum5 - wNum3

  mov ax, word [wNum5]
  sub ax, word [wNum6]
  mov word [wAns9], ax

  mov ax, word [wNum5]
  sub ax, word [wNum3]
  mov word [wAns10], ax

; -----
; unsigned word multiplication
;	dAns11 = wNum1 * wNum3
;	dAns12 = wNum3 * wNum4
;	dAns13 = wNum2 * wNum3

  mov ax, word [wNum1]
  mul     word [wNum3]
  mov     word [dAns11], ax
  mov     word [dAns11+2], dx

  mov ax, word [wNum3]
  mul     word [wNum4]
  mov     word [dAns12], ax
  mov     word [dAns12+2], dx

  mov ax, word [wNum2]
  mul     word [wNum3]
  mov     word [dAns13], ax
  mov     word [dAns13+2], dx

; -----
; signed word multiplication
;	dAns14  = wNum5 * wNum6
;	dAns15  = wNum6 * wNum1

  mov   ax, word [wNum5]
  imul      word [wNum6]
  mov       word [dAns14], ax
  mov       word [dAns14+2], dx

  mov   ax, word [wNum6]
  imul      word [wNum1]
  mov       word [dAns15], ax
  mov       word [dAns15+2], dx

; -----
; unsigned word division
;	wAns16 = wNum2 / wNum3
;	wAns17 = wNum4 / wNum1
;	wAns18 = dAns13 / wNum1
;	wRem18 = dAns13 % wNum1

  mov ax, word [wNum2]
  mov dx, 0
  div     word [wNum3]
  mov     word [wAns16], ax


  mov ax, word [wNum4]
  mov dx, 0
  div     word [wNum1]
  mov     word [wAns17], ax

  mov ax, word [dAns13]
  mov dx, word [dAns13+2]
  div     word [wNum1]
  mov     word [wAns18], ax
  mov     word [wRem18], dx

; -----
; signed word division
;	wAns19 = wNum5 / wNum1
;	wAns20 = wNum5 / wNum3
;	wAns21 = dAns14 / wNum1
;	wRem21 = dAns14 % wNum1

  mov ax, word [wNum5]
  cwd
  idiv    word [wNum1]
  mov     word [wAns19], ax

  mov ax, word [wNum5]
  cwd
  idiv    word [wNum3]
  mov     word [wAns20], ax

  mov ax, word [dAns14]
  mov dx, word [dAns14+2]
  idiv    word [wNum1]
  mov     word [wAns21], ax
  mov     word [wRem21], dx


; ********************************************
; Double-Word Operations

; unsigned double word additions
;	dAns1  = dNum2 + dNum3
;	dAns2  = dNum3 + dNum4
;	dAns3  = dNum2 + dNum4

  mov eax, dword [dNum2]
  add eax, dword [dNum3]
  mov dword [dAns1], eax

  mov eax, dword [dNum3]
  add eax, dword [dNum4]
  mov dword [dAns2], eax

  mov eax, dword [dNum2]
  add eax, dword [dNum4]
  mov dword [dAns3], eax

; -----
; signed double word additions
;	dAns4  = dNum5 + dNum6
;	dAns5  = dNum5 + dNum2

  mov eax, dword [dNum5]
  add eax, dword [dNum6]
  mov dword [dAns4], eax

  mov eax, dword [dNum5]
  add eax, dword [dNum2]
  mov dword [dAns5], eax

; -----
; unsigned double word subtractions
;	dAns6  = dNum1 - dNum4
;	dAns7  = dNum4 - dNum3
;	dAns8  = dNum3 - dNum2

  mov eax, dword [dNum1]
  sub eax, dword [dNum4]
  mov dword [dAns6], eax

  mov eax, dword [dNum4]
  sub eax, dword [dNum3]
  mov dword [dAns7], eax

  mov eax, dword [dNum3]
  sub eax, dword [dNum2]
  mov dword [dAns8], eax

; -----
; signed double word subtraction
;	dAns9  = dNum5 - dNum6
;	dAns10 = dNum5 - dNum2

  mov eax, dword [dNum5]
  sub eax, dword [dNum6]
  mov dword [dAns9], eax

  mov eax, dword [dNum5]
  sub eax, dword [dNum2]
  mov dword [dAns10], eax

; -----
; unsigned double word multiplication
;	qAns11  = dNum2 * dNum2
;	qAns12  = dNum1 * dNum2
;	qAns13  = dNum2 * dNum4

  mov eax, dword [dNum2]
  mul      dword [dNum2]
  mov      dword [qAns11], eax
  mov      dword [qAns11+4], edx

  mov eax, dword [dNum1]
  mul      dword [dNum2]
  mov      dword [qAns12], eax
  mov      dword [qAns12+4], edx

  mov eax, dword [dNum2]
  mul      dword [dNum4]
  mov      dword [qAns13], eax
  mov      dword [qAns13+4], edx

; -----
; signed double word multiplication
;	qAns14  = dNum5 * dNum6
;	qAns15  = dNum5 * dNum2

  mov   eax, dword [dNum5]
  imul       dword [dNum6]
  mov        qword [qAns14], rax

  mov   eax, dword [dNum5]
  imul       dword [dNum2]
  mov        qword [qAns15], rax

; -----
; unsigned double word division
;	dAns16 = dNum1 / dNum4
;	dAns17 = dNum3 / dNum2
;	dAns18 = qAns13 / dNum2
;	dRem18 = modulus (qAns13 / dNum2)

  mov eax, dword [dNum1]
  mov edx, 0
  div      dword [dNum4]
  mov      dword [dAns16], eax

  mov eax, dword [dNum3]
  mov edx, 0
  div      dword [dNum2]
  mov      dword [dAns17], eax

  mov eax, dword [qAns13]
  mov edx, dword [qAns13+4]
  div      dword [dNum2]
  mov      dword [dAns18], eax
  mov      dword [dRem18+4], edx

; -----
; signed double word division
;	dAns19 = dNum5 / dNum2 
;	dAns20 = dNum5 / dNum6
;	dAns21 = qAns15 / dNum4
;	dRem21 = qAns15 % dNum4

  mov eax, dword [dNum5]
  cdq
  idiv     dword [dNum2]
  mov      dword [dAns19], eax

  mov eax, dword [dNum5]
  cdq
  idiv     dword [dNum6]
  mov      dword [dAns20], eax

  mov eax, dword [qAns15]
  cdq
  idiv     dword [dNum4]
  mov      dword [dAns21], eax
  mov      dword [dRem21], edx



; ***************************************** 
; QuadWord Operations

; unsigned quadword additions 
;	qAns1  = qNum1 + qNum2 
;	qAns2  = qNum3 + qNum2 
;	qAns3  = qNum3 + qNum1

  mov rax, qword [qNum1]
  add rax, qword [qNum2]
  mov qword [qAns1], rax

  mov rax, qword [qNum3]
  add rax, qword [qNum2]
  mov qword [qAns2], rax

  mov rax, qword [qNum3]
  add rax, qword [qNum1]
  mov qword [qAns3], rax

; ----- 
; signed quadword additions 
;	qAns4  = qNum6 + qNum7 
;	qAns5  = qNum5 + qNum8 

  mov rax, qword [qNum6]
  add rax, qword [qNum7]
  mov qword [qAns4], rax

  mov rax, qword [qNum5]
  add rax, qword [qNum8]
  mov qword [qAns5], rax

; ----- 
; unsigned quadword subtractions 
;	qAns6  = qNum3 - qNum1 
;	qAns7  = qNum4 - qNum2 
;	qAns8  = qNum4 - qNum1 

  mov rax, qword [qNum3]
  sub rax, qword [qNum1]
  mov qword [qAns6], rax

  mov rax, qword [qNum4]
  sub rax, qword [qNum2]
  mov qword [qAns7], rax

  mov rax, qword [qNum4]
  sub rax, qword [qNum1]
  mov qword [qAns8], rax

; ----- 
; signed quadword subtraction 
;	qAns9  = qNum7 - qNum6 
;	qAns10 = qNum8 - qNum7 

  mov rax, qword [qNum7]
  sub rax, qword [qNum6]
  mov qword [qAns9], rax

  mov rax, qword [qNum8]
  sub rax, qword [qNum7]
  mov qword [qAns10], rax

; ----- 
; unsigned quadword multiplication 
;	dqAns11  = qNum4 * qNum3 
;	dqAns12  = qNum3 * qNum4 
;	dqAns13  = qNum2 * qNum2 

  mov rax, qword [qNum4]
  mul      qword [qNum3]
  mov      qword [dqAns11], rax
  mov      qword [dqAns11+8], rdx

  mov rax, qword [qNum3]
  mul      qword [qNum4]
  mov      qword [dqAns12], rax
  mov      qword [dqAns12+8], rdx

  mov rax, qword [qNum2]
  mul      qword [qNum2]
  mov      qword [dqAns13], rax
  mov      qword [dqAns13+8], rdx

; ----- 
; signed quadword multiplication 
;	dqAns14  = qNum6 * qNum7 
;	dqAns15  = qNum5 * qNum8 

  mov   rax, qword [qNum6]
  imul       qword [qNum7]
  mov        qword [dqAns14], rax
  mov        qword [dqAns14+8], rdx

  mov   rax, qword [qNum5]
  imul       qword [qNum8]
  mov        qword [dqAns15], rax
  mov        qword [dqAns15+8], rdx

; ----- 
; unsigned quadword division 
;	qAns16 = qNum3 / qNum1 
;	qAns17 = qNum4 / qNum3
;	qAns18 = dqAns11 / qNum3 
;	qRem18 = dqAns11 % qNum3 

  mov rax, qword [qNum3]
  mov rdx, 0
  div      qword [qNum1]
  mov      qword [qAns16], rax

  mov rax, qword [qNum4]
  mov rdx, 0
  div      qword [qNum3]
  mov      qword [qAns17], rax

  mov rax, qword [dqAns11]
  mov rdx, qword [dqAns11+8]
  div      qword [qNum3]
  mov      qword [qAns18], rax
  mov      qword [qRem18+8], rdx


; ----- 
; signed quadword division 
;	qAns19 = qNum5 / qNum6
;	qAns20 = qNum8 / qNum7
;	qAns21 = dqAns12 / qNum8
;	qRem21 = dqAns12 % qNum8

  mov rax, qword [qNum5]
  cqo
  idiv     qword [qNum6]
  mov      qword [qAns19], rax

  mov rax, qword [qNum8]
  cqo
  idiv     qword [qNum7]
  mov      qword [qAns20], rax

  mov rax, qword [dqAns12]
  mov rdx, qword [dqAns12+8]
  idiv     qword [qNum8]
  mov      qword [qAns21], rax
  mov      qword [qRem21], rdx

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall
