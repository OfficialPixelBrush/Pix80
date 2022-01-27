; I/O Device 0 is LCD Instructions (RS = 0)
; I/O Device 1 is LCD Data         (RS = 1)
; I/O Device 2 is Keyboard
; I/O Device 3 is Serial-Port

; load Program via Serial Port
; set starting address to
; start of RAM
LD HL,0x8000
load: 
; load and write byte
IN A,(3)
LD (HL),A
; check if HL is at 0xFFFF
LD A, 0xFF
;CP H
; if H isn't 0xFF, don't
; bother checking lower bits
;JR NZ, notfull
; if it is equal to 0xFF,
; check the lower bits
CP L
; if they are 0xFF, exit
JP NZ, 0x8000
notfull:
; if not, increment HL
INC HL
; loop for next byte
JR load
HALT
