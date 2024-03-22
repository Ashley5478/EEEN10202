processor 18F8722
radix dec 

CONFIG OSC = HS 
CONFIG WDT = OFF 
CONFIG LVP = OFF 

#include <xc.inc> 


PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start 
PSECT start, class=CODE, reloc=2
start: 
// Setup TRIS I/O before main loop
    movlw 0x0F	    ; Digital Input
    movwf ADCON1, a
    
    bcf TRISA, 4, a ; Q3
    clrf TRISF	    ; Binary
    movlw 11110000B  ; MSB, Q1 and Q2
    movwf TRISH
    movlw 00111100B  ; LSB
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
    /*
    movf PORTB, W, a  ; Read all of PORTB
    andlw 00000001B    ; Mask off unused bits (RB0)
    bz pb2_pressed    ; If pressed go to this label
*/
    movf PORTJ, W, a  ; Read all of PORTJ
    andlw 00100000B    ; mask off unused bits (RJ5)
    bz pb1_pressed

// Switch scanner
    

    bra main	    ; Else loop back to main
  
pb1_pressed:
    movf LATF, W, a
    
    movwf LATF
    movf PORTJ, W, a  ; Read all of PORTB (Protection)

    btfss PORTJ, 5, a ; Test RJ5, skip next line if button pressed
    goto Protection2
    bra main
  
    end