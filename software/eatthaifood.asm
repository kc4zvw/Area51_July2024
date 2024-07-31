;
;  Executable: EATTHAIFOOD.ASM
;  Version: 1.0
;  Created date: Friday, July 05, 2019 at 17:54:43 PM (EDT)
;  Last update: Wednesday, August 10, 2022 at 22:06:45 PM (EDT)
;  Author: David Billsbrough
;
; $Id:$
;
;  Description	: A simple program in assembly for FreeBSD, using NASM 2.15,
;	demonstrating the use of INT 80H syscalls to display text.
;
;  Build using these commands:
;	nasm -f elf64 -g -F stabs eatsyscall.asm
;	ld -o eatsyscall eatsyscall.o
;

section .data			; Section containing initialised data

NULL		equ		0
LF		equ		10

message:	db		"Eat more chicken!", LF
msglen:		equ		$-message
message2:	db		"Eat more Thai food in Longwood!", LF
len:		equ		$-message2	

sys_exit	equ	1
sys_write	equ	4

stdin		equ	0	; standard input file handle
stdout		equ	1	; standard output file handle

section .text			; Section containing code

global _start			; Linker needs this to find the entry point!

_start:
	mov		rax, sys_write
	mov		rdi, stdout
	mov		rsi, message2
	mov		rdx, len
	syscall

	mov		rax, sys_exit 
	xor		rdi, rdi
	syscall


;; End of File
