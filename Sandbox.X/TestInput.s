processor 18F8722
radix dec 

CONFIG OSC = HS 
CONFIG WDT = OFF 
CONFIG LVP = OFF 

#include <xc.inc> 

PSECT udata_acs
global LSB_switch, MSB_switch;, TOTAL_switch ; Custom memory allocation
LSB_switch: ds 1    ; 1 byte reservation each
MSB_switch: ds 1
;TOTAL_switch: ds 1

PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start 
PSECT start, class=CODE, reloc=2
start: 
// Setup TRIS I/O before main loop
    movlw 0x0F	    ; Digital Input (00001111)
    movwf ADCON1, a
    
    bcf TRISA, 4, a ; Q3 (LED outputs, RA4)
    clrf TRISF	    ; Binary (Digital outputs, RF01234567)
    movlw 11110000B  ; MSB, Q1 and Q2 (Switche inputs and 7seg display outputs, RH4567 RH01)
    movwf TRISH
    movlw 00111100B  ; LSB, requires RRNCF (rotate right no carry) twice (RC2345)
    movwf TRISC
    
    bsf TRISJ, 5, a ; Right button PB1
    // Initialize latch values
    movlw 00000011B  ; Q1 and Q2 PNP
    movwf LATH
    bcf LATA, 4, a  ; Q3
    clrf LATF	    ; Binary
    
    
    // Illumination
main:
// Button scanner
    /* FOR PB2 (LEFT BUTTON)
    movf PORTB, W, a  ; Read all of PORTB
    andlw 00000001B    ; Mask off unused bits (RB0)
    bz pb2_pressed    ; If pressed go to this label
*/
    movf PORTJ, W, a  ; Read all of PORTJ (Copy port inputs to working register)
    andlw 00100000B    ; mask off unused bits (RJ5)
    bz pb1_pressed	; Go to pb1_pressed if WREG is zero flagged. We used AND gate after reading PORTJ. The PORTJ (RJ5) becomes zero if pressed.
    bnz switch
    // Turn on letter "U" on MSB 7seg display while PB1 pressed
    pb1_pressed:

    movlw 10000101B  ; Letter "U" inverted (BCDEF)
    movwf LATF
    bcf LATH, 1, a  ; Enabling the PNP transistor Q2 (RH1) for MSB 7seg display

	// Transistion
    bsf LATH, 1, a  ; Disabling the PNP transistor for next sequence
    setf LATF	    ; Clearing the output binary for LEDs
    
// Switch scanner
switch:
    // LSB
    movf PORTC, W, a  ;RC2 - RC5 to working register
    movwf LSB_switch, a		; Working register to custom memory allocation
    rrncf LSB_switch, F, a	; Rotate switches right RC2345 acting as RC1234
    rrncf LSB_switch, F, a	; Rotate switches right RC1234 acting as RC0123
    movf  LSB_switch, W, a	; Back to working register
    andlw 0x0F			; Mask off unused bits (00001111)
    movwf LSB_switch, a
    
    // MSB
    movf PORTH, W, a
    movwf MSB_switch, a
    movf MSB_switch, W, a
    andlw 11110000B
    movwf MSB_switch, a
    
    movf LSB_switch, W, a
    iorwf MSB_switch, W, a
    movwf LATF

    bsf LATA, 4, a  ; Enabling the NPN transistor Q3 (RA4) for LEDs

    // Transistion LED --> 7 seg display


    clrf LATF
    bcf LATA, 4, a  ; Disabling the NPN transistor for next sequence
    bra main	    ; Else loop back to main
  
    end