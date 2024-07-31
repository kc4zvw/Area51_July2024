;
; Assemble and link with:
;	nasm -f elf printf-test.asm && cc -m32 -o printf-test printf-test.o
;
;  $Id:$

SECTION .data
	align 8

message:	db " %3d", 10, 0
msg1:		db "Fizz", 10, 0
msg2:		db "Buzz", 10, 0
msg3:		db "FizzBuzz", 10, 0

n:	dq	1				; long int n = 1;
fmt:	db	"num = %ld", 10, 0		; The printf format, "\n",'0


SECTION .text
	global main
	extern printf

	;align 8
main:
	push	rbp		; set up stack frame

	mov	rax, [n]	; put "a" from store into register
	add	rax, 2		; a+2 add constant 2
	mov	rdi, fmt	; format for printf
	mov	rsi, [n]	; first parameter for printf
	;mov	rdx, rax	; second parameter for printf
	mov	rax, 0		; no xmm registers
	call	printf		; Call C function

	pop	rbp		; restore stack

	inc	byte [n]

	mov	rax, [n]	; put "a" from store into register
	cmp	byte [n], 100
	jle	main

	;jmp	main
quit:
	mov	rax, 0		; normal, no error, return value
	ret			; return
	
; vim: tabstop=8: nowrap:

; ***** End of file ******
