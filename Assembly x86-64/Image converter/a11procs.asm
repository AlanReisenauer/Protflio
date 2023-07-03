; *****************************************************************
;  Name: Alan Reisenauer
;  Description: Read in a large image file, 
;				and reproduce a smaller thumbnail image 

;  CS 218 - Assignment #11
;  Functions Template

; ***********************************************************************
;  Data declarations
;	Note, the error message strings should NOT be changed.
;	All other variables may changed or ignored...

section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string
SPACE		equ	0x20			; space

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

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

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

; -----
;  Define program specific constants.

MIN_FILE_LEN	equ	5

; buffer size (part A) - DO NOT CHANGE THE NEXT LINE.
BUFF_SIZE	equ	750000

; -----
;  Variables for getImageFileName() function.

eof		db	FALSE

usageMsg	db	"Usage: ./makeThumb <inputFile.bmp> "
		db	"<outputFile.bmp>", LF, NULL
errIncomplete	db	"Error, incomplete command line arguments.", LF, NULL
errExtra	db	"Error, too many command line arguments.", LF, NULL
errReadName	db	"Error, invalid source file name.  Must be '.bmp' file.", LF, NULL
errWriteName	db	"Error, invalid output file name.  Must be '.bmp' file.", LF, NULL
errReadFile	db	"Error, unable to open input file.", LF, NULL
errWriteFile	db	"Error, unable to open output file.", LF, NULL

; -----
;  Variables for setImageInfo() function.

HEADER_SIZE	equ	138

errReadHdr	db	"Error, unable to read header from source image file."
		db	LF, NULL
errFileType	db	"Error, invalid file signature.", LF, NULL
errDepth	db	"Error, unsupported color depth.  Must be 24-bit color."
		db	LF, NULL
errCompType	db	"Error, only non-compressed images are supported."
		db	LF, NULL
errSize		db	"Error, bitmap block size inconsistent.", LF, NULL
errWriteHdr	db	"Error, unable to write header to output image file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Variables for readRow() function.

buffMax		dq	BUFF_SIZE
curr		dq	BUFF_SIZE
wasEOF		db	FALSE
pixelCount	dq	0

errRead		db	"Error, reading from source image file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Variables for writeRow() function.

errWrite	db	"Error, writting to output image file.", LF,
		db	"Program terminated.", LF, NULL

; ------------------------------------------------------------------------
;  Unitialized data

section	.bss

buffer		resb	BUFF_SIZE
header		resb	HEADER_SIZE

; ############################################################################

section	.text

; ***************************************************************
;  Routine to get image file names (from command line)
;	Verify files by atemptting to open the files (to make
;	sure they are valid and available).

;  Command Line format:
;	./makeThumb <inputFileName> <outputFileName>

; -----
;  Arguments:
;	RDI - argc (value)
;	RSI - argv table (address)
;	RDX - read file descriptor (address)
;	RCX - write file descriptor (address)
;  Returns:
;	read file descriptor (via reference)
;	write file descriptor (via reference)
;	TRUE or FALSE

global getImageFileNames
getImageFileNames:

;push registers if needed
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	push 	r12
	push 	r13
	push 	r14
	push 	r15

;	YOUR CODE GOES HERE
	mov		r12, rsi
	mov		r13, rdx
	mov		r14, rcx
;check if argc = 1, then usage error message
;check if argc != 3, then error
cmp		rdi, 1
je		errUsgMsg

cmp		rdi, 3
jb		errLowCLCount

cmp		rdi, 3
ja		errHiCLCount

;---------------------------------------
;verify the .bmp file extention at the
;end of each filename string
mov		r15, 0
mov		rbx, qword[rsi+8]
inStringCheck:
mov		al, byte[rbx+r15]
cmp		al, "."
je		inBmpCheck

cmp		al, NULL
je		errInFileExtention

inc 	r15
jmp 	inStringCheck

inBmpCheck:
inc		r15
mov		al, byte[rbx+r15]
cmp		al, "b"
jne		errInFileExtention

inc		r15
mov		al, byte[rbx+r15]
cmp		al, "m"
jne		errInFileExtention

inc		r15
mov		al, byte[rbx+r15]
cmp		al, "p"
jne		errInFileExtention

inc		r15
mov		al, byte[rbx+r15]
cmp		al, NULL
jne		errInFileExtention

;---------------------------------------
;verify the .bmp file extention at the
;end of outfile filename string
mov		r15, 0
mov		rbx, qword[rsi+8*2]
outStringCheck:
mov		al, byte[rbx+r15]
cmp		al, "."
je		outBmpCheck

cmp		al, NULL
je		errOutFileExtension

inc 	r15
jmp 	outStringCheck

