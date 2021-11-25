; screen starts at 8000h and is 320 bytes
; (could probably be optimized to be singular bits for pixels)
scrn: EQU  0x8000

LD IX,scrn
INC IX

LD A, (IX)
OUT (1),A
