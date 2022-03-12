; Set DDRAM Address
LD A,0b10000000
OUT (0),A

LD A,55
LD B,A        ; load contents of A into B

loop:
SRL A         ; shift contents of A to the right, 0 the 7th bit
XOR B         ; XOR A with B, result is put in A
BIT 0,A       ; Check Bit 0, Zero Flag is set
; this can be improved
LD A,B        ; load contents of B into A
SRL A         ; shift contents of A to the right, 0 the 7th bit
JP Z, skipset ; if Zero flag is set, putting it to 7th bit is unnecessary, so skip
SET 7,A       ; set 7th bit

skipset:
LD B,A        ; load contents of A into B
; do the above for safe keeping
; print Char according to Zero Flag
JP Z, printBackslash
LD A,47
OUT (1),A
JP exit
printBackslash:
LD A,33
OUT (1),A

exit:
LD A,B        ; load contents of B into A
JP loop       ; unconditional jump
