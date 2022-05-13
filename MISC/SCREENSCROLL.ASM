; LCD init
LD A,0b00111000     ; set screen mode
OUT (0),A
LD A,0b00001100     ; turn on display
OUT (0),A
LD A,0b00000001     ; clear display
OUT (0),A
LD A,0b00000110     ; set entry mode
OUT (0),A

LD A,0b10000000     ; set DRAM Address
LD IX,message
writeMessage:
    ; hello offset + pointer
    LD A,(IX)
    ; increment IX
    INC IX
    CP 0  ; check if contents of A is 0 
    JR Z,exitMessage ; if it is, exit, otherwise resume
    ; output on data bus to LCD
    CALL printCharToLCD
    JR writeMessage
exitMessage:
HALT


printCharToLCD:
CP ' '
JR NC,printableAscii
LD A,' '
;CP 0x0A          ; check if A is equal to NewLine
;JR NZ,noNewLine  ; if it's not newline, just skip
;LD A,D
;ADD A,0x14
;LD D,A
;noNewLine: 
printableAscii:
PUSH AF 
INC D            ; if the character is printable, increment D
LD A,D           ; load D into A
checkLine:
CP 0x14          ; check if A is equal to 0x14
CALL Z, NEXTLINE2
CP 0x28          ; check if A is equal to 0x28
CALL Z, NEXTLINE3
CP 0x3C          ; check if A is equal to 0x3C
CALL Z, NEXTLINE4
CP 0x50          ; check if A is larger than 0x4F
CALL Z, SCOLLSCREENDOWN
;CALL NC, SCOLLSCREENDOWN
POP AF
OUT (1),A        ; otherwise print the character that was found
RET

SCOLLSCREENDOWN:
PUSH AF   
; push second line to first 
PUSH DE          ; Store D in Stack
; D to store destination, E to store source
PUSH BC
; ----------- SECOND LINE -----------
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
OUT (0),A
IN  A,(0)

; Reposition Cursor
PUSH AF
LD A,D 
OUT (0),A        
POP AF

; Print read char
OUT (1),A

LD A,B
CP 19
JR Z,secondLineExit
INC B
INC D
INC E
JR secondLineLoop
secondLineExit:
; ----------- THIRD LINE -----------
; B for counting loops
; Empty B
LD B,0
; Last Byte on LCD
LD E,LCDLINE3+0b10000000
; Above Byte on LCD
LD D,0b10000000+LCDLINE2

thirdLineLoop:
; Read Char from DRAM
LD A,E 
OUT (0),A
IN  A,(0)

; Reposition Cursor
PUSH AF
LD A,D 
OUT (0),A        
POP AF

; Print read char
OUT (1),A

LD A,B
CP 19
JR Z,thirdLineExit
INC B
INC D
INC E
JR thirdLineLoop
thirdLineExit:
; ----------- FOURTH LINE -----------
; B for counting loops
; Empty B
LD B,0
; Last Byte on LCD
LD E,LCDLINE4+0b10000000
; Above Byte on LCD
LD D,0b10000000+LCDLINE3

fourthLineLoop:
; Read Char from DRAM
LD A,E 
OUT (0),A
IN  A,(0)

; Reposition Cursor
PUSH AF
LD A,D 
OUT (0),A        
POP AF

; Print read char
OUT (1),A

; Clear just read Character
LD A,E 
OUT (0),A
LD A,' '
OUT (1),A

LD A,B
CP 19
JR Z,fourthLineExit
INC B
INC D
INC E
JR fourthLineLoop
fourthLineExit:
; Reset printing position
LD A,LCDLINE4+0b10000000
OUT (0),A
POP BC
POP DE
LD D,0x3C
POP AF
RET

NEXTLINE1:
LD D,0
LD A,0b10000000+LCDLINE1
OUT (0),A
RET 

NEXTLINE2:
LD A,0b10000000+LCDLINE2
OUT (0),A
RET 

NEXTLINE3:
LD A,0b10000000+LCDLINE3
OUT (0),A
RET 

NEXTLINE4:
LD A,0b10000000+LCDLINE4
OUT (0),A
RET

DEFINE LCDLINE1=0x0
DEFINE LCDLINE2=0x40
DEFINE LCDLINE3=0x14
DEFINE LCDLINE4=0x54

message:
    INCLUDEBINARY "osborne1.txt"
