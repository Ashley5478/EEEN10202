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

; Our program start point
PSECT start, class=CODE, reloc=2
start: 
p equ 121
 call sub1, 0
 
inf:
    movf 0x0, w
    bra inf

sub1:
    movlw p
    movwf 0x5, a
    movwf 0x0, a
   
loop:
    rrncf 0x0, f, a
    addwf 0x5, f, a
    bnz loop
    return 0
    end