outBmpCheck:
inc		r15
mov		al, byte[rbx+r15]
cmp		al, "b"
jne		errOutFileExtension

inc		r15
mov		al, byte[rbx+r15]
cmp		al, "m"
jne		errOutFileExtension

inc		r15
mov		al, byte[rbx+r15]
cmp		al, "p"
jne		errOutFileExtension

inc		r15
mov		al, byte[rbx+r15]
cmp		al, NULL
jne		errOutFileExtension
;-------------------------------------------
;Try to open the read file - argv[1]
mov		rax, SYS_open
mov		rdi, qword[r12+8]
mov		rsi, O_RDONLY
syscall
;if fail to open, send back error
cmp		rax, 0
jl		errInFileOpen
;if success proceede
mov		qword[r13], rax

;Try to open the write file - argv[2]
mov		rax, SYS_creat
mov		rdi, qword[r12+8*2]
mov		rsi, S_IRUSR|S_IWUSR
syscall
;if fail to open, send back error
cmp		rax, 0
jl		errOutFileOpen
;if sucess send to success
mov		qword[r14], rax
jmp		successParam
;-------------------------------------------------
;error messages bank
;-------------------------------------------------

;error message for usageMsg
errUsgMsg:
	mov rdi, usageMsg
	jmp		printIt

;error message for too few command line args
errLowCLCount:
	mov rdi, errIncomplete
	jmp		printIt

;error message for too many comand line args
errHiCLCount:
	mov rdi, errExtra
	jmp		printIt

errInFileOpen:
	mov rdi, errReadFile
	jmp		printIt

errInFileExtention:
	mov rdi, errReadName
	jmp		printIt

errOutFileOpen:
	mov rdi, errWriteFile
	jmp		printIt

errOutFileExtension:
	mov rdi, errWriteName
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

; ***************************************************************
;  Read, verify, and set header information

;  HLL Call:
;	bool = setImageInfo(readFileDesc, writeFileDesc,
;		&picWidth, &picHeight, thumbWidth, thumbHeight)

;  If correct, also modifies header information and writes modified
;  header information to output file (i.e., thumbnail file).

; -----
;  2 -> BM						(+0)
;  4 file size					(+2)
;  4 skip						(+6)
;  4 header size				(+10)
;  4 skip						(+14)
;  4 width						(+18)
;  4 height						(+22)
;  2 skip						(+26)
;  2 depth (16/24/32)			(+28)
;  4 compression method code	(+30)
;  4 bytes of pixel data		(+34)
;  skip remaing header entries

; -----
;   Arguments:
;	RDI - read file descriptor (value)
;	RSI - write file descriptor (value)
;	RDX - old image width (address)
;	RCX - old image height (address)
;	R8  - new image width (value)
;	R9  - new image height (value)

;  Returns:
;	old image width (via reference)
;	old image height (via reference)
;	TRUE or FALSE

global setImageInfo
setImageInfo:

;push registers if needed
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	push 	r12
	push 	r13
	push 	r14
	push 	r15

	mov		rbx, rdi
	mov		r12, rsi
	mov		r13, rdx
	mov		r14, rcx

;	YOUR CODE GOES HERE
	mov		rax, SYS_read
	mov		rdi, rbx
	mov		rsi, header
	mov		rdx, HEADER_SIZE
	syscall

;check if reading is good
	cmp		rax, 0
	jl		errorReadHeader

;verify the file type
	mov		ax,	word[header]
	cmp		ax,	0x4d42
	jne		fileTypeError

;verify the color depth
	mov		ax, word[header+28]
	cmp		ax, 24
	jne		depthError

;verify the compression type
	mov		eax, dword[header+30]
	cmp		eax, 0
	jne		compTypeError

;calculate the size
	mov		eax, dword[header+18]
	mul		dword[header+22]
	imul	eax, 3
	add 	eax, HEADER_SIZE

;verify the size
	mov		ecx, dword[header+2]
	cmp		eax, ecx
	jne		sizeError

;return the old file height and width
	mov		eax, dword[header+18]
	mov		dword[r13], eax
	mov		eax, dword[header+22]
	mov		dword[r14], eax

;overwrite the height
	mov		dword[header+18], r8d
	
;overwrite the width
	mov		dword[header+22], r9d

;overwrite the fileSize
	mov		eax, r8d
	mul		r9d
	imul	eax, 3
	add 	eax, HEADER_SIZE
	mov		dword[header+2], eax

;write to update header to write file
	mov		rax, SYS_write
	mov		rdi, r12
	mov		rsi, header
	mov		rdx, HEADER_SIZE
	syscall

;check if reading is good
	cmp		rax, 0
	jl		errorWriteHeader

;all succeedes then success
	jmp	successSetInfo

