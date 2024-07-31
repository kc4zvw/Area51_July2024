;;;
;;; Created by chat-gpt A.I.
;;;

;
;  Build using these commands:
;	nasm -f elf64 -g -F stabs fizzbuzz4.asm
;	ld -o fizzbuzz4 fizzbuzz4.o
;
;  (FreeBSD syscalls/NASM/ELF64)

%macro writestr 2
; Argument 1: char* string to write
; Argument 2: length of string
	mov rax, write			; write %1 to stdout
	mov rdi, stdout
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

; ==============================================================================

sys_exit:	equ	1
exitcode:	equ	0
write:		equ	4
stdout:		equ	1
LF:		equ	10

; ==============================================================================

SECTION .data
	align 8

message:	db "%3d", LF, 0
msg1:		db "Fizz", LF, 0
msg2:		db "Buzz", LF, 0
msg3:		db "FizzBuzz", LF, 0

num2:		dq 1				; long int n = 1;
fmt:		db "%ld", LF, 0			; The printf format, "\n",'0
fmt2:		db "%s", 0			; The printf format, "\n",'0

SECTION .rodata
	fizz: db "Fizz", 10, 0
	lenFizz equ $ - fizz

	buzz: db "Buzz", 10, 0
	lenBuzz equ $ - buzz

	fizzbuzz: db "FizzBuzz", 10, 0
	lenFizzBuzz equ $ - fizzbuzz

SECTION .bss
	num resb 11

SECTION .text
	global main
	extern printf

main:
	mov edx, 1	; counter
	jmp .printNumber

.checkFizz:
	mov edx, [num]
	mov eax, edx
	cdq
	mov ebx, 3
	div ebx
	cmp edx, 0
	jne .notFizz
	mov edx, 3
	jmp .printFizz

.checkBuzz:
	mov edx, [num]
	mov eax, edx
	cdq
	mov ebx, 5
	div ebx
	cmp edx, 0
	jne .notBuzz
	mov edx, 5
	jmp .printBuzz

;.checkFizzBuzz:
	;mov eax, [num]
	;cdq
	;mov ebx, 15
	;div ebx
	;cmp edx, 0
	;jne .notBuzz
	;mov edx, 15
	;jmp .printFizzBuzz

.printFizz:
	push	rbp		; set up stack frame
	mov	rax, msg1	; put "a" from store into register
	mov	rdi, fmt2	; format for printf
	mov	rsi, msg1	; first parameter for printf
	;mov	rdx, rax	; second parameter for printf
	mov	rax, 0		; no xmm registers
	call	printf		; Call C function
	pop	rbp		; restore stack

	;writestr fizz, lenFizz
	jmp .nextNumber

.printBuzz:
	push	rbp		; set up stack frame
	mov	rax, msg2	; put "a" from store into register
	mov	rdi, fmt2	; format for printf
	mov	rsi, msg2	; first parameter for printf
	;mov	rdx, rax	; second parameter for printf
	mov	rax, 0		; no xmm registers
	call	printf		; Call C function
	pop	rbp		; restore stack

	;writestr buzz, lenBuzz
	jmp .nextNumber

.printFizzBuzz:
	push	rbp		; set up stack frame
	mov	rax, msg3	; put "a" from store into register
	;add	rax, 2		; a+2 add constant 2
	mov	rdi, fmt2	; format for printf
	mov	rsi, msg3	; first parameter for printf
	;mov	rdx, rax	; second parameter for printf
	mov	rax, 0		; no xmm registers
	call	printf		; Call C function
	pop	rbp		; restore stack

	;writestr fizzbuzz, lenFizzBuzz
	jmp .nextNumber

.notFizz:
	jmp .printNumber

.notBuzz:
	jmp .printNumber

.notFizzBuzz:
	jmp .printNumber

.printNumber:
	push	rbp		; set up stack frame
	mov	rax, [num]	; put "num" from store into register
	add	rax, 2		; a+2 add constant 2
	mov	rdi, fmt	; format for printf
	mov	rsi, [num]	; first parameter for printf
	;mov	rdx, rax	; second parameter for printf
	mov	rax, 0		; no xmm registers
	call	printf		; Call C function
	pop	rbp		; restore stack

.nextNumber:
	inc edx
	inc byte [num]
	cmp byte [num], 100
	jle .checkFizz

	mov rax, sys_exit	; Code for Exit Syscall
	mov rdi, exitcode	; Return a code of zero
	syscall	; Make kernel call  (int 0x80)


; vim: tabstop=8: nowrap:

; ***** End of File *****
