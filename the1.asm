LIST    P=18F8722
#INCLUDE <p18f8722.inc>
CONFIG OSC=HSPLL, FCMEN=OFF, IESO=OFF,PWRT=OFF,BOREN=OFF, WDT=OFF, MCLRE=ON, LPT1OSC=OFF, LVP=OFF, XINST=OFF, DEBUG=OFF

operationSelect udata h'20'
operationSelect
 
portSelectionBC udata h'21'
portSelectionBC
 
portSelectionD udata h'22'
portSelectionD

delay_counter1 udata h'23'
delay_counter1

delay_counter2 udata h'24'
delay_counter2
 
delay_counter3 udata h'25'
delay_counter3 
 
org 0x00
goto main

delay_500 ; 500 ms delay
    movlw b'00011011'
    movwf delay_counter1
    movlw b'01011111'
    movwf delay_counter2
    movlw b'00000011'
    movwf delay_counter3
    nop
travel1:
    decfsz delay_counter1
    goto travel2
    return
travel2:
    decfsz delay_counter2
    goto travel3
    goto travel1
travel3:
    decfsz delay_counter3
    goto travel3
    goto travel2 
 
init
    clrf operationSelect
    clrf portSelectionBC
    clrf portSelectionD
    clrf LATA
    clrf LATB
    clrf LATC
    clrf LATD
    clrf LATE
    movlw h'ff'
    movwf ADCON1
    movlw h'10'
    movwf TRISA
    movlw h'f0'
    movwf TRISB
    movwf TRISC
    movlw h'00'
    movwf TRISD
    movlw h'18'
    movwf TRISE
    clrf WREG
    goto performDelay

performDelay:
    movlw h'ff'
    movwf LATB
    movwf LATC
    movwf LATD
    call delay_500
    call delay_500
    nop 
    movlw h'00'
    movwf LATB
    movwf LATC
    movwf LATD
    goto wait
 
wait:
    btfss PORTA, 4
    goto wait
    incf operationSelect
    goto additionWillPerform

additionWillPerform:
    btfss PORTA, 4
    goto selectPort
    decf operationSelect
    goto subWillPerform

subWillPerform:
    btfss PORTA, 4
    goto selectPort
    incf operationSelect
    goto additionWillPerform

selectPort:
    btfss PORTE, 3
    goto selectPort
    incf portSelectionBC
    goto selectPortB

selectPortB:
    btfss PORTE, 3
    goto valueToBOrC
    decf portSelectionBC
    goto selectPortC

selectPortC:
    btfss PORTE, 3
    goto valueToBOrC
    incf portSelectionD
    goto selectPortD

selectPortD:
    btfss PORTE, 3
    goto whichOperation
    incf portSelectionBC
    decf portSelectionD
    goto selectPortB
    
valueToBOrC:
    btfss portSelectionBC, 0
    goto enterValueForC
    goto enterValueForB

enterValueForB:
    btfss PORTE, 4
    goto enterValueForB
    btg LATB, 0, 0
    btfss PORTE, 4
    goto selectPortB
    btg LATB, 1, 0
    btfss PORTE, 4
    goto selectPortB
    btg LATB, 2, 0
    btfss PORTE, 4
    goto selectPortB
    btg LATB, 3, 0
    btfss PORTE, 4
    goto selectPortB
    clrf portSelectionBC
    clrf LATB
    goto selectPort
    
enterValueForC:
    btfss PORTE, 4
    goto enterValueForC
    btg LATC, 0, 0
    btfss PORTE, 4
    goto selectPortC
    btg LATC, 1, 0
    btfss PORTE, 4
    goto selectPortC
    btg LATC, 2, 0
    btfss PORTE, 4
    goto selectPortC
    btg LATC, 3, 0
    btfss PORTE, 4
    goto selectPortC
    clrf portSelectionBC
    clrf LATC
    goto selectPort

whichOperation:
    btfss operationSelect, 0
    goto subActual
    goto addActual
    
addActual:
    btfsc PORTB, 0
    incf WREG
    
    btfsc PORTB, 1
    incf WREG
   
    btfsc PORTB, 2
    incf WREG
   
    btfsc PORTB, 3
    incf WREG
   
    btfsc PORTC, 0
    incf WREG
    
    btfsc PORTC, 1
    incf WREG
    
    btfsc PORTC, 2
    incf WREG
    btfsc PORTC, 3
    incf WREG
    goto turnOnLeds

subActual:
    movf LATB, WREG
    cpfslt LATC
    goto cIsLarger
    goto bIsLarger
    
bIsLarger:
    clrf WREG
    btfsc PORTB, 0
    incf WREG
    nop
    btfsc PORTB, 1
    incf WREG
    nop
    btfsc PORTB, 2
    incf WREG
    nop
    btfsc PORTB, 3
    incf WREG
    btfsc PORTC, 3
    decf WREG
    nop
    btfsc PORTC, 2
    decf WREG
    nop
    btfsc PORTC, 1
    decf WREG
    nop
    btfsc PORTC ,0
    decf WREG
    goto turnOnLeds
   
cIsLarger:
    clrf WREG
    btfsc PORTC, 0
    incf WREG
    nop
    btfsc PORTC, 1
    incf WREG
    nop
    btfsc PORTC, 2
    incf WREG
    nop
    btfsc PORTC, 3
    incf WREG
    btfsc PORTB, 3
    decf WREG
    nop
    btfsc PORTB, 2
    decf WREG
    nop
    btfsc PORTB, 1
    decf WREG
    nop
    btfsc PORTB ,0
    decf WREG
    goto turnOnLeds
    
    
turnOnLeds:
    bz afterTurnOn
    decf WREG
    bsf LATD, 0, 0
    bz afterTurnOn
    decf WREG
    bsf LATD, 1, 0
    bz afterTurnOn
    decf WREG
    bsf LATD, 2, 0
    bz afterTurnOn
    decf WREG
    bsf LATD, 3, 0
    bz afterTurnOn
    decf WREG
    bsf LATD, 4, 0
    bz afterTurnOn
    decf WREG
    bsf LATD, 5, 0
    bz afterTurnOn
    decf WREG
    bsf LATD, 6, 0
    bz afterTurnOn
    decf WREG  
    bsf LATD, 7, 0
    bz afterTurnOn
    
afterTurnOn:
    
    call delay_500
    call delay_500
    clrf operationSelect
    clrf portSelectionBC
    clrf portSelectionD
    clrf LATA
    clrf LATB
    clrf LATC
    clrf LATD
    clrf LATE
    goto wait

main:
    call init
    
end
