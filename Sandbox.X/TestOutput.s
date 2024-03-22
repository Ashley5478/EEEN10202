; Name: [Write your name here]
; Student ID number: [Write your student number here e.g. 12341010]
processor 18F8722
radix dec
CONFIG OSC = HS
CONFIG WDT = OFF ;
CONFIG LVP = OFF
#include <xc.inc>
PSECT resetVector, class=CODE, reloc=2
resetVector:
 goto start ;
PSECT start, class=CODE, reloc=2
start:
; Your code should be here
; Initialization
movlw 11101111B ; TRISA4 output, don't cares on other binary (any value)
movwf TRISA ; Sets the RA4 as output, LED NPN transistor

clrf TRISF ; Sets all RF0-RF7 pins to outputs by assigning TRISF to zero

movlw 11111100B ; RH0 and RH1 output, don't cares on other binary (any value)
movwf TRISH ; Sets the TRISH with the binary above, 7seg display PNP transistor

    goto ILLUMINATION
; Illumination loop
ILLUMINATION:
    ;LSB 7 Segment display "2"
movlw 11111110B ; Activating the Q1 PNP transistor, first six binary don't care
movwf LATH ; Assigning this value to RH0

movlw 01001100B ; 2 in inverted binary
movwf LATF ; Writing this value to display
    
setf LATH ; Deactivating all transistors to turn off the display first
setf LATF ; Deactivating all the inverted 7 segment display

movlw 11111101B; Activating the Q2 PNP transistor, first six binary don't care
movwf LATH; Assigning this value to RH1

movlw 10001111B ; L in inverted binary
movwf LATF ; Writing this value to display
    
setf LATH ; Deactivating all transistors
clrf LATF ; Initializing to zero for LED display

movlw 00010000B ; NPN transistor activation for LED
movwf LATA ; Activating the Q3 transistor at RA4

movlw 11111010B ; -6 in twos complement
movwf LATF ; Writing this to LED
    
clrf LATA ; Deactivating the NPN transistor

bra ILLUMINATION ; Loop
end ; Do not forget the end statement!