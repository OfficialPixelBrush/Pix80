; 16-bit division
; A, HL, BC, DE
; Divide BC with DE
; Result goes in BC
; Rest in DE
divide:
  LD A,0
  LD HL,BC
  divloop:
	CP DE
	JP C,divexit  ; could be JR
	INC BC
	SUB DE
	JP NZ,divloop ; same with this one
  divexit:
  LD BC,DE
  LD DE,HL
; Load E back in
LD E, B
; E += 2
INC E
INC E