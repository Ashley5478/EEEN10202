/*
Handbook practical exam Q2 Version B
    Read a 4-bit unsigned integer value x from the 4 least significant toggle switches,
    read a 4-bit unsigned integer value y from the 4 most significant toggle switches,
    use a loop construct to calculate z = x · y,
    display the value z on the LEDs LD1...LD8 as an 8-bit unsigned binary number

    You are NOT permitted to use the MULWF or MULLW instructions. Instead use ADDWF with a loop.
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
global LSB, MSB
LSB: ds 1
MSB: ds 1
    
    
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start ; On reset, jump to our program start location


    
    
; Our program start point
PSECT start, class=CODE, reloc=2
start:
// Initialize TRIS values and other constants
    movlw 15	// Digital input 0x0F or 00001111B
    movwf ADCON1, a
    
    movlw 00111100B // LSB switches to be used with RRNCF twice
    movwf TRISC, a
    
    movlw 11110000B // MSB switches to be used with RRNCF four times + Q1 and Q2 transistor 7seg display
    movwf TRISH, a
    
    bcf TRISA, 4, a // LED transistors as outputs
    
    clrf TRISF, a // LED outputs
    
    movlw 00000011B // Disable PNP transistors for 7 segment display (Unused)
    movwf LATH, a
    
    clrf LATF, a	// Clear LED outputs initially
    

    
loop:
    bcf LATA, 4, a  // Disable LED outputs NPN transistor for stable and non-flickering outputs
    // Reader and calculator
    ; LSB read
    movf PORTC, W, a
    movwf LSB, a
    rrncf LSB, f, a
    rrncf LSB, W, a
    andlw 00001111B // Mask off the unused bits
    movwf LSB, a
    
    ; MSB read
    movf PORTH, W, a
    movwf MSB, a
    rrncf MSB, f, a
    rrncf MSB, f, a
    rrncf MSB, f, a
    rrncf MSB, W, a
    andlw 00001111B // Mask off the unused bits
    movwf MSB, a
    
    ; Calculating loop
    clrf LATF, a
    Multiplier:
    movf LSB, W, a  // Pick one side; either LSB or MSB. If the MSB is used, then decf LSB, a should be used.
    addwf LATF, a
    
    decf MSB, a
    bnz Multiplier
    
    bsf LATA, 4, a // Enable LED outputs NPN transistor
    nop
    nop
    nop
    nop
    
    bra loop ; endless loop
    end