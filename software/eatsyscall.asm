;  Executable	: EATSYSCALL
;  Version	: 1.0
;  Created date	: 1/7/2009
;  Last update	: 2/18/2009
;  Author	: Jeff Duntemann
;  Description	: A simple program in assembly for Linux, using NASM 2.05,
;	demonstrating the use of Linux INT 80H syscalls to display text.
;
;  Build using these commands:
;	nasm -f elf64 -g -F stabs eatsyscall.asm
;	ld -o eatsyscall eatsyscall.o
;

;  (FreeBSD syscalls/NASM/ELF64)

%macro writestr 2
; Argument 1: char* string to write
; Argument 2: length of string
        mov     rax, write                      ; write %1 to stdout
        mov     rdi, stdout
        mov     rsi, %1
        mov     rdx, %2
        syscall
%endmacro

; ==============================================================================

SECTION .data

LF:	db	10                      ; Linefeed character (0x0A)

; =============================================================================

sys_write:	equ	4
sys_exit:	equ	1
stdout:		equ	1
exitcode:	equ	0
linefeed:	equ	10                      ; Linefeed character (0x0A)

SECTION .rodata					; Section containing initialised data
	
	EatMsg: db "Eat at Joe's Diner!", linefeed
	EatLen: equ $-EatMsg	
	
SECTION .bss					; Section containing uninitialized data	

SECTION .text					; Section containing code

	global 	_start				; Linker needs this to find the entry point!
	
_start:
	nop					; This no-op keeps gdb happy...
	mov rax, sys_write			; Specify sys_write call
	mov rdi, stdout				; Specify File Descriptor 1: Standard Output
	mov rsi, EatMsg				; Pass offset of the message
	mov rdx, EatLen				; Pass the length of the message
	syscall					; Make kernel call  (int 0x80)

	mov rax, sys_exit			; Code for Exit Syscall
	mov rbx, exitcode			; Return a code of zero	
	syscall					; Make kernel call  (int 0x80)

; vim: tabstop=8: nowrap:

; ***** End of Source File *****
