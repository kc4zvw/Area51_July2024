;
; Copyright (c) 2021 David Billsbrough
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions
; are met:
; 1. Redistributions of source code must retain the above copyright
;    notice, this list of conditions and the following disclaimer.
; 2. Redistributions in binary form must reproduce the above copyright
;    notice, this list of conditions and the following disclaimer in the
;    documentation and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
; SUCH DAMAGE.
;
;  $Id: fizzbuzz.asm,v 0.35 2021/04/23 04:15:17 kc4zvw Exp kc4zvw $
;
; FILE: fizzbuzz.asm

; Author: David Billsbrough
; influenced by Matt_Giuca version of Feb '07
; Revised: Monday, September 18, 2017 at 09:42:39 AM (EDT)
; another weird fizzbuzz example
;
; =====
; Uh, someone ordered an 86_64 assembly version?

;  (FreeBSD syscalls/NASM/ELF64)

%macro writestr 2
; Argument 1: char* string to write
; Argument 2: length of string
	mov	rax, write                      ; write %1 to stdout
	mov	rdi, stdout
	mov	rsi, %1
	mov	rdx, %2
	syscall
%endmacro

; ========================================================================

section .data

; ========================================================================

section .rodata

FIZZ	db	"Fizz", 0
LENF	equ	4
BUZZ	db	"Buzz", 0
LENB	equ	4
NL	db	10

; ========================================================================

section .bss

index:	resb 1
char:	resb 1
tmp:	resb 1

; ========================================================================

section .text

global _start

_start:

write:		equ	4		; FreeBSD syscall for write
stdout:		equ	1		; standard output file handle
sysexit:	equ	1		; FreeBSD syscall for exit
maxnum:		equ	100		; count to where?

	mov byte [index], 1
forloop:
	cmp byte [index], maxnum
	jbe not_exit
	jmp exit
not_exit:

	; if (i % 3 == 0)
	mov al, [index]
	xor ah, ah
	mov cl, 3
	div cl
	test ah, ah
	jnz trybuzz
	writestr FIZZ, LENF

	; if (i % 5 == 0)
	mov al, [index]
	mov cl, 5
	div cl
	test ah, ah
	jnz not_buzz
	writestr BUZZ, LENB

not_buzz:
	jmp continue
trybuzz:
	; if (i % 5 == 0)
	mov al, [index]
	xor ah, ah
	mov cl, 5
	div cl
	test ah, ah
	jnz printnum

	writestr BUZZ, LENB 
	jmp continue
printnum:
	; Write the number i
	mov al, [index]
	xor ah, ah
	cmp al, 100
	jl tens
	mov cl, 100
	div cl ; ah = al % 100
	add al, '0'
	mov [char], al
	mov [tmp], ah
	writestr char, 1
	mov al, [tmp]
	xor ah, ah
tens:
	mov al, [index]
	cmp al, 10
	jl ones
	mov cl, 10
	div cl ; ah = al % 10
	add al, '0'
	mov [char], al
	mov [tmp], ah
	writestr char, 1
	mov al, [tmp]
	xor ah, ah
ones:
	add al, '0'
	mov [char], al
	writestr char, 1
continue:
	writestr NL, 1
	inc byte [index]
	jmp forloop

exit:
	mov	rax, sysexit		; exit program
	xor	rdi, rdi		; set a zero exit code (I think)
        syscall

; vim: ts=8: nowrap:

; OH my God, that took two ages!!
