; I/O Device 0 is LCD Instructions (RS = 0)
; I/O Device 1 is LCD Data         (RS = 1)
; I/O Device 2 is Keyboard
; Startup setup
; Display ON
;LD A,0b00000001
;OUT (0),A
; Clear Display
;LD A,0b00000001
;OUT (0),A
; Function Set
;LD A,0b00101000
;OUT (0),A


; Set CGRAM address
LD A,0b01000000
OUT (0),A

; Write Data to Screen
; Last 3 bits shouldn't matter
LD A,0b00000
OUT (1),A
LD A,0b01010
OUT (1),A
LD A,0b01010
OUT (1),A
LD A,0b00000
OUT (1),A
LD A,0b11111
OUT (1),A
LD A,0b01110
OUT (1),A
LD A,0b00000
OUT (1),A
OUT (1),A
; Should be smileyq

; Set DDRAM Address
LD A,0b10000000
OUT (0),A

; Print Character
LD A,0
OUT (1),A 
   
; IX used as pointer
LD IX,0
writeHelloWorld:
; hello offset + pointer
LD A,(IX+hello)
; output on data bus to LCD
OUT (1),A
; increment IX
INC IX
CP 0
JP NZ,writeHelloWorld 

keyboard:
IN A,(2)
; put PS/2 to ASCII Processing here
CP 32 ; if the Character is within printable ASCII
JP C, keyboard
; backspace
CP 8
JP C,backspace
OUT (1),A ; then print the character

backspace:
PUSH A
LD A, 0b00010100
OUT (0),A ; reverse printing direction to r-l
LD A, 32
OUT (1),A ; print space
OUT (1),A ; print space
LD A, 0b00010000
OUT (0),A ; return printing direction to l-r
POP A


; LCD Printing handling
;INC E ; increase Display Position
; insert handling of lines here
;LD A,0b10000000
;ADD A,E ; Set display Address 
;OUT (0),A   ; Output on Data Bus
JP keyboard  ; return to keyboard loop

hello:
    DEFM  " Hello, world! ",0

panda:
    ;INCLUDE "redPanda.bin"
