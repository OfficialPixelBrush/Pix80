LD HL, 0x100
loop:
LD C,(HL)
OUT (C),C
INC HL
JP loop
