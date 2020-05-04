LIST    P=18F8722
#INCLUDE <p18f8722.inc>
CONFIG OSC=HSPLL, FCMEN=OFF, IESO=OFF,PWRT=OFF,BOREN=OFF, WDT=OFF, MCLRE=ON, LPT1OSC=OFF, LVP=OFF, XINST=OFF, DEBUG=OFF


barLocation udata h'20'
barLocation

state   udata 0x21
state
level udata 0x29
level
health udata 0x30
health 
remBall udata 0x31
remBall
 
counter3 udata 0x32
counter3
 
   
tempTimer1 udata 0x26
tempTimer1
tempTimer2 udata 0x27
tempTimer2
tempLast udata 0x28
tempLast
   
counter   udata 0x22
counter

w_temp  udata 0x23
w_temp

status_temp udata 0x24
status_temp

pclath_temp udata 0x25
pclath_temp
 
counter2 udata 0x34
counter2

org 0x00
goto main

org     0x08
goto    isr 

init:
    movlw d'100'
    movwf counter2
    movlw d'2'
    movwf counter3
    movlw d'0'
    movwf barLocation
    movlw h'ff'
    movwf ADCON1
    clrf PORTA
    clrf PORTB
    clrf PORTC
    clrf PORTD
    clrf PORTE
    clrf PORTF
    clrf PORTG
    clrf PORTH
    clrf PORTJ
    clrf WREG
    clrf LATA
    clrf LATB
    clrf LATC
    clrf LATD
    clrf LATE
    clrf LATF
    clrf LATG
    clrf LATH
    clrf LATJ
    clrf TRISG
    clrf INTCON
    clrf T0CON
    bcf PIE1,0
    
    movlw h'10000001'
    movwf T1CON 
    
    movlw b'001101'
    movwf TRISG
    movlw b'00000000'
    movwf TRISA
    movwf TRISB
    movwf TRISC
    movwf TRISD
    
    bsf PORTA,5 
    bsf PORTB,5
    return
    ;led olacak

tim:
    clrf    INTCON
    clrf    INTCON2

    ;Configure Output Ports
    clrf    LATF
    clrf    TRISF

    ;Configure Input/Interrupt Ports
    movlw   b'00010000'
    bsf     INTCON2, 7  ;External Pull-ups are enabled, Internal Pull-ups are disabled

    ;Initialize Timer0
    movlw   b'01000111' ;Disable Timer0 by setting TMR0ON to 0 (for now)
                        ;Configure Timer0 as an 8-bit timer/counter by setting T08BIT to 1
                        ;Timer0 increment from internal clock with a prescaler of 1:256.
    movwf   T0CON

    ;Enable interrupts
    movlw   b'11100000' ;Enable Global, peripheral, Timer0 and RB interrupts by setting GIE, PEIE, TMR0IE and RBIE bits to 1
    movwf   INTCON

    bsf     T0CON, 7    ;Enable Timer0 by setting TMR0ON to 1
    return
barAtAB:
    bsf PORTA,5 
    bsf PORTB,5
    bcf PORTC,5
    movlw d'0'
    movwf barLocation
    goto checkG2
    
barAtBC:
    bsf PORTB,5
    bsf PORTC,5
    movf barLocation, W
    xorlw d'0'
    bz setportA
    goto setportD
    
setportA:
    bcf PORTA,5
    movlw d'1'
    movwf barLocation
    goto checkG2

setportD:
    bcf PORTD,5
    movlw d'1'
    movwf barLocation
    goto checkG2
    
barAtCD:
    bsf PORTC,5
    bsf PORTD,5
    bcf PORTB,5
    movlw d'2'
    movwf barLocation
    goto checkG2
   
checkG2:
    btfss PORTG,2
    goto checkG3
    goto checkRelaseG2
    
checkG3:
    btfss PORTG,3
    goto checkG2
    goto checkRelaseG3

checkRelaseG2:
    btfsc PORTG,2
    goto checkRelaseG2
    goto move_bar_right
 
checkRelaseG3:
    btfsc PORTG,3
    goto checkRelaseG3
    goto move_bar_left
    
move_bar_left:
    nop
    movf barLocation, W
    xorlw d'1'
    bz barAtAB
    movf barLocation, W
    xorlw d'2'
    bz barAtBC
    goto checkG2
      
move_bar_right: 
    nop
    movf barLocation, W
    xorlw d'0'
    bz barAtBC
    movf barLocation, W
    xorlw d'1'
    bz barAtCD
    goto checkG2    

