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
LD A,0b10000000     ; set DRAM Address
OUT (1),A

; program start
; HL used as pointer
LD HL,0
write:
; hello offset + pointer
LD A,(HL)
; increment HL
INC HL
; output on data bus to LCD
CALL printHex
LD A,' '
OUT (0),A
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
OUT (0),A        ; otherwise print the character that was found
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
LD A,0x50+0b10000000
OUT (1),A
RET 
