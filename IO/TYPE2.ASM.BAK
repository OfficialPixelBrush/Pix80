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
; Set Device for C
LD C,1

LD D,0b10000000
OUT (C),D              ; Set DRAM to 0

keyboard:
IN A,(2)         ; check keyboard buffer for new data
; put PS/2 to ASCII Processing here
CP 32            ; if the Character is not printable ASCII
JP C, keyboard   ; loop back to check for a new character
INC D
OUT (0),A        ; otherwise print the character that was found
JP keyboard      ; then loop back to check again

HALT
