LCDINST:    EQU 0
LCDDATA:    EQU 1
LCDDRAM:    EQU 0b10000000

; *********************
; ***   Hellorld!   *** 
; *********************
; LCD init
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Set Number of Lines and Font
OUT (LCDINST),A
LD A, 0b00001100 ; Set Display Control Properties
OUT (LCDINST),A  ; Display 1/0, Cursor 1/0, Blink 1/0
OUT (LCDINST),A
LD A, 0b00000001 ; Clear Screen
LD A, 0b00000110 ; Set Entry Mode
OUT (LCDINST),A
LD A,LCDDRAM ; set DRAM Address
OUT (LCDINST),A  

    ; IX used as pointer
    LD IX,0
writeHelloWorld:
    ; hello offset + pointer
    LD A,(IX+hello)
    CP 0
    JR Z,exit
    ; output on data bus to LCD
    OUT (LCDDATA),A
    ; increment IX
    INC IX
    JP writeHelloWorld 
exit:
HALT
hello:
    DEFM "Hellorld!",0  
