#
# Copyright (c) 2024 David Billsbrough
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
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
# FILE: helloworld.asm
#

.file "helloworld.asm"

.section .data

	.equ	NULL, 0

hello:
	.ascii "Hello World!\n"
	.byte NULL

break:	.ascii "\n"

num1:	.quad 5
num2:	.quad 10
num3:	.quad 20
num4:	.quad 7
result:	.quad

buffer:	.space 3


.section .text

.global _start

_start:
	call print_hello		# calls the function to print the string
	call display_num
	call display_num2
	jmp exit

print_hello:

	mov $4, %rax			# syscall: sys_write
	mov $1, %rdi			# file descriptor: stdout
	mov $hello, %rsi		# string address
	mov $13, %rdx			# string length
	syscall				# calls the kernel
	ret				# returns to _start

display_num:

	mov num1(%rip), %rax		# load num1 into rax
	add num2(%rip), %rax		# add num2 to rax
	mov %rax, result(%rip)		# stores the result

	# Code to print the result
	mov result(%rip), %rax		# load the result into rax
	mov $buffer + 2, %rsi		# points to the end of the buffer (2 digits)

        # Code to print the result
        mov result(%rip), %rax          # load the result into rax
        mov $buffer + 2, %rsi           # points to the end of the buffer (2 digits)

	call int_to_string		# convert number to string

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

	ret

display_num2:

	mov num3(%rip), %rax		# load num1 into rax
	add num4(%rip), %rax		# add num2 to rax
	mov %rax, result(%rip)		# stores the result

	# Code to print the result
	mov result(%rip), %rax		# load the result into rax
	mov $buffer + 2, %rsi		# points to the end of the buffer (2 digits)

	call int_to_string		# convert number to string

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

	ret

int_to_string:
	# Convert %rax to decimal string and store it in %rsi
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

	ret				# returns to _start

exit:
	mov $1, %rax			# syscall: sys_exit
	xor %rdi, %rdi			# exit status: 0
	syscall				# calls the kernel

.end	_start


# vim: syntax=asm ts=8 nowrap:

# ***** End of file *****
