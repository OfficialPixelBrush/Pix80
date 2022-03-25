; I/O Device 0 is LCD Instructions (RS = 0)
; I/O Device 1 is LCD Data         (RS = 1)
; Startup setup
; Display ON
LD A,0b00000001
OUT (0),A
; Clear Display
LD A,0b00000001
OUT (0),A
; Function Set
LD A,0b00101000
OUT (0),A
; Set DDRAM Address
LD A,0b10000000
OUT (0),A

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
LD C, 1
LD A, 48
ADD A, D
OUT (1),A
LD A, 48
ADD A, E
OUT (1),A
HALT
