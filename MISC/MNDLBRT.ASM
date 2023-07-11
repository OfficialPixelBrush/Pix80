SCREEN: EQU 0

MaxX: EQU 10
MaxY: EQU 10
FACTOR: EQU 4
T: EQU 10
XCOORD: EQU 10
YCOORD: EQU 10
ZOOM: EQU 10

; init IX and IY
LD IX,0
LD IY,0

LD B,15
LD C,3

CALL divide
HALT



; Simple, Slow, Reliable
; Inputs: 
; B and C Reg
; Output: 
; B Reg, C Reg Remainder
divide:
PUSH AF; Push AF as it's only temp used here
; check if signed
; if signed
NEG
; if no signed just continue
notsigned:
; check the resulting thing
LD A,B ; Load B into A for Math
LD B,0 ; Zero B to use as counter 
divideAgain:
CP C   ; Check if A-C is less than 0
JR C,divisionFinished  ; if it is, we're done
SUB C  ; otherwise A = A-C
INC B
JR divideAgain
divisionFinished: 
LD C,A
; apply signs
POP AF
RET

; Inputs
; B what we're multiplying by
; C how often we add
; B and C Reg
; Output:
; B Reg
; C Reg = 0
multiply:
PUSH AF; Push AF as it's only temp used here
LD A,B ; Check if B or C is the smallest
CP C
JR NC,multiplyAlreadyIdeal
LD B,C ; swap the two
LD C,A ; there we go
multiplyAlreadyIdeal:
LD A,0
multiplyLoop:
ADD A,B
DEC C
JR NZ,multiplyLoop
LD B,A
POP AF
RET
