/*
Handbook practical exam Q2 Version D
    read an 8-bit unsigned integer value m from the 8 toggle switches,
    illuminate LED LD5 if m is in the range 18...36 (inclusive)
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

PSECT udata_acs
global LSB, switches
LSB: ds 1
switches: ds 1
    
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start ; On reset, jump to our program start location  
    
; Our program start point
PSECT start, class=CODE, reloc=2
start:
// Initialize TRIS values and other constants
    movlw 15
    movwf ADCON1, a
    
    clrf TRISF, a
    bcf TRISA, 4, a
    movlw 00111100B
    movwf TRISC, a
    movlw 11110000B
    movwf TRISH, a
    
    clrf LATF, a
    
    bsf LATH, 0, a
    bsf LATH, 1, a
    
    bsf LATA, 4, a
    
// Switch reader
    loop:
    ; LSB
    movf PORTC, W, a
    movwf LSB, a
    rrncf LSB, F, a
    rrncf LSB, W, a
    andlw 00001111B
    movwf LSB, a
    
    ; MSB
    movf PORTH, W, a
    andlw 11110000B
    iorwf LSB, W, a
    
    movwf switches, a
    
    
    // Comparator (18 <= switches <= 36, unsigned)
    // Accepts binary between 00010010 and 00100100
    addlw -37	// 11011011
    bz loop
    bnc Lessthan37
    bra loop
    
    Lessthan37:
    movf switches, W, a
    addlw -17
    bz loop
    bnc loop
    
    Morethan17:
    bsf LATF, 4, a  // LD5
    nop
    nop
    nop
    nop
    bcf LATF, 4, a
    
    bra loop ; endless loop
    end