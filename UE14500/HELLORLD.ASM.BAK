LCDINST:    EQU 0
LCDDATA:    EQU 1
LCDDISP:    EQU 0x8001
LCDDISPPOS: EQU 0x8000
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
CALL resetLCD      

LD IX,text
LD IY,LCDDISP
LD HL,LCDDISPPOS
LD A,1
LD (HL),A    ; acts as character counter
LD A,(IX)
printText:
    LD A,(IX)
    ;CP 0x0A ; New line 
    ;CALL Z,newLine     THIS SHIT IS RIGGED
    CP 0
    JR Z,textDone
    LD (IY),A
    CALL updateLCD

    INC IX
    INC IY
    INC (HL)

    LD A,(HL)
    CP 81
    CALL NZ,printText
    CALL pushScreenUp
    LD A,61
    LD (HL),A
    LD IY,LCDDISP+60
    JR printText
textDone:
HALT

newline:
PUSH AF
LD A,1
LD (HL),A
POP AF
LD IY,LCDDISP-1

;PUSH HL
;LD HL,20
;ADD IY,HL
;POP HL

CALL pushScreenUp
RET

; Routine to update Contents of LCD Based on Memory
updateLCD:
PUSH AF
PUSH HL
PUSH BC

LD HL,LCDDISP
LD B,0
printLoop:
    LD A,(HL)
    OUT (LCDDATA),A
    INC HL
    INC B
    LD A,B
    CP 20
    JP Z,gotoSecondLine
    CP 40
    JP Z,gotoThirdLine
    CP 60
    JP Z,gotoFourthLine
    CP 80
    JR NZ,printLoop
POP AF
POP HL
POP BC
RET

gotoSecondLine:
LD A,LCDDRAM+0x40
OUT (LCDINST),A
JP printLoop 

gotoThirdLine:
LD A,LCDDRAM+0x14
OUT (LCDINST),A
JP printLoop 

gotoFourthLine:
LD A,LCDDRAM+0x54
OUT (LCDINST),A
JP printLoop 

pushScreenUp:
PUSH AF
PUSH BC
PUSH DE
PUSH HL
; Push elements from screen up a line
LD HL,LCDDISP+20
LD DE,LCDDISP
LD BC,80
LDIR 

; Clear lowest Line and fill with spaces
LD A,32
LD B,80
LD HL,LCDDISP+60
loopResetPush:
LD (HL),A
INC HL
DEC B
JR NZ,loopResetPush

POP AF
POP BC
POP DE
POP HL
RET

; Reset Contents of LCD Memory to Spaces
resetLCD:
PUSH AF
PUSH BC
PUSH HL

LD A,32
LD B,80
LD HL,LCDDISP
loopReset:
LD (HL),A
INC HL
DEC B
JR NZ,loopReset

POP AF
POP BC
POP HL
RET

text:
INCLUDEBINARY "hellorld.txt"
;DEFM "Hellorld!",0
DEFB 0
