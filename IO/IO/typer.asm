; I/O Device 0 is LCD Instructions (RS = 0)
; I/O Device 1 is LCD Data         (RS = 1)
; I/O Device 2 is Serial I/O

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

keyboard:
IN A,(2)         ; check keyboard buffer for new data
; put PS/2 to ASCII Processing here
CP 8             ; if the pressed key is 8, backspace has been pressed
CALL Z,backspace ; enter backspace subroutine
CP 32            ; if the Character is not printable ASCII
JP C, keyboard   ; loop back to check for a new character
INC D
OUT (0),A        ; otherwise print the character that was found
JP keyboard      ; then loop back to check again

backspace:
PUSH AF
;DEC D            ; Decrement D
CALL moveLCDtoD  ; Move Cursor to previous character 
LD A, 32         ; print space over last character
OUT (0),A        ; print space
CALL moveLCDtoD  ; Move Cursor to previous character 
POP AF           
RET              ; return to function that called

moveLCDtoD:
; check if D is 13h or less
LD A,D ; load D into A
CP 14
JP C, moveLCDend
LD D,0
; check if D is 14h - 27h, if yes, add 0x2C to A
; check if D is 28h, make it 40h, vice versa too for 3F -> 27h
; check if D is 40h  - 53h, if yes, subtract 0x2C from A
; check if D is is >54h
moveLCDend:
LD A,0b10000000
ADD A,D
OUT (1),A
RET
