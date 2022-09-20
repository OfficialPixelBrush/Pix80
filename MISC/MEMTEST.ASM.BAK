LCDINST: EQU 0
LCDDATA: EQU 1

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

; program start
; HL used as pointer
LD HL,0
write:
; hello offset + pointer
LD A,(HL)
; increment HL
INC HL
; output on data bus to LCD
LD A,' '
OUT (LCDDATA),A
JR write 
exit:
HALT
; print Memory from 0x0000 until 0x0003
  ; load memory location into A
  ; check upper 4-bits
  ; print according char 
  ; check lower 4-bits
  ; print according char 
  
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
