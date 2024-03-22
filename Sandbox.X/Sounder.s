/*This project is not part of the EEEN10202 course.
This source code mimics the fire alarm on the IO board.*/
    
processor 18F8722
radix dec
CONFIG OSC = HS
CONFIG WDT = OFF ;
CONFIG LVP = OFF
#include <xc.inc>
    
PSECT udata_acs
global p, q, k, t
p: ds	1    
q: ds	1
k: ds	1
t: ds	1
tm: ds	1
km: ds	1
    
PSECT resetVector, class=CODE, reloc=2
resetVector:
    goto start ;
PSECT start, class=CODE, reloc=2
start:
    
    MOVLW 255
    MOVWF tm
    
    MOVLW 3 ; Volume
    MOVWF km

    MOVF tm, W
    MOVWF t

note1:
    
    
    BCF TRISJ,6
    BSF LATJ, 6 ; Speaker ON
    
    
    MOVF km, W
    MOVWF k
    loop2:
	MOVLW 1
	SUBWF k, W
	MOVWF k
	BZ clear
	Bra loop2
    
    
clear:
    CLRF LATJ

    
    MOVLW 8
    MOVWF q
	loop1:

	    MOVLW 1
	    SUBWF q, W
	    MOVWF q

	    MOVLW 60
	    MOVWF p
	      

	    MOVF q, W

	    BZ here
	    loop:
		MOVLW 1
		SUBWF p, W
		MOVWF p
		BZ loop1
		Bra loop

here:
    MOVLW 1
    SUBWF t, W
    MOVWF t
    BZ timing
    Bra note1
		
		
timing:
    MOVF tm, W
    MOVWF t

note2:		
    BCF TRISJ,6
    BSF LATJ, 6
    
    
    MOVF km, W
    MOVWF k
    loop3:
	MOVLW 1
	SUBWF k, W
	MOVWF k
	BZ clear2
	Bra loop3
    
    
clear2:
    CLRF LATJ
    
    
    MOVLW 10  
    MOVWF q
	loop4:

	    MOVLW 1
	    SUBWF q, W
	    MOVWF q

	    MOVLW 60
	    MOVWF p
	    
	    

	    MOVF q, W

	    BZ here2
	    loop5:
		MOVLW 1
		SUBWF p, W
		MOVWF p
		BZ loop4
		Bra loop5
	
here2:
    MOVLW 1
    SUBWF t, W
    MOVWF t
    BZ start
    Bra note2
   
bra start
	    
end ; Do not forget the end statement!