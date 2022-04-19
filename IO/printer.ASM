ORG 0x0
LD D,0

; LCD init
LD A,0b00111000     ; set screen mode
OUT (1),A
LD A,0b00111000     ; set screen mode
OUT (1),A
LD A,0b00001111     ; turn on display
OUT (1),A
LD A,0b00000001     ; clear display
OUT (1),A
LD A,0b00000110     ; set entry mode
OUT (1),A

; Set DRAM to 0x0
LD A,0b10000000
OUT (1),A 


LD IX,0
writeHelloWorld:           
;IN A,(2)         ; check keyboard buffer for new data
LD A,(IX+hello)
; put PS/2 to ASCII Processing here
;CP 32            ; if the Character is not printable ASCII
;JP C, keyboard   ; loop back to check for a new character
PUSH AF
INC D            ; if the character is printable, increment D
LD A,D           ; load D into A
CP 0x14          ; check if A is larger than 0x14
CALL Z, NEXTLINE2
CP 0x28          ; check if A is larger than 0x28
CALL Z, NEXTLINE3
CP 0x3C          ; check if A is larger than 0x3C
CALL Z, NEXTLINE4
CP 0x50          ; check if A is larger than 0x50
CALL Z, NEXTLINE1
POP AF
INC IX
CP 0
JP Z,exitHello
OUT (0),A
JR writeHelloWorld 
exitHello:

;EI
HALT
;JP keyboard      ; then loop back to check again

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

;buildDate:
;DEFDATETIME

hello:
    DEFM "If she leaves you for another, there is always her mother",0
