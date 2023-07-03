;  Name: Alan Reisenauer
;  Description: finding volumes and surface areas of the data sets

; *****************************************************************
;  Data Declarations
;	Note, all data is declared statically (for now).
          
; --------------------------------------------------------------

section	.data

; -----
;  Define constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Provided Data

lengths      dd  1355, 1037, 1123, 1024, 1453
             dd  1115, 1135, 1123, 1123, 1123
             dd  1254, 1454, 1152, 1164, 1542
             dd -1353, 1457, 1182, -1142, 1354
             dd  1364, 1134, 1154, 1344, 1142
             dd  1173, -1543, -1151, 1352, -1434
             dd  1134, 2134, 1156, 1134, 1142
             dd  1267, 1104, 1134, 1246, 1123
             dd  1134, -1161, 1176, 1157, -1142
             dd -1153, 1193, 1184, 1142

widths       dw  367, 316, 542, 240, 677
             dw  635, 426, 820, 146, -333
             dw  317, -115, 226, 140, 565
             dw  871, 614, 218, 313, 422
             dw -119, 215, -525, -712, 441
             dw -622, -731, -729, 615, 724
             dw  217, -224, 580, 147, 324
             dw  425, 816, 262, -718, 192
             dw -432, 235, 764, -615, 310
             dw  765, 954, -967, 515

heights      db  42, 21, 56, 27, 35
             db -27, 82, 65, 55, 35
             db -25, -19, -34, -15, 67
             db  15, 61, 35, 56, 53
             db -32, 35, 64, 15, -10
             db  65, 54, -27, 15, 56
             db  92, -25, 25, 12, 25
             db -17, 98, -77, 75, 34
             db  23, 83, -73, 50, 15
             db  35, 25, 18, 13

count        dd  49
vMin         dd  0
vEstMed      dd  0
vMax         dd  0
vSum         dd  0
vAve         dd  0
saMin        dd  0
saEstMed     dd  0
saMax        dd  0
saSum        dd  0
saAve        dd  0
; --------------------------------------------------------------
; Uninitialized data
section      .bss
volumes      resd 49
surfaceAreas resd 49

; *****************************************************************
;  Code Section

section	.text
global _start
_start:

;******************************************************************
;Finding stats for volumes

    ;Finding the volumes and storing them
    mov     ecx, dword[count]
    mov     rsi, 0
    VLoopStart:
        mov     rax, 0
        mov     al, byte[heights+rsi]
        cbw
        cwde
        mov     ebx, eax
        
        mov     ax, word[widths+rsi*2]
        cwde
        mov     edi, eax
        imul    edi, ebx

        mov     r8d, dword[lengths+rsi*4]
        imul    r8d, edi

        mov     dword[volumes+rsi*4], r8d

        inc rsi
        loop VLoopStart

    ;Finding the minimum of the volumes
    mov eax, dword[volumes]
    mov dword[vMin], eax
    mov rsi, 0
    mov ecx, dword[count]
    minLoopStart:
        mov eax, dword[volumes+rsi*4]
        cmp dword[vMin], eax
        JLE minLoopDone
        mov dword[vMin], eax
    minLoopDone:
        inc rsi
        loop minLoopStart

    ;Finding the max of the volumes
    mov eax, dword[volumes]
    mov dword[vMax], eax
    mov rsi, 0
    mov ecx, dword[count]
    maxLoopStart:
        mov eax, dword[volumes+rsi*4]
        cmp dword[vMax], eax
        JGE maxLoopDone
        mov dword[vMax], eax
    maxLoopDone:
        inc rsi
        loop maxLoopStart

    ;Summing the volumes
    mov rbx, volumes
    mov ecx, dword[count]
    mov eax, 0
    sumLp:
        add eax, dword[rbx]
        add rbx, 4
        dec ecx
        cmp ecx, 0
        JG sumLp
    mov dword[vSum], eax

    ;Taking the volumes average
    mov eax, dword [vSum]
    idiv     dword [count]
    mov      dword [vAve], eax

    ;Estimating the median of the list
    ;(volumes[0]+volumes[length-1]+volumes[length/2])/3
        ;length/2 in rdi
        mov eax, dword[count]
        mov r8d, 2
        mov edx, 0
        div r8d
        mov rdi, 0
        mov edi, eax

        ;calculate lenth-1 in rsi
        mov rsi, 0
        mov esi, dword[count]
        dec rsi

        ;getting the indexed values 
        ;and adding them together
        mov eax, dword[volumes]
        add eax, dword[volumes+rdi*4]
        add eax, dword[volumes+rsi*4]

        ;dividing all of the values by 3
        mov rdx, 0
        mov r11d, 3
        idiv r11d
        mov      dword[vEstMed], eax
