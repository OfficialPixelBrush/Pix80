IM 1

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

keyboard:
EI
HALT
DI
IN A,(2)         ; check keyboard buffer for new data
; put PS/2 to ASCII Processing here
;CP 32            ; if the Character is not printable ASCII
;JP C, keyboard   ; loop back to check for a new character
OUT (0),A        ; otherwise print the character that was found
JP keyboard      ; then loop back to check again
