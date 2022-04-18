; LCD init
LD A,0b00111000     ; set screen mode
OUT (1),A
LD A,0b00111000     ; set screen mode
OUT (1),A
LD A,0b00001100     ; turn on display
OUT (1),A
LD A,0b00000001     ; clear display
OUT (1),A
LD A,0b00000110     ; set entry mode
OUT (1),A

; print test Char
LD A,0b10000000
OUT (1),A
LD A,'A'
OUT (0),A
CALL SCROLLLINEDOWN
HALT


printCharToLCD:
PUSH AF
INC D            ; if the character is printable, increment D
LD A,D           ; load D into A
CP 0x14          ; check if A is equal to 0x14
CALL Z, NEXTLINE2
CP 0x28          ; check if A is equal to 0x28
CALL Z, NEXTLINE3
CP 0x3C          ; check if A is equal to 0x3C
CALL Z, NEXTLINE4
CP 0x50          ; check if A is equal to 0x50
CALL Z, SCROLLLINEDOWN
POP AF
OUT (0),A        ; otherwise print the character that was found
RET

SCROLLLINEDOWN:    
PUSH DE          ; Store D in Stack
                 ; D to store destination, E to store source
LD A,0b10000000  ; 
OUT (1),A        ;   
IN  A,(1)        ; Read from DRAM

PUSH AF
LD A,0b10000011  ; 
OUT (1),A        ; Reposition Cursor
POP AF

OUT (0),A        ; Print read char
;LD E,A

;LD A,0x40+0b10000000
;OUT (1),A        ; Set DRAM Pos

;LD A,E
;OUT (0),A        ; Print Saved Character
POP DE
RET

NEXTLINE1:
LD D,0
LD A,0b10000000
OUT (1),A
RET 

NEXTLINE2:
LD A,0x40+0b10000000
OUT (1),A
RET 

NEXTLINE3:
LD A,0x14+0b10000000
OUT (1),A
RET 

NEXTLINE4:
LD A,0x54+0b10000000
OUT (1),A
RET
