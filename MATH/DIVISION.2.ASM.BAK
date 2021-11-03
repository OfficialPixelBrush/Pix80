LD D, 42
LD E, 7


; Multiply D with E
; Result goes in D
; Rest in E
divide:
  LD C,0
  LD A,D
  divloop:
    CP E
    JP C,divexit
    INC C
    SUB E
    JP NZ,divloop
  divexit:
  LD D,C
  LD E,A

; output result on Port C
LD C,D
OUT (C),A
LD C,E
OUT (C),A