errorReadHeader:
	mov rdi, errReadHdr
	jmp		printError1

errorWriteHeader:
	mov rdi, errWriteHdr
	jmp		printError1

fileTypeError:
	mov	rdi, errFileType
	jmp		 printError1

sizeError:
	mov	rdi, errSize
	jmp		 printError1

depthError:
	mov	rdi, errDepth
	jmp		 printError1

compTypeError:
	mov	rdi, errCompType
	jmp		 printError1

;returns sucess and leaves function
successSetInfo:
	mov		rax, TRUE
	jmp		exitSetInfo

;prints the error message and goes to exit
printError1:
	call	printString
	mov 	rax, FALSE


exitSetInfo:
;pop registers if needed
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp

ret

; ***************************************************************
;  Return a row from read buffer
;	This routine performs all buffer management

; ----
;  HLL Call:
;	bool = readRow(readFileDesc, picWidth, rowBuffer[]);

;   Arguments:
;	RDI - read file descriptor (value)
;	RSI- image width (value)
;	RDX- row buffer (address)
;  Returns:
;	RAX - TRUE or FALSE

; -----
;  This routine returns TRUE when row has been returned
;	and returns FALSE if there is no more data to
;	return (i.e., all data has been read) or if there
;	is an error on read (which would not normally occur).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.

;buffMax = current buffer maximum
;curr = current buffer index
;wasEOF = FALSE
;pixelCount = actual read
;buffer

global readRow
readRow:

;push registers if needed
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	push 	r12
	push 	r13
	push 	r14
	push 	r15

;i = 0
mov	r12, 0
mov	r13, rdi
mov	r14, rsi
mov	r15, rdx

getNextByte:

;if(curr >= buffMax){
mov	r9, 0
mov	r9, qword[curr]
cmp r9, qword[buffMax]
jb copying

mov qword[curr], 0	
;	if(wasEOF)
mov	r9b, byte[wasEOF]
cmp	r9b, TRUE
jne readFile

;	return FALSE
mov rax, FALSE
jmp	exitRead

;	read file (BUFFERSIZE bytes)
	mov rax, 0
readFile:
	mov rax, SYS_read
	mov rdi, r13
	mov rsi, buffer
	mov	rdx, qword[buffMax]
	syscall

	mov	qword[pixelCount], rax

;	if(read error)
readError:
	cmp rax, 0 
	jg pixels
	mov	rdi, errRead
	call printString
	mov rax, FALSE
	jmp	exitRead
;	if(pixelCount < buffMax)
pixels:
	mov	r9, 0
	mov	r9, pixelCount
	cmp	r9, buffMax
    jae	copying

;		eof = TRUE
	mov r9, 0
	mov r9b, TRUE
	mov	byte[wasEOF], r9b

	mov r9, 0
;		buffMax = pixelCount
	mov	r9, qword[pixelCount]
	mov qword[buffMax], r9

;cur = 0}

copying:
;chr = buffer[curr]
mov r9, 0
mov r9, qword[curr]
mov r8b, byte[buffer+r9]
inc r9
mov	qword[curr], r9

;rowBuff[i] = chr
mov	byte[r15+r12], r8b
;i++
inc r12

;if (i< picWidth*3)
mov	rax, r14
imul rax, 3
cmp r12, rax
jb getNextByte

successRead:
mov rax, TRUE

exitRead:
;pop registers if needed
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp

ret

; ***************************************************************
;  Write image row to output file.
;	Writes exactly (width*3) bytes to file.
;	No requirement to buffer here.

; -----
;  HLL Call:
;	bool = writeRow(writeFileDesc, picWidth, rowBuffer);

;  Arguments are:
;	RDI - write file descriptor (value)
;	RSI - image width (value)
;	RDX - row buffer (address)

;  Returns:
;	N/A

; -----
;  This routine returns TRUE when row has been written
;	and returns FALSE only if there is an
;	error on write (which would not normally occur).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.


;	YOUR CODE GOES HERE

global writeRow
writeRow:

;push registers if needed
	push 	rbp
	mov 	rbp, rsp
	push 	rbx
	push 	r12
	push 	r13
	push 	r14
	push 	r15

	mov	r13, rdi
	mov	r14, rsi
	mov r15, rdx

;mulitply image width by 3
	mov	r8, 3
	mov rax, r14
	mul r8
	mov	r14, rax
;write to file
	mov rax, SYS_write
	mov rdi, r13
	mov rsi, r15
	mov	rdx, r14
	syscall
;if it fails display error 
;message and return false

writeFail:
	cmp rax, 0 
	jg successWrite
	mov	rdi, errWrite
	call printString
	mov rax, FALSE
	jmp	exitWrite

successWrite:
mov rax, TRUE

exitWrite:
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

