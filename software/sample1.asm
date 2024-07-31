#
# Copyright (c) 2024 David Billsbrough
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
#  $Id:$
#
# FILE: sample1.asm
#
# Author: David Billsbrough
# Revised: Friday, July 26, 2024 at 19:53:52 PM (EDT)
# another weird example
#
# =====
# Uh, someone ordered an 86_64 assembly version?

.file "sample1.asm"
.code64

#  (FreeBSD syscalls/VASM/ELF64)

.nolist

.macro writestr buffer, len
# Argument 1: char* string to write
# Argument 2: length of string
	mov $4, %rax			# write %1 to stdout
	mov $1, %rdi
	mov \buffer, %rsi
	mov $5, %rdx
	syscall
.endm

# ========================================================================

.data

	.set	NULL, 0			# NULL character (0x00)
	.set	LF, 10			# Linefeed character (0x0A)

break:	.ascii "\n"			# to skip/break a line
result:	.quad 0				# reserves space for the result
buffer: .space 2			# space for number string (2 digits)

maxnum:	.quad 100


# ========================================================================


FIZZ:	.ascii	"Fizz"
	.byte LF
LENF:	.size FIZZ, 5			# length of the FIZZ char string

BUZZ:	.ascii	"Buzz"
	.byte LF
LENB:	.size BUZZ, 5			# length of the BUZZ char string

# ========================================================================

.bss

index:	.quad 0
char:	.byte 0
tmp:	.byte 0

# ========================================================================

.list
.text

.global _start

_start:
	.equ	stdout, 1		# standard output file handle
	.equ	MaxNum, 10		# count to where?

	mov $1, %rax
	mov %rax, index(%rbp)
forloop:
	mov index(%rbp), %rdx
	cmp %rdx, maxnum
	jge not_exit
	jmp exit
not_exit:

	# if (i % 3 == 0)
	mov index(%rbp), %al
	xor %ah, %ah
	mov $3, %cl
	div %cl
	test %ah, %ah
	jnz trybuzz
	# writestr FIZZ, LENF
	mov $4, %rax			# syscall: sys_write
	mov $1, %rdi			# file descriptor: stdout
	mov $FIZZ, %rsi			# break address
	mov $5, %rdx			# break length(1 digit)
	syscall				# calls the kernel
	jmp continue

trybuzz:

	# if (i % 5 == 0)
	mov index(%rbp), %al
	xor %ah, %ah
	mov $5, %cl
	div %cl
	test %ah, %ah
	jnz trynumber
	# writestr FIZZ, LENF
	mov $4, %rax			# syscall: sys_write
	mov $1, %rdi			# file descriptor: stdout
	mov $BUZZ, %rsi			# break address
	mov $5, %rdx			# break length(1 digit)
	syscall				# calls the kernel
	jmp continue

trynumber:

	mov %rdx, result(%rip)

	# Code to print the result
	mov result(%rip), %rax		# load the result into rax
	mov $buffer + 2, %rsi		# points to the end of the buffer (2 digits)

	call int_to_string

	mov $4, %rax			# syscall: sys_write
	mov $1, %rdi			# file descriptor: stdout
	lea buffer(%rip), %rsi		# string address
	mov $2, %rdx			# maximum string length (2 digits)
	syscall				# calls the kernel

	mov $4, %rax			# syscall: sys_write
	mov $1, %rdi			# file descriptor: stdout
	mov $break, %rsi		# break address
	mov $1, %rdx			# break length(1 digit)
	syscall				# calls the kernel


continue:
	incq index(%rbp)
	jmp forloop

int_to_string:
	# convert %rax to decimal string and store it in %rsi
	mov %rax, %rcx			# copy number to rcx
	mov $10, %rbx			# decimal base
	
convert_loop:
	xor %rdx, %rdx			# clear rdx (dividend)
	div %rbx			# divide rax by 10
	add $'0', %dl			# converts the rest to ASCII characters
	dec %rsi			# move buffer pointer backward
	mov %dl, (%rsi)			# stores the character in the buffer
	test %rax, %rax			# checks if rax is 0
	jnz convert_loop		# if not 0, continue the loop
	ret

exit:
	mov	$1, %rax		# exit program
	xor	%rdi, %rdi		# set a zero exit code (I think)
	syscall

	.end	_start



# vim: syntax=asm ts=8 nowrap:

# ***** End of File *****
