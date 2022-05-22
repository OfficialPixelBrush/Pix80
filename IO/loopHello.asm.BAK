; I/O Device 0 is LCD Data         (RS = 1)
; I/O Device 1 is LCD Instructions (RS = 0)
; I/O Device 2 is Keyboard
; Enable Display
LD A,0b00001100
OUT (0),A

; Set CGRAM address
;LD A,0b01000000
;OUT (0),A

; Write Data to Screen
; Last 3 bits shouldn't matter
;LD A,0b00000
;OUT (1),A
;LD A,0b01010
;OUT (1),A
;LD A,0b01010
;OUT (1),A
;LD A,0b00000
;OUT (1),A
;LD A,0b11111
;OUT (1),A
;LD A,0b01110
;OUT (1),A
;LD A,0b00000
;OUT (1),A
;OUT (1),A
; Should be smiley

; Set DDRAM Address
LD A,0b10000000
OUT (0),A

; Print Character
;LD A,0
;OUT (1),A
 
; IX used as pointer
LD HL,hello
LD C,1
LD B,afterhello-hello
OTIR

;keyboard:
;IN A,(0)
; put PS/2 to ASCII Processing here v
;CP 8
;CALL Z,backspace
;CP 32 ; if the Character is within printable ASCII
;JP C, keyboard
;OUT (0),A ; then print the character
;OUT (3),A
;JP keyboard

backspace:
;PUSH AF
; clear char
;LD A, 0b00010000
;OUT (1),A ; reverse printing direction to r-l

;LD A, 32
;OUT (0),A ; print space

; clear char
;LD A, 0b00010000
;OUT (1),A ; reverse printing direction to r-l

;POP AF
;RET
; LCD Printing handling
;INC E ; increase Display Position
; insert handling of lines here
;LD A,0b10000000
;ADD A,E ; Set display Address 
;OUT (1),A   ; Output on Data Bus
;JP keyboard  ; return to keyboard loop

hello:
    DEFM  "Hello, world! "
afterhello:

panda:
    ;INCLUDE "redPanda.bin"
