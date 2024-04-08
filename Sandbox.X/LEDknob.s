/*This project is not part of the EEEN10202 course.
This source code uses analog input for the potentiometer and then displays its value in LEDS from 0 to 255.*/

processor 18F8722
radix dec

CONFIG OSC = HS
CONFIG WDT = OFF
CONFIG LVP = OFF

#include <xc.inc> 

    /*
PSECT udata_acs
global LSB_switch, MSB_switch;, TOTAL_switch ; Custom memory allocation
LSB_switch: ds 1    ; 1 byte reservation each
MSB_switch: ds 1
*/
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start
PSECT start, class=CODE, reloc=2
start:
// Setup TRIS I/O before main loop
    
    movlw 00000111B ; Inputs and output configuration for TRISA (RA012 RA4)
    movwf TRISA
    clrf TRISF	    ; Binary (Digital outputs, RF01234567)
    movlw 11110000B ; MSB, Q1 and Q2 (Switche inputs and 7seg display outputs, RH4567 RH01)
    movwf TRISH
    movlw 00111100B ; LSB, requires RRNCF (rotate right no carry) twice (RC2345)
    movwf TRISC
    
    // Initialize latch values
    movlw 00000011B  ; Q1 and Q2 PNP deactivate
    movwf LATH
    bsf LATA, 4, a  ; Q3 activate
    
    // Illumination
main:

    bra main	    ; Else loop back to main

    end