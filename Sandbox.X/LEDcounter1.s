/* This project aims to utilize both inputs and outputs of the UoM I/O Board.
The PB2(Left) will increment the number by 1 and PB1 (Right) will decrement the number by 1.
The LEDs will be in unsigned binary.
*/
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
    movlw 0x0F	; 00001111B
    movwf ADCON1, a  ; Set all inputs as digital (see p272 of datasheet)
    bsf TRISB, 0, a  ; Set TRISB0 as input
    bsf TRISJ, 5, a ; RJ5
    clrf TRISF ; LEDS output
    bcf TRISA, 4, a  ; Set Q3 as output
  
  // Initialize latch values
    clrf LATF, a      ; Clear all LEDs
    bsf LATA, 4, a  ; Enable Q3
  // illumination
main:
// Button scanner
    movf PORTB, W, a  ; Read all of PORTB
    andlw 00000001B    ; Mask off unused bits (RB0)
    bz pb2_pressed    ; If pressed go to this label

    movf PORTJ, W, a  ; Read all of PORTJ
    andlw 00100000B    ; mask off unused bits (RJ5)
    bz pb1_pressed
 
  bra main	    ; Else loop back to main

pb2_pressed:
    movf LATF, W, a
    addlw 00000001B
    movwf LATF
    movf PORTB, W, a  ; Read all of PORTB (Protection)
Protection1:
    btfss PORTB, 0, a ; Test RB0, skip next line if button pressed
    goto Protection1
    bra main
  
 pb1_pressed:
    movf LATF, W, a
    addlw 255 ; sublw not working
    movwf LATF
    movf PORTJ, W, a  ; Read all of PORTB (Protection)
Protection2:
    btfss PORTJ, 5, a ; Test RJ5, skip next line if button pressed
    goto Protection2
    bra main
  
  end