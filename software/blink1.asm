;
;
;
;
;

list p=16f84a

#include <p16f84a.inc>

COUNT1 equ 08h
COUNT2 equ 09h

	org 0x00
	goto start

start:
	bsf STATUS, RP0                 ;Bank 1
	movlw 0xFE
	movwf TRISB                     ;Set all PORTB input except for RB0
	bcf STATUS, RP0                 ;Bank 0

main:
	bsf PORTB, 0                    ;Make RB0 high
	call delay                      ;Delay subroutine
	bcf PORTB, 0                    ;Make RB0 low
	goto main

delay:
loop1:
	decfsz COUNT1, 1                ;Decrement COUNT1 variable until zero
	goto loop1
	decfsz COUNT2, 1                ;Decrement COUNT2, if not zero, go back to loop1
	goto loop1
	return

	end

