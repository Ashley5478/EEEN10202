processor 18F8722
radix dec

CONFIG OSC = HS
CONFIG WDT = OFF
CONFIG LVP = OFF

#include <xc.inc>

PSECT udata_acs
global DelayLoopCount; Custom memory allocation
DelayLoopCount: ds 1    ; 1 byte reservation each

PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start
PSECT start, class=CODE, reloc=2
start:
// Setup TRIS I/O before main loop
    movlw 0x0F	    ; Digital Input (00001111)
    movwf ADCON1, a
    
    bcf TRISA, 4, a ; Q3 (LED outputs, RA4)
    clrf TRISF, a	    ; Binary (Digital outputs, RF01234567)
    movlw 11110000B ; MSB, Q1 and Q2 (Switche inputs and 7seg display outputs, RH4567 RH01)
    movwf TRISH, a
    movlw 00111100B ; LSB, requires RRNCF (rotate right no carry) twice (RC2345)
    movwf TRISC, a
    
    bsf TRISJ, 5, a ; Right button PB1
    bsf TRISB, 0, a ; Left button PB2
    // Initialize all relevant latch values
    
    movlw 00000011B  ; Q1 and Q2 PNP (7 segment display driver) disable
    movwf LATH, a
    
    clrf LATF, a	    ; Binary all zero
    
    bsf LATA, 4, a  ; Q3 (LED driver) enable
    
    // Illumination

    bcf LATA, 0, a  ; Disabling the NPN transistor (Q3, RA4) for next sequence
    setf LATH, a	    ; Clearing all the binary for 7 segment display

// Switch scanner
    // For the four right switches, the PORTH values are 4 - 7.
switch:
    movf PORTC, W, a ;RC2 - RC5 to working register
;    movf PORTH, W, a ;RH4 - RH7 to working register
    ANDLW 00000100B  ; Only reads the RC2 (Rightmost switch)
    bz switch	    ; Back to switch if zero flag is active (No switch input)

// Adder
counter:
// Button scanner
    button_loop:
//     FOR PB2 (LEFT BUTTON)
    movf PORTB, W, a	; Read all of PORTB
    andlw 00000001B	; Mask off unused bits (RB0)
    bz pb2_pressed	; If pressed go to this label
/*
    movf PORTJ, W, a	; Read all of PORTJ (Copy port inputs to working register)
    andlw 00100000B	; mask off unused bits (RJ5)
    bz pb1_pressed	; Go to pb1_pressed if WREG is zero flagged. We used AND gate after reading PORTJ. The PORTJ (RJ5) becomes zero if pressed.
    bnz switch
    */
    // Stop the iteration while the button is pressed
    pb2_pressed:
    btfss PORTB, 0, a	// Skip the next line if the button is released. (Buttons have inverted binary unlike switches)
    goto pb2_pressed
    
    // Main iteration
    
    movf LATF, W, a
    addlw 00000001B
    bz ended
    movwf LATF, a   
    
    movlw 255
    movwf DelayLoopCount, b	; Length of time for a delay
    
    call delayer
    
    bra counter

delayer:
    
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    
    decf DelayLoopCount, b
    bnz delayer
    return

ended:
    bra ended
    
    end