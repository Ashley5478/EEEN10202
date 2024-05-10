/*
Mock question 2 option 2
    Read a 4-bit unsigned value x from the four left-most toggle switches SW0[7:4]
    Read a 4-bit unsigned value y from the four right-most toggle switches SW0[3:0]
    All displays should be off except when x > y
    When x > y, flash the right-most LED (LD1) at 1 Hz (500 ms on, 500 ms off).
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
global LSB, MSB, delaydec1, delaydec2
LSB: ds 1
MSB: ds 1
delaydec1: ds 1
delaydec2: ds 1

; Our program start point
PSECT start, class=CODE, reloc=2
start:
// Initialize TRIS values and other constants
    movlw 15
    movwf ADCON1, a
    
    movlw 00111100B
    movwf TRISC, a
    
    movlw 11110000B
    movwf TRISH,a 
    setf LATH, a
    
    clrf TRISF, a
    clrf LATF, a
    
    bcf TRISA, 4, a
    bsf LATA, 4, a
loop:
    // Switch reader
    ; LSB (y)
    movf PORTC, w, a
    movwf LSB, a
    rrncf LSB, f, a
    rrncf LSB, w, a
    andlw 00001111B
    movwf LSB, a
    
    ; MSB (x)
    movf PORTH, w, a
    movwf MSB, a
    rrncf MSB, f, a
    rrncf MSB, f, a
    rrncf MSB, f, a
    rrncf MSB, w, a
    andlw 00001111B
    movwf MSB, a
    
    
    // Comparator
    movf MSB, w, a  // LSB (y) to working register
    
    subwf LSB, w, a // Subtracts working register MSB (x) from LSB (y), y-x, looking for x > y
    bz loop
    bnn loop	// It is possible to use 8-bit twos complement negative flag for 4-bit switch comparison.
    
    // Flasher
    bsf LATF, 0, a
    call _500ms_delay
    bcf LATF, 0, a
    call _500ms_delay
    
    bra loop ; endless loop
    
_500us_delay:
    movlw 208
    movwf delaydec1, a
    _500us_delay_run:
    nop
    nop
    nop
    decf delaydec1, a
    bnz _500us_delay_run
return
    
_500ms_delay:
    movlw 200
    movwf delaydec2, a
    _500ms_delay_run:
    call _500us_delay
    call _500us_delay
    call _500us_delay
    call _500us_delay
    call _500us_delay
    decf delaydec2, a
    bnz _500ms_delay_run
return
    
    end