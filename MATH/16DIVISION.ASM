; 16-bit division
; A, HL, BC, DE
LD BC, 2000
LD DE, 1000
; Divide BC with DE
; Result goes in BC, Rest in DE
divide:
  LD A,0
  LD HL,BC
  divloop:
	CP DE
	JP C,divexit  ; could be JR
	INC A
	SUB DE
	JP NZ,divloop ; same with this one
  divexit:
  LD BC,A
  LD DE,HL