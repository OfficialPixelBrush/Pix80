ORG 0x0
IM 1
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
LD A,'>'
OUT (0),A
JP keyboard 


ORG 0x38
;keyboard:
DI
IN A,(2)         ; check keyboard buffer for new data
; put PS/2 to ASCII Processing here
CP 32            ; if the Character is not printable ASCII
JP C, keyboard   ; loop back to check for a new character
PUSH AF
INC D            ; if the character is printable, increment D
LD A,D           ; load D into A
CP 0x13          ; check if A is larger than 0x13
CALL NC, SHIFTLEFT
POP AF
OUT (0),A        ; otherwise print the character that was found
keyboard:
;JP keyboard      ; then loop back to check again
EI
HALT

SHIFTLEFT:
PUSH AF
LD A,0b00011000
OUT (1),A
POP AF
RET 
