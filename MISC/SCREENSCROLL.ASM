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
LD A,0b10000000+LCDLINE2
OUT (1),A
LD A,'A'
loopPrint:
OUT (0),A
INC A
CP 85
JP NZ,loopPrint
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
; push second line to first 
PUSH DE          ; Store D in Stack
; D to store destination, E to store source
PUSH BC
; B for counting loops
; Empty B
LD B,0
; Last Byte on LCD
LD E,LCDLINE2+0b10000000
; Above Byte on LCD
LD D,0b10000000

secondLineLoop:
; Read Char from DRAM
LD A,E 
OUT (1),A
IN  A,(1)

; Reposition Cursor
PUSH AF
LD A,D 
OUT (1),A        
POP AF

; Print read char
OUT (0),A

LD A,B
CP 19
JR Z,secondLineExit
INC B
INC D
INC E
JR secondLineLoop
HALT
secondLineExit:




POP BC
POP DE
RET

NEXTLINE1:
LD D,0
LD A,0b10000000+LCDLINE1
OUT (1),A
RET 

NEXTLINE2:
LD A,0b10000000+LCDLINE2
OUT (1),A
RET 

NEXTLINE3:
LD A,0b10000000+LCDLINE3
OUT (1),A
RET 

NEXTLINE4:
LD A,0b10000000+LCDLINE4
OUT (1),A
RET

DEFINE LCDLINE1=0x0
DEFINE LCDLINE2=0x40
DEFINE LCDLINE3=0x14
DEFINE LCDLINE4=0x54