; *****************************************************************
;	Onto surface area stats
    ;Finding the surface areas and storing them
    mov     ecx, dword[count]
    mov     rsi, 0
    saLoopStart:
        mov     rax, 0
        mov     al, byte[heights+rsi]
        cbw
        cwde
        mov     ebx, eax
        
        mov     ax, word[widths+rsi*2]
        cwde
        mov     edi, eax
        imul    edi, ebx

        imul    edi, 2

        mov     rax, 0
        mov     al, byte[heights+rsi]
        cbw
        cwde
        mov     ebx, eax
        
        mov     r8d, dword[lengths+rsi*4]
        imul    r8d, ebx

        imul    r8d, 2

        mov     ax, word[widths+rsi*2]
        cwde
        mov     r10d, eax

        mov     r9d, dword[lengths+rsi*4]
        imul    r9d, r10d

        imul    r9d, 2

        add     r8d,  edi
        add     r9d, r8d

        mov     dword[surfaceAreas+rsi*4], r9d

        inc rsi
        loop saLoopStart


;Finding the minimum of the surface area
    mov eax, dword[surfaceAreas]
    mov dword[saMin], eax
    mov rsi, 0
    mov ecx, dword[count]
    saMinLoopStart:
        mov eax, dword[surfaceAreas+rsi*4]
        cmp dword[saMin], eax
        JLE saMinLoopDone
        mov dword[saMin], eax
    saMinLoopDone:
        inc rsi
        loop saMinLoopStart

    ;Finding the max of the surface area
    mov eax, dword[surfaceAreas]
    mov dword[saMax], eax
    mov rsi, 0
    mov ecx, dword[count]
    saMaxLoopStart:
        mov eax, dword[surfaceAreas+rsi*4]
        cmp dword[saMax], eax
        JGE saMaxLoopDone
        mov dword[saMax], eax
    saMaxLoopDone:
        inc rsi
        loop saMaxLoopStart

    ;Summing the surface area
    mov rbx, surfaceAreas
    mov ecx, dword[count]
    mov eax, 0
    saSumLp:
        add eax, dword[rbx]
        add rbx, 4
        dec ecx
        cmp ecx, 0
        JG saSumLp
    mov dword[saSum], eax

    ;Taking the surface areas average
    mov edx, 0
    mov eax, dword [saSum]
    cdq
    idiv     dword [count]
    mov      dword [saAve], eax

    ;Estimating the median of the list
    ;(surfaceAreas[0]+surfaceAreas[length-1]+surfaceAreas[length/2])/3
        ;length/2 in rdi
        mov eax, dword[count]
        mov r8d, 2
        mov edx, 0
        div r8d
        mov rdi, 0
        mov edi, eax

        ;calculate lenth-1 in rsi
        mov rsi, 0
        mov esi, dword[count]
        dec rsi

        ;getting the indexed values 
        ;and adding them together
        mov eax, dword[surfaceAreas]
        add eax, dword[surfaceAreas+rdi*4]
        add eax, dword[surfaceAreas+rsi*4]

        ;dividing all of the values by 3
        mov rdx, 0
        mov r11d, 3
        idiv r11d
        mov      dword[saEstMed], eax


; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall
