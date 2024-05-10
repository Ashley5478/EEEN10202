/*
Mock question 2 option 1
    read an 8-bit unsigned value x from the eight toggle switches (SW1A)
    Turn on LED LD8 if x == 2
    Flash LED LD1 at 1 Hz if x > 23
    
    All displays should be off unless otherwise stated.
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
global LSB, switches, delayer1, delayer2
LSB: ds 1
switches: ds 1
delayer1: ds 1
delayer2: ds 1

; Our program start point
PSECT start, class=CODE, reloc=2
start:
// Initialize TRIS values and other constants
    movlw 15
    movwf ADCON1, a
    
    movlw 00111100B
    movwf TRISC, a
    
    movlw 11110000B
    movwf TRISH, a
    setf LATH, a
    
    clrf TRISF, a
    clrf LATF, a
    
    bcf TRISA, 4, a
    bsf LATA, 4, a
    
loop:
    // Switch reader
    clrf LATF, a
    ; LSB
    movf PORTC, w, a
    movwf LSB, a
    rrncf LSB, f, a
    rrncf LSB, w, a
    andlw 00001111B
    movwf LSB, a
    
    ; MSB
    movf PORTH, w, a
    andlw 11110000B
    iorwf LSB, w, a
    
    movwf switches, a
    
    
    // Comparator
    // switch = 2
    ; movf switches, w, a
    addlw -2
    bnz xLargerthan23	// Next test if x != 2
    bsf LATF, 7, a  // Turn on LED LD8 if x == 2
    
    
    
    
    xLargerthan23:
    // switch > 23
    movf switches, w, a
    addlw -23
    bz loop	// Returns if x = 23
    bnc loop	// Returns if x < 23
    bsf LATF, 6, a
    call delay_1s
    bcf LATF, 6, a
    call delay_1s
    
    bra loop ; endless loop
    
    delay_500_us:
    movlw 208
    movwf delayer1, a
    delay_500_us_run:
	nop
	nop
	nop
	decf delayer1, a
	bnz delay_500_us_run
    return
    
    delay_1s:
    movlw 200
    movwf delayer2, a
    delay_1s_run:
	call delay_500_us
	call delay_500_us
	call delay_500_us
	call delay_500_us
	call delay_500_us
	call delay_500_us
	call delay_500_us
	call delay_500_us
	call delay_500_us
	call delay_500_us
	decf delayer2, a
	bnz delay_1s_run
    return
    
    end