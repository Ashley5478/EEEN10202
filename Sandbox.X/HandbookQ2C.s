/*
Handbook practical exam Q2 Version C
     In this question the toggle switches (SW1A) represent a 8-bit twos complement value. So if bit 7 of your switches
is set to 1, then the number is negative.
     Read the 8-bit twos complement value x from the eight toggle switches (SW1A)
     Illuminate LED LD7 if x < 44
     Illuminate LED LD8 if x = ?2
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
global switch, LSB//, MSB
switch: ds 1
LSB: ds 1
//MSB: ds 1
    
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start ; On reset, jump to our program start location


    
    
; Our program start point
PSECT start, class=CODE, reloc=2
start:
// Initialize TRIS values and other constants
    movlw 15
    movwf ADCON1, a
    
    
    bcf TRISA, 4, a // LED NPN transistor as outputs
    
    movlw 00111100B // LSB switches
    movwf TRISC, a
    
    clrf TRISF, a	// Binary outputs
    
    movlw 11110000B // MSB switches and PNP transistors
    movwf TRISH, a
    
    bsf LATH, 0, a
    bsf LATH, 1, a  // Disabling the PNP transistors
    
    clrf LATF, a
    
    bsf LATA, 4, a  // Turning on the NPN transistor
    
loop:
    clrf LATF, a
    // Switch scanner
    ; LSB scanner
    movf PORTC, W, a
    movwf LSB, a
    rrncf LSB, F, a
    rrncf LSB, W, a
    andlw 00001111B // Masking off unused bits
    movwf LSB, a
    
    ; MSB scanner
    movf PORTH, W, a
    andlw 11110000B // Masing off unused bits
    //movwf MSB, a
    
    addwf LSB, W, a // Combining LSB and MSB, you can use iorwf.
    movwf switch, a
    
    // Number comparator
    // TIP: Whenever comparing numbers, please test the "equal to" operation using bz first and then use bc or bnc (Switch greater than or less than desired value respectively.)
    // Note: If you are dealing with TWOS COMPLEMENT, you must use MSB negative flag. There can be OVERFLOW so the MSB should be considered as if it is inverted.
    //movf switch, W, a
    addlw 2 // Tests if switch = -2
    btfsc STATUS, 2, a	// If zero flag is not active, skip the next line.
    call EqualNeg2
    
    movf switch, W, a
    addlw -44	// 11010100
    
    bz loop // Equal to 44, no illumination
    
    bov InvertedNeg // Tests if there is an overflow so that negative flag has been disabled. Considers opposite situation of conventional unsigned situation.
    bn Lessthan44   // If no overflow and negative (conventional as if unsigned), switches < 44
    bra loop
    
    InvertedNeg:
    bnn Lessthan44  // There is an overflow (MSB inverted) so no negative means switches < 44. Opposite of conventional.
    bra loop
    // Less than 44
    Lessthan44:
    bsf LATF, 7, a  // LD8 adctivation
    nop
    nop
    bra loop ; endless loop
    
    EqualNeg2:	// Equal to -2
	bsf LATF, 6, a	// LD7 activation
    return
    end