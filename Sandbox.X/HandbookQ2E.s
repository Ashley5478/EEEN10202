/*
Handbook practical exam Q2 Version E
    read the states of pushbuttons PB1 and PB2,
    if only one of the pushbuttons is pressed, then display the symbol ?1? on the 7-segment display U1,
    if both pushbuttons are pressed then display the symbol ?2? on the 7-segment display U1,
    otherwise, 7-segment display U1 should display the symbol ?0?
*/
; Program to move 3 values to 3 memory
; Add the global options "-Wl,-presetVector=0h, -Wl,-pstart=200h" in MPLAB before building this

processor 18F8722
radix   dec ; use decimal numbers
    
CONFIG  OSC = HS  ; use the high speed external crystal on the PCB
CONFIG  WDT = OFF ; turn off the watchdog timer
CONFIG  LVP = OFF ; turn off low voltage mode

;Include useful processor-specific definitions
#include <xc.inc>      

    
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start ; On reset, jump to our program start location  
    
PSECT udata_acs
global numbercode
numbercode: ds 1

; Our program start point
PSECT start, class=CODE, reloc=2
start:
// Initialize TRIS values and other constants
    movlw 15
    movwf ADCON1, a
    
    clrf TRISF, a
    
    bsf TRISB, 0, a
    bsf TRISJ, 5, a
    
    clrf TRISH, a
    bcf LATH, 0, a
    bsf LATH, 1, a
    
    bcf TRISA, 4, a
    bcf LATA, 4, a
    
    
loop:
    // Button scanner
    setf LATF, a
    movlw 00000001B
    clrf numbercode, a
    // Left button PB2 (RB0)
    btfss PORTB, 0, a
    addwf numbercode, f, a
    
    // Right button PB1 (RJ5)
    btfss PORTJ, 5, a
    addwf numbercode, f, a
    
    // Numbercode comparator
    ; 1 button
    one:
    movf numbercode, w, a
    addlw -1
    bnz both
    movlw 11110101B
    movwf LATF, a
    
    both:
    movf numbercode, w, a
    addlw -2
    bnz loop
    movlw 01001100B
    movwf LATF, a
    
    bra loop ; endless loop
    end