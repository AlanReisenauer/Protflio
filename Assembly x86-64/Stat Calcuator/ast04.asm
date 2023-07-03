;  Name: Alan Reisenauer
;  Description: Finds the Median, average, max, min, and sum of the data

; *****************************************************************
;  Data Declarations
;	Note, all data is declared statically (for now).
          
section	.data

; -----
;  Standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

;***********************************
; Declaring the list of data
lst     dd 4224, 1116, 1542, 1240, 1677, 1635, 2420, 1820, 1246, 1333
        dd 2315, 1215, 2726, 1140, 2565, 2871, 1614, 2418, 2513, 1422
        dd 1119, 1215, 1525, 1712, 1441, 3622, 1731, 1729, 1615, 2724
        dd 1217, 1224, 1580, 1147, 2324, 1425, 1816, 1262, 2718, 1192
        dd 1435, 1235, 2764, 1615, 1310, 1765, 1954, 1967, 1515, 1556
        dd 1342, 7321, 1556, 2727, 1227, 1927, 1382, 1465, 3955, 1435
        dd 1225, 2419, 2534, 1345, 2467, 1615, 1959, 1335, 2856, 2553
        dd 1035, 1833, 1464, 1915, 1810, 1465, 1554, 1267, 1615, 1656
        dd 2192, 1825, 1925, 2312, 1725, 2517, 1498, 1677, 1475, 2034
        dd 1223, 1883, 1173, 1350, 2415, 1335, 1125, 1118, 1713, 3025

;needed declared length of list for calcuations
length  dd 100

;calcution variables that will store the variables
lstMin  dd 0
estMed  dd 0
lstMax  dd 0
lstSum  dd 0
lstAve  dd 0

;more calcuation variables but only for the odds
oddCnt  dd 0
oddSum  dd 0
oddAve  dd 0

;more calcuation variables but only for numbers evenly diveded by 9
nineCnt dd 0
nineSum dd 0
nineAve dd 0

;place holder variables
oddDivRem  dd 0
nineDivAns dd 0
nineDivRem dd 0
one        dd 1
oddAns     dd 0

; *****************************************************************
;  Code Section

section	.text
global _start
_start:

;*******************************************************************
;Finding general list stats

    ;Finding the minimum of the list
    mov eax, dword[lst]
    mov dword[lstMin], eax
    mov rsi, 0
    mov ecx, dword[length]
    minLoopStart:
        mov eax, dword[lst+rsi*4]
        cmp dword[lstMin], eax
        Jbe minLoopDone
        mov dword[lstMin], eax
    minLoopDone:
        inc rsi
        loop minLoopStart

    ;Estimating the median of the list
    ;(lst[0]+lst[length-1]+lst[length/2]+lst[length/2-1])/4
        ;length/2 in rdi
        mov eax, dword[length]
        mov r8d, 2
        mov edx, 0
        div r8d
        mov rdi, 0
        mov edi, eax

        ;length/2-1 in r9d
        mov r9, rdi
        dec r9

        ;calculate lenth-1 in rsi
        mov rsi, 0
        mov esi, dword[length]
        dec rsi

        ;getting the indexed values 
        ;and adding them together
        mov eax, dword[lst]
        add eax, dword[lst+rdi*4]
        add eax, dword[lst+r9*4]
        add eax, dword[lst+rsi*4]

        mov rdx, 0
        mov r11d, 4
        div r11d
        mov      dword[estMed], eax


    ;Finding the maximum of the list
    mov eax, dword[lst]
    mov dword[lstMax], eax
    mov rsi, 0
    mov ecx, dword[length]
    maxLoopStart:
        mov eax, dword[lst+rsi*4]
        cmp eax, dword[lstMax]
        Jbe maxLoopDone
        mov dword[lstMax], eax
    maxLoopDone:
        inc rsi
        loop maxLoopStart

    ;Summing the list
    mov rbx, lst
    mov ecx, dword[length]
    mov eax, 0
    sumLp:
        add eax, dword[rbx]
        add rbx, 4
        dec ecx
        cmp ecx, 0
        ja sumLp
    mov dword[lstSum], eax

    ;Taking the list average
    mov eax, dword [lstSum]
    mov edx, 0
    div      dword [length]
    mov      dword [lstAve], eax

;*******************************************************************
;Finding odd list stats

    ;Finding the count of odds in the list 
    ;as taking the sum in the loop,
    ;and then taking the average afterwards
    mov eax, dword[lst]
    mov ecx, dword[length]
    inc ecx
    mov esi, 0
    mov ebx, 0
    mov edi, 2
    mov ebp, dword[lst]
    mov esp, 0
    
    top:
        dec ecx
        mov eax, dword[lst+ebx*4]
        mov edx, 0
        div      edi
        mov      dword[oddAns], eax
        mov      dword[oddDivRem], edx
        
        inc ebx

        cmp ecx, 0
        je endLoop

        cmp edx, 0
        je  top



    oddAdding:
        dec ebx
        add esp, dword[lst+ebx*4]
        inc ebx
        
        inc esi
        cmp ecx, 0
        jne top
    endLoop:
    mov dword[oddCnt], esi
    mov dword[oddSum], esp

    ;take the average of the sum
    mov eax, dword [oddSum]
    mov edx, 0
    div      dword [oddCnt]
    mov      dword [oddAve], eax

;*******************************************************************
;Finding nines list stats

    ;Finding the count of nines in the list 
    ;as taking the sum in the loop,
    ;and then taking the average afterwards
    mov eax, dword[lst]
    mov ecx, dword[length]
    inc ecx
    mov esi, 0
    mov ebx, 0
    mov edi, 9
    mov ebp, dword[lst]
    mov esp, 0
    
    ninetop:
        dec ecx
        mov eax, dword[lst+ebx*4]
        mov edx, 0
        div      edi
        mov      dword[nineDivAns], eax
        mov      dword[nineDivRem], edx
        
        inc ebx

        cmp ecx, 0
        je nineendLoop

        cmp edx, 0
        jne  ninetop

    nineAdding:
        dec ebx
        add esp, dword[lst+ebx*4]
        inc ebx
        
        inc esi
        cmp ecx, 0
        jne ninetop
    nineendLoop:
    mov dword[nineCnt], esi
    mov dword[nineSum], esp

    ;take the average of the sum
    mov eax, dword [nineSum]
    mov edx, 0
    div      dword [nineCnt]
    mov      dword [nineAve], eax

; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall
