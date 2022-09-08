; B = NUMBER
; C = DIVIDER
; D = COUNTER
; E = COUNTER POS

LD A,15
LD B,A

LD A,3
LD C,A

; loop until limit is found
LD A,C
checkLoop: 
INC E
SLA A
CP B
JR C,checkLoop
; once limit is found, start doing math
SRA A

