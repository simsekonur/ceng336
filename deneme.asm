LIST    P=18F8722
#INCLUDE <p18f8722.inc>
CONFIG OSC=HSPLL, FCMEN=OFF, IESO=OFF,PWRT=OFF,BOREN=OFF, WDT=OFF, MCLRE=ON, LPT1OSC=OFF, LVP=OFF, XINST=OFF, DEBUG=OFF

opSelect udata h'20'
opSelect
 
portSelBC udata h'21'
portSelBC
 
portSelD udata h'22'
portSelD

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
for1:
    decfsz delay_counter1
    goto for2
    return
for2:
    decfsz delay_counter2
    goto for3
    goto for1
for3:
    decfsz delay_counter3
    goto for3
    goto for2 
 
setup
    clrf opSelect
    clrf portSelBC
    clrf portSelD
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
    call showtime
    goto wait

showtime
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
    return
 
wait:
    btfss PORTA, 4
    goto wait
    incf opSelect
    goto waitAdd

waitAdd:
    btfss PORTA, 4
    goto select
    decf opSelect
    goto waitSub

waitSub:
    btfss PORTA, 4
    goto select
    incf opSelect
    goto waitAdd

select:
    btfss PORTE, 3
    goto select
    incf portSelBC
    goto selectB

selectB:
    btfss PORTE, 3
    goto enterVal
    decf portSelBC
    goto selectC

selectC:
    btfss PORTE, 3
    goto enterVal
    incf portSelD
    goto selectD

selectD:
    btfss PORTE, 3
    goto operation
    incf portSelBC
    decf portSelD
    goto selectB
    
enterVal:
    btfss portSelBC, 0
    goto enterValC
    goto enterValB

enterValB:
    btfss PORTE, 4
    goto enterValB
    btg LATB, 0, 0
    btfss PORTE, 4
    goto selectB
    btg LATB, 1, 0
    btfss PORTE, 4
    goto selectB
    btg LATB, 2, 0
    btfss PORTE, 4
    goto selectB
    btg LATB, 3, 0
    btfss PORTE, 4
    goto selectB
    clrf portSelBC
    clrf LATB
    goto select
    
enterValC:
    btfss PORTE, 4
    goto enterValC
    btg LATC, 0, 0
    btfss PORTE, 4
    goto selectC
    btg LATC, 1, 0
    btfss PORTE, 4
    goto selectC
    btg LATC, 2, 0
    btfss PORTE, 4
    goto selectC
    btg LATC, 3, 0
    btfss PORTE, 4
    goto selectC
    clrf portSelBC
    clrf LATC
    goto select

operation:
    btfss opSelect, 0
    goto sub2
    goto add2
    
add2:
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
    goto yakyakyak

sub2:
    movf LATB, WREG
    cpfslt LATC
    goto cbuyuk
    goto bbuyuk
    
bbuyuk:
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
    goto yakyakyak
   
cbuyuk:
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
    goto yakyakyak
    
    
yakyakyak:
    bz yandik
    decf WREG
    bsf LATD, 0, 0
    bz yandik
    decf WREG
    bsf LATD, 1, 0
    bz yandik
    decf WREG
    bsf LATD, 2, 0
    bz yandik
    decf WREG
    bsf LATD, 3, 0
    bz yandik
    decf WREG
    bsf LATD, 4, 0
    bz yandik
    decf WREG
    bsf LATD, 5, 0
    bz yandik
    decf WREG
    bsf LATD, 6, 0
    bz yandik
    decf WREG
    bsf LATD, 7, 0
    bz yandik
    
yandik:
    nop
    goto setup

main:
    call setup
end
