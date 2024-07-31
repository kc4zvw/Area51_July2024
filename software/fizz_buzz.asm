;;;
;;; Created by AI
;;;


section .data
	fizz db 'Fizz', 0
	buzz db 'Buzz', 0
	fizzbuzz db 'FizzBuzz', 0

	lenFizz equ $ - fizz
	lenBuzz equ $ - buzz
	lenFizzBuzz equ $ - fizzbuzz

section .bss
	num resb 11

section .rodata

section .text
	global _start

_start:
	mov edx, 1   ; counter
	jmp .printNumber

.checkFizz:
	mov eax, edx
	cdq
	mov ebx, 3
	div ebx
	cmp edx, 0
	jne .notFizz
	mov edx, 3
	jmp .printFizz

.checkBuzz:
	mov eax, edx
	cdq
	mov ebx, 5
	div ebx
	cmp edx, 0
	jne .notBuzz
	mov edx, 5
	jmp .printBuzz

.printFizz:
	mov eax, 4   ; sys_write
	mov ebx, 1   ; stdout
	mov ecx, fizz
	mov edx, lenFizz
	int 0x80
	jmp .nextNumber

.printBuzz:
	mov eax, 4   ; sys_write
	mov ebx, 1   ; stdout
	mov ecx, buzz
	mov edx, lenBuzz
	int 0x80
	jmp .nextNumber

.printFizzBuzz:
	mov eax, 4   ; sys_write
	mov ebx, 1   ; stdout
	mov ecx, fizzbuzz
	mov edx, lenFizzBuzz
	int 0x80
	jmp .nextNumber

.notFizz:
	mov eax, edx
	cdq
	mov ebx, 5
	div ebx
	cmp edx, 0
	jne .notFizzBuzz
	jmp .printFizzBuzz

.notBuzz:
	jmp .printNumber

.notFizzBuzz:
	jmp .printNumber

.printNumber:
	mov eax, 1   ; sys_write
	mov ebx, 1   ; stdout
	mov ecx, num
	mov edx, 1
	int 0x80

.nextNumber:
	;inc num
	inc byte [num]
	cmp byte [num], '9'
	jle .checkFizz
	mov eax, 4   ; sys_write
	mov ebx, 1   ; stdout
	mov ecx, num
	mov edx, 1
	int 0x80
	mov eax, 4   ; sys_write
	mov ebx, 1   ; stdout
	mov ecx, 10  ; line feed
	mov edx, 1
	int 0x80
	mov byte [num], '1'
	inc edx
	jmp .checkFizz 

; vim: tabstop=8: nowrap:

; ***** End of File *****
