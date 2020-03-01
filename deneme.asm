LIST P=18F8722

#INCLUDE <p18f8722.inc>
    
CONFIG OSC=HSPLL, FCMEN=OFF, IESO=OFF,PWRT=OFF,BOREN=OFF, WDT=OFF, MCLRE=ON, LPT1OSC=OFF, LVP=OFF, XINST=OFF, DEBUG=OFF

 
org 0x00
goto main

org 0x08
retfie

org 0x18
retfie
 
init
    clrf WREG
    
    movlw d'3'
    movwf TRISA
    movwf PORTA
    movwf LATA
    
    
    return
   
main:
    call init
   
end