checkG0:
    
    btfss PORTG,0
    goto checkG0
    call tim
    movlw d'1'
    movwf level
    movlw d'100'
    movwf counter2
    movlw d'5'
    movwf health
    movlw d'30'
    movwf remBall
 
  
    movf TMR1H,WREG
    movwf tempTimer1
    movf TMR1L,WREG
    movwf tempTimer2
    clrf T1CON
   
    goto checkRelaseG0

checkRelaseG0:
    btfsc PORTG,0
    goto checkRelaseG0
    goto checkG2

deleteCD
    bcf PORTC,5
    bcf PORTD,5
    return 
deleteAB
    bcf PORTA,5
    bcf PORTB,5
    return 
deleteAD
    bcf PORTA,5
    bcf PORTD,5
    return 
check5 
    movf barLocation,WREG
    xorlw d'0'
    bz deleteCD
    movf barLocation,WREG
    xorlw d'1'
    bz deleteAD
    movf barLocation,WREG
    xorlw d'2'
    bz deleteAB
    
    
    
moveBalls
    call ballA5
    call ballB5
    call ballC5
    call ballD5
    call ballA4
    call ballB4
    call ballC4
    call ballD4
    

    call ballA3
    call ballA2
    call ballA1
    call ballA0
    call ballB3
    call ballB2
    call ballB1
    call ballB0
    call ballC3
    call ballC2
    call ballC1
    call ballC0
    call ballD3
    call ballD2
    call ballD1
    call ballD0
    movf health,WREG
    xorlw d'0'
    btfss STATUS,Z
    return 
    goto main

    ballA5
	movf barLocation,WREG
	xorlw d'0'
	bnz mayreduceHealthA
	return
    mayreduceHealthA
	btfss PORTA,5
	return
	decf health
	bcf PORTA,5
	return
	
    ballB5
	movf barLocation,WREG
	xorlw d'2'
	bz mayreduceHealthB
	return
    mayreduceHealthB
	btfss PORTB,5
	return
	decf health
	bcf PORTB,5
	return
    ballC5
	movf barLocation,WREG
	xorlw d'0'
	bz mayreduceHealthC
	return
    mayreduceHealthC
	btfss PORTC,5
	return
	decf health
	bcf PORTC,5
	return
    ballD5
	movf barLocation,WREG
	xorlw d'2'
	bnz mayreduceHealthD
	return
    mayreduceHealthD
	btfss PORTD,5
	return
	decf health
	bcf PORTD,5
	return
	
    ballA4
	btfss PORTA,4
	return 
	movf barLocation,WREG
	xorlw d'0'
	bcf PORTA,4
	bnz lightA5
	return
    lightA5
	bsf PORTA,5
	return 
   
    ballB4
	btfss PORTB,4
	return 
	movf barLocation,WREG
	xorlw d'2'
	bcf PORTB,4
	bz  lightB5
	return 
    lightB5 
	bsf PORTB,5
	return
	
    ballC4
	btfss PORTC,4
	return 
	movf barLocation,WREG
	xorlw d'0'
	bcf PORTC,4
	bz  lightC5
	return 
    lightC5 
	bsf PORTC,5
	return 
    ballD4
	btfss PORTD,4
	return 
	movf barLocation,WREG
	xorlw d'2'
	bcf PORTD,4
	bnz  lightD5
	return 
    lightD5 
	bsf PORTD,5
	return 
    
;;PORTA
    ballA3
        btfss PORTA,3
        return
        bcf PORTA,3
        bsf PORTA,4
        return

    ballA2
        btfss PORTA,2
        return
        bcf PORTA,2
        bsf PORTA,3
        return

    ballA1
        btfss PORTA,1
        return
        bcf PORTA,1
        bsf PORTA,2
        return

    ballA0
        btfss PORTA,0
        return
        bcf PORTA,0
        bsf PORTA,1
        return

;;PORTB
    ballB3
        btfss PORTB,3
        return
        bcf PORTB,3
        bsf PORTB,4
        return
    
    ballB2
        btfss PORTB,2
        return
        bcf PORTB,2
        bsf PORTB,3
        return
    
    ballB1
        btfss PORTB,1
        return
        bcf PORTB,1
        bsf PORTB,2
        return
    
    ballB0
        btfss PORTB,0
        return
        bcf PORTB,0
        bsf PORTB,1
        return

;;PORTC
    ballC3
        btfss PORTC,3
        return
        bcf PORTC,3
        bsf PORTC,4
        return

    ballC2
        btfss PORTC,2
        return
        bcf PORTC,2
        bsf PORTC,3
        return

    ballC1
        btfss PORTC,1
        return
        bcf PORTC,1
        bsf PORTC,2
        return

    ballC0
        btfss PORTC,0
        return
        bcf PORTC,0
        bsf PORTC,1
        return

