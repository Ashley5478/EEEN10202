processor 18F8722
radix dec
CONFIG OSC = HS
CONFIG WDT = OFF ;
CONFIG LVP = OFF
#include <xc.inc>


PSECT udata_acs
global switch_value
switch_value: ds 1


PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start ;
PSECT start, class=CODE, reloc=2
start: 
; Setup TRIS I/O before main loop
    movlw 0x0F	; 00001111
    movwf ADCON1, a  ; Set all inputs as digital (see p272 of datasheet)
    setf TRISC, a    ; Set all of TRISC as inputs (although only using RC2:RC5), last four switches
;   movlw 11110000 ; RH4567
;   movwf TRISH	; First four switches
    clrf TRISF, a    ; Set all LEDs as outputs
    bcf  TRISA, 4, a ; Set Q3 as output
;   bsf TRISH, 0
;   bsf TRISH, 1

; Setup initial outputs
    clrf LATF, a      ; Turn off all LEDs
    bsf LATA, 4, a    ; Enable Q3

main:
    movf PORTC, W, a  ;RC2 - RC5 to working register
    movwf switch_value, a	; Working register to custom memory allocation
    rrncf switch_value, F, a	; Rotate switches right RC2345 acting as RC1234
    rrncf switch_value, F, a	; Rotate switches right RC1234 acting as RC0123
    movf  switch_value, W, a	; Back to working register
    andlw 0x0F			; Mask off unused bits (00001111)
    movwf LATF, a
  
    movf PORTH, W, a
    movwf switch_value, a
    movf switch_value, W, a
    andlw 11110000B
  
    movwf LATF, a

    bra main

end