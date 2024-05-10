/*
Handbook practical exam Q2 Version
    turn ON LED LD8,
    delay for 1s (± 0.1s),
    turn OFF LED LD8,
    delay for 2s (± 0.1s).
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

decCounter equ 0x303
decCounter2 equ 0x306
    
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start ; On reset, jump to our program start location


    
    
; Our program start point
PSECT start, class=CODE, reloc=2
start:
// Initialize TRIS values and other constants
clrf TRISF  // Outputs for LED

bcf TRISA, 4, a	// NPN transistor as outputs

movlw 11110000B	// PNP transistors as outputs
movwf TRISH
    
movlw 00000011B	// PNP transistor disable
movwf LATH

movlw 10000000B	// LD8 constant
movwf LATF

loop:
    bsf LATA, 4, a
    call delay_1_s
    bcf LATA, 4, a
    call delay_1_s
    call delay_1_s
    
    bra loop ; endless loop
    
delay_500_us:
    movlw 207
    movwf decCounter, b
    delay_500_us_run:
    nop
    nop
    nop
    decf decCounter, b
    bnz delay_500_us_run
    return
    
delay_1_s:
    movlw 200
    movwf decCounter2, b
    delay_1_s_run:
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
    decf decCounter2, b
    bnz delay_1_s_run
    return
    
    end