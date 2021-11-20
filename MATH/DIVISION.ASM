LD D, 184
LD E, 15

; Multiply D with E
; Result goes in D
; Rest in E
divide:
  LD C,0
  LD A,D
  divloop:
    CP E
    JP C,divexit  ; could be JR
    INC C
    SUB E
    JP NZ,divloop ; same with this one
  divexit:
  LD D,C
  LD E,A

; output result on Databus
OUT (C),D
OUT (C),E
HALT
