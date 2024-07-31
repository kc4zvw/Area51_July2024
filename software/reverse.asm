
;
; initialized data
;

section .data

	Sys_Write	equ 4
	stdout		equ 1
	Sys_Exit	equ 1
	ExitCode	equ 0

	newline		db 0x0a
	input1		db "Alpha Bravo Charlie"
	len1		db $-input1

	input2		db "Delta Echo Foxtrot"
	len2		db $-input2

	input3		db "Golf Hotel India"
	input4		db "Mike November Oscar!"
	input		db "Hello world!"
	len		db $-input

;
;  non initialized data
;

section .bss

	output	resb 1

;
;  code
;
section .text

	global	_start

;
;  main routine
;

_start:

	mov	rsi, input
	xor	rcx, rcx
	
	cld
	mov	rdi, byte [$], len
	call	calculateStrLength
	xor	rax, rax
	xor	rdi, rdi
	
	call	reverseStr

	mov	rsi, input1
	xor	rcx, rcx
	
	cld
	mov	rdi, byte [$], len1
	call	calculateStrLength
	xor	rax, rax
	xor	rdi, rdi
	
	call	reverseStr

	mov	rsi, input2
	xor	rcx, rcx
	
	cld
	mov	rdi, len2
	call	calculateStrLength
	xor	rax, rax
	xor	rdi, rdi
	
	call	reverseStr

	jmp	exit


;
;  calculate length of string
;

calculateStrLength:
	;; check is it end of string

	cmp	byte [rsi], 0
	je	exitFromRoutine
	lodsb
	push	rax
	inc	rcx

	jmp	calculateStrLength

;
;  back to _start
;

exitFromRoutine:
	; push return address to stack again

	push	rdi
	ret

;
;  reverse string
;
;  31 in stack

reverseStr:
	;; check is it end of string

	cmp	rcx, 0
	je	printResult
	pop	rax
	mov	[output + rdi], rax
	dec	rcx
	inc	rdi

	jmp	reverseStr

;
;  Print result string
;

printResult:
	mov	rdx, rdi
	mov	rax, Sys_Write
	mov	rdi, stdout
	mov	rsi, output
	syscall
	call	printNewLine
	ret

;
;  Print new line
;

printNewLine:
	mov	rax, Sys_Write
	mov	rdi, stdout
	mov	rsi, newline
	mov	rdx, 1
	syscall

	ret

;
;  Exit from program
;

exit:
	mov	rax, Sys_Exit
	mov	rdi, ExitCode
	syscall

; vim: syntax=asm ts=8 nowrap:

; ***** End of File *****