;;PORTD
    ballD3
        btfss PORTD,3
        return
        bcf PORTD,3
        bsf PORTD,4
        return

    ballD2
        btfss PORTD,2
        return
        bcf PORTD,2
        bsf PORTD,3
        return

    ballD1
        btfss PORTD,1
        return
        bcf PORTD,1
        bsf PORTD,2
        return

    ballD0
        btfss PORTD,0
        return
        bcf PORTD,0
        bsf PORTD,1
        return

handleScoreBoard
    
	
levelUp
    incf level
    movf level,w
    xorlw d'2'
    bz counter_level2
    goto counter_level3
gameover
    goto main
counter_level2
    movlw d'80'
    movwf counter2
    movlw d'4'
    movwf counter3
    goto gercek_create_ball
counter_level3
    movlw d'70'
    movwf counter2
    movlw d'6'
    movwf counter3
    goto gercek_create_ball
createBall:;Timer ın son üç bitinin modulo suna göre topu üretme
    decf remBall
    movf remBall ,WREG
    xorlw d'25'
    bz levelUp
    movf remBall,WREG
    xorlw d'15'
    bz levelUp
    movf remBall,WREG
    xorlw d'0'
    bz gameover
    movf counter3,w
gercek_create_ball
    decfsz WREG
    goto shift_time
    goto gercek_create_ball_devami
shift_time
    RRCF tempTimer1
    RRCF tempTimer2
    goto gercek_create_ball
gercek_create_ball_devami
    movf tempTimer2,WREG
    andlw b'00000011'  ; 111 = mod 4 = 
    movwf tempLast
    xorlw d'0'
    bz createAtA
    movf tempLast,WREG
    xorlw d'1'
    bz createAtB
    movf tempLast,WREG
    xorlw d'2'
    bz createAtC
    movf tempLast,WREG
    xorlw d'3'
    bz createAtD
    
createAtA:
    bsf PORTA,0
    return 
createAtB:
    bsf PORTB,0
    return 
createAtC:
    bsf PORTC,0
    return 
createAtD:
    bsf PORTD,0
    return 

git:
    nop
    call moveBalls
    btfss tempTimer2,0
    goto create_ball_call
    bsf STATUS,C
    call createBall
    nop
    return 

create_ball_call
    bcf STATUS,C
    call createBall
    return
    
    
main:
    call init
    
    nop
    goto checkG0

isr:
    call    save_registers  ;Save current content of STATUS and PCLATH registers to be able to restore them later

    btfss   INTCON, 2       ;Is this a timer interrupt?
    nop    
    goto    timer_interrupt ;Yes. Goto timer interrupt handler part


;;;;;;;;;;;;;;;;;;;;;;;; Timer interrupt handler part ;;;;;;;;;;;;;;;;;;;;;;;;;;
timer_interrupt:
    incf	counter, f              ;Timer interrupt handler part begins here by incrementing count variable
    movf	counter, w              ;Move count to Working register
    subfwb	counter2,0,1                 ;Decrement 100 from Working register
    btfss	STATUS, Z               ;Is the result Zero?
    goto	timer_interrupt_exit    ;No, then exit from interrupt service routine
    clrf	counter                 ;Yes, then clear count variable
    call	git                ;Complement our state variable which controls on/off state of LED0

timer_interrupt_exit:
    bcf	    INTCON, 2		    ;Clear TMROIF
    movlw	d'61'               ;256-61=195; 195*256*100 = 4992000 instruction cycle;
    movwf	TMR0
    call	restore_registers   ;Restore STATUS and PCLATH registers to their state before interrupt occurs
    retfie

;;;;;;;;;;;; Register handling for proper operation of main program ;;;;;;;;;;;;
save_registers:
    movwf 	w_temp          ;Copy W to TEMP register
    swapf 	STATUS, w       ;Swap status to be saved into W
    clrf 	STATUS          ;bank 0, regardless of current bank, Clears IRP,RP1,RP0
    movwf 	status_temp     ;Save status to bank zero STATUS_TEMP register
    movf 	PCLATH, w       ;Only required if using pages 1, 2 and/or 3
    movwf 	pclath_temp     ;Save PCLATH into W
    clrf 	PCLATH          ;Page zero, regardless of current page
    return

restore_registers:
    movf 	pclath_temp, w  ;Restore PCLATH
    movwf 	PCLATH          ;Move W into PCLATH
    swapf 	status_temp, w  ;Swap STATUS_TEMP register into W
    movwf 	STATUS          ;Move W into STATUS register
    swapf 	w_temp, f       ;Swap W_TEMP
    swapf 	w_temp, w       ;Swap W_TEMP into W
    return
end
