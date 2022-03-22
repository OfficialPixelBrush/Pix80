; RAM TEST
LD HL,0x8000        ; Start testing at 0x8000
LD B,0              ; Set Number of Errors to 0
LD C,0
loop:
LD A,H              ; Load H into A
LD (HL),H           ; Load H into Memory
CP (HL)             ; Compare Memory with A
JP Z,same           ; If they're the same, test next
INC B               ; If they're unequal, count another error
same:
OUT (C),H
OUT (C),B
INC HL
JP loop
