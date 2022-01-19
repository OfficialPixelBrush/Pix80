LD D, 3
LD E, 13

; Multiply D with E
; Result goes in D
multiply:
  LD A, 0 ; replace with push a
  muliloop:
  ADD A,D
  DEC E
  JP NZ, muliloop
  LD D,A

; output result on Port 0
LD A,D
OUT (1),A
HALT
