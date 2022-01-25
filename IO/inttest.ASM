; I/O Device 0 is LCD Instructions (RS = 0)
; I/O Device 1 is LCD Data         (RS = 1)
; I/O Device 2 is Keyboard
; Startup setup
; Display ON
ORG 00h
LD A,0b00000001
OUT (0),A
EI
IM 0

; Interrupt test
LD A,'0'
JP loop
loop:
HALT
OUT (1),A
INC A
JP loop
