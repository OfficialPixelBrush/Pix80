; B = x
; D = y
; E = z
; C = Output

start:
LD   B , 0x0 ; x = 0
LD   D , 0x1 ; y = 1

loop:
; print x goes here
LD   C , B
OUT (C), A
; print end
LD   A , B
ADD  A , D
LD   E , A ; z = x + y
LD   B , D ; x = y
LD   D , E ; y = z
; check if x is 233
LD A, 233
SUB A, B 
JP NZ, loop
JP start
