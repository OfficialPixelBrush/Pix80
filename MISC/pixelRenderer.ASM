; Screen configured as a 20x16p (4x2 chars)
; if carry = 1, the relevant pixel will be turned off instead of on
; B is for X
; C is for Y 
pixelLCDdraw:
; calculate X coordinate
; get character coordinate (xChar = xTruePixel/5)
; get pixel coordinate (xPixel = xTruePixel%5)

; calculate Y coordinate
; get character coordinate (yChar = yTruePixel/8)
; get pixel coordinate (yPixel = yTruePixel%8)

; draw to screen

modulus:

C_Div_D:
;Inputs:
;     C is the numerator
;     D is the denominator
;Outputs:
;     A is the remainder
;     B is 0
;     C is the result of C/D
;     D,E,H,L are not changed
;
     ld b,8
     xor a
       sla c
       rla
       cp d
       jr c,$+4
         inc c
         sub d
       djnz $-8
     ret
