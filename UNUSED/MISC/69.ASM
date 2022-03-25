; B = x
; D = y
; E = z
; C = Output

LD   B , 0x0 ; x = 0
LD   D , 0x1 ; y = 1

loop:
; print x goes here
LD   C , 69
OUT (C), A   
JP loop
; print end
;LD   A , B
;ADD  A , D
;LD   E , A ; z = x + y
;LD   B , D ; x = y
;LD   D , E ; y = z
; check if x is 233
;LD A, 233
;SUB A, B 
;JP NZ, loop
