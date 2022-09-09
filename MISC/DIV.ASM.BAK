LCDINST: EQU 0
LCDDATA: EQU 1
DIVIDEND: EQU 0x8000
DIVISOR:  EQU 0x8001

LD A,15
LD (DIVIDEND),A
LD A,3
LD (DIVISOR),A

; LCD init
; LCD init
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Function set (Interface is 8-bits long)
OUT (LCDINST),A
LD A, 0b00111000 ; Set Number of Lines and Font
OUT (LCDINST),A
LD A, 0b00001111 ; Set Display Control Properties
OUT (LCDINST),A
OUT (LCDINST),A
LD A, 0b00000001 ; Clear Screen
LD A, 0b00000110 ; Set Entry Mode
OUT (LCDINST),A

; B = DIVIDEND
; C = DIVISOR
; E = FRACTION
LD A,(DIVIDEND)
LD B,A
LD A,(DIVISOR)
LD C,A
LD A,0
LD E,A

; loop until limit is found
LD A,C     ; initalized
DIVmaxLoop: 
SLA A
CP B
JR C,DIVmaxLoop
JR Z,DIVmaxLoop
; once limit is found, start doing calculations
; calc start
LD C,A       
LD A,B 
tryNext:
SLA E
SRA C   
CP C
JR C,tryNext
JR Z,tryNext
INC E
SUB C
; check if C is it's original value again
;PUSH AF
;LD A,(DIVISOR)
;CP C
;JR NZ,divComplete
;POP AF
;JR tryNext
divComplete:

; still needs actual division logic (pls help)


LD A,B
CALL printHex

LD A,','
CALL printCharToLCD

LD A,C
CALL printHex

LD A,','
CALL printCharToLCD

LD A,E
CALL printHex
HALT
 
printHex:
RLCA
RLCA
RLCA
RLCA
CALL printHexFrom4Bits
RLCA
RLCA
RLCA
RLCA
CALL printHexFrom4Bits   
RET      

printHexFrom4Bits:
PUSH AF
AND 0x0F            ; limit to 4 lowest bits
CP 0xA              ; check if less than A
JR NC,biggerThan9    ; if it's bigger than 9, move onto Chars
ADD A,'0'           ; else add ASCII 0
CALL printCharToLCD ; then print char
POP AF
RET

biggerThan9:
ADD A,55          ; otherwise add offset to allow for printing chars
CALL printCharToLCD ; then print char
POP AF
RET


printCharToLCD:
PUSH AF
INC D            ; if the character is printable, increment D
LD A,D           ; load D into A
CP 0x14          ; check if A is equal to 0x14
CALL NC, NEXTLINE2
CP 0x28          ; check if A is equal to 0x28
CALL NC, NEXTLINE3
CP 0x3C          ; check if A is equal to 0x3C
CALL NC, NEXTLINE4
CP 0x50          ; check if A is equal to 0x50
CALL NC, NEXTLINE1
POP AF
OUT (LCDDATA),A        ; otherwise print the character that was found
RET

NEXTLINE1:
LD D,0
LD A,0b10000000
OUT (LCDINST),A
RET 

NEXTLINE2:
LD A,0x40+0b10000000
OUT (LCDINST),A
RET 

NEXTLINE3:
LD A,0x14+0b10000000
OUT (LCDINST),A
RET 

NEXTLINE4:
LD A,0x50+0b10000000
OUT (LCDINST),A
RET 
