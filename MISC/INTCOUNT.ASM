ORG 0x0
IM 1
EI

LD A,0b00111000     ; set screen mode
CALL SendLCDCommand
LD A,0b00111000     ; set screen mode
CALL SendLCDCommand
LD A,0b00001100     ; turn on display
CALL SendLCDCommand
LD A,0b00000001     ; clear display
CALL SendLCDCommand
LD A,0b00000110     ; set entry mode
CALL SendLCDCommand
LD A,0b10000000     ; set DRAM Address
CALL SendLCDCommand
LD D,0

ORG 0x38
interrupt:
DI      
LD A,0b10000000
CALL SendLCDCommand
INC D
LD A,D
CALL printHex
EI
HALT

printHex:
RLCA
RLCA
RLCA
RLCA
CALL printHexFrom4Bits
RLCA
RLCA
RLCA
RLCA
CALL printHexFrom4Bits   
RET      

printHexFrom4Bits:
PUSH AF
CALL loopUntilLCDNoLongerBusy
AND 0x0F            ; limit to 4 lowest bits
CP 0xA              ; check if less than A
JR NC,biggerThan9    ; if it's bigger than 9, move onto Chars
ADD A,'0'           ; else add ASCII 0
CALL SendLCDData
POP AF
RET

biggerThan9:
ADD A,55          ; otherwise add offset to allow for printing chars
OUT (0),A        ; otherwise print the character that was found
POP AF
RET

loopUntilLCDNoLongerBusy:
;IN A,(1)
;BIT 7,A ; one tick faster than BIT operation
RET ;Z
;JR loopUntilLCDNoLongerBusy

SendLCDCommand:
CALL loopUntilLCDNoLongerBusy
OUT (1),A
RET

SendLCDData:
CALL loopUntilLCDNoLongerBusy
OUT (0),A
RET
